# run-tests.ps1 - automated checks for secrets-kit. Windows PowerShell 5.1.
#
#   powershell -NoProfile -ExecutionPolicy Bypass -File .\tests\run-tests.ps1
#   ... -KitRoot <dir>        test another checkout or install (default: the kit this file sits in)
#   ... -Legacy               the kit under test has the OLD layout (bin\*.ps1 beside the launchers)
#   ... -Live                 KitRoot is a real install with real keys: read-only smoke checks only
#
# How it stays safe:
#   * Every behavioural test runs against a COPY of the kit in %TEMP% with its own
#     KEYS.md and its own throwaway credential prefix (sktest-<random>:), so the
#     real store and the real KEYS.md are never touched.
#   * Every value is generated here (sktest-<guid>). At the end, all captured
#     output and the temp KEYS.md are scanned for every generated value; one hit
#     fails the run. Throwaway credentials are deleted in teardown.
#   * -Live runs only names-only commands plus boolean presence probes
#     (prints True/False, never a value).
#
# What it cannot test headless (stated, not hidden): the interactive hidden
# prompt itself and the multi-line-paste flush, which need a real console. Those
# are covered by a static check that the code path exists.

param(
    [string]$KitRoot = (Split-Path $PSScriptRoot -Parent),
    [switch]$Legacy,
    [switch]$Live
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$KitRoot = [IO.Path]::GetFullPath($KitRoot)
$PS = Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe'

$script:Results = @()
$script:Captured = New-Object System.Text.StringBuilder
$script:Values = @()

function Check {
    param([string]$Id, [string]$Name, [bool]$Pass, [string]$Detail = '')
    $script:Results += [pscustomobject]@{ Id = $Id; Name = $Name; Pass = $Pass; Detail = $Detail }
    $tag = if ($Pass) { 'PASS' } else { 'FAIL' }
    $color = if ($Pass) { 'Green' } else { 'Red' }
    Write-Host ("  [{0}] {1,-6} {2}" -f $tag, $Id, $Name) -ForegroundColor $color
    if ($Detail -and -not $Pass) { Write-Host "         $Detail" -ForegroundColor DarkGray }
}
function Skip { param([string]$Id, [string]$Name, [string]$Why) Write-Host ("  [SKIP] {0,-6} {1} ({2})" -f $Id, $Name, $Why) -ForegroundColor DarkGray }

function New-Value { $v = 'sktest-' + [guid]::NewGuid().ToString('N'); $script:Values += $v; return $v }

# Runs a launcher through cmd.exe (the way a user or an MCP entry does), with
# optional stdin from a file and optional extra environment, capturing stdout,
# stderr and the exit code. Each call is written to a one-off wrapper batch file
# so quoting is cmd's own: % is doubled there so a literal %NAME% argument
# reaches the launcher unexpanded, exactly as it would from a user's prompt.
# Output is also appended to the leak scan buffer.
function Invoke-Kit {
    param([string]$Launcher, [string[]]$KitArgs = @(), [string]$StdinFile = $null, [hashtable]$Env = @{}, [string]$CheckVar = '', [string]$PipeFrom = '')
    $dir = Join-Path $env:TEMP ('sk-call-' + [guid]::NewGuid().ToString('N').Substring(0, 8))
    New-Item -ItemType Directory -Path $dir | Out-Null
    $o = Join-Path $dir 'out.txt'; $e = Join-Path $dir 'err.txt'; $w = Join-Path $dir 'call.cmd'
    $quoted = @($KitArgs | ForEach-Object {
        $a = $_ -replace '%', '%%'
        if ($a -match '[\s"]' -or $a -eq '') { '"' + ($a -replace '"', '""') + '"' } else { $a }
    })
    $line = '"' + $Launcher + '"'
    if ($PipeFrom) { $line = 'echo ' + $PipeFrom + '| ' + $line }
    if ($quoted.Count -gt 0) { $line += ' ' + ($quoted -join ' ') }
    if ($StdinFile) { $line += ' < "' + $StdinFile + '"' }
    $line += ' 1> "' + $o + '" 2> "' + $e + '"'
    $body = "@echo off`r`n"
    foreach ($k in $Env.Keys) { $body += 'set "' + $k + '=' + $Env[$k] + '"' + "`r`n" }
    $body += $line + "`r`n"
    if ($CheckVar) {
        # Did the launcher leave the variable behind in the CALLING shell? (a launcher that
        # `set`s values, or an in-process .ps1, would). Checked in the same cmd process.
        $body += 'set "__RC=%ERRORLEVEL%"' + "`r`n" + 'if defined ' + $CheckVar + ' (>>"' + $o + '" echo LEAKED_TO_CALLER)' + "`r`n" + 'exit /b %__RC%' + "`r`n"
    } else {
        $body += 'exit /b %ERRORLEVEL%' + "`r`n"
    }
    [IO.File]::WriteAllText($w, $body, [Text.Encoding]::ASCII)
    $sw = [Diagnostics.Stopwatch]::StartNew()
    $p = Start-Process -FilePath (Join-Path $env:SystemRoot 'System32\cmd.exe') -ArgumentList @('/d', '/c', ('"' + $w + '"')) -NoNewWindow -Wait -PassThru
    $code = $p.ExitCode
    $elapsed = $sw.Elapsed.TotalSeconds
    $out = if (Test-Path $o) { [IO.File]::ReadAllText($o) } else { '' }
    $err = if (Test-Path $e) { [IO.File]::ReadAllText($e) } else { '' }
    Remove-Item $dir -Recurse -Force -ErrorAction SilentlyContinue
    # Launcher and argument COUNT only: F4b/F4c pass a generated value as an argument,
    # and the leak scan must cover what the kit printed, not what the harness typed.
    [void]$script:Captured.AppendLine("--- $Launcher ($($KitArgs.Count) args) ---").AppendLine($out).AppendLine($err)
    return [pscustomobject]@{ Out = $out; Err = $err; All = ($out + "`n" + $err); Code = $code; Seconds = $elapsed }
}

# The guard dialog is a real window on the real desktop. A person at the machine can click
# Yes during the 2-second window, which looks exactly like a missing guard in exit code and
# stderr. Timing tells them apart: a skipped guard returns at once, a timeout takes the full
# GuardTimeoutSeconds, a click lands in between. One retry when a click is suspected.
function Invoke-Guarded {
    param([string[]]$KitArgs, [hashtable]$Env)
    for ($attempt = 1; $attempt -le 2; $attempt++) {
        Write-Host '         (a run-with-secrets TEST dialog appears for 2 seconds; do not click it)' -ForegroundColor DarkGray
        $r = Invoke-Kit $Rws $KitArgs $null $Env
        $r | Add-Member -NotePropertyName Verdict -NotePropertyValue $(if ($r.Err -match 'withheld') { 'withheld' } elseif ($r.Seconds -lt 1.2) { 'guard-skipped' } else { 'answered-yes' })
        if ($r.Verdict -ne 'answered-yes') { return $r }
        Write-Host "         (dialog was answered Yes after $([math]::Round($r.Seconds, 1)) s; someone at the desk? retrying hands-off)" -ForegroundColor Yellow
    }
    return $r
}

# Store probes run in a fresh PowerShell against the temp kit's own
# CredentialStore (own prefix), names and lengths only.
function Get-StoreScript { param([string]$Root) if ($Legacy) { Join-Path $Root 'bin\CredentialStore.ps1' } else { Join-Path $Root 'lib\CredentialStore.ps1' } }
function Probe-Length {
    param([string]$Root, [string]$Name)
    $r = & $PS -NoProfile -ExecutionPolicy Bypass -Command ". '$(Get-StoreScript $Root)'; Get-SecretLength '$Name'" 2>&1
    return [int]($r | Select-Object -Last 1)
}
function Get-StorePrefix {
    param([string]$Root)
    $r = & $PS -NoProfile -ExecutionPolicy Bypass -Command ". '$(Get-StoreScript $Root)'; `$script:SecretsPrefix" 2>&1
    return [string]($r | Select-Object -Last 1)
}
function Remove-TestSecrets {
    param([string]$Root)
    # The store script decides what Get-SecretIndex enumerates. Refuse to delete anything
    # unless it resolved to a throwaway sktest- prefix: a wrong -KitRoot must never reach
    # the real store.
    $r = & $PS -NoProfile -ExecutionPolicy Bypass -Command ". '$(Get-StoreScript $Root)'; if (`$script:SecretsPrefix -cnotlike 'sktest-*') { throw ('refusing: prefix is ' + `$script:SecretsPrefix) }; `$n = 0; foreach (`$c in @(Get-SecretIndex)) { [void](Remove-Secret `$c.Name); `$n++ }; `$n" 2>&1
    $last = [string]($r | Select-Object -Last 1)
    if ($last -notmatch '^\d+$') { throw "teardown did not run cleanly ($last). Throwaway credentials may remain under $Prefix* - remove them in Credential Manager." }
    return [int]$last
}

function Write-Utf8 { param([string]$Path, [string]$Text) [IO.File]::WriteAllText($Path, $Text, (New-Object Text.UTF8Encoding($false))) }

$KeysTemplate = @'
# Key registry (test copy)

<!-- keys:begin -->
| Key | Purpose | Issued by | Rotate at | Scope | Last rotated |
|-----|---------|-----------|-----------|-------|--------------|
<!-- keys:end -->
'@

Write-Host ''
Write-Host "secrets-kit tests  KitRoot=$KitRoot  layout=$(if ($Legacy) { 'legacy (bin\*.ps1)' } else { 'lib + launchers' })  mode=$(if ($Live) { 'live smoke' } else { 'temp copy' })" -ForegroundColor White
Write-Host ''

# =============================================================================
if (-not $Live) {
    $rand = [guid]::NewGuid().ToString('N').Substring(0, 8)
    $Tmp = Join-Path $env:TEMP "sk-test-$rand"
    $Prefix = "sktest-$rand" + ':'
    New-Item -ItemType Directory -Path $Tmp | Out-Null
    Copy-Item -Path (Join-Path $KitRoot 'bin') -Destination (Join-Path $Tmp 'bin') -Recurse
    if (Test-Path (Join-Path $KitRoot 'lib')) { Copy-Item -Path (Join-Path $KitRoot 'lib') -Destination (Join-Path $Tmp 'lib') -Recurse }
    Write-Utf8 (Join-Path $Tmp 'KEYS.md') $KeysTemplate
    if ($Legacy) {
        # The old store hard-codes its prefix; point the copy at the throwaway one.
        $cs = Join-Path $Tmp 'bin\CredentialStore.ps1'
        $txt = [IO.File]::ReadAllText($cs)
        $txt2 = [regex]::Replace($txt, '(?m)^\$script:SecretsPrefix\s*=.*$', ('$script:SecretsPrefix = ''' + $Prefix + ''''))
        if ($txt2 -eq $txt) { throw 'Could not re-point the legacy prefix; aborting rather than touching the real store.' }
        Write-Utf8 $cs $txt2
    } else {
        Write-Utf8 (Join-Path $Tmp 'secrets-kit.config.psd1') @"
@{
    Prefix = '$Prefix'
    Guarded = @('SKTEST_GUARDED')
    GuardTimeoutSeconds = 2
    DenyRules = @('Read(**/.env)')
}
"@
    }
    $Bin = Join-Path $Tmp 'bin'
    $Secrets = Join-Path $Bin 'secrets.cmd'
    $Rws = Join-Path $Bin 'run-with-secrets.cmd'
    $Keys = Join-Path $Tmp 'KEYS.md'
    $got = Get-StorePrefix $Tmp
    if ($got -cne $Prefix) { Remove-Item -Path $Tmp -Recurse -Force -ErrorAction SilentlyContinue; throw "the kit under test did not take the throwaway prefix (got '$got'); refusing to run against a real store." }
    $StdinFlag = @(); if (-not $Legacy) { $StdinFlag = @('-Stdin') }
    $AllFlag = @(); if (-not $Legacy) { $AllFlag = @('--all') }
    $AllWord = if ($Legacy) { '' } else { '--all ' }
    Write-Host "  temp kit: $Tmp   prefix: $Prefix" -ForegroundColor DarkGray
    Write-Host ''

    try {
        # ---- F4(a): what PowerShell resolves, and no .ps1 beside the launchers ----
        $res = & $PS -NoProfile -Command "`$env:Path = '$Bin;' + `$env:Path; (Get-Command secrets).Source; (Get-Command run-with-secrets).Source" 2>&1
        $res = @($res | ForEach-Object { [string]$_ })
        Check 'F4a-1' 'PowerShell resolves secrets and run-with-secrets to the .cmd launchers' (($res.Count -eq 2) -and ($res[0] -like '*\secrets.cmd') -and ($res[1] -like '*\run-with-secrets.cmd')) ("resolved: " + ($res -join ' | '))
        $ps1 = @(Get-ChildItem -Path $Bin -Filter *.ps1 -File)
        Check 'F4a-2' 'bin\ holds launchers only (no .ps1 on PATH)' ($ps1.Count -eq 0) ("found: " + (($ps1 | ForEach-Object { $_.Name }) -join ', '))
        $launchers = @(Get-ChildItem -Path $Bin -File | Where-Object { $_.Name -in 'secrets.cmd', 'run-with-secrets.cmd', 'secrets', 'run-with-secrets' })
        $bare = @(); $noAbs = @()
        foreach ($lf in $launchers) {
            $t = ((Get-Content -LiteralPath $lf.FullName) | Where-Object { $_ -notmatch '^\s*(REM\b|#)' } | ForEach-Object { $_ -replace '(?i)echo [^&]*', 'echo ...' }) -join "`n"
            # a powershell token not preceded by a path separator = resolved by name (comments skipped)
            if ($t -match '(?im)(^|[\s"=(&|''])powershell(\.exe)?(["\s''`$]|$)') { $bare += $lf.Name }
            if ($t -notmatch '(?i)System32[\\/]WindowsPowerShell[\\/]v1\.0[\\/]powershell\.exe') { $noAbs += $lf.Name }
        }
        Check 'F4a-3' 'all 4 launchers name powershell.exe by absolute path and never by bare name' (($launchers.Count -eq 4) -and ($bare.Count -eq 0) -and ($noAbs.Count -eq 0)) ("bare-name in: " + ($bare -join ', ') + "; no absolute path in: " + ($noAbs -join ', '))

        # ---- seed one key through the kit itself (-Stdin from a file) ----
        $vA = New-Value
        $f = Join-Path $Tmp 'a.txt'; Write-Utf8 $f $vA
        $r = Invoke-Kit $Secrets (@('add', 'SKTEST_A') + $StdinFlag) $f
        Check 'SEED' 'secrets add SKTEST_A -Stdin < file stores the value (length matches, nothing printed)' (($r.Code -eq 0) -and ((Probe-Length $Tmp 'SKTEST_A') -eq $vA.Length) -and ($r.All -notlike "*$vA*")) "exit=$($r.Code) len=$(Probe-Length $Tmp 'SKTEST_A')"

        # ---- F4(a) in-shell injection: child sees it, this shell never does ----
        $r = Invoke-Kit $Rws ($AllFlag + @('powershell', '-NoProfile', '-Command', '[bool]$env:SKTEST_A')) $null @{} 'SKTEST_A'
        Check 'F4a-4' 'run-with-secrets child sees SKTEST_A (True); the calling cmd shell never gets it' (($r.Out -match '^True') -and ($r.Out -notmatch 'LEAKED_TO_CALLER') -and ($r.Code -eq 0)) "out=$($r.Out.Trim()) exit=$($r.Code)"
        $res = & $PS -NoProfile -ExecutionPolicy Bypass -Command "`$env:Path = '$Bin;' + `$env:Path; run-with-secrets ${AllWord}powershell -NoProfile -Command '[bool]`$env:SKTEST_A' 2>`$null; [bool]`$env:SKTEST_A" 2>&1
        $res = @($res | ForEach-Object { [string]$_ })
        Check 'F4a-6' 'from an interactive-style PowerShell, run-with-secrets by name leaves nothing in that shell' (($res -contains 'True') -and ($res[-1] -eq 'False')) ("shell saw: " + ($res -join ' | '))

        # ---- F4(b): secrets add NAME <value> must not print the value ----
        $vB = New-Value
        $r = Invoke-Kit $Secrets @('add', 'SKTEST_B', $vB)
        Check 'F4b' 'secrets add NAME <value> refuses without printing the value and warns the value is burned' (($r.Code -ne 0) -and ($r.All -notlike "*$vB*") -and ($r.All -match '(?i)revoke|history|burned') -and ((Probe-Length $Tmp 'SKTEST_B') -eq -1)) ("exit=$($r.Code) printed-value=" + ($r.All -like "*$vB*") + " stored=" + (Probe-Length $Tmp 'SKTEST_B'))

        # ---- F4(c): a rejected name is never echoed ----
        $vC = New-Value
        $r = Invoke-Kit $Secrets @('add', $vC)
        Check 'F4c' 'a rejected name (a pasted key where the name goes) is never echoed back' (($r.Code -ne 0) -and ($r.All -notlike "*$vC*")) ("exit=$($r.Code) echoed=" + ($r.All -like "*$vC*"))

        # ---- F4(d): multi-line input: line 2 must never reach KEYS.md ----
        $vD1 = New-Value; $vD2 = New-Value
        $f = Join-Path $Tmp 'd.txt'; Write-Utf8 $f ($vD1 + "`r`n" + $vD2 + "`r`n")
        $r = Invoke-Kit $Secrets (@('add', 'SKTEST_D') + $StdinFlag) $f
        $keysText = [IO.File]::ReadAllText($Keys)
        $wantLen = ($vD1 + "`r`n" + $vD2).Length
        Check 'F4d-1' 'multi-line -Stdin value: stored whole; the second line never reaches KEYS.md' (($r.Code -eq 0) -and ((Probe-Length $Tmp 'SKTEST_D') -eq $wantLen) -and ($keysText -notlike "*$vD2*") -and ($keysText -notlike "*$vD1*")) "exit=$($r.Code) stored=$(Probe-Length $Tmp 'SKTEST_D') want=$wantLen"
        $implFile = if ($Legacy) { Join-Path $Tmp 'bin\secrets.ps1' } else { Join-Path $Tmp 'lib\secrets-impl.ps1' }
        $impl = [IO.File]::ReadAllText($implFile)
        $flushRx = '(?s)Read-Host\s+\$Prompt\s+-AsSecureString.*?if\s*\(\[Console\]::KeyAvailable\)\s*\{[^}]*FlushInputBuffer\(\)[^}]*Dispose\(\)[^}]*exit 2'
        $m = [regex]::Match($impl, $flushRx)
        $firstSet = $impl.IndexOf('Set-Secret -Name')
        Check 'F4d-2' 'interactive path: hidden read, then KeyAvailable -> flush, dispose, exit 2, all before Set-Secret (static)' ($m.Success -and ($firstSet -gt $m.Index)) 'needs a real console to exercise; construct checked statically'

        # ---- echo refusal: piped value without -Stdin must be refused ----
        $vE = New-Value
        $f = Join-Path $Tmp 'e.txt'; Write-Utf8 $f $vE
        $r = Invoke-Kit $Secrets @('add', 'SKTEST_E') $f
        Check 'F4a-5' 'redirected stdin without -Stdin (Git Bash pty shape) is refused, nothing stored' (($r.Code -ne 0) -and ((Probe-Length $Tmp 'SKTEST_E') -eq -1) -and ($r.All -notlike "*$vE*")) "exit=$($r.Code) stored=$(Probe-Length $Tmp 'SKTEST_E')"

        # ---- a value piped with echo is refused even with -Stdin (it is already in shell history) ----
        $vP = New-Value
        $r = Invoke-Kit $Secrets (@('add', 'SKTEST_P') + $StdinFlag) $null @{} '' $vP
        Check 'PIPE-1' 'echo VALUE | secrets add NAME -Stdin is refused (pipe, not file), nothing stored, burn warning shown' (($r.Code -ne 0) -and ((Probe-Length $Tmp 'SKTEST_P') -eq -1) -and ($r.All -notlike "*$vP*") -and ($r.All -match '(?i)history|revoke')) "exit=$($r.Code) stored=$(Probe-Length $Tmp 'SKTEST_P')"

        # ---- F4(e): case-sensitive name validation ----
        $vF = New-Value
        $f = Join-Path $Tmp 'f.txt'; Write-Utf8 $f $vF
        $r = Invoke-Kit $Secrets (@('add', 'sktest_lower') + $StdinFlag) $f
        Check 'F4e' 'lowercase name is rejected (case-sensitive validation), nothing stored' (($r.Code -ne 0) -and ((Probe-Length $Tmp 'sktest_lower') -eq -1)) "exit=$($r.Code) stored=$(Probe-Length $Tmp 'sktest_lower')"

        # ---- F4(f): %NAME% and !NAME! in a batch target's arguments ----
        $probe = Join-Path $Tmp 'probe.cmd'
        $probeOut = Join-Path $Tmp 'probe.out'
        Write-Utf8 $probe "@echo off`r`n>`"%~dp0probe.out`" echo %1`r`n"
        $r = Invoke-Kit $Rws ($AllFlag + @($probe, '%SKTEST_A%'))
        $got = if (Test-Path $probeOut) { [IO.File]::ReadAllText($probeOut).Trim() } else { '<not run>' }
        Check 'F4f-1' 'an argument %SKTEST_A% (an injected name) to a .cmd target is refused, or at least never expands' ((($r.Code -ne 0) -and ($got -eq '<not run>')) -or ($got -in '%SKTEST_A%', '"%SKTEST_A%"')) "exit=$($r.Code) batch received: $(if ($got -like "*$vA*") { '<THE VALUE>' } else { $got })"
        if (-not $Legacy) { Check 'F4f-1b' 'new kit: %SKTEST_A% is refused outright (a batch that CALLs with it would re-expand)' (($r.Code -ne 0) -and ($got -eq '<not run>') -and ($r.Err -match 'could expand')) "exit=$($r.Code)" }
        Remove-Item $probeOut -Force -ErrorAction SilentlyContinue
        $r = Invoke-Kit $Rws ($AllFlag + @($probe, '!SKTEST_A!'))
        $got = if (Test-Path $probeOut) { [IO.File]::ReadAllText($probeOut).Trim() } else { '<not run>' }
        Check 'F4f-2' 'an argument !SKTEST_A! to a .cmd target is refused (cmd could expand it)' (($r.Code -ne 0) -and ($got -eq '<not run>') -and ($r.All -notlike "*$vA*")) "exit=$($r.Code) batch received: $got"
        Remove-Item $probeOut -Force -ErrorAction SilentlyContinue
        $r = Invoke-Kit $Rws ($AllFlag + @($probe, '%SKTEST_NOT_A_KEY%'))
        $got = if (Test-Path $probeOut) { [IO.File]::ReadAllText($probeOut).Trim() } else { '<not run>' }
        Check 'F4f-3' 'an unrelated %NAME% reaches the .cmd target as literal text (percent escaping works)' (($r.Code -eq 0) -and ($got -in '%SKTEST_NOT_A_KEY%', '"%SKTEST_NOT_A_KEY%"')) "exit=$($r.Code) batch received: $got"
        $probeCall = Join-Path $Tmp 'probe-call.cmd'
        Write-Utf8 $probeCall "@echo off`r`ncall :w %1`r`nexit /b`r`n:w`r`n>`"%~dp0probe.out`" echo %1`r`n"
        Remove-Item $probeOut -Force -ErrorAction SilentlyContinue
        $r = Invoke-Kit $Rws ($AllFlag + @($probeCall, '%SKTEST_A%'))
        $got = if (Test-Path $probeOut) { [IO.File]::ReadAllText($probeOut).Trim() } else { '<not run>' }
        Check 'F4f-4' 'a batch that CALLs with its argument never sees the injected value (%SKTEST_A% refused or literal)' (($got -notlike "*$vA*") -and ($r.All -notlike "*$vA*")) "exit=$($r.Code) batch received: $(if ($got -like "*$vA*") { '<THE VALUE>' } else { $got })"

        # ---- RWS_ONLY scoping ----
        $vG = New-Value
        $f = Join-Path $Tmp 'g.txt'; Write-Utf8 $f $vG
        $r = Invoke-Kit $Secrets (@('add', 'SKTEST_G') + $StdinFlag) $f
        $r = Invoke-Kit $Rws @('powershell', '-NoProfile', '-Command', '"$([bool]$env:SKTEST_A) $([bool]$env:SKTEST_G) $([bool]$env:RWS_ONLY)"') $null @{ RWS_ONLY = 'SKTEST_A' }
        Check 'RWS-1' 'RWS_ONLY=SKTEST_A injects only SKTEST_A and the child does not inherit RWS_ONLY' ($r.Out.Trim() -eq 'True False False') "out=$($r.Out.Trim()) exit=$($r.Code)"
        $r = Invoke-Kit $Rws @('powershell', '-NoProfile', '-Command', '"$([bool]$env:SKTEST_CHILD) $([bool]$env:SKTEST_A)"') $null @{ RWS_ONLY = 'SKTEST_CHILD=SKTEST_A' }
        Check 'RWS-2' 'RWS_ONLY=CHILD=VAULT maps the vault value to the child name only' ($r.Out.Trim() -eq 'True False') "out=$($r.Out.Trim()) exit=$($r.Code)"
        $r = Invoke-Kit $Rws @('powershell', '-NoProfile', '-Command', '[bool]$env:SKTEST_MISSING') $null @{ RWS_ONLY = 'SKTEST_MISSING' }
        Check 'RWS-3' 'RWS_ONLY naming an unset key fails closed (nothing runs)' (($r.Code -ne 0) -and ($r.Out.Trim() -eq '')) "exit=$($r.Code) out=$($r.Out.Trim())"
        $r = Invoke-Kit $Rws @('powershell', '-NoProfile', '-Command', 'echo ran') $null @{ RWS_ONLY = 'bad name;calc' }
        Check 'RWS-4' 'RWS_ONLY with a malformed entry is rejected without echoing it' (($r.Code -ne 0) -and ($r.All -notlike '*calc*') -and ($r.Out.Trim() -ne 'ran')) "exit=$($r.Code)"

        if (-not $Legacy) {
            # ---- least privilege: --only / --all / no flag ----
            $r = Invoke-Kit $Rws @('--only', 'SKTEST_A', 'powershell', '-NoProfile', '-Command', '"$([bool]$env:SKTEST_A) $([bool]$env:SKTEST_G)"')
            Check 'ONLY-1' '--only SKTEST_A injects just that key' ($r.Out.Trim() -eq 'True False') "out=$($r.Out.Trim()) exit=$($r.Code)"
            $r = Invoke-Kit $Rws @('--only=SKTEST_CHILD2=SKTEST_A', 'powershell', '-NoProfile', '-Command', '[bool]$env:SKTEST_CHILD2')
            Check 'ONLY-2' '--only=CHILD=VAULT form works' ($r.Out.Trim() -eq 'True') "out=$($r.Out.Trim()) exit=$($r.Code)"
            $r = Invoke-Kit $Rws @('powershell', '-NoProfile', '-Command', 'echo ran')
            Check 'ONLY-3' 'no --only / --all / RWS_ONLY: nothing runs, exit 2, usage names both flags' (($r.Code -eq 2) -and ($r.Out.Trim() -ne 'ran') -and ($r.Err -match '--only') -and ($r.Err -match '--all')) "exit=$($r.Code) out=$($r.Out.Trim())"
            $r = Invoke-Kit $Rws @('--only', 'SKTEST_A', '--all', 'powershell', '-NoProfile', '-Command', 'echo ran')
            Check 'ONLY-4' '--only together with --all is refused' (($r.Code -eq 2) -and ($r.Out.Trim() -ne 'ran')) "exit=$($r.Code)"

            # ---- registry AND store: a credential written behind the kit's back is never injected ----
            $vU = New-Value
            $null = & $PS -NoProfile -ExecutionPolicy Bypass -Command ". '$(Get-StoreScript $Tmp)'; `$s = New-Object Security.SecureString; foreach (`$ch in '$vU'.ToCharArray()) { `$s.AppendChar(`$ch) }; Set-Secret -Name SKTEST_UNREG -Value `$s" 2>&1
            Check 'REG-0' 'setup: a credential exists under the prefix with no KEYS.md row' ((Probe-Length $Tmp 'SKTEST_UNREG') -eq $vU.Length) "stored=$(Probe-Length $Tmp 'SKTEST_UNREG')"
            $r = Invoke-Kit $Rws @('--all', 'powershell', '-NoProfile', '-Command', '"$([bool]$env:SKTEST_UNREG) $([bool]$env:SKTEST_A)"')
            Check 'REG-1' '--all skips the unregistered credential (and says so by name), registered ones still flow' (($r.Out.Trim() -eq 'False True') -and ($r.Err -match 'not injected.*SKTEST_UNREG')) "out=$($r.Out.Trim()) exit=$($r.Code)"
            $r = Invoke-Kit $Rws @('--only', 'SKTEST_UNREG', 'powershell', '-NoProfile', '-Command', 'echo ran')
            Check 'REG-2' '--only on an unregistered credential fails closed (exit 127, child not run)' (($r.Code -eq 127) -and ($r.Out.Trim() -ne 'ran')) "exit=$($r.Code) out=$($r.Out.Trim())"
            $r = Invoke-Kit $Secrets @('check')
            Check 'REG-3' 'secrets check FAILs (not WARNs) on a stored-but-unregistered credential' ($r.Out -match '\[FAIL\] SKTEST_UNREG is stored but missing from KEYS.md') "exit=$($r.Code)"

            # ---- loader-affecting names are refused everywhere ----
            $vL = New-Value
            $f = Join-Path $Tmp 'l.txt'; Write-Utf8 $f $vL
            $r1 = Invoke-Kit $Secrets (@('add', 'NODE_OPTIONS') + $StdinFlag) $f
            $r2 = Invoke-Kit $Secrets (@('add', 'GIT_SSH_COMMAND') + $StdinFlag) $f
            Check 'FORBID-1' 'secrets add refuses NODE_OPTIONS and GIT_* names, nothing stored' (($r1.Code -ne 0) -and ($r2.Code -ne 0) -and ((Probe-Length $Tmp 'NODE_OPTIONS') -eq -1) -and ((Probe-Length $Tmp 'GIT_SSH_COMMAND') -eq -1)) "exits: $($r1.Code) $($r2.Code)"
            $r = Invoke-Kit $Rws @('--only', 'PATH=SKTEST_A', 'powershell', '-NoProfile', '-Command', 'echo ran')
            Check 'FORBID-2' '--only with a loader name as the child name is refused' (($r.Code -eq 2) -and ($r.Out.Trim() -ne 'ran')) "exit=$($r.Code)"
            $null = & $PS -NoProfile -ExecutionPolicy Bypass -Command ". '$(Get-StoreScript $Tmp)'; `$s = New-Object Security.SecureString; foreach (`$ch in '$vL'.ToCharArray()) { `$s.AppendChar(`$ch) }; Set-Secret -Name PYTHONSTARTUP -Value `$s" 2>&1
            # register it too, so only the loader-name rule stands between it and the child
            $kt = [IO.File]::ReadAllText($Keys); $kt = $kt.Replace('<!-- keys:end -->', "| PYTHONSTARTUP | planted | - | - | - | 2026-01-01 | - |`n<!-- keys:end -->"); Write-Utf8 $Keys $kt
            $r = Invoke-Kit $Rws @('--all', 'powershell', '-NoProfile', '-Command', '"$([bool]$env:PYTHONSTARTUP) $([bool]$env:SKTEST_A)"')
            Check 'FORBID-3' 'a planted PYTHONSTARTUP credential (stored AND registered) is still never injected by --all' (($r.Out.Trim() -eq 'False True') -and ($r.Err -match 'PYTHONSTARTUP')) "out=$($r.Out.Trim()) exit=$($r.Code)"
            $r = Invoke-Kit $Secrets @('check')
            Check 'FORBID-4' 'secrets check FAILs on the planted loader-name credential' ($r.Out -match '\[FAIL\] PYTHONSTARTUP .*loader') "exit=$($r.Code)"
            $kt = [IO.File]::ReadAllText($Keys); Write-Utf8 $Keys ($kt.Replace("| PYTHONSTARTUP | planted | - | - | - | 2026-01-01 | - |`n", ''))

            # ---- Guarded via the KEYS.md column (not the config) ----
            $kt = [IO.File]::ReadAllText($Keys)
            $kt2 = [regex]::Replace($kt, '(?m)^(\| SKTEST_G \|.*\|) - \|\s*$', '$1 yes |')
            if ($kt2 -eq $kt) { Write-Host '         (could not mark SKTEST_G guarded in KEYS.md; GUARD-5 will fail)' -ForegroundColor Yellow }
            Write-Utf8 $Keys $kt2
            $r = Invoke-Guarded @('--only', 'SKTEST_G', 'powershell', '-NoProfile', '-Command', 'echo ran') @{}
            Check 'GUARD-5' 'a key marked Guarded = yes in KEYS.md is guarded (dialog, withheld when not confirmed)' (($r.Code -eq 126) -and ($r.Out.Trim() -ne 'ran') -and ($r.Verdict -eq 'withheld')) "exit=$($r.Code) verdict=$($r.Verdict)"
            Write-Utf8 $Keys $kt

            # ---- Git Bash shim: a file redirect under MSYS arrives as a file, not a pipe ----
            $bash = @('C:\Program Files\Git\bin\bash.exe', 'C:\Program Files\Git\usr\bin\bash.exe') | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1
            if ($bash) {
                $vGB = New-Value
                $f = Join-Path $Tmp 'gb.txt'; Write-Utf8 $f $vGB
                $shim = (Join-Path $Bin 'secrets') -replace '\\', '/'
                $fPosix = $f -replace '\\', '/'
                $o = & $bash -c "'$shim' add SKTEST_GB -Stdin < '$fPosix'" 2>&1
                [void]$script:Captured.AppendLine('--- git bash shim ---').AppendLine(($o | Out-String))
                Check 'GB-1' 'Git Bash shim: secrets add NAME -Stdin < file stores the value (file redirect is not mistaken for a pipe)' ((Probe-Length $Tmp 'SKTEST_GB') -eq $vGB.Length) "stored=$(Probe-Length $Tmp 'SKTEST_GB') want=$($vGB.Length)"
            } else { Skip 'GB-1' 'Git Bash shim file redirect' 'bash.exe not found' }
        }

        # ---- Guarded keys (config-driven; dialog times out to No in 2 s) ----
        if ($Legacy) {
            Skip 'GUARD' 'guarded key withheld when the dialog is not confirmed' 'legacy guard list is hard-coded with a 300 s timeout'
        } else {
            $vH = New-Value
            $f = Join-Path $Tmp 'h.txt'; Write-Utf8 $f $vH
            $r = Invoke-Kit $Secrets (@('add', 'SKTEST_GUARDED') + $StdinFlag) $f
            $r = Invoke-Guarded @('powershell', '-NoProfile', '-Command', 'echo ran') @{ RWS_ONLY = 'SKTEST_GUARDED' }
            Check 'GUARD-1' 'RWS_ONLY on a guarded key: dialog not confirmed -> exit 126, child not started' (($r.Code -eq 126) -and ($r.Out.Trim() -ne 'ran') -and ($r.Verdict -eq 'withheld')) "exit=$($r.Code) verdict=$($r.Verdict) $([math]::Round($r.Seconds,1))s"
            $r = Invoke-Guarded ($AllFlag + @('powershell', '-NoProfile', '-Command', '"$([bool]$env:SKTEST_GUARDED) $([bool]$env:SKTEST_A)"')) @{}
            Check 'GUARD-2' 'all-keys mode: guarded key withheld (message on stderr), the others still injected' (($r.Out.Trim() -eq 'False True') -and ($r.Verdict -eq 'withheld')) "out=$($r.Out.Trim()) exit=$($r.Code) verdict=$($r.Verdict) $([math]::Round($r.Seconds,1))s"
            $r = Invoke-Guarded @('powershell', '-NoProfile', '-Command', 'echo ran') @{ RWS_ONLY = 'SKTEST_ALIAS=SKTEST_GUARDED' }
            Check 'GUARD-3' 'RWS_ONLY alias CHILD=GUARDED_VAULT still hits the guard (exit 126, child not run)' (($r.Code -eq 126) -and ($r.Out.Trim() -ne 'ran') -and ($r.Verdict -eq 'withheld')) "exit=$($r.Code) verdict=$($r.Verdict) $([math]::Round($r.Seconds,1))s"
            $r = Invoke-Guarded @('powershell', '-NoProfile', '-Command', '"ran $([bool]$env:SKTEST_A)"') @{ RWS_ONLY = 'SKTEST_A,SKTEST_GUARDED' }
            Check 'GUARD-4' 'RWS_ONLY mixed list with a guarded key: nothing injected and the child never runs when not confirmed' (($r.Code -eq 126) -and ($r.Out.Trim() -eq '') -and ($r.Verdict -eq 'withheld')) "exit=$($r.Code) verdict=$($r.Verdict) $([math]::Round($r.Seconds,1))s"
        }

        # ---- config file is data, and bad values are refused before any store access ----
        if (-not $Legacy) {
        $cfgPath = Join-Path $Tmp 'secrets-kit.config.psd1'
        $cfgGood = [IO.File]::ReadAllText($cfgPath)
        $marker = Join-Path $Tmp 'cfg-marker.txt'
        Write-Utf8 $cfgPath ("@{ Prefix = (New-Item -ItemType File -Path '" + $marker.Replace("'", "''") + "').Name }")
        $r = Invoke-Kit $Secrets @('list')
        Check 'CFG-1' 'an expression in the config file is refused as data (no code runs, non-zero exit)' (($r.Code -ne 0) -and -not (Test-Path $marker)) "exit=$($r.Code) marker-created=$(Test-Path $marker)"
        Write-Utf8 $cfgPath "@{ Prefix = 'nocolon' }"
        $r1 = Invoke-Kit $Secrets @('list')
        Write-Utf8 $cfgPath "@{ Prefix = 'ok:'; Guarded = @('lower_case') }"
        $r2 = Invoke-Kit $Secrets @('list')
        Write-Utf8 $cfgPath "@{ Prefix = 'ok:'; GuardTimeoutSeconds = 0 }"
        $r3 = Invoke-Kit $Secrets @('list')
        Check 'CFG-2' 'malformed Prefix / Guarded / GuardTimeoutSeconds are refused' (($r1.Code -ne 0) -and ($r2.Code -ne 0) -and ($r3.Code -ne 0)) "exits: $($r1.Code) $($r2.Code) $($r3.Code)"
        Write-Utf8 $cfgPath $cfgGood
        }

        # ---- -Debug / -Verbose on the command line must not reopen the stdin-echo prompt ----
        $vZ = New-Value
        $f = Join-Path $Tmp 'z.txt'; Write-Utf8 $f $vZ
        $r1 = Invoke-Kit $Secrets (@('add', 'SKTEST_Z') + $StdinFlag + @('-Debug')) $f
        $r2 = Invoke-Kit $Secrets (@('-Verbose', 'add', 'SKTEST_Z') + $StdinFlag) $f
        Check 'DBG-1' '-Debug / -Verbose are inert: no value printed, no stored value via those forms' (($r1.All -notlike "*$vZ*") -and ($r2.All -notlike "*$vZ*") -and ($r1.Code -ne 0) -and ((Probe-Length $Tmp 'SKTEST_Z') -eq -1)) "exits: $($r1.Code) $($r2.Code) stored=$(Probe-Length $Tmp 'SKTEST_Z')"

        # ---- child environment hygiene ----
        $r = Invoke-Kit $Rws ($AllFlag + @('powershell', '-NoProfile', '-Command', '"$([bool]$env:__SECRETS_KIT_PS) $([bool]$env:__SECRETS_KIT_DIR) $([bool]$env:PSExecutionPolicyPreference) $([bool]$env:RWS_ONLY)"'))
        Check 'ENV-1' 'child inherits none of the launcher internals (__SECRETS_KIT_*, PSExecutionPolicyPreference, RWS_ONLY)' ($r.Out.Trim() -eq 'False False False False') "out=$($r.Out.Trim())"

        if (-not $Legacy) {
            $r = Invoke-Kit $Secrets @('list')
            Check 'LIST-G' 'secrets list marks the config-guarded key [guarded]' ($r.Out -match 'SKTEST_GUARDED\s+set\s+\S+\s+.*\[guarded\]') "exit=$($r.Code)"
        }

        # ---- secrets list / check / path: names only, config honoured ----
        $r = Invoke-Kit $Secrets @('list')
        Check 'LIST' 'secrets list shows the throwaway names and a set/unset count' (($r.Out -match 'SKTEST_A') -and ($r.Out -match '\d+ set')) "exit=$($r.Code)"
        $r = Invoke-Kit $Secrets @('path')
        Check 'PATH' 'secrets path reports the configured prefix' ($r.Out -like "*$Prefix*") "exit=$($r.Code)"
        $r = Invoke-Kit $Secrets @('check')
        Check 'CHECK-1' 'secrets check runs and has a NO LEFTOVER COPIES section' ($r.Out -match 'NO LEFTOVER COPIES') "exit=$($r.Code)"
        if (-not $Legacy) {
            Check 'CHECK-2' 'secrets check says it does not verify deny-rule enforcement' ($r.Out -match 'does NOT verify') 'F12 wording missing'
        }

        # ---- the invariant: no generated value anywhere in any output or in KEYS.md ----
        $all = $script:Captured.ToString() + "`n" + [IO.File]::ReadAllText($Keys)
        $leaked = @($script:Values | Where-Object { $all -like "*$_*" })
        Check 'LEAK' "no generated value appeared in any captured output or in KEYS.md ($($script:Values.Count) values checked)" ($leaked.Count -eq 0) "$($leaked.Count) value(s) leaked"
    } finally {
        $n = Remove-TestSecrets $Tmp
        Write-Host ''
        Write-Host "  teardown: removed $n throwaway credential(s) under $Prefix*; deleting $Tmp" -ForegroundColor DarkGray
        Remove-Item -Path $Tmp -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# =============================================================================
if ($Live) {
    $Bin = Join-Path $KitRoot 'bin'
    $Secrets = Join-Path $Bin 'secrets.cmd'
    $Rws = Join-Path $Bin 'run-with-secrets.cmd'
    $res = & $PS -NoProfile -Command "(Get-Command secrets).Source; (Get-Command run-with-secrets).Source" 2>&1
    $res = @($res | ForEach-Object { [string]$_ })
    Check 'LIVE-1' 'a fresh PowerShell resolves secrets / run-with-secrets to the .cmd launchers in this install' (($res.Count -eq 2) -and ($res[0] -eq $Secrets) -and ($res[1] -eq $Rws)) ("resolved: " + ($res -join ' | '))
    $ps1 = @(Get-ChildItem -Path $Bin -Filter *.ps1 -File)
    Check 'LIVE-2' 'live bin\ has no .ps1' ($ps1.Count -eq 0) ("found: " + (($ps1 | ForEach-Object { $_.Name }) -join ', '))
    $hub = @(Get-Command hub-mcp-headers -ErrorAction SilentlyContinue)
    Check 'LIVE-3' 'hub-mcp-headers is not on PATH' ($hub.Count -eq 0) ("found: " + (($hub | ForEach-Object { $_.Source }) -join ', '))
    $r = Invoke-Kit $Secrets @('list')
    $m = [regex]::Match($r.Out, '(\d+) set, (\d+) unset')
    Check 'LIVE-4' 'secrets list runs (names only)' ($m.Success) "exit=$($r.Code)"
    if ($m.Success) { Write-Host "         list: $($m.Groups[1].Value) set, $($m.Groups[2].Value) unset" -ForegroundColor DarkGray }
    $r = Invoke-Kit $Secrets @('check')
    $m2 = [regex]::Match($r.Out, 'reachable \((\d+) key\(s\)')
    Check 'LIVE-5' 'secrets check runs and agrees with list on the stored count' ($m.Success -and $m2.Success -and ($m.Groups[1].Value -eq $m2.Groups[1].Value)) "exit=$($r.Code)"
    $fails = @([regex]::Matches($r.Out, '\[FAIL\][^\r\n]*') | ForEach-Object { $_.Value })
    Write-Host "         check exit=$($r.Code); FAIL lines: $($fails.Count)" -ForegroundColor DarkGray
    foreach ($fl in $fails) { Write-Host "           $fl" -ForegroundColor DarkGray }
    # MCP-shaped presence probes: booleans only, exactly what the MCP entries ask for.
    foreach ($spec in @(@('github', 'GITHUB_PERSONAL_ACCESS_TOKEN=GITHUB_PAT', 'GITHUB_PERSONAL_ACCESS_TOKEN'), @('gpt-image-2', 'OPENAI_API_KEY', 'OPENAI_API_KEY'))) {
        $probe = "console.log(Boolean(process.env.$($spec[2])))"
        if ($probe -notmatch '^console\.log\(Boolean\(process\.env\.[A-Z0-9_]+\)\)$') { throw 'live probe is not boolean-shaped; refusing to run it against the real store' }
        $r = Invoke-Kit $Rws @('node', '-e', $probe) $null @{ RWS_ONLY = $spec[1] }
        $t = $r.Out.Trim()
        # Never echo the child's stdout here: report its shape only.
        Check "LIVE-$($spec[0])" "MCP entry shape for $($spec[0]) (RWS_ONLY=$($spec[1])) hands the child the key (boolean probe)" ($t -eq 'true') "stdout is boolean: $($t -in 'true', 'false'); len=$($t.Length); exit=$($r.Code)"
    }
}

# =============================================================================
Write-Host ''
$failed = @($script:Results | Where-Object { -not $_.Pass })
Write-Host ("  {0} checks, {1} passed, {2} failed" -f $script:Results.Count, ($script:Results.Count - $failed.Count), $failed.Count) -ForegroundColor $(if ($failed.Count -eq 0) { 'Green' } else { 'Red' })
Write-Host ''
exit ([int]($failed.Count -gt 0))

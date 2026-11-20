# secrets-impl.ps1 - manage secret NAMES and metadata. Never prints a secret VALUE.
#
# Everything this script prints goes through Say(), except Read-Host prompts
# (Read-Line, Read-SecretValue) and uncaught error messages. Those are the only
# places to audit for value leakage. Get-SecretValue is never called from this
# file - only run-with-secrets-impl.ps1 calls it.

# No param block on purpose (same reason as run-with-secrets-impl.ps1): any
# [Parameter()] or [CmdletBinding()] makes the script advanced, and the binder
# then prefix-matches common parameters. `add NAME -p VALUE` bound VALUE to
# -PipelineVariable silently; `-ea VALUE` printed it in a binding error. -Stdin
# (exact, any case) is the only flag; `add NAME value` lands in $Rest.
$Stdin   = @($args | Where-Object { $_ -eq '-Stdin' }).Count -gt 0
$pos     = @($args | Where-Object { $_ -ne '-Stdin' })
$Command = if ($pos.Count -gt 0) { [string]$pos[0] } else { 'help' }
$Name    = if ($pos.Count -gt 1) { [string]$pos[1] } else { '' }
$Rest    = if ($pos.Count -gt 2) { @($pos[2..($pos.Count - 1)]) } else { @() }

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
# Deliberately ignore -Debug/-Verbose. For a tool whose entire contract is "never
# emit a value", a debug stream that can turn into a stdin-echoing prompt is a
# leak channel, not a feature.
$DebugPreference   = 'SilentlyContinue'
$VerbosePreference = 'SilentlyContinue'

. (Join-Path $PSScriptRoot 'CredentialStore.ps1')
. (Join-Path $PSScriptRoot 'KeysRegistry.ps1')

# The registry sits one level above lib\ - the install dir, or the repo root
# when run straight from a clone. Only bin\ (the launchers) goes on PATH.
$KitRoot  = $script:KitRoot
$KeysFile = $script:KeysFile
$BinDir   = Join-Path $KitRoot 'bin'

# Output choke point. The only other console writers are the Read-Host prompts
# below and uncaught errors.
function Say { param([string]$Text = '', [string]$Color = 'Gray') Write-Host $Text -ForegroundColor $Color }
function Ok   { param([string]$T) Say "  [PASS] $T" 'Green' }
function Bad  { param([string]$T) Say "  [FAIL] $T" 'Red' }
function Warn { param([string]$T) Say "  [WARN] $T" 'Yellow' }

function Say-Burned {
    Say 'If you typed a key value on that command line, it is now in your shell history. Revoke it at the issuer and issue a new one.' 'Yellow'
}

function Assert-Name {
    param([string]$N)
    if ($Rest) {
        $tail = if ($Command -in 'add', 'rotate') { ' - the value is asked for separately, with hidden input.' } else { '' }
        Say "Usage: secrets $Command <NAME>$tail" 'Red'; Say-Burned; exit 2
    }
    if ([string]::IsNullOrWhiteSpace($N)) { Say "Usage: secrets $Command <NAME>" 'Red'; exit 2 }
    # -c: -notmatch ignores case. \z not $: .NET's $ also matches just before a
    # trailing newline, so "FOO`n" would pass and split the KEYS.md row in two.
    if ($N -cnotmatch '^[A-Z][A-Z0-9_]*\z') {
        # Never echo $N: `add NAME=value` (a dotenv habit) would print the value.
        Say 'Key names must be UPPER_SNAKE_CASE (env-var shaped), e.g. OPENAI_API_KEY.' 'Red'
        # Always: a pasted key where the name goes is often 40 chars or fewer.
        Say-Burned
        exit 2
    }
    if (Test-ForbiddenName $N) {
        Say "$N changes how programs load code or where they connect (PATH, NODE_OPTIONS, PYTHONPATH, HTTPS_PROXY, ...). It cannot be a key name here." 'Red'
        exit 2
    }
}

# KEYS.md reading and writing lives in KeysRegistry.ps1 (shared with run-with-secrets).

# One reader for all non-secret prompts. Read-Host and [Console]::In do not share
# a buffer, so mixing them against redirected stdin silently drops lines.
function Read-Line {
    param([string]$Prompt)
    if ([Console]::IsInputRedirected) {
        Say "  $Prompt" 'DarkGray'
        return [Console]::In.ReadLine()
    }
    return Read-Host "  $Prompt"
}

function Prompt-Meta {
    param([string]$Label, [string]$Current)
    $suffix = if ($Current) { " [$Current]" } else { '' }
    $v = Read-Line "$Label$suffix"
    if ([string]::IsNullOrWhiteSpace($v)) { return $Current }
    return ($v -replace '\|', '/').Trim()
}

# Silent input. Never echoed, never entered into PSReadLine history.
#
# Read-Host -AsSecureString needs a real console; with stdin redirected it blocks
# forever, so a piped invocation would deadlock. When input is redirected we read
# stdin directly instead - but only with -Stdin. Git Bash/mintty with pseudo
# consoles off (Git for Windows <= 2.46, or MSYS=disable_pcon) also hands us a
# pipe, and its pty ECHOES every typed character. That path also briefly holds the
# value in a managed string, which the interactive path never does.
function Read-SecretValue {
    param([string]$Prompt)

    if ([Console]::IsInputRedirected) {
        if (-not $Stdin) {
            Say 'stdin is not a console here, so typed input would NOT be hidden. Nothing was read or changed.' 'Red'
            Say 'Run this in PowerShell, cmd or Windows Terminal (or update Git for Windows).' 'Red'
            Say '(-Stdin is only for reading a file - cmd or Git Bash: secrets add NAME -Stdin < key.txt; PowerShell: cmd /c "secrets add NAME -Stdin < key.txt". Never type or paste into it.)' 'Red'
            exit 2
        }
        # `echo VALUE | secrets add NAME -Stdin` puts the value in shell history and in
        # any agent transcript, the same burn as a value on the command line. The handle
        # type tells a pipe (3) from the documented file redirect (1); refuse the pipe.
        if (-not ('SecretsKit.StdinKind' -as [type])) {
            Add-Type -Debug:$false -Language CSharp -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
namespace SecretsKit {
    public static class StdinKind {
        [DllImport("kernel32.dll", SetLastError = true)] static extern IntPtr GetStdHandle(int nStdHandle);
        [DllImport("kernel32.dll")] static extern uint GetFileType(IntPtr hFile);
        public static uint Get() { return GetFileType(GetStdHandle(-10)); }
    }
}
'@
        }
        $kind = [SecretsKit.StdinKind]::Get()
        if ($kind -ne 1) {
            Say 'Refused: the value came through a pipe, not a file. Nothing was read or changed.' 'Red'
            Say 'A value typed after echo is in your shell history and in any agent transcript: revoke it at the issuer.' 'Red'
            Say '-Stdin reads a file only: secrets add NAME -Stdin < key.txt' 'Red'
            exit 2
        }
        Say "$Prompt [reading from the redirected file]" 'DarkGray'
        # ReadToEnd, not ReadLine. A multi-line value (PEM, JSON blob) would
        # otherwise leave its continuation lines in the shared stdin buffer, where
        # the metadata prompts below read them straight into KEYS.md -- publishing
        # the tail of the secret to a committed file while silently storing only
        # line 1. Draining the stream makes the later prompts see EOF and keep
        # their defaults.
        # Decode by BOM, else UTF-8 - not by the console code page, which turns the
        # UTF-16LE that PS 5.1's `>` writes (and a UTF-8 BOM) into a mangled value.
        $plain = (New-Object IO.StreamReader([Console]::OpenStandardInput(), (New-Object Text.UTF8Encoding($false)), $true)).ReadToEnd()
        if ($null -ne $plain) { $plain = $plain.TrimEnd("`r", "`n") }
        if ([string]::IsNullOrEmpty($plain)) { Say 'Empty value - aborted, nothing was changed.' 'Red'; exit 2 }
        # BOM-less UTF-16 still decodes to NULs, and a NUL silently truncates the
        # variable run-with-secrets injects. Tab/CR/LF stay allowed (PEM, JSON).
        if ($plain -match '[\x00-\x08\x0B\x0C\x0E-\x1F\uFFFD]') {
            Say 'That input has control characters or is not UTF-8/UTF-16 text - nothing was changed. Save it as UTF-8 and retry.' 'Red'; exit 2
        }
        Assert-Size $plain.Length
        $s = New-Object System.Security.SecureString
        foreach ($ch in $plain.ToCharArray()) { $s.AppendChar($ch) }
        $s.MakeReadOnly()
        Remove-Variable plain
        return $s
    }

    $s = Read-Host $Prompt -AsSecureString
    # The hidden read ends at the first line break. The rest of a multi-line paste
    # stays in the console input buffer, where the next (echoing) prompt would show
    # it and write it to KEYS.md - or, after exit, the shell would run it and log it
    # to history. Discard it and store nothing: line 1 alone is probably not the key.
    if ([Console]::KeyAvailable) {
        $Host.UI.RawUI.FlushInputBuffer()
        $s.Dispose()
        Say 'That paste had more than one line. Discarded - nothing was changed. Paste only the key itself.' 'Red'; exit 2
    }
    if ($s.Length -eq 0) { Say 'Empty value - aborted, nothing was changed.' 'Red'; exit 2 }
    Assert-Size $s.Length
    return $s
}

# Same limit Set-Secret enforces, refused here as a clean exit 2 instead of a raw
# error record. Only the length is shown.
function Assert-Size {
    param([int]$Len)
    if ($Len -gt $script:MaxSecretChars) {
        Say "That value is $Len chars; Credential Manager caps a key at $($script:MaxSecretChars). Nothing was changed." 'Red'; exit 2
    }
}

# --- commands -------------------------------------------------------------

function Cmd-Add {
    param([string]$N, [switch]$IsRotate)
    Assert-Name $N
    # A broken KEYS.md must fail here, before the value is taken, or the key would be
    # stored but unrecorded (and, from now on, never injected).
    try { Assert-Registry } catch { Say $_.Exception.Message 'Red'; exit 2 }
    $reg = @(Read-Registry)
    $row = $reg | Where-Object { $_.Name -eq $N } | Select-Object -First 1
    $exists = (Get-SecretLength $N) -ge 0

    if ($IsRotate) {
        if (-not $exists) { Say "$N is not set. Use: secrets add $N" 'Red'; exit 2 }
        if ($row -and $row.RotateUrl -and $row.RotateUrl -ne '-') {
            Say ''
            Say "  Issue a new $N at:" 'Cyan'
            Say "  $($row.RotateUrl)" 'Cyan'
            if ($row.Scope -and $row.Scope -ne '-') { Say "  Scope it to: $($row.Scope)" 'Cyan' }
            Say ''
        } else {
            Warn "No rotation URL recorded for $N. Add one in KEYS.md."
        }
    } elseif ($exists) {
        Warn "$N already has a value. Continuing will overwrite it."
    }

    $val = Read-SecretValue ("  Value for $N (input hidden)")
    Set-Secret -Name $N -Value $val
    $val.Dispose()

    $cur = @{ Purpose = '-'; Issuer = '-'; RotateUrl = '-'; Scope = '-'; Guarded = $false }
    if ($row) {
        $cur.Purpose = $row.Purpose; $cur.Issuer = $row.Issuer
        $cur.RotateUrl = $row.RotateUrl; $cur.Scope = $row.Scope; $cur.Guarded = $row.Guarded
    }

    if ($IsRotate -and $row) {
        # Rotation keeps the metadata; only the value and the date change.
        $purpose = $cur.Purpose; $issuer = $cur.Issuer
        $rotateUrl = $cur.RotateUrl; $scope = $cur.Scope; $guarded = $cur.Guarded
    } else {
        Say ''
        Say '  Registry metadata (Enter to keep the shown default):' 'DarkGray'
        $purpose   = Prompt-Meta 'What is it for'      $cur.Purpose
        $issuer    = Prompt-Meta 'Issued by (service)'  $cur.Issuer
        $rotateUrl = Prompt-Meta 'Rotate at (URL)'      $cur.RotateUrl
        $scope     = Prompt-Meta 'Scope it should have' $cur.Scope
        $gDefault  = if ($cur.Guarded) { 'y' } else { 'n' }
        $gAns      = Prompt-Meta 'Guarded: ask on a dialog before run-with-secrets releases it (y/n)' $gDefault
        $guarded   = ($gAns -match '^(?i)y')
    }

    $new = [pscustomobject]@{
        Name = $N; Purpose = $purpose; Issuer = $issuer
        RotateUrl = $rotateUrl; Scope = $scope
        LastRotated = (Get-Date -Format 'yyyy-MM-dd')
        Guarded = $guarded
    }
    Write-Registry (@($reg | Where-Object { $_.Name -ne $N }) + $new)

    $verb = if ($IsRotate) { 'rotated' } else { 'stored' }
    Say ''
    Say "  $N $verb in Credential Manager and recorded in KEYS.md." 'Green'
    if ($IsRotate) { Warn "Revoke the OLD $N at the issuer now - rotation is not complete until the old one is dead." }
}

function Cmd-List {
    $reg = @(Read-Registry)
    $live = @(Get-SecretIndex)
    $guardedAll = @(Get-GuardedNames)
    # The outer @() matters: with a single key the pipeline returns a bare string,
    # and .Count on a string throws under StrictMode Latest.
    $names = @(@(@($reg | ForEach-Object { $_.Name }) + @($live | ForEach-Object { $_.Name })) |
               Where-Object { $_ } | Sort-Object -Unique)
    if ($names.Count -eq 0) { Say 'No keys yet. Add one:  secrets add MY_API_KEY' 'DarkGray'; return }

    Say ''
    Say ('  {0,-28} {1,-9} {2,-12} {3}' -f 'KEY', 'STATUS', 'LAST SET', 'ISSUED BY') 'White'
    Say ('  ' + ('-' * 72)) 'DarkGray'
    foreach ($n in $names) {
        $l = $live | Where-Object { $_.Name -eq $n } | Select-Object -First 1
        $r = $reg  | Where-Object { $_.Name -eq $n } | Select-Object -First 1
        $status = if ($l) { 'set' } else { 'UNSET' }
        $when   = if ($l -and $l.LastWritten) { $l.LastWritten.ToString('yyyy-MM-dd') } else { '-' }
        $issuer = if ($r -and $r.Issuer) { $r.Issuer } else { '-' }
        if ($guardedAll -contains $n) { $issuer = "$issuer [guarded]" }
        $color  = if ($l) { 'Gray' } else { 'Yellow' }
        Say ('  {0,-28} {1,-9} {2,-12} {3}' -f $n, $status, $when, $issuer) $color
    }
    Say ''
    Say "  $($live.Count) set, $(@($names).Count - @($live).Count) unset. Values are never displayed." 'DarkGray'
}

function Cmd-Rm {
    param([string]$N)
    Assert-Name $N
    try { Assert-Registry } catch { Say $_.Exception.Message 'Red'; exit 2 }
    $confirm = Read-Line "Delete $N from Credential Manager and KEYS.md? (y/N)"
    if ($confirm -ne 'y') { Say 'Aborted.' 'DarkGray'; return }
    $removed = Remove-Secret $N
    Write-Registry @(Read-Registry | Where-Object { $_.Name -ne $N })
    if ($removed) { Say "  $N deleted." 'Green' } else { Say "  $N had no stored value; registry row removed." 'Yellow' }
}

function Cmd-Path {
    Say ''
    Say '  There is no secrets file. Values live in Windows Credential Manager.' 'White'
    Say ''
    Say '  Credential target prefix   ' 'DarkGray'; Say "    $($script:SecretsPrefix)*" 'Cyan'
    Say '  Inspect / edit by hand     ' 'DarkGray'; Say '    control /name Microsoft.CredentialManager' 'Cyan'
    Say '  Key registry (no values)   ' 'DarkGray'; Say "    $KeysFile" 'Cyan'
    $cfgNote = if (Test-Path -LiteralPath $script:ConfigFile) { '' } else { ' (absent; defaults)' }
    Say '  Config (prefix, guarded)   ' 'DarkGray'; Say "    $($script:ConfigFile)$cfgNote" 'Cyan'
    $g = @(Get-GuardedNames)
    if ($g.Count -gt 0) { Say '  Guarded (dialog to release)' 'DarkGray'; Say "    $($g -join ', ')" 'Cyan' }
    Say ''
    Say '  Nothing to chmod and nothing to gitignore - that is the point of this backend.' 'DarkGray'
    Say '  Anything running as you can still read them, including an AI agent that tries.' 'DarkGray'
}

function Cmd-Check {
    $fails = 0
    Say ''
    Say '  BACKEND' 'White'
    try {
        $live = @(Get-SecretIndex)
        Ok "Credential Manager reachable ($($live.Count) key(s) under $($script:SecretsPrefix)*)"
    } catch { Bad "Credential Manager unreachable: $($_.Exception.Message)"; $fails++; $live = @() }

    Say ''
    Say '  INSTALL' 'White'
    if (Test-Path $KeysFile) { Ok "Key registry at $KeysFile" }
    else { Bad "Key registry missing at $KeysFile - re-run install.ps1"; $fails++ }
    foreach ($cmd in 'secrets', 'run-with-secrets') {
        $found = @(Get-Command $cmd -CommandType Application, ExternalScript -ErrorAction SilentlyContinue)
        if ($found.Count -eq 0) {
            Warn "$cmd is not on PATH in this terminal. Open a new one (in VS Code/Cursor, restart the editor)."
        } elseif ((Split-Path $found[0].Source -Parent).TrimEnd('\') -ne $BinDir.TrimEnd('\')) {
            Bad "Another '$cmd' runs first on PATH: $($found[0].Source)"; $fails++
        } else { Ok "$cmd on PATH ($BinDir)" }
    }

    # A clone or a repo-hosted install (KEYS.md lives in a git repo) also gets the
    # file-level checks: nothing credential-shaped on disk, the usual names
    # gitignored, the pre-commit scanner wired and gitleaks present.
    if (Test-Path -LiteralPath (Join-Path $KitRoot '.git')) {
        Say ''
        Say '  NO PLAINTEXT ON DISK (file names only)' 'White'
        $strays = @(Get-ChildItem -Path $KitRoot -Recurse -File -Force -ErrorAction SilentlyContinue |
            Where-Object { $_.FullName -notmatch '\\\.git\\' -and $_.FullName -notmatch '\\node_modules\\' } |
            Where-Object { $_.Name -ne '.env.example' } |
            Where-Object { $_.Name -match '^\.env' -or $_.Name -eq 'secrets.env' -or $_.Extension -in '.pem', '.key', '.pfx', '.p12', '.ppk' })
        if ($strays.Count -eq 0) { Ok 'No .env / secrets.env / .pem / .key / .pfx / .p12 / .ppk files anywhere in the repo' }
        else { foreach ($st in $strays) { Bad "Credential-shaped file in repo: $($st.FullName)"; $fails++ } }

        Say ''
        Say '  GIT BOUNDARY' 'White'
        # PS 5.1 wraps a redirected native command's stderr in a NativeCommandError,
        # which $ErrorActionPreference='Stop' promotes to terminating; one git
        # warning would abort the rest of the checks.
        $git = Get-Command git -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
        $hp = $null
        if (-not $git) {
            Bad 'git is not on PATH; cannot verify .gitignore or the pre-commit hook'; $fails++
        } else {
            $prevEap = $ErrorActionPreference
            $ErrorActionPreference = 'Continue'
            try {
                foreach ($p in '.env', '.env.local', 'secrets.env', 'test.pem', 'test.key') {
                    & $git.Source -C $KitRoot check-ignore -q -- $p 2>$null
                    if ($LASTEXITCODE -eq 0) { Ok "gitignored: $p" } else { Bad "NOT gitignored: $p"; $fails++ }
                }
                $hp = (& $git.Source -C $KitRoot config core.hooksPath) 2>$null
            } finally { $ErrorActionPreference = $prevEap }
            if ($hp -and (Test-Path -LiteralPath (Join-Path $KitRoot (Join-Path $hp 'pre-commit')))) {
                Ok "pre-commit hook installed (core.hooksPath=$hp)"
            } else { Bad "pre-commit hook not wired (core.hooksPath='$hp')"; $fails++ }
        }
        if (Get-Command gitleaks -CommandType Application -ErrorAction SilentlyContinue) { Ok 'gitleaks on PATH' }
        else { Bad 'gitleaks not on PATH - the hook will block every commit until it is'; $fails++ }
    }

    Say ''
    Say '  AGENT DENY RULES' 'White'
    Say '    This kit does NOT verify that deny rules are enforced, only that the ones you' 'DarkGray'
    Say '    listed in secrets-kit.config.psd1 (DenyRules) are present in ~/.claude/settings.json.' 'DarkGray'
    if ($script:DenyRules.Count -eq 0) {
        Say '    (none listed; deny rules are yours to keep - see README)' 'DarkGray'
    } else {
        $userSettings = Join-Path $env:USERPROFILE '.claude\settings.json'
        $deny = @()
        if (Test-Path -LiteralPath $userSettings) {
            try { $deny = @((Get-Content -LiteralPath $userSettings -Raw | ConvertFrom-Json).permissions.deny) } catch { $deny = @() }
        }
        foreach ($need in $script:DenyRules) {
            # Read(.env) and Read(**/.env) are the same rule to Claude Code; accept either spelling.
            $alt = $need -replace '^Read\(\*\*/', 'Read('
            if ($need -eq $alt) { $alt = $need -replace '^Read\(', 'Read(**/' }
            if ($deny -contains $need -or $deny -contains $alt) { Ok "deny rule present: $need" }
            else { Bad "deny rule missing: $need"; $fails++ }
        }
    }

    Say ''
    Say '  KEY VALUES (presence only - values are never shown)' 'White'
    $reg = @(Read-Registry)
    if ($reg.Count -eq 0) { Say '    (registry is empty)' 'DarkGray' }
    foreach ($r in $reg) {
        $len = Get-SecretLength $r.Name
        if ($len -gt 0) { Ok "$($r.Name) is set (non-empty)" }
        elseif ($len -eq 0) { Bad "$($r.Name) is set but EMPTY"; $fails++ }
        else { Bad "$($r.Name) is in KEYS.md but has no stored value"; $fails++ }
    }
    foreach ($l in $live) {
        if (-not ($reg | Where-Object { $_.Name -eq $l.Name })) {
            Bad "$($l.Name) is stored but missing from KEYS.md. run-with-secrets will not inject it until you add it (secrets add $($l.Name)) or remove it (secrets rm $($l.Name))"; $fails++
        }
        if (Test-ForbiddenName $l.Name) {
            Bad "$($l.Name) is stored under this prefix but is a loader/connection name; something other than this kit wrote it. It is never injected. Remove it: secrets rm $($l.Name)"; $fails++
        }
    }

    # A key that is also a saved or inherited environment variable reaches every
    # program, so the kit protects nothing for it. Names only: GetValueNames and
    # Test-Path never hand a value to this script.
    Say ''
    Say '  NO LEFTOVER COPIES (variable names only)' 'White'
    $saved = @{}
    foreach ($s in @(
        @([Microsoft.Win32.Registry]::CurrentUser, 'Environment', 'your saved user environment variables'),
        @([Microsoft.Win32.Registry]::LocalMachine, 'SYSTEM\CurrentControlSet\Control\Session Manager\Environment', 'the system environment variables'))) {
        $k = $s[0].OpenSubKey($s[1])
        if (-not $k) { continue }
        try { foreach ($v in $k.GetValueNames()) { if (-not $saved.ContainsKey($v)) { $saved[$v] = $s[2] } } }
        finally { $k.Close() }
    }
    $names = @(@(@($reg | ForEach-Object { $_.Name }) + @($live | ForEach-Object { $_.Name })) |
               Where-Object { $_ } | Sort-Object -Unique)
    $dupes = 0
    foreach ($n in $names) {
        $where = $null; $fix = 'Delete that copy.'
        if ($saved.ContainsKey($n)) { $where = $saved[$n] }
        elseif (Test-Path -LiteralPath "env:$n") {
            $where = "this terminal's environment"
            $fix = 'Remove it from your profile/.bashrc. If there is none, this terminal (or the editor it runs in) was opened before you deleted a saved copy, or under run-with-secrets: open a new one from the Start menu.'
        }
        if ($where) { Bad "$n is also in $where - every program started there gets it. $fix"; $fails++; $dupes++ }
    }
    # A key saved under a DIFFERENT name (GITHUB_PERSONAL_ACCESS_TOKEN beside a
    # stored GITHUB_PAT) is still a leftover. Two heuristics, names and lengths
    # only: a credential-shaped variable name, or a value exactly as long as a
    # stored key. The saved value is read to measure it and dropped at once; it
    # is never compared, copied or printed.
    $nameShape = '(?i)(^|_)(API|AUTH|BEARER|CREDENTIALS?|KEY|PAT|PASS|PASSWORD|PASSWD|PRIVATE|PWD|SECRET|TOKEN)(_|$)'
    $benign = @('PATHEXT', 'PSMODULEPATH', 'PUBLIC', 'SSH_AUTH_SOCK', 'GPG_AGENT_INFO', 'ANDROID_SDK_ROOT', 'JAVA_HOME', 'PYTHONUTF8', 'PYTHONPATH')
    $lengths = @{}
    foreach ($l in $live) { if ($l.Length -ge 16) { $lengths[[string]$l.Length] = $l.Name } }
    foreach ($s in @(
        @([Microsoft.Win32.Registry]::CurrentUser, 'Environment', 'your saved user environment variables'),
        @([Microsoft.Win32.Registry]::LocalMachine, 'SYSTEM\CurrentControlSet\Control\Session Manager\Environment', 'the system environment variables'))) {
        $k = $s[0].OpenSubKey($s[1])
        if (-not $k) { continue }
        try {
            foreach ($v in $k.GetValueNames()) {
                if ($names -contains $v -or $benign -contains $v.ToUpper() -or $v -eq 'Path') { continue }
                $len = ([string]$k.GetValue($v, '', 'DoNotExpandEnvironmentNames')).Length
                if ($v -match $nameShape) {
                    Bad "$v (in $($s[2]), $len chars) has a credential-shaped name. If it is a key, store it with: secrets add NAME, then delete the variable and rotate the key: every program you have started could read it."
                    $fails++; $dupes++
                } elseif ($len -ge 16 -and $lengths.ContainsKey([string]$len)) {
                    Warn "$v (in $($s[2])) is exactly as long as the stored key $($lengths[[string]$len]) ($len chars). Probably a coincidence; check it is not a copy."
                }
            }
        } finally { $k.Close() }
    }
    if ($dupes -eq 0) { Ok 'No stored key, and no credential-shaped name, among the saved environment variables' }

    Say ''
    if ($fails -eq 0) { Say '  ALL CHECKS PASSED. No values were shown.' 'Green' }
    else { Say "  $fails CHECK(S) FAILED. No values were shown." 'Red' }
    Say ''
    exit ([int]($fails -gt 0))
}

function Cmd-Help {
    Say ''
    Say '  secrets - API key management (values live in Windows Credential Manager)' 'White'
    Say ''
    Say '    secrets add <NAME>      store a new key (hidden input) + record its metadata' 'Gray'
    Say '      ... -Stdin < FILE     read the value from a file, from cmd or Git Bash (max 1280 chars)' 'Gray'
    Say '    secrets list            names, set/unset, last-set date. Never values.' 'Gray'
    Say '    secrets rotate <NAME>   show the issuing console, take a new value, stamp the date' 'Gray'
    Say '    secrets rm <NAME>       delete a key and its registry row' 'Gray'
    Say '    secrets check           verify the whole setup. Pass/fail only, never values.' 'Gray'
    Say '    secrets path            where things actually live' 'Gray'
    Say ''
    Say '    run-with-secrets --only NAME[,NAME] <cmd> [args...]   run a command with just those keys' 'Gray'
    Say '    run-with-secrets --all <cmd> [args...]                every registered key; only for code you wrote' 'Gray'
    Say '      RWS_ONLY=NAME[,CHILD=VAULT]  (env var) same as --only, for MCP server entries' 'Gray'
    Say '      Only keys that are BOTH stored and in KEYS.md are ever injected.' 'Gray'
    Say ''
}

switch ($Command.ToLower()) {
    'add'    { Cmd-Add $Name }
    'rotate' { Cmd-Add $Name -IsRotate }
    'list'   { Cmd-List }
    'ls'     { Cmd-List }
    'rm'     { Cmd-Rm $Name }
    'remove' { Cmd-Rm $Name }
    'check'  { Cmd-Check }
    'path'   { Cmd-Path }
    default  { Cmd-Help }
}

# run-with-secrets-impl.ps1 - put stored keys in a command's environment.
#
#   run-with-secrets --only OPENAI_API_KEY npm test
#   run-with-secrets --only STRIPE_SECRET_KEY,STRIPE_PUBLISHABLE_KEY python .\scripts\deploy.py
#   run-with-secrets --all npm run dev
#   run-with-secrets --only NAME node -e "console.log(Boolean(process.env.NAME))"
#
# Least privilege by default: nothing is injected unless asked. --only NAME[,NAME]
# names the keys (each may be CHILD_NAME=VAULT_NAME: the child sees CHILD_NAME, the
# value comes from VAULT_NAME). --all hands over every key and must be typed on
# purpose. RWS_ONLY=... in the launching environment is the same as --only, for MCP
# server entries and other places that cannot pass flags; it is removed before the
# child starts.
#
# A key is injected only if it is BOTH stored under the prefix AND listed in KEYS.md,
# and its name is not one that changes how programs load or where they connect
# (PATH, NODE_OPTIONS, PYTHONPATH, HTTPS_PROXY, ... see CredentialStore.ps1). So a
# credential that another program wrote into the store is never handed to a child.
#
# Guarded keys (KEYS.md column, or Guarded = @(...) in secrets-kit.config.psd1) are
# released only after a Yes on a Windows dialog that names the command; the default
# and the timeout answer are No. A speed bump for agents, not a wall: any process
# running as this user can still read Credential Manager directly, or edit the
# config and KEYS.md if nothing denies it writes.
#
# This is the ONLY script that calls Get-SecretValue. Values are pulled from
# Credential Manager into this short-lived process's environment, the child
# inherits them, and the process exits. Nothing is written to disk and no value
# is ever printed - only key names are echoed so you can see what was injected.
#
# Values land in THIS process's environment, so always reach this script through
# the .cmd or Git Bash shim (or powershell -File). Running it inside a shell you keep
# using leaves the keys in that shell until the finally block clears them.

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
# See CredentialStore.ps1: a debug record can become a stdin-echoing prompt.
$DebugPreference   = 'SilentlyContinue'
$VerbosePreference = 'SilentlyContinue'

. (Join-Path $PSScriptRoot 'CredentialStore.ps1')
. (Join-Path $PSScriptRoot 'KeysRegistry.ps1')

# No param block on purpose. With [CmdletBinding()] and a -Command parameter,
# PowerShell's binder eats the child's own flags: `run-with-secrets node -c app.js`
# prefix-matches "-c" to -Command and runs the wrong program. Reading $args keeps
# arguments away from our own binder; the program branch below rebuilds the
# command line itself, because PowerShell 5.1's own passing strips embedded
# quotes and drops empty arguments. One limit remains: powershell -File has
# already split -name:value and refuses a lone '-' before this script runs
# (README, "Argument quirks").
#
# Every message goes to stderr, so `run-with-secrets tool > out.json` and
# `run-with-secrets tool | jq` see only the child's own output.
function Usage {
    [Console]::Error.WriteLine('Usage: run-with-secrets --only NAME[,NAME...] <command> [args...]')
    [Console]::Error.WriteLine('       run-with-secrets --all <command> [args...]')
    [Console]::Error.WriteLine('  --only  inject just those keys (NAME, or CHILD_NAME=VAULT_NAME). RWS_ONLY=... in the environment means the same.')
    [Console]::Error.WriteLine('  --all   inject every stored key that is in KEYS.md. Only for code you wrote; never for an install.')
}

# --- flags, before the command -----------------------------------------------
$rest = @($args)
$onlySpec = $null
$all = $false
while ($rest.Count -gt 0 -and $rest[0] -like '--*') {
    $flag = [string]$rest[0]
    if ($flag -eq '--all') { $all = $true; $rest = @($rest | Select-Object -Skip 1); continue }
    if ($flag -eq '--only') {
        if ($rest.Count -lt 2) { Usage; exit 2 }
        $onlySpec = [string]$rest[1]; $rest = @($rest | Select-Object -Skip 2); continue
    }
    if ($flag -like '--only=*') { $onlySpec = $flag.Substring(7); $rest = @($rest | Select-Object -Skip 1); continue }
    if ($flag -eq '--') { $rest = @($rest | Select-Object -Skip 1); break }
    # The flag is not echoed: a value pasted where a flag goes would print.
    [Console]::Error.WriteLine('run-with-secrets: unknown option. Flags are --only NAME[,NAME] and --all.')
    exit 2
}

# RWS_ONLY: same as --only, for callers that cannot pass flags (MCP entries). Read and
# cleared before anything is taken from the store, so no child inherits it.
$rwsOnly = [Environment]::GetEnvironmentVariable('RWS_ONLY', 'Process')
[Environment]::SetEnvironmentVariable('RWS_ONLY', $null, 'Process')
if ($rwsOnly -and -not $onlySpec) { $onlySpec = $rwsOnly }

if ($rest.Count -eq 0) { Usage; exit 2 }
if (-not $onlySpec -and -not $all) {
    [Console]::Error.WriteLine('run-with-secrets: say which keys: --only NAME[,NAME...] (or RWS_ONLY=...), or --all for every key.')
    exit 2
}
if ($onlySpec -and $all) { [Console]::Error.WriteLine('run-with-secrets: --only and --all together make no sense.'); exit 2 }

$Command   = [string]$rest[0]
$Arguments = @()
if ($rest.Count -gt 1) { $Arguments = @($rest[1..($rest.Count - 1)]) }

# Get-Command reads * and ? as wildcards (n*e finds nano); no file name has them.
if ($Command -match '[*?]') {
    [Console]::Error.WriteLine("run-with-secrets: '$Command' has a wildcard; name the program exactly.")
    exit 2
}

# --- which keys -----------------------------------------------------------------
$only = @()
if ($onlySpec) {
    foreach ($pair in ($onlySpec -split ',')) {
        if ([string]::IsNullOrWhiteSpace($pair)) { continue }
        $parts = $pair.Trim() -split '=', 2
        $target = $parts[0].Trim()
        $vault  = if ($parts.Count -gt 1) { $parts[1].Trim() } else { $target }
        # Both halves are key names; nothing else is accepted, so nothing else
        # can be echoed back in an error.
        if ($target -cnotmatch '^[A-Z][A-Z0-9_]*\z' -or $vault -cnotmatch '^[A-Z][A-Z0-9_]*\z') {
            [Console]::Error.WriteLine('run-with-secrets: --only entries must be NAME or CHILD_NAME=VAULT_NAME in UPPER_SNAKE_CASE.')
            exit 2
        }
        foreach ($n in @($target, $vault)) {
            if (Test-ForbiddenName $n) { [Console]::Error.WriteLine("run-with-secrets: $n changes how programs load or connect and is never injected."); exit 2 }
        }
        $only += [pscustomobject]@{ Target = $target; Vault = $vault }
    }
    if ($only.Count -eq 0) { [Console]::Error.WriteLine('run-with-secrets: --only names no key.'); exit 2 }
}

$injected = @()
$code = 127

# One dialog per run, whatever it is asked for. 4 = Yes/No, 48 = warning icon,
# 256 = No is the default, 4096 = always on top. A timeout answers No.
$script:GuardAnswer = $null
function Confirm-GuardedRelease([string[]]$names) {
    if ($null -ne $script:GuardAnswer) { return $script:GuardAnswer }
    $cmdLine = (@($Command) + $Arguments) -join ' '
    if ($cmdLine.Length -gt 300) { $cmdLine = $cmdLine.Substring(0, 300) + '...' }
    $text = "Release guarded keys?`n`n$($names -join ', ')`n`nCommand:`n$cmdLine`n`nFolder:`n$((Get-Location).Path)"
    try {
        $r = (New-Object -ComObject WScript.Shell).Popup($text, $script:GuardTimeoutSeconds, 'run-with-secrets', 4 + 48 + 256 + 4096)
    } catch { $r = 7 }
    $script:GuardAnswer = ($r -eq 6)
    return $script:GuardAnswer
}

try {
    $registered = @(Get-RegistryNames)
    $guardedAll = @(Get-GuardedNames)

    if ($only.Count -gt 0) {
        foreach ($o in $only) {
            if ($registered -cnotcontains $o.Vault) {
                [Console]::Error.WriteLine("run-with-secrets: $($o.Vault) is not in KEYS.md, so it is not injected. Add it with: secrets add $($o.Vault)")
                exit 127
            }
        }
        $wanted = @($only | Where-Object { $guardedAll -contains $_.Vault } | ForEach-Object { $_.Vault } | Sort-Object -Unique)
        if ($wanted.Count -gt 0 -and -not (Confirm-GuardedRelease $wanted)) {
            [Console]::Error.WriteLine("run-with-secrets: withheld $($wanted -join ', ') (not confirmed)")
            exit 126
        }
        foreach ($o in $only) {
            $v = Get-SecretValue $o.Vault
            if ($null -eq $v) { [Console]::Error.WriteLine("run-with-secrets: $($o.Vault) is not set"); exit 127 }
            if ($v.Length -eq 0) { [Console]::Error.WriteLine("run-with-secrets: $($o.Vault) is empty"); exit 127 }
            [Environment]::SetEnvironmentVariable($o.Target, $v, 'Process')
            $injected += $o.Target
        }
    } else {
        $index = @(Get-SecretIndex)
        $skipped = @()
        $eligible = @()
        foreach ($k in $index) {
            if ($registered -cnotcontains $k.Name) { $skipped += $k.Name; continue }
            if (Test-ForbiddenName $k.Name) { $skipped += $k.Name; continue }
            $eligible += $k
        }
        if ($skipped.Count -gt 0) {
            [Console]::Error.WriteLine("run-with-secrets: not injected (stored but not in KEYS.md, or a loader name): $($skipped -join ', ')")
        }
        $wanted = @($eligible | Where-Object { $guardedAll -contains $_.Name } | ForEach-Object { $_.Name })
        $release = ($wanted.Count -eq 0) -or (Confirm-GuardedRelease $wanted)
        if (-not $release) {
            [Console]::Error.WriteLine("run-with-secrets: withheld $($wanted -join ', ') (not confirmed)")
        }
        foreach ($k in $eligible) {
            if (-not $release -and $guardedAll -contains $k.Name) { continue }
            $v = Get-SecretValue $k.Name
            if ($null -eq $v -or $v.Length -eq 0) {
                [Console]::Error.WriteLine("run-with-secrets: skipping $($k.Name) (empty)")
                continue
            }
            # Assigned straight into the environment; never emitted to the pipeline,
            # so it cannot reach a transcript or scrollback.
            [Environment]::SetEnvironmentVariable($k.Name, $v, 'Process')
            $injected += $k.Name
        }
    }
    Remove-Variable v -ErrorAction SilentlyContinue

    if ($injected.Count -eq 0) {
        [Console]::Error.WriteLine("run-with-secrets: nothing injected (no stored key under $($script:SecretsPrefix)* is also in KEYS.md). Add one with: secrets add NAME")
    } else {
        [Console]::Error.WriteLine("run-with-secrets: injected $($injected.Count) key(s): $($injected -join ', ')")
    }

    # Prefer the program on PATH, as cmd and Git Bash would: Windows PowerShell
    # maps curl, sort, where, cat, ls ... to its own aliases, and npm/npx/pnpm (any
    # npm global bin) ship a .ps1 beside the .cmd that would hand our arguments to
    # PowerShell 5.1's native passing. A .ps1 is used only when no program matches.
    $target = Get-Command $Command -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
    if (-not $target) { $target = Get-Command $Command -CommandType ExternalScript -ErrorAction SilentlyContinue | Select-Object -First 1 }
    if (-not $target) { $target = Get-Command $Command -ErrorAction Stop | Select-Object -First 1 }
    if (-not $target) { throw "The term '$Command' is not recognized as the name of a program or script." }

    # The launcher's -ExecutionPolicy Bypass is recorded here; the child should
    # get the user's own policy.
    Remove-Item Env:PSExecutionPolicyPreference -ErrorAction SilentlyContinue

    if ($target.CommandType -ne 'Application') {
        # A .ps1, cmdlet or function runs in this process: arguments bind exactly.
        # Give it PowerShell's defaults, not this script's StrictMode and Stop,
        # or it dies on its first unset variable or non-terminating error.
        if ($target.CommandType -eq 'ExternalScript') { $Command = $target.Source }
        Set-StrictMode -Off
        $ErrorActionPreference = 'Continue'
        $global:LASTEXITCODE = 0
        try {
            & $Command @Arguments
            $code = $LASTEXITCODE
        } catch {
            # The target's own error: report it as-is, with the usual exit 1.
            # 127 stays reserved for "could not start".
            [Console]::Error.WriteLine(($_ | Out-String))
            $code = 1
        }
    } else {
        # Windows PowerShell 5.1 drops empty arguments and unescapes embedded quotes
        # when it starts a program, so build the command line here instead.
        $batch = $target.Extension -match '^\.(cmd|bat)$'
        $line = @($Arguments | ForEach-Object {
            if (-not $batch) {
                # MSVCRT rules: backslashes before a quote are doubled, the quote becomes \".
                if ($_ -ne '' -and $_ -notmatch '[\s"]') { $_ }
                else { '"' + ($_ -replace '(\\*)"', '$1$1\"' -replace '(\\+)\z', '$1$1') + '"' }
            } else {
                # cmd.exe re-reads a batch file's command line. Quote the way Rust does
                # since BatBadBut: "" for a quote so cmd's quote state never flips, and
                # %%cd:~,% for % so no %VAR% - such as an injected key - can expand. ! cannot
                # be escaped for a batch that enables delayed expansion, so !KEY! is refused;
                # and a batch that CALLs with its arguments re-expands %, so %KEY% is refused too.
                if ($_ -match '[\r\n]') { throw "$Command is a batch file; cmd.exe cannot pass a line break in an argument." }
                foreach ($n in $injected) {
                    if ($_ -match ('!' + [regex]::Escape($n) + '[!:]')) { throw "$Command is a batch file; an argument contains !$n!, which cmd.exe could expand to that key's value." }
                    if ($_ -match ('%' + [regex]::Escape($n) + '[%:]')) { throw "$Command is a batch file; an argument contains %$n%, which cmd.exe could expand to that key's value if the batch CALLs with it." }
                }
                $s = $_ -replace '(\\*)"', '$1$1""' -replace '%', '%%cd:~,%'
                if ($_ -eq '' -or $_ -match '[^\w#$*+\-./:?@\\]|\\\z') { $s = '"' + ($s -replace '(\\+)\z', '$1$1') + '"' }
                $s
            }
        }) -join ' '
        $psi = New-Object System.Diagnostics.ProcessStartInfo
        $psi.UseShellExecute = $false
        if ($batch) {
            # Not $env:ComSpec: the quoting above is cmd.exe's, and a bare name would
            # be searched for in the current directory first. The path gets the same
            # % escaping as the arguments, or a %KEY% in it would expand to the value.
            $psi.FileName  = Join-Path ([Environment]::SystemDirectory) 'cmd.exe'
            $psi.Arguments = '/e:ON /v:OFF /d /s /c ""' + ($target.Path -replace '%', '%%cd:~,%') + '" ' + $line + '"'
        } else {
            $psi.FileName  = $target.Path
            $psi.Arguments = $line
        }
        $p = [System.Diagnostics.Process]::Start($psi)
        $p.WaitForExit()
        $code = $p.ExitCode
    }
} catch {
    # The message may name the command but never a value.
    [Console]::Error.WriteLine("run-with-secrets: $($_.Exception.Message)")
    $code = 127
} finally {
    foreach ($n in $injected) { [Environment]::SetEnvironmentVariable($n, $null, 'Process') }
}

exit $code

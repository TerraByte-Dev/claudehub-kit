# install.ps1 - install secrets-kit for the current Windows user.
#
#   powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1
#
# Copies bin\ (launchers) and lib\ (scripts) to %LOCALAPPDATA%\secrets-kit,
# creates the KEYS.md registry there (never overwrites an existing one) and puts
# only bin\ on the user PATH.
# Re-run it to update: scripts are replaced, KEYS.md and stored keys are kept.
# Reads and writes no secret values.

[CmdletBinding()]
param([string]$InstallDir = (Join-Path $env:LOCALAPPDATA 'secrets-kit'))

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if ($env:OS -ne 'Windows_NT') {
    Write-Host 'secrets-kit is Windows-only: it stores keys in Windows Credential Manager.' -ForegroundColor Red
    exit 1
}

$InstallDir = [IO.Path]::GetFullPath($InstallDir)
$bin = Join-Path $InstallDir 'bin'
foreach ($d in 'bin', 'lib') {
    $dst = Join-Path $InstallDir $d
    New-Item -ItemType Directory -Force -Path $dst | Out-Null
    Copy-Item -Path (Join-Path $PSScriptRoot "$d\*") -Destination $dst -Force
    # A zip downloaded from GitHub marks every file as from the internet.
    Get-ChildItem -Path $dst -File | Unblock-File
}
# bin\ is on PATH, so it holds launchers only. A .ps1 there (left by an older
# install) would win over the .cmd in PowerShell and run in the user's own shell.
Get-ChildItem -Path $bin -Filter *.ps1 | Remove-Item -Force

$keys = Join-Path $InstallDir 'KEYS.md'
if (-not (Test-Path $keys)) { Copy-Item -Path (Join-Path $PSScriptRoot 'KEYS.md') -Destination $keys }
# Optional config (prefix, guarded keys). Copied once, never overwritten; the
# example file documents the keys. Most installs run on the defaults.
$cfgSrc = Join-Path $PSScriptRoot 'secrets-kit.config.psd1'
$cfgDst = Join-Path $InstallDir 'secrets-kit.config.psd1'
if ((Test-Path $cfgSrc) -and -not (Test-Path $cfgDst)) { Copy-Item -Path $cfgSrc -Destination $cfgDst }

# User PATH. Read the raw registry value so %VAR% entries stay unexpanded, and
# write it back as the same value kind. [Environment]::SetEnvironmentVariable
# would expand every entry and silently downgrade the value to REG_SZ.
$envKey = [Microsoft.Win32.Registry]::CurrentUser.OpenSubKey('Environment', $true)
try {
    $raw  = [string]$envKey.GetValue('Path', '', 'DoNotExpandEnvironmentNames')
    $kind = [Microsoft.Win32.RegistryValueKind]::ExpandString
    if ($envKey.GetValueNames() -contains 'Path') { $kind = $envKey.GetValueKind('Path') }

    $present = @($raw -split ';' | Where-Object {
        $_ -and [Environment]::ExpandEnvironmentVariables($_).TrimEnd('\') -eq $bin.TrimEnd('\')
    }).Count -gt 0

    if ($present) {
        $pathNote = 'already on your user PATH'
    } else {
        $new = if ($raw.Trim(';')) { $raw.TrimEnd(';') + ';' + $bin } else { $bin }
        $envKey.SetValue('Path', $new, $kind)
        # A bare registry write does not tell Explorer, so new terminals would
        # not see the change until you sign out. Setting any variable through
        # .NET broadcasts WM_SETTINGCHANGE; this throwaway one does exactly that.
        [Environment]::SetEnvironmentVariable('SECRETS_KIT_PATH_REFRESH', '1', 'User')
        [Environment]::SetEnvironmentVariable('SECRETS_KIT_PATH_REFRESH', $null, 'User')
        $pathNote = 'added to your user PATH'
    }
} finally { $envKey.Close() }

# So the check below can find the commands without a new terminal.
if (-not (@($env:Path -split ';') -contains $bin)) { $env:Path = "$env:Path;$bin" }

Write-Host ''
Write-Host "  Installed to $InstallDir ($bin $pathNote)." -ForegroundColor Green
& (Join-Path $bin 'secrets.cmd') check
$code = $LASTEXITCODE

Write-Host '  Next: open a NEW terminal (PATH changes only reach new ones; in VS Code/Cursor restart the editor), then' -ForegroundColor Cyan
Write-Host '    secrets add OPENAI_API_KEY        # hidden prompt - never paste keys into an AI chat' -ForegroundColor Cyan
Write-Host '    run-with-secrets <your command>   # runs it with your keys in its environment' -ForegroundColor Cyan
Write-Host ''
exit $code

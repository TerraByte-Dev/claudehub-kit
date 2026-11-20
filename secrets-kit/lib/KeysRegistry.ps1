# KeysRegistry.ps1 - KEYS.md, the metadata registry. Names and metadata only, never values.
#
# Dot-sourced by secrets-impl.ps1 (read and write) and run-with-secrets-impl.ps1 (read
# only: a key is injected only if it is BOTH stored and registered here, so a credential
# that something else wrote into the store under our prefix is never handed to a child).
# Expects CredentialStore.ps1 to have been dot-sourced first ($script:KitRoot, $script:Guarded).

$script:KeysFile  = Join-Path $script:KitRoot 'KEYS.md'
$script:BeginMark = '<!-- keys:begin -->'
$script:EndMark   = '<!-- keys:end -->'

# Explicit UTF-8 both ways. Get-Content/Set-Content in PS 5.1 default to ANSI on
# read and BOM'd UTF-8 on write, so a naive round-trip mangles any non-ASCII
# prose in KEYS.md a little more on every single `secrets add`.
# The leading comma keeps a 0- or 1-line file an array (PowerShell would unroll it).
function Read-KeysFile { return ,@([IO.File]::ReadAllLines($script:KeysFile, [Text.Encoding]::UTF8)) }
function Write-KeysFile {
    param([string[]]$Lines)
    [IO.File]::WriteAllLines($script:KeysFile, $Lines, (New-Object Text.UTF8Encoding($false)))
}

# Both markers, whole-line, begin before end. Called BEFORE a value is asked for, so a
# broken registry never leaves a key stored but unrecorded.
function Assert-Registry {
    if (-not (Test-Path -LiteralPath $script:KeysFile)) { throw "KEYS.md is missing at $($script:KeysFile). Re-run install.ps1 or restore it." }
    $lines = Read-KeysFile
    $b = 0; $e = 0
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($b -eq 0 -and $lines[$i].Trim() -eq $script:BeginMark) { $b = $i + 1 }
        elseif ($b -ne 0 -and $e -eq 0 -and $lines[$i].Trim() -eq $script:EndMark) { $e = $i + 1 }
    }
    if ($b -eq 0 -or $e -eq 0) { throw "KEYS.md has lost its $($script:BeginMark) / $($script:EndMark) markers." }
    if ($e -lt $b) { throw 'KEYS.md markers are out of order.' }
}

# Rows have 6 columns (older files) or 7 (with Guarded). Either reads; writes are always 7.
function Read-Registry {
    if (-not (Test-Path -LiteralPath $script:KeysFile)) { return @() }
    $lines = Read-KeysFile
    $in = $false; $rows = @()
    foreach ($l in $lines) {
        if ($l.Trim() -eq $script:BeginMark) { $in = $true; continue }
        if ($l.Trim() -eq $script:EndMark)   { $in = $false; continue }
        if (-not $in) { continue }
        if ($l -notmatch '^\s*\|') { continue }
        $c = ($l -split '\|')
        # split on a leading+trailing pipe yields empty first/last elements
        if ($c.Count -lt 8) { continue }
        $name = $c[1].Trim()
        if ($name -eq 'Key' -or $name -match '^-+$' -or $name -eq '') { continue }
        $guarded = $false
        if ($c.Count -ge 9) { $guarded = ($c[7].Trim() -match '^(?i)(yes|y|true|guarded)$') }
        $rows += [pscustomobject]@{
            Name        = $name
            Purpose     = $c[2].Trim()
            Issuer      = $c[3].Trim()
            RotateUrl   = $c[4].Trim()
            Scope       = $c[5].Trim()
            LastRotated = $c[6].Trim()
            Guarded     = $guarded
        }
    }
    return $rows
}

function Write-Registry {
    param([object[]]$Rows)
    $tbl = @(
        '| Key | Purpose | Issued by | Rotate at | Scope | Last rotated | Guarded |'
        '|-----|---------|-----------|-----------|-------|--------------|---------|'
    )
    foreach ($r in ($Rows | Sort-Object Name)) {
        $g = if ($r.PSObject.Properties['Guarded'] -and $r.Guarded) { 'yes' } else { '-' }
        $tbl += "| $($r.Name) | $($r.Purpose) | $($r.Issuer) | $($r.RotateUrl) | $($r.Scope) | $($r.LastRotated) | $g |"
    }

    Assert-Registry
    $lines = Read-KeysFile
    # Whole-line match, matching Read-Registry exactly. Select-String would match
    # a marker mentioned inside ordinary prose and rewrite around the wrong anchor,
    # destroying the file. Indices are 1-based to match the old LineNumber usage.
    $b = 0; $e = 0
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($b -eq 0 -and $lines[$i].Trim() -eq $script:BeginMark) { $b = $i + 1 }
        elseif ($b -ne 0 -and $e -eq 0 -and $lines[$i].Trim() -eq $script:EndMark) { $e = $i + 1 }
    }
    $out = @()
    $out += $lines[0..($b - 1)]
    $out += $tbl
    $out += $lines[($e - 1)..($lines.Count - 1)]
    Write-KeysFile $out
}

# Names only: the registry's rows.
function Get-RegistryNames { return @(@(Read-Registry) | ForEach-Object { $_.Name }) }

# The effective guard list: the config file's Guarded entries plus every KEYS.md row
# marked Guarded = yes. The registry is where the list lives; the config entry remains
# for installs that keep KEYS.md minimal.
function Get-GuardedNames {
    $fromRegistry = @(@(Read-Registry) | Where-Object { $_.Guarded } | ForEach-Object { $_.Name })
    return @(@($script:Guarded) + $fromRegistry | Where-Object { $_ } | Sort-Object -Unique)
}

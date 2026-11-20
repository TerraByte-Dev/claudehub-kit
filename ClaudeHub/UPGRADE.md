# Upgrade an existing ClaudeHub with this kit

> **For the agent.** The person already has a folder they open Claude in (usually
> `%USERPROFILE%\ClaudeHub`). The kit's `BOOTSTRAP.md` found it and sent you here, with this
> kit folder at `%USERPROFILE%\TerraByte-Kit\ClaudeHub` (the staging copy; an older
> hand-delivered kit called it `ClaudeHub-kit`). Add the kit's rooms, rules and tools around
> their work **without moving, renaming, deleting or overwriting anything of theirs**, then
> prove it with a file-by-file comparison. This folder is only the source: nothing of theirs
> lives here, and they never launch from it.
>
> **Order, from the bootstrap:** steps 0 to 7 here, then back to `BOOTSTRAP.md` for its phases 3
> (secrets-kit) and 4 (the Hub) in this same session, then step 9 here as its phase 5. Its
> phase 6 replaces step 10's `YOUR TURN` with the one restart.

Names used below. Write them out in full whenever the person will see or paste them:

- `<CH>`: their existing folder (step 1). `<KIT>`: this folder, the one holding this file.
- `<BK>`: `%USERPROFILE%\ClaudeHub-backups\<yyyy-MM-dd_HHmm>` (step 3). Never inside `<CH>` or `<KIT>`.

## Ground rules (the whole task)

1. **Additive only.** Never move, rename, delete or overwrite a file or folder of theirs. You add
   new files and folders, plus the few appends the plan (step 4) names.
2. **One edit per existing file, backed up first.** The only existing files you change are
   `<CH>\CLAUDE.md` (append), `~/.claude/CLAUDE.md` (append) and `~/.claude/settings.json`
   (merge), plus older-kit files they say yes to (step 4). Each one: backup, show the exact text
   you'll add, get a yes, change it once. Their text stays byte for byte; yours goes after it.
3. **Stop and ask** on any ambiguity: a name collision, a folder you can't place, a rule of
   theirs that contradicts the kit. Say what you'd do, ask once.
4. **Never read** `.env` files, key or certificate files, anything named like a credential,
   secret or token, `~/.claude.json` (connection names only, by the command in
   `02-Internals/07-hub/hub-addon/AGENTS.md` rule 8), `~/.claude/.credentials.json`, or the session
   transcripts in `~/.claude/projects/` (folder names only). Never print a value from any
   settings file.
5. **Git: look only**, always with `git --no-optional-locks` (a plain `git status` rewrites
   `.git\index` and the final check flags it). Never commit, stash, pull, checkout or clean for
   them. Uncommitted work: tell them, suggest they commit before you start.
6. The kit's rules hold here too: no keys in any file, never send, post or approve for them, no
   TerraByte client names or prices in any file.
7. **Keep `<KIT>\UPGRADE-STATE.md` current**: tick each step as it finishes. A new session that
   finds it resumes at the first unticked step and re-runs nothing that's ticked.

Before step 0, tell them in a few lines what's coming (the bootstrap already gave the
overview): a read-only look, a backup of their text and settings files, a plan they approve, the kit added next to their
folders, a short interview, then a check that proves nothing of theirs changed. Writes outside
the folder Claude was opened in ask for **Allow**; that's expected. Then ask them to:

- **close every other Claude session** open on their ClaudeHub or a folder inside it, and
- **pause anything that writes there** (a render or clipping run, a sync job, a scheduled task) until
  the final check. Something that can't pause: note the folder it writes to; the check will show
  those files and you'll explain them.

## 0. Where am I?

- `<KIT>` must not be `<CH>` and must not sit inside it. Its top level holds only the kit
  (`START-HERE.md`, `UPGRADE.md`, `CLAUDE.md`, `AGENTS.md`, `PERSON.md`, `01-AIDesktop`,
  `02-Internals`, `03-Clinic`, later `UPGRADE-STATE.md`, `upgrade-snapshot.ps1`,
  `append-root.md`, `append-global.md` and a `.claude` folder). Anything
  else at its top level means the kit was unzipped over their folder: **stop**, change nothing,
  tell them what you see and ask.
- Path contains `.zip` or `\Temp\`: not extracted. Ask them to paste the prompt in `PROMPT.md`
  again (it extracts the kit to `%USERPROFILE%\TerraByte-Kit`), and stop.
- Not Windows: stop; the upgrade is Windows-only. The Hub alone still works: in the Code tab,
  folder `<KIT>/02-Internals/07-hub/hub-addon`, paste `Read AGENTS.md and connect me to the Hub.`

## 1. Find their folder

From the bootstrap, `<CH>` is the folder its phase 1 found and they confirmed: don't ask again.
Otherwise ask: "Which folder do you open Claude in for your projects?" Default
`%USERPROFILE%\ClaudeHub`. Check it and the usual variants: `%USERPROFILE%\Desktop\ClaudeHub`,
`%USERPROFILE%\Documents\ClaudeHub`, `%USERPROFILE%\OneDrive\ClaudeHub`,
`%USERPROFILE%\OneDrive\Desktop\ClaudeHub`. More than one exists: list each with its file count
and last change, and ask which. Either way, run the two checks below.

- **Under OneDrive** (path contains `\OneDrive`): warn in two lines (sync locks files, keeps
  cloud-only copies and fights git; an unsynced folder is better), but **don't move it**. Moving
  is their call, another day. Carry on in place.
- Projects that live **outside** `<CH>` (a tool in `C:\dev\...`): note their paths. They get
  routing rows (step 6); nothing is added inside them.

**Verify:** `Test-Path "<CH>"` is `True` and they confirmed it's the one. Then
`Test-Path "<CH>\.git"`: `True`, and `<CH>` is neither an older kit (step 2.9's files) nor a
folder named `ClaudeHub` (whose git repo may be the backup `06-github` made) → **stop**: that's
a project, not the workspace. Ask for the folder above it that holds their projects.

## 2. Look, don't touch: UPGRADE-STATE.md

Read-only. Run `<KIT>\02-Internals\00-setup\CONTEXT.md` step 1 (the PC check), then collect:

1. **Tree**: `<CH>` to three levels, folders only, not descending into `.git`, `node_modules`,
   `venv`, `.venv`, `__pycache__`; file count and size per top-level folder.
2. **Instruction files**: every `CLAUDE.md`, `AGENTS.md`, `CONTEXT.md`, `README.md`, any depth
   (path, line count). Read the root one and each top-level one.
3. **`.claude` folders** in `<CH>`: file names; for settings files, key names only
   (`permissions`, `hooks`...). `.mcp.json`: server names only.
4. **Git repos**: each `.git`: branch, `git --no-optional-locks -C "<repo>" status --porcelain`
   line count, remote host only.
5. **Heavy folders**: anything over 1 GB, media and model file counts; every `pyvenv.cfg`
   (a Python venv breaks when its folder moves).
6. **Tied to this path** (the reason nothing may move): config files that name `<CH>`, and
   scheduled tasks that run from it. Prints `path:line` and task names, never line contents:

   ```powershell
   $CH = '<CH>'; $leaf = Split-Path $CH -Leaf
   $pats = @($CH, ($CH -replace '\\', '/'), $CH.Replace('\', '\\'), "~/$leaf", "%USERPROFILE%\$leaf")   # 3rd: as JSON writes it
   Get-ChildItem -LiteralPath $CH -Recurse -File -Force -ErrorAction SilentlyContinue |
     Where-Object { $_.FullName -notmatch '\\(\.git|node_modules|venv|\.venv|__pycache__)\\' -and $_.Length -lt 1MB -and
       $_.Name -notmatch '^\.env|\.(pem|key|pfx|p12)$|credential|secret|token' -and
       $_.Extension -match '^\.(json|ya?ml|toml|ini|cfg|conf|py|ps1|psm1|bat|cmd|sh|js|mjs|cjs|ts|md|txt)$' } |
     Select-String -SimpleMatch -Pattern $pats -List | ForEach-Object { '{0}:{1}' -f $_.Path.Substring($CH.Length + 1), $_.LineNumber }
   $tp = '(' + ((@($CH, ($CH -replace '\\', '/'), "%USERPROFILE%\$leaf") | ForEach-Object { [regex]::Escape($_) }) -join '|') + ')(?![\w-])'   # full path, not ClaudeHub-kit or -backups
   Get-ScheduledTask | Where-Object { ($_.Actions | ForEach-Object { "$($_.Execute) $($_.Arguments) $($_.WorkingDirectory)" }) -match $tp } |
     ForEach-Object { "$($_.TaskPath)$($_.TaskName)" }
   ```

7. **Where they launch from**: folder names in `~/.claude/projects` (each is a folder they
   opened Claude in, its path written with dashes), session count and last date. Names only:

   ```powershell
   Get-ChildItem "$HOME\.claude\projects" -Directory -ErrorAction SilentlyContinue | ForEach-Object {
     [pscustomobject]@{ Folder = $_.Name; Sessions = @(Get-ChildItem -LiteralPath $_.FullName -Filter *.jsonl -File).Count; Last = $_.LastWriteTime.ToString('yyyy-MM-dd') } } |
     Sort-Object Last, Sessions -Descending | Select-Object -First 20 | Format-Table -AutoSize | Out-String -Width 250
   ```

8. **Global**: `~/.claude/CLAUDE.md` (read it; it's their instructions); `settings.json` key
   names, `permissions.defaultMode`, and the allow/deny/ask counts, nothing under `env` or
   `hooks`; skill, command and agent names; MCP connection names (rule 4). **Hub**:
   `Test-Path "$HOME\.terrabyte\hub.mjs"`, and if `True`, `node "$HOME/.terrabyte/hub.mjs"
   check`. An existing `hub-addon` folder or Hub room anywhere (`%USERPROFILE%\hub-addon`,
   `%USERPROFILE%\Hub`, a `hub` folder in `<CH>`).
9. **Older ClaudeHub kit?** `<CH>\02-Internals\CHANGELOG.md` or `<CH>\03-Clinic\ICM Doctor`
   exists: yes (the October kits had them). Step 4 has the rules for that case.
10. **Secret-looking files**: names and paths only (`.env*`, `*.key`, `*.pem`), never opened
    (rule 4). A tool of theirs may need its `.env` exactly where it is:

    ```powershell
    $CH = '<CH>'
    Get-ChildItem -LiteralPath $CH -Recurse -File -Force -ErrorAction SilentlyContinue |
      Where-Object { $_.Name -match '^\.env|\.(key|pem)$' -and $_.FullName -notmatch '\\(node_modules|venv|\.venv|__pycache__)\\' } |
      ForEach-Object { $_.FullName.Substring($CH.Length + 1) }
    ```

Write it all to `<KIT>\UPGRADE-STATE.md` (paths, names, counts, yes/no; no values), with a
checklist of steps 0–10 at the top. Then tell them in five to eight lines: their projects, the
git repos with uncommitted work (suggest a commit now; you won't make one), what's tied to
`<CH>`'s path, any secret-looking files (paths only; they stay where they are), and the
folders they use most.

## 3. Safety net, before any change

1. `<BK>` = `%USERPROFILE%\ClaudeHub-backups\` plus the local date and time, `yyyy-MM-dd_HHmm`.
2. Extract the script below into `<KIT>\upgrade-snapshot.ps1` with this command (never type
   it out by hand), then run it in Windows PowerShell 5.1:

   ```powershell
   $t = [IO.File]::ReadAllText('<KIT>\UPGRADE.md'); $m = [regex]::Match($t, '(?s)```powershell\r?\n(# upgrade-snapshot\.ps1 .*?)\r?\n```'); if (-not $m.Success) { throw 'script block not found' }; [IO.File]::WriteAllText('<KIT>\upgrade-snapshot.ps1', $m.Groups[1].Value + "`r`n", (New-Object Text.UTF8Encoding($false)))
   powershell.exe -NoProfile -ExecutionPolicy Bypass -File "<KIT>\upgrade-snapshot.ps1" -Root "<CH>" -OutDir "<BK>" -Phase Before
   ```

   It only reads `<CH>`. Into `<BK>` it writes `manifest-before.csv` (every file: relative path,
   size, last-write time UTC; junctions and links are recorded, not followed), and
   `backup-text.zip`: text and config files only, without `.git`, `venv`, `.venv`,
   `node_modules`, `__pycache__`, media, models, archives, files over 20 MB, secret-looking
   names, or cloud-only OneDrive files. It reopens the zip and checks entry count and bytes. It
   copies `~/.claude/CLAUDE.md`, `settings.json` and `skills\` to `<BK>\dot-claude\`.
3. Folders it couldn't read are listed in `<BK>\manifest-before-errors.txt`. Any there: tell
   them; the final check can't cover those.
4. Tell them where `<BK>` is: theirs, local only, never in git, never shared (the
   `settings.json` copy may hold their keys). They can delete it themselves in a few weeks.

**Verify:** it printed the `reopened and checked` line, and `<BK>\manifest-before.csv` exists.
Then write the full `<BK>` path and the `<CH>` path into the top of `UPGRADE-STATE.md`; a
resumed session needs both for steps 6, 7 and 9.

```powershell
# upgrade-snapshot.ps1 - Windows PowerShell 5.1. Reads -Root, never changes it; writes only in -OutDir.
#   -Phase Before : manifest-before.csv, backup-text.zip (checked by reopening), copies of ~/.claude files
#   -Phase Edit   : copies each -Edited / -Replaced file to OutDir\edited\ before it changes
#   -Phase Append : backs up -Target, then appends -Block to it (a kit block, to its one right file)
#   -Phase After  : manifest-after.csv and the comparison; exit 0 = nothing of theirs moved or changed
#   Lists are paths relative to -Root, comma-separated: -Edited CLAUDE.md,Notes\CLAUDE.md
param(
    [Parameter(Mandatory = $true)][string]$Root,
    [Parameter(Mandatory = $true)][string]$OutDir,
    [ValidateSet('Before', 'Edit', 'Append', 'After')][string]$Phase = 'Before',
    [string[]]$Edited = @(),     # files that only get text appended
    [string[]]$Replaced = @(),   # files replaced on the person's yes (older-kit files only)
    [string]$Target = '',        # -Phase Append: <CH>\CLAUDE.md or ~/.claude/CLAUDE.md
    [string]$Block = '',         # -Phase Append: the file holding the kit block
    [string]$ClaudeDir = (Join-Path $HOME '.claude')   # change only for a test run
)
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2.0
$Edited = @($Edited | ForEach-Object { $_ -split ',' } | Where-Object { $_ } | ForEach-Object { $_ -replace '^\.?\\', '' })
$Replaced = @($Replaced | ForEach-Object { $_ -split ',' } | Where-Object { $_ } | ForEach-Object { $_ -replace '^\.?\\', '' })
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem
$LP = '\\?\'   # long-path prefix: deep node_modules and venv paths pass 260 characters

$Root = (Resolve-Path -LiteralPath $Root).ProviderPath.TrimEnd('\')
if ($Root -eq $HOME.TrimEnd('\') -or $Root.Length -le 3) { throw "Refusing: $Root is the home folder or a drive root." }
$OutDir = [IO.Path]::GetFullPath($OutDir).TrimEnd('\')
if (($OutDir + '\').StartsWith($Root + '\', [StringComparison]::OrdinalIgnoreCase)) { throw 'OutDir must be outside Root.' }
if (-not (Test-Path -LiteralPath $OutDir)) { New-Item -ItemType Directory -Path $OutDir | Out-Null }

function Get-Manifest([string]$ErrFile) {
    $rows = New-Object System.Collections.Generic.List[object]
    $errs = New-Object System.Collections.Generic.List[string]
    $stack = New-Object System.Collections.Generic.Stack[string]
    $stack.Push($Root)
    while ($stack.Count -gt 0) {
        $dir = $stack.Pop()
        try { $items = ([IO.DirectoryInfo]($LP + $dir)).GetFileSystemInfos() }
        catch { $errs.Add("$dir : $($_.Exception.Message)"); continue }
        foreach ($i in $items) {
            $full = $i.FullName.Substring($LP.Length)
            $rel = $full.Substring($Root.Length + 1)
            if ($i -is [IO.DirectoryInfo]) {
                if ($i.Attributes -band [IO.FileAttributes]::ReparsePoint) {
                    $lt = 'link'
                    try { $lt = (Get-Item -LiteralPath $full -Force).LinkType } catch {}
                    if ($lt) { $rows.Add([pscustomobject]@{ Path = $rel; Size = -1; LastWriteUtc = ''; Kind = $lt }); continue }
                }
                $stack.Push($full)
            }
            else { $rows.Add([pscustomobject]@{ Path = $rel; Size = $i.Length; LastWriteUtc = $i.LastWriteTimeUtc.ToString('o'); Kind = 'file' }) }
        }
    }
    [IO.File]::WriteAllLines($ErrFile, [string[]]$errs)
    if ($errs.Count) { Write-Host "Could not read $($errs.Count) folder(s); listed in $ErrFile" -ForegroundColor Yellow }
    return , @($rows | Sort-Object Path)
}

function Test-Binary([string]$Path) {
    $fs = [IO.File]::OpenRead($Path)
    try { $buf = New-Object byte[] 8000; $n = $fs.Read($buf, 0, 8000); return ([Array]::IndexOf($buf, [byte]0, 0, $n) -ge 0) }
    finally { $fs.Dispose() }
}

function Test-Prefix([string]$Old, [string]$New) {   # True when New = Old + appended bytes
    $a = [IO.File]::ReadAllBytes($Old); $b = [IO.File]::ReadAllBytes($New)
    if ($b.Length -lt $a.Length) { return $false }
    for ($i = 0; $i -lt $a.Length; $i++) { if ($a[$i] -ne $b[$i]) { return $false } }
    return $true
}

function Get-Tail([string]$Old, [string]$New) {   # the text appended after Old's bytes
    $a = [IO.File]::ReadAllBytes($Old); $b = [IO.File]::ReadAllBytes($New)
    return [Text.Encoding]::UTF8.GetString($b, $a.Length, $b.Length - $a.Length)
}

function Get-LostKeys($a, $b, [string]$path) {   # setting paths in $a that $b lost; prints paths, never values
    if ($a -is [Management.Automation.PSCustomObject]) {
        if (-not ($b -is [Management.Automation.PSCustomObject])) { return @($path) }
        $out = @()
        foreach ($p in $a.PSObject.Properties) {
            $q = $b.PSObject.Properties[$p.Name]
            if ($null -eq $q) { $out += "$path.$($p.Name)" } else { $out += Get-LostKeys $p.Value $q.Value "$path.$($p.Name)" }
        }
        return $out
    }
    if ($a -is [array]) {
        $bj = @(@($b) | ForEach-Object { ConvertTo-Json $_ -Compress -Depth 30 })
        foreach ($x in $a) { if ($bj -notcontains (ConvertTo-Json $x -Compress -Depth 30)) { return @("$path[]") } }
        return @()
    }
    if ("$a" -ne "$b") { return @($path) }
    return @()
}

if ($Phase -eq 'Before') {
    $before = Join-Path $OutDir 'manifest-before.csv'
    if (Test-Path -LiteralPath $before) { throw "$before already exists. Use a new dated folder." }
    $rows = Get-Manifest (Join-Path $OutDir 'manifest-before-errors.txt')
    $rows | Export-Csv -LiteralPath $before -NoTypeInformation -Encoding UTF8

    # Text and config files only. Never secrets, media, models, repos, environments, or anything over 20 MB.
    $skipDir = '^(\.git|node_modules|venv|\.venv|__pycache__)$'
    $skipExt = '\.(mp4|mov|mkv|avi|webm|m4v|wmv|flv|mp3|wav|flac|m4a|aac|ogg|opus|png|jpe?g|gif|webp|bmp|tiff?|heic|psd|exr|pt|pth|bin|safetensors|ckpt|onnx|gguf|ggml|h5|pb|tflite|npy|npz|pkl|joblib|zip|7z|rar|tar|gz|exe|dll|msi|pyd|so|iso|db|sqlite3?)$'
    $secret  = '^\.env|\.(pem|key|pfx|p12|kdbx)$|^id_(rsa|ed25519)|credential|secret|token|password'
    $zipPath = Join-Path $OutDir 'backup-text.zip'
    $added = 0; $bytes = [int64]0
    $skipped = @{ 'repo/env folder' = 0; 'media/model/archive' = 0; 'secret-looking name' = 0; 'over 20 MB' = 0; 'binary' = 0; 'locked or unreadable' = 0; 'cloud-only, not downloaded' = 0 }
    $fs = [IO.File]::Open($zipPath, [IO.FileMode]::CreateNew)
    try {
        $za = New-Object IO.Compression.ZipArchive($fs, [IO.Compression.ZipArchiveMode]::Create)
        try {
            foreach ($r in $rows) {
                if ($r.Kind -ne 'file') { continue }
                $parts = $r.Path.Split('\'); $name = $parts[-1]
                if (@($parts | Where-Object { $_ -match $skipDir }).Count) { $skipped['repo/env folder']++; continue }
                if ($name -match $skipExt) { $skipped['media/model/archive']++; continue }
                if ($name -match $secret) { $skipped['secret-looking name']++; continue }
                if ($r.Size -gt 20MB) { $skipped['over 20 MB']++; continue }
                $src = $LP + (Join-Path $Root $r.Path)
                try {
                    if ([int][IO.File]::GetAttributes($src) -band 0x00401000) { $skipped['cloud-only, not downloaded']++; continue }   # Offline, RecallOnDataAccess
                    if (Test-Binary $src) { $skipped['binary']++; continue }
                    [IO.Compression.ZipFileExtensions]::CreateEntryFromFile($za, $src, $r.Path.Replace('\', '/'), [IO.Compression.CompressionLevel]::Optimal) | Out-Null
                    $added++; $bytes += $r.Size
                }
                catch { $skipped['locked or unreadable']++ }
            }
        }
        finally { $za.Dispose() }
    }
    finally { $fs.Dispose() }

    # Prove the zip: reopen it and count.
    $zr = [IO.Compression.ZipFile]::OpenRead($zipPath)
    try { $n = $zr.Entries.Count; $zb = [int64]0; foreach ($e in $zr.Entries) { $zb += $e.Length } } finally { $zr.Dispose() }
    if ($n -ne $added -or $zb -ne $bytes) { throw "Backup zip check FAILED: $n entries / $zb bytes, expected $added / $bytes." }

    $copied = @()
    $dst = Join-Path $OutDir 'dot-claude'
    New-Item -ItemType Directory -Path $dst -Force | Out-Null
    foreach ($x in 'CLAUDE.md', 'settings.json', 'skills') {
        $p = Join-Path $ClaudeDir $x
        if (Test-Path -LiteralPath $p) { Copy-Item -LiteralPath $p -Destination $dst -Recurse -Force; $copied += $x }
    }

    $total = ($rows | Where-Object { $_.Kind -eq 'file' } | Measure-Object Size -Sum).Sum
    Write-Host ("Manifest: {0} files, {1:N1} MB, {2} links not followed -> {3}" -f @($rows | Where-Object { $_.Kind -eq 'file' }).Count, ($total / 1MB), @($rows | Where-Object { $_.Kind -ne 'file' }).Count, $before)
    Write-Host ("Backup zip: {0} files, reopened and checked ({1:N1} MB of text) -> {2}" -f $n, ($bytes / 1MB), $zipPath)
    Write-Host ('Left out of the zip: ' + (($skipped.Keys | Sort-Object | ForEach-Object { "$_ $($skipped[$_])" }) -join ', '))
    Write-Host ('~/.claude copies: ' + $(if ($copied) { $copied -join ', ' } else { 'none existed' }) + " -> $dst")
    exit 0
}

if ($Phase -eq 'Edit') {
    foreach ($rel in ($Edited + $Replaced)) {
        $src = Join-Path $Root $rel
        $dst = Join-Path (Join-Path $OutDir 'edited') $rel
        if (-not (Test-Path -LiteralPath $src -PathType Leaf)) { throw "Not a file: $src" }
        if (Test-Path -LiteralPath $dst) { Write-Host "Already backed up (kept the first copy): $dst"; continue }
        New-Item -ItemType Directory -Path (Split-Path -Parent $dst) -Force | Out-Null
        Copy-Item -LiteralPath $src -Destination $dst
        Write-Host "Backed up: $rel -> $dst"
    }
    exit 0
}

if ($Phase -eq 'Append') {
    foreach ($p in $Target, $Block) { if (-not $p -or -not (Test-Path -LiteralPath $p -PathType Leaf)) { throw "Not found: '$p'" } }
    $Target = (Resolve-Path -LiteralPath $Target).ProviderPath
    $add = ([IO.File]::ReadAllText((Resolve-Path -LiteralPath $Block).ProviderPath)).Trim()
    $head = ($add -split "`r?`n")[0]
    if ($head -like '## ClaudeHub kit*') { $want = Join-Path $Root 'CLAUDE.md'; $bak = Join-Path $OutDir 'edited\CLAUDE.md'; $mark = '(?m)^## ClaudeHub kit\b' }
    elseif ($head -like '# Added by the ClaudeHub kit*') { $want = Join-Path $ClaudeDir 'CLAUDE.md'; $bak = Join-Path $OutDir 'dot-claude\CLAUDE.md'; $mark = '(?m)^# Added by the ClaudeHub kit\b' }
    else { throw "The block must start with '## ClaudeHub kit' or '# Added by the ClaudeHub kit'. It starts with: $head" }
    if (-not $Target.Equals([IO.Path]::GetFullPath($want), [StringComparison]::OrdinalIgnoreCase)) { throw "This block belongs in $want, not $Target. Nothing changed." }
    $b = [IO.File]::ReadAllBytes($Target)
    if ($b.Length -ge 2 -and (($b[0] -eq 0xFF -and $b[1] -eq 0xFE) -or ($b[0] -eq 0xFE -and $b[1] -eq 0xFF))) { throw 'UTF-16 file: stop and ask. Nothing changed.' }
    try { [void](New-Object Text.UTF8Encoding($false, $true)).GetString($b) } catch { throw 'Not UTF-8 (ANSI?): stop and ask. Nothing changed.' }
    $old = [IO.File]::ReadAllText($Target)
    if ($old -match $mark) { throw "$Target already has the kit block. Nothing changed." }
    if (-not (Test-Path -LiteralPath $bak)) {
        New-Item -ItemType Directory -Path (Split-Path -Parent $bak) -Force | Out-Null
        Copy-Item -LiteralPath $Target -Destination $bak
    }
    if (-not (Test-Prefix $bak $Target)) { throw "$Target changed since its backup $bak. Nothing changed; stop and ask." }
    $nl = if ($old -match "`r`n") { "`r`n" } else { "`n" }
    $lead = if ($old.EndsWith("`n")) { $nl } else { $nl + $nl }
    [IO.File]::AppendAllText($Target, $lead + ($add -replace "`r?`n", $nl) + $nl, (New-Object Text.UTF8Encoding($false)))
    Write-Host "Appended to $Target (backup: $bak)"
    exit 0
}

# After
$beforeRows = Import-Csv -LiteralPath (Join-Path $OutDir 'manifest-before.csv')
$afterRows = Get-Manifest (Join-Path $OutDir 'manifest-after-errors.txt')
$afterRows | Export-Csv -LiteralPath (Join-Path $OutDir 'manifest-after.csv') -NoTypeInformation -Encoding UTF8
$now = @{}; foreach ($r in $afterRows) { $now[$r.Path] = $r }
$editSet = @{}; foreach ($e in $Edited) { $editSet[$e] = $true }
$replSet = @{}; foreach ($e in $Replaced) { $replSet[$e] = $true }
$missing = @(); $changed = @(); $editedOk = @(); $editedBad = @(); $same = 0
foreach ($b in $beforeRows) {
    $a = $null; if ($now.ContainsKey($b.Path)) { $a = $now[$b.Path] }
    if ($null -eq $a) { $missing += $b.Path; continue }
    if ("$($a.Size)" -eq $b.Size -and "$($a.LastWriteUtc)" -eq $b.LastWriteUtc) { $same++; continue }
    $bak = Join-Path (Join-Path $OutDir 'edited') $b.Path
    if ($replSet.ContainsKey($b.Path)) {
        if (Test-Path -LiteralPath $bak) { $editedOk += "$($b.Path) (replaced on their yes; backup: $bak)" }
        else { $editedBad += "$($b.Path) (replaced, no backup in edited\)" }
        continue
    }
    if ($editSet.ContainsKey($b.Path)) {
        if (-not (Test-Path -LiteralPath $bak)) { $editedBad += "$($b.Path) (no backup in edited\)" }
        elseif (-not (Test-Prefix $bak (Join-Path $Root $b.Path))) { $editedBad += "$($b.Path) (not a pure append; backup: $bak)" }
        else { $editedOk += "$($b.Path) (pure append; backup: $bak)" }
        continue
    }
    $changed += ("{0} (was {1} bytes {2}, now {3} bytes {4})" -f $b.Path, $b.Size, $b.LastWriteUtc, $a.Size, $a.LastWriteUtc)
}
# The root block went to the right file, right after their text, once.
$rb = Join-Path $OutDir 'edited\CLAUDE.md'; $rc = Join-Path $Root 'CLAUDE.md'
if ($editSet.ContainsKey('CLAUDE.md') -and (Test-Path -LiteralPath $rb) -and (Test-Path -LiteralPath $rc) -and (Test-Prefix $rb $rc)) {
    $n = [regex]::Matches([IO.File]::ReadAllText($rc), '(?m)^## ClaudeHub kit\b').Count
    if ((Get-Tail $rb $rc) -notmatch '^\s*## ClaudeHub kit\b' -or $n -ne 1) { $editedBad += "CLAUDE.md (the text after theirs must start with the one '## ClaudeHub kit' block; found $n)" }
}
$beforeSet = @{}; foreach ($b in $beforeRows) { $beforeSet[$b.Path] = $true }
$new = @($afterRows | Where-Object { -not $beforeSet.ContainsKey($_.Path) })
$report = New-Object System.Collections.Generic.List[string]
$report.Add("Compared $($beforeRows.Count) entries from before with now, under $Root")
$report.Add("Unchanged (same size and last-write time): $same")
$report.Add("Missing: $($missing.Count)"); foreach ($x in $missing) { $report.Add("  MISSING  $x") }
$report.Add("Changed but not on the edit list: $($changed.Count)"); foreach ($x in $changed) { $report.Add("  CHANGED  $x") }
$report.Add("Edited on purpose: $($editedOk.Count + $editedBad.Count)")
foreach ($x in $editedOk) { $report.Add("  OK       $x") }; foreach ($x in $editedBad) { $report.Add("  PROBLEM  $x") }
$report.Add("New files and links: $($new.Count)")
foreach ($g in ($new | Group-Object { $_.Path.Split('\')[0] } | Sort-Object Name)) { $report.Add("  $($g.Name): $($g.Count)") }

# The global files: still a pure append, still valid, nothing lost (setting paths only, never values).
$globalBad = 0
$gm = Join-Path $OutDir 'dot-claude\CLAUDE.md'
if (Test-Path -LiteralPath $gm) {
    $gc = Join-Path $ClaudeDir 'CLAUDE.md'
    $ok = (Test-Path $gc) -and (Test-Prefix $gm $gc)
    $line = if ($ok) { 'their text intact, kit text appended' } else { 'PROBLEM: no longer starts with their original text' }
    if ($ok -and ([IO.File]::ReadAllText($gm)).Trim()) {   # they had real content: the kit's part must start with its heading
        $tail = Get-Tail $gm $gc
        if ($tail.Trim() -and $tail -notmatch '^\s*# Added by the ClaudeHub kit\b') { $ok = $false; $line = "PROBLEM: the text after theirs doesn't start with '# Added by the ClaudeHub kit'" }
    }
    if (-not $ok) { $globalBad++ }
    $report.Add('~/.claude/CLAUDE.md: ' + $line)
}
$gs = Join-Path $OutDir 'dot-claude\settings.json'
if (Test-Path -LiteralPath $gs) {
    try {
        $old = [IO.File]::ReadAllText($gs) | ConvertFrom-Json
        $cur = [IO.File]::ReadAllText((Join-Path $ClaudeDir 'settings.json')) | ConvertFrom-Json
        $lost = @(Get-LostKeys $old $cur '')
        $report.Add('~/.claude/settings.json: valid JSON; ' + $(if ($lost.Count) { 'CHANGED or removed: ' + ($lost -join ', ') } else { 'every setting from before is still there' }))
    }
    catch { $report.Add('~/.claude/settings.json: PROBLEM: could not parse it in PowerShell; check it with node') }
}
$report | Set-Content -LiteralPath (Join-Path $OutDir 'compare.txt') -Encoding UTF8
$report | ForEach-Object { Write-Host $_ }
if ($missing.Count -or $changed.Count -or $editedBad.Count -or $globalBad) { Write-Host 'RESULT: CHECK FAILED - read the lines above.' -ForegroundColor Red; exit 1 }
Write-Host 'RESULT: PASS - nothing of theirs was moved, renamed, deleted or changed except the edits listed.' -ForegroundColor Green
exit 0
```

## 4. The plan: get a yes

Show it on one screen:

- **Stays exactly where it is**: each of their top-level folders and files, by name.
- **Added next to them**, new folders only: `02-Internals\` (the settings room, with
  `07-hub\hub-addon\`), `03-Clinic\` (ICM Doctor, Troubleshooter, secrets-kit), and
  `01-AIDesktop\` holding only its `CONTEXT.md`, `02-Work\CONTEXT.md`, `03-Research\` and
  `04-Toolshed\` (the Hub room `02-Work\hub\` comes with the Hub; `ABOUT-ME.md` with the
  interview). At the root: `PERSON.md`, and `AGENTS.md` if they have none. Not copied:
  `START-HERE.md`, `UPGRADE.md`, and the kit's `CLAUDE.md` when they have their own.
- **Appended once each, after they see the text**: `<CH>\CLAUDE.md` (a routing table for their
  projects and the kit rooms, plus the kit's rules; or, with no root `CLAUDE.md`, the kit's
  installed), `~/.claude/CLAUDE.md` (kit sections they don't already have),
  `~/.claude/settings.json` (missing permission rules only).
- **Collisions**: a name above already exists in `<CH>` → name it, suggest `<name>-kit`, ask.
  Never merge into a folder of theirs silently. Their own numbering doesn't matter (`02-Clips`
  beside `02-Internals` is fine); the kit's names stay, since its files point at them.

Ask "OK to go ahead?" and wait for yes. Write the agreed plan into `UPGRADE-STATE.md`.

**A kit room renamed** for a collision: after copying, replace the old room name in every file
you copied from the kit (kit copies are yours to edit; theirs never) and log it.

**Older kit** (step 2.9): their `01-AIDesktop`, `02-Internals` and `03-Clinic` are theirs now.
No suffix; step 5 adds only the kit files they lack and never overwrites. List the kit files
that differ (step 5's dry run shows them as `Newer`, `Older` or `Changed`). Their records are
never replaced: `CHANGELOG.md`, `INVENTORY.md`, `WHERE-THINGS-LIVE.md`, `REGISTRY.md`,
`IDEAS.md`, backups, Troubleshooter cases, `ABOUT-ME.md`, desks. Playbooks (`00-setup`,
`07-hub/CONTEXT.md`, `01-harness/PERMISSIONS.md`, `05-field-guide`, the ICM Doctor's playbooks,
`hub-addon`, `secrets-kit`) can be replaced one by one on their yes: run the snapshot script
with `-Phase Edit -Replaced <path relative to <CH>>` first, then copy that one file. Their
records do get new lines from later steps (setup's changelog and maps, the interview's
`ABOUT-ME.md`, the device row, `REGISTRY.md`, the Hub phase's changelog lines): back each one up
the same way before its first change, and list it under `-Replaced` in step 9.

## 5. Add the kit

Copy each approved room with robocopy, which here never overwrites and never deletes:

```powershell
robocopy "<KIT>\02-Internals" "<CH>\02-Internals" /E /XC /XN /XO /XJ /R:0 /W:0 /NP /NJH; if ($LASTEXITCODE -lt 8) { $global:LASTEXITCODE = 0 }
```

Exit code 0 to 7 is success (the `if` turns it into 0); 8 or more failed: stop and report. Never add `/MIR`, `/PURGE` or
`/MOV`. Same for `03-Clinic`, `01-AIDesktop\03-Research` and `01-AIDesktop\04-Toolshed`. Older
kit: run each first with `/L /V` added (a dry run that lists what differs). Single files
(`01-AIDesktop\CONTEXT.md`, `01-AIDesktop\02-Work\CONTEXT.md`, `PERSON.md`, `AGENTS.md`):
`Test-Path` first, copy only when absent.

Then adapt your copies (kit files, yours to edit):

- `01-AIDesktop\CONTEXT.md`: under the table add "Projects that were here before the kit stay
  where they are in `<CH>`; the routing table in `<CH>\CLAUDE.md` lists them." Drop the
  `01-Personal/` row unless step 7 makes that folder.
- `01-AIDesktop\02-Work\CONTEXT.md`: under **Desks** add "Existing work stays at the ClaudeHub
  root (see its `CLAUDE.md`); new desks go here. A desk for work an existing project already
  does links to that folder; it never copies or moves its files. New routing rows go only
  under the `## ClaudeHub kit` table in the root `CLAUDE.md`."

**Verify:** `<CH>\02-Internals\07-hub\hub-addon\AGENTS.md`, `<CH>\03-Clinic\ICM Doctor\CLAUDE.md`
and `<CH>\03-Clinic\secrets-kit\install.ps1` exist.

## 6. Register their existing work

1. **Routing rows**, one per project folder (top level of `<CH>`, plus outside projects from
   step 1): `| <when they'd go there, their words> | <folder> | <read first: its CLAUDE.md,
   CONTEXT.md or README.md, or "ask"> |`. Agree the wording with them.
2. **The root `CLAUDE.md`.** None: copy the kit's `CLAUDE.md` in as a new file, put the rows
   in its floor-plan table, and add the `### Where to open Claude` section from the block below. One of theirs: write the block below to `<KIT>\append-root.md`, show
   it, and on yes append it with the script (it backs the file up to `<BK>\edited\` first):

   ```powershell
   powershell.exe -NoProfile -ExecutionPolicy Bypass -File "<KIT>\upgrade-snapshot.ps1" -Root "<CH>" -OutDir "<BK>" -Phase Append -Target "<CH>\CLAUDE.md" -Block "<KIT>\append-root.md"
   ```

   It refuses, changing nothing, when a path is wrong, the block doesn't belong in that file,
   the block is already there, or the file isn't UTF-8 or plain ASCII (say UTF-16, or ANSI with
   smart quotes): stop and ask. The block, with `<CH>` written out as the real path:

   ```
   ## ClaudeHub kit (added YYYY-MM-DD)

   Added by the kit upgrade. Everything above this heading is <name>'s own and still applies;
   where it and this part disagree on how a project runs, the part above wins. The hard rules
   below hold everywhere.

   ### Routing table
   | Enter when… | Go to | Read first |
   |---|---|---|
   <their rows>
   | a new project, research, a free tool | `01-AIDesktop/` | its `CONTEXT.md` |
   | Hub: what's waiting, handoffs, updates | `01-AIDesktop/02-Work/hub/` | its `CONTEXT.md` (made by the Hub session) |
   | change how Claude behaves, connect a tool or the Hub, GitHub, "what can you do?" | `02-Internals/` | its `CLAUDE.md` |
   | lay out or repair a project, fix a PC problem, store an API key | `03-Clinic/` | its `CONTEXT.md` |

   ### Where to open Claude
   | To… | Open this folder in the Code tab |
   |---|---|
   | anything, when unsure | `<CH>` |
   | focused work on one project | that project's folder |
   | settings, connections, "what can you do?" | `<CH>\02-Internals` |
   | connect or fix the Hub | `<CH>\02-Internals\07-hub` |
   | daily Hub work | `<CH>\01-AIDesktop\02-Work\hub` |

   Never `TerraByte-Kit` (the kit's staging copy).

   "Finish my TerraByte setup." → follow `02-Internals/00-setup/FINISH.md` before anything else.

   Who <name> is: `01-AIDesktop/ABOUT-ME.md` (summary: `PERSON.md`).
   Read this file, then the one room the job belongs to. Don't read the whole tree first.
   ```

   followed by the kit `CLAUDE.md`'s **Hard rules**, **Working posture** and **Soft rules**,
   word for word as `###` headings, plus one soft rule: "Folders that were here before the kit
   keep their names and places; new rooms follow the kit's conventions." Right after the copied
   Hard rules, add: "Folders that were here before the kit get a CONTEXT.md only when <name>
   says yes (see 02-Internals/04-lab/IDEAS.md, 'From the upgrade')." When step 2.10 found
   secret-looking files, also add under Hard rules: "Existing `.env` files in <their projects>
   predate the kit and stay as they are. Moving a key into secrets-kit is <name>'s call, never
   done unasked." Leave out a kit rule their file already states. One of theirs contradicts a
   kit hard rule, or the state of their folders: show both, ask.
3. **ICM Doctor registry** (`<CH>\03-Clinic\ICM Doctor\01-index\REGISTRY.md`, a kit file): one
   row per project (path, type in a few words, subfolder count, pattern `-` until diagnosed,
   `unaudited`, today), and one for `<CH>` itself.
4. **CONTEXT.md, offered.** Project folders with no `CONTEXT.md` (and no `CLAUDE.md` doing that
   job): offer one, starting with the folder they use most (step 2.7). On yes: run the ICM
   Doctor's `04-utilities/playbooks/diagnose.md` on it (read-only; the diagnosis goes in the
   Doctor's `02-planning/`). Stop at the diagnosis. Never run `repair.md` on a folder that was
   here before the kit; its fixes go to <name> as suggestions. Then write a **new** `CONTEXT.md` in that folder from
   `04-utilities/templates/CONTEXT.template.md`, filled from what the folder really does, 80
   lines at most. `Test-Path` first; never edit their files. In a git repo, tell them it shows
   as a new untracked file to commit or ignore. Update its registry row. The other folders go
   on the lab list: in `<CH>\02-Internals\04-lab\IDEAS.md`, under `## From the upgrade`, one
   line each: `- **[work] <folder>**: diagnose it with the ICM Doctor (stop at the diagnosis, no repair, never move or rename), then add a CONTEXT.md (new file only).`

**Verify:** `<CH>\CLAUDE.md` has exactly one `## ClaudeHub kit` heading (step 9 proves the rest).

## 7. Interview and setup (merge, never replace)

1. **Interview** by `<CH>\02-Internals\00-setup\INTERVIEW.md`; it writes
   `<CH>\01-AIDesktop\ABOUT-ME.md`. Skip what step 2 answered (their own Claude setup, the
   tools they built, plan, PC) or confirm it in one line ("I see <tool>, a Python tool with a
   venv. Anything else you run?"). When it hands back to setup, continue here.
2. **Setup**: `<CH>\02-Internals\00-setup\CONTEXT.md` steps 2–9, with `<CH>` as the ClaudeHub
   path, changed like this:
   - **Step 3**: still make the redacted copies it asks for; the raw ones are in `<BK>\dot-claude\`.
   - **Step 4, global `CLAUDE.md`**: none, or empty: install as written. Real content: **merge,
     never replace**. Their text stays first, byte for byte. Write the addition to
     `<KIT>\append-global.md`: a heading `# Added by the ClaudeHub kit (YYYY-MM-DD)`, the line
     "My own rules above win on style; the safety sections below always hold.", then each
     `PERSON_CLAUDE.md` section their file doesn't already cover, placeholders filled. They
     already have a `## Me`: the kit's shrinks to the ABOUT-ME, desks and Hub-room lines. They
     already have a `## TerraByte Hub` block: leave `{{HUB_RULE}}` out (the Hub session compares
     the two). A rule of theirs contradicts "Stop and ask me first", "Never send, post, approve,
     or contact", "TerraByte facts" or "Secrets": show both, ask. The desks line reads: "My
     existing projects are in `<CH>` (routing table in its `CLAUDE.md`); new desks go in
     `<CH>\01-AIDesktop\02-Work\`." Show the file, then on yes append it with the script:
     `powershell.exe -NoProfile -ExecutionPolicy Bypass -File "<KIT>\upgrade-snapshot.ps1" -Root "<CH>" -OutDir "<BK>" -Phase Append -Target "$HOME\.claude\CLAUDE.md" -Block "<KIT>\append-global.md"`.
   - **Step 5, permissions**: add each kit `allow`, `deny` and `ask` rule they lack, after
     theirs; remove and change nothing. Use a short node script (PowerShell `ConvertFrom-Json` /
     `ConvertTo-Json -Depth 100` if node is missing) that prints only the rules it adds, never a
     value; show that list, write on yes, check it parses. Their `defaultMode` is something
     else (say `bypassPermissions`): two lines on what the kit recommends and why; their choice
     stands, and the "Accept edits" line in the appended global text says what they really run.
     Never add a `Bash(...)` deny rule. They already have one: tell them it switches off the
     PowerShell tool (`01-harness/PERMISSIONS.md`); change nothing.
   - **Step 6**: `~/.claude/skills/research/` exists: ask; default keep theirs and skip.
   - **Step 7**: a side project they pick goes in `<CH>\01-AIDesktop\01-Personal\<name>\` (copy
     the kit's `01-Personal\CONTEXT.md` first), unless they already keep personal projects
     somewhere; then it goes there.
   - **Step 8**: git `user.name` / `user.email` already set: leave them.
   - **Step 9**: log every change this upgrade made too, one line each with its undo (a room
     added: delete that folder; an append: restore from `<BK>\edited\` or `<BK>\dot-claude\`).
3. **Tailor the lab**: `START-HERE.md`'s agent step 6, in `<CH>\02-Internals\04-lab\CONTEXT.md`.

## 8. The Hub: the bootstrap's phase 4

Go back to `BOOTSTRAP.md` now for phase 3 (secrets-kit) and phase 4 (the Hub), in this same
session, then come back for step 9 so the check covers them too. Step 2.8 printed `Connected`:
phase 4 does only the crew rule and the room (add-on steps 9 and 10; room
`<CH>\01-AIDesktop\02-Work\hub\`). A Hub room already exists elsewhere: ask; default keep using
it and route to it, leaving the new path unmade. The CHANGELOG's Hub line is set by
`FINISH.md` after the restart; until then it reads `Hub: NOT CONNECTED YET`.

## 9. Prove nothing of theirs changed

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "<KIT>\upgrade-snapshot.ps1" -Root "<CH>" -OutDir "<BK>" -Phase After -Edited CLAUDE.md
```

`-Edited` lists every existing file under `<CH>` you appended to, relative and comma-separated
(drop it if there were none); add `-Replaced <list>` for older-kit files replaced on their yes.
Nothing else goes on either list. It writes `manifest-after.csv` and `compare.txt` and prints:
unchanged count, `MISSING`, `CHANGED` (not on a list), each edited file (pure append, backup
path), new files per folder, and whether `~/.claude/CLAUDE.md` still starts with their text and
`settings.json` still holds every setting it had. It also checks each kit block sits in its own
file, straight after their text (a block in the wrong file prints `PROBLEM`).

- **Show them the printed result as it is.**
- Any `MISSING` or `PROBLEM`: stop. Say plainly what happened, restore that file from
  `<BK>\edited\` or `backup-text.zip` on their ok, and run the check again.
- Each `CHANGED` line needs a reason: a tool of theirs that kept running, a session they left
  open. Ask; don't guess. If it was you, restore it and say so.
- New files must all sit in the planned rooms (and any `CONTEXT.md` they said yes to).

Tick it in `UPGRADE-STATE.md` with the one-line result.

## 10. Hand over: what the bootstrap's phase 6 says

The bootstrap's phase 6 hands over once, after the Hub. Use this material there, plain words,
short:

- One or two sentences showing you listened: what they run, what they're after.
- The check in one line: "All N of your files are exactly as they were. `CLAUDE.md` got the kit
  section added at the end; the original is at `<BK>\edited\CLAUDE.md`."
- What's new: the bullets in 00-setup step 11, briefly.
- **Where you launch from now on**, with their real paths:

  | To… | Open this folder in the Code tab |
  |---|---|
  | anything, when unsure | `<CH>` |
  | focused work on one project | that project's folder inside `<CH>`; it still gets `<CH>`'s rules, because Claude reads the `CLAUDE.md` in the folder you open and in every folder above it |
  | settings, connections, "what can you do?" | `<CH>\02-Internals` |
  | connect or fix the Hub | `<CH>\02-Internals\07-hub` |
  | daily Hub work | `<CH>\01-AIDesktop\02-Work\hub` (once the Hub is connected) |

  A project outside `<CH>` opened on its own gets only the global rules. Never
  `TerraByte-Kit`: its job is done.
- `YOUR TURN`: the bootstrap's one restart, then `Finish my TerraByte setup.` in `<CH>`. That
  session runs the proof test, checks the Hub and offers the first Hub task (`FINISH.md`).
- They can delete `%USERPROFILE%\TerraByte-Kit` and the zip once they're happy (you don't);
  `<BK>` is their backup.

`FINISH.md` ticks step 10. Don't start the proof test, a desk, or any research in this session.

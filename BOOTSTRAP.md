# BOOTSTRAP.md: set this person up with the TerraByte kit

> **For the agent.** The person pasted `PROMPT.md`. You are in whatever folder they opened Claude
> in. This file finds out what they already have, picks the path, and does the whole setup in
> **this one session**: workspace, secrets-kit, Hub. Then **one restart**, and one line in the
> new session finishes it. Commands are Windows PowerShell unless marked otherwise.

Names used below. Write them out in full whenever the person will see or paste them:

- `<STAGE>`: `%USERPROFILE%\TerraByte-Kit`, the folder holding this file. A staging copy of the
  kit, never a workspace. Nothing of theirs goes in it, and nobody launches Claude from it.
- `<KIT>`: `<STAGE>\ClaudeHub`, the kit's workspace template.
- `<CH>`: their workspace, found or made in phases 1 and 2.
- `<STATE>`: `<STAGE>\BOOTSTRAP-STATE.md`.

## Rules for the whole run (they beat every file this one sends you to)

1. **The Hub key is never yours.** Don't ask for it, read it, print it, or store it. They store
   it themselves: `secrets add TB_HUB_TOKEN` in a new terminal they open (the Hub add-on's step
   6), pasting it at secrets-kit's hidden prompt. Pasted into the chat by mistake: it has
   leaked; they revoke it on the Hub's Settings -> API page, click **New token**, and run
   `secrets rotate TB_HUB_TOKEN` (or `secrets add TB_HUB_TOKEN` if it was never stored) in their
   own terminal.
2. **Never move, rename or delete a file or folder of theirs.** You copy and add. The only
   existing files you change are the ones the upgrade plan names, each backed up first and
   changed on their yes. Your own files in `<STAGE>` are yours.
3. **Never send, post, approve or contact anyone on your own.** Outside the Hub: you draft, they
   send. In the Hub: a hand-back or update goes up only after their ok in the chat; money,
   won/lost and approvals are always their click in the Hub.
4. **No keys, passwords, client names or prices** in any file you write, `<STATE>` included.
5. **Keep `<STATE>` current.** Write it after every phase (paths, names, yes/no; never a value).
   A new session that finds it resumes at the first unticked phase and re-runs nothing ticked.
6. **One question at a time**, plain words, exact clicks. Define a term the first time. Tell
   them up front to expect about 25 **Allow** clicks for commands (plus one per file written
   outside the folder Claude was opened in, or per file if they didn't choose **Accept edits**),
   and that clicking Allow is expected.

Before phase 0, tell them in three lines what's coming: a read-only look at their PC, then their
workspace set up (a short interview included), secrets-kit, and the Hub (they sign in and store
one key themselves with `secrets add TB_HUB_TOKEN`). About an hour, most of it you working, then
one restart and a 10-minute finish. They can stop any time; pasting the prompt again resumes.

## 0. Look (read only)

- **Resume?** `<STATE>` exists: read it. Phases left → say in one line where you're picking up,
  and go there. Every phase ticked → this is a kit update: tell them, then get the newest kit
  the way `PROMPT.md` says, but rename the old `<STAGE>` to `TerraByte-Kit-old-<yyyyMMdd-HHmm>`
  first (never delete it), read the new `BOOTSTRAP.md` and start over at phase 0.
- **The kit is whole:** `<STAGE>` holds `BOOTSTRAP.md`, `VERSION`, `ClaudeHub\`, `hub-addon\` and
  `secrets-kit\`. Missing one: the download or extraction broke; get the kit again by `PROMPT.md`.
- **Windows only.** `$env:OS` isn't `Windows_NT` (Git Bash: `$OS`): stop. Tell them the
  workspace and secrets-kit are Windows-only, but the Hub works: open Claude in
  `<STAGE>/hub-addon` and paste `Read AGENTS.md and connect me to the Hub.`
- Run: the current folder, `claude --version`, `node -v`, `git --version`, `winget --version`.
  `claude` not found = desktop app only (fine). Missing git is fine (GitHub setup installs it).
- **Node 18 or newer** is needed for the Hub. Missing or older: ask once, and before running it
  say "Windows will ask *Do you want to allow this app to make changes?* Click **Yes**; it may
  only blink on the taskbar." Then:

  ```powershell
  winget install --id OpenJS.NodeJS.LTS -e --source winget --accept-source-agreements --accept-package-agreements
  ```

  Your shell won't see it: call `& "C:\Program Files\nodejs\node.exe"` for the rest of this run.
  They say no: carry on; phase 4 is skipped and the hand-over says why.

Write `<STATE>`: the top facts (date, kit `VERSION`, current folder, desktop-only or terminal,
Node version and whether you installed it, git yes/no) and this checklist:

```
- [ ] 0 look  - [ ] 1 detect  - [ ] 2 workspace  - [ ] 3 secrets-kit  - [ ] 4 hub
- [ ] 5 prove (upgrade only)  - [ ] 6 hand-over  - [ ] 7 finish (after the restart)
```

## 1. Detect what they have

Read-only. Prints paths and kinds only:

```powershell
$H = $env:USERPROFILE.TrimEnd('\'); $cwd = (Get-Location).Path.TrimEnd('\')
$c = @($cwd) + @(Get-ChildItem -LiteralPath $cwd -Directory -ErrorAction SilentlyContinue | ForEach-Object FullName)
$d = Split-Path $cwd   # the folders above this one, up to (not including) the user folder
while ($d -and $d.Length -gt $H.Length -and $d.StartsWith($H + '\', [StringComparison]::OrdinalIgnoreCase)) { $c += $d; $d = Split-Path $d }
foreach ($b in @($H) + @(Get-ChildItem -LiteralPath $H -Directory -Filter 'OneDrive*' -ErrorAction SilentlyContinue | ForEach-Object FullName)) {
  foreach ($s in 'ClaudeHub', 'Desktop\ClaudeHub', 'Documents\ClaudeHub') { $c += Join-Path $b $s } }
$c | Where-Object { $_ -and (Test-Path -LiteralPath $_ -PathType Container) -and $_ -notmatch '\\TerraByte-Kit(-old-[^\\]*)?(\\|$)|ClaudeHub-(kit|backups)' } |
  ForEach-Object { (Resolve-Path -LiteralPath $_).ProviderPath.TrimEnd('\') } | Sort-Object -Unique | ForEach-Object {
  $p = $_; $leaf = Split-Path $p -Leaf
  if (-not (Test-Path -LiteralPath (Join-Path $p 'CLAUDE.md')) -and $leaf -ne 'ClaudeHub') { return }
  $rooms = @(Get-ChildItem -LiteralPath $p -Directory -ErrorAction SilentlyContinue | Where-Object Name -match '^\d{2}-').Count
  $older = (Test-Path -LiteralPath (Join-Path $p '03-Clinic\ICM Doctor')) -or
           @(Get-ChildItem -LiteralPath (Join-Path $p '02-Internals\00-setup') -Filter '*_CLAUDE.md' -ErrorAction SilentlyContinue).Count -gt 0
  if ((Test-Path -LiteralPath (Join-Path $p '.git')) -and -not $older -and $leaf -ne 'ClaudeHub') { return }   # a project's repo, not a workspace
  $kind = if ($older) { 'older TerraByte kit' } elseif ($leaf -eq 'ClaudeHub') { 'ClaudeHub folder (own layout)' } elseif ($rooms -ge 2) { 'ClaudeHub-like' } elseif ($p -eq $cwd) { 'this folder has a CLAUDE.md' } else { return }
  [pscustomobject]@{ Path = $p; Kind = $kind; NumberedRooms = $rooms; LastChange = (Get-Item -LiteralPath $p).LastWriteTime.ToString('yyyy-MM-dd') } } |
  Format-Table -AutoSize | Out-String -Width 250
```

- **Nothing listed** → **fresh**: `<CH>` = `%USERPROFILE%\ClaudeHub`.
- **One `older TerraByte kit`, `ClaudeHub folder (own layout)` or `ClaudeHub-like`** →
  **upgrade** it in place: `<CH>` = that path.
- **Several** → list them (path, kind, last change) and ask which one they open Claude in.
- **Only `this folder has a CLAUDE.md`** → ask once: "Is this folder where you keep your Claude
  work?" Yes → upgrade it. No → fresh.
- A folder already sits at `%USERPROFILE%\ClaudeHub` but they want a fresh one: it can't go
  there; ask whether to upgrade that one instead or name another folder.

Tell them in two lines what you found and which path you'll take, for example: "You have a
workspace at `<path>` (an older TerraByte kit). I'll upgrade it in place: backup first, nothing
of yours moved or changed, kit added next to your folders. OK?" Wait for yes. Write the route
and `<CH>` into `<STATE>`.

## 2. The workspace

**Assemble the kit first** (both routes). The Hub add-on and secrets-kit ship beside `<KIT>`;
copy them into their rooms so the installed workspace is self-contained afterwards:

```powershell
$S = "$env:USERPROFILE\TerraByte-Kit"
robocopy "$S\hub-addon" "$S\ClaudeHub\02-Internals\07-hub\hub-addon" /E /R:0 /W:0 /NP /NJH; if ($LASTEXITCODE -lt 8) { $global:LASTEXITCODE = 0 }
robocopy "$S\secrets-kit" "$S\ClaudeHub\03-Clinic\secrets-kit" /E /R:0 /W:0 /NP /NJH; if ($LASTEXITCODE -lt 8) { $global:LASTEXITCODE = 0 }
```

Exit code 0 to 7 is success (the `if` turns it into 0 so the tool doesn't call it an error).
**Verify:** `<KIT>\02-Internals\07-hub\hub-addon\AGENTS.md` and
`<KIT>\03-Clinic\secrets-kit\install.ps1` exist.

### Fresh

1. First: `Test-Path -LiteralPath "<CH>"` must be `False`. `True` means a folder is already
   there: stop, change nothing, go back to phase 1 and offer the upgrade of that folder.
   Then copy, never move:
   `robocopy "<KIT>" "<CH>" /E /XC /XN /XO /XJ /R:0 /W:0 /NP /NJH; if ($LASTEXITCODE -lt 8) { $global:LASTEXITCODE = 0 }`
   (written out with the real paths; exit code 0 to 7 is success). **Verify:**
   `<CH>\START-HERE.md` and `<CH>\02-Internals\07-hub\hub-addon\AGENTS.md` exist.
2. Run `<CH>\START-HERE.md`, section "For the agent", steps 2 to 6, with `<CH>` as the ClaudeHub
   path. Its step 1 is done (you placed the folder), and its closing paragraph is replaced by
   phases 3 to 6 here: when step 6 is done, come back to phase 3.

### Upgrade (existing workspace or older kit)

Run `<KIT>\UPGRADE.md` with `<KIT>` = `%USERPROFILE%\TerraByte-Kit\ClaudeHub`. Its own state
file is `<KIT>\UPGRADE-STATE.md`. Run its steps 0 to 7, then come back here for phases 3 and 4;
its step 8 (the Hub) is phase 4, its step 9 is phase 5, and its step 10 is replaced by phase 6.

Tick phase 2 when the interview has written `<CH>\01-AIDesktop\ABOUT-ME.md` and setup has run.

## 3. secrets-kit (always)

It keeps API keys in Windows Credential Manager instead of in files. Find what's there, in a
process that reads PATH fresh from the registry (as a new terminal would):

```powershell
powershell.exe -NoProfile -Command { $env:Path = [Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [Environment]::GetEnvironmentVariable('Path','User'); $c = Get-Command secrets -ErrorAction SilentlyContinue; if ($c) { $c.Source } else { 'not installed' } }
```

- **`not installed`** → install it from `<CH>\03-Clinic\secrets-kit` by its `AGENTS.md`, rules
  first, with these changes: step 2 (get the files) is done, never clone; step 3 runs
  `powershell -NoProfile -ExecutionPolicy Bypass -File "<CH>\03-Clinic\secrets-kit\install.ps1"`;
  steps 5 to 7 only if `ABOUT-ME.md` (or the upgrade's step 2.10 list of secret-looking files)
  names a tool that uses an API key: otherwise skip them without asking and just teach the two
  lines below; step 8 is skipped when `~/.claude/CLAUDE.md` already has a Secrets section naming
  secrets-kit (setup installs one).

  **Upgrade route:** of steps 5 to 7, run 5 and 6 only. Skip step 7 for every file under
  `<CH>` (a tool of theirs may still read that `.env`, and deleting it would fail phase 5's
  check). Instead add one line per such file to `<CH>\02-Internals\04-lab\IDEAS.md` under
  `## From the upgrade` (an older kit's own `IDEAS.md`: back it up first, `UPGRADE.md` step 4):
  `- **[work] <project>\.env**: store its keys with secrets add, run the tool with
  run-with-secrets --only <NAME>, then <name> deletes the .env themselves.`
- **A path under `%LOCALAPPDATA%\secrets-kit\bin`** → installed. Compare it with the kit's copy:

  ```powershell
  $k = "<CH>\03-Clinic\secrets-kit"; $i = "$env:LOCALAPPDATA\secrets-kit"
  foreach ($d in 'bin', 'lib') { Get-ChildItem "$k\$d" -File | ForEach-Object { $t = Join-Path "$i\$d" $_.Name
    if (-not (Test-Path $t) -or (Get-FileHash $t).Hash -ne (Get-FileHash $_.FullName).Hash) { "differs: $d\$($_.Name)" } } }
  ```

  Nothing printed → current; skip to the Verify. Lines printed → an older version: offer to
  update ("re-running the installer keeps every stored key"), and on yes run step 3 as above.
- **Any other path** → a different `secrets` command runs first on PATH. Don't install over it,
  don't touch PATH: tell them the path in one line and record `secrets-kit: blocked by <path>`.
  Phase 4 is then skipped too: the Hub key lives in secrets-kit.

**Verify** (unless blocked), before any key is stored: the same fresh-PATH process, which sees
what a new terminal would, lists names only:

```powershell
powershell.exe -NoProfile -Command { $env:Path = [Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [Environment]::GetEnvironmentVariable('Path','User'); (Get-Command secrets -ErrorAction Stop).Source; secrets list }
```

It must print the `%LOCALAPPDATA%\secrets-kit\bin\secrets.cmd` path and then run (an empty
list is fine). Then teach them this, and nothing more:

> To store a key: open a **new** terminal (Start menu, Terminal) and run `secrets add OPENAI_API_KEY`;
> paste the key when it asks (it shows `*`). Claude then runs a tool with it like this:
> `run-with-secrets --only OPENAI_API_KEY <command>`. Never paste a key into the chat. Your Hub
> key goes here too, the same way, in the next part: `secrets add TB_HUB_TOKEN`.

Record the result in `<STATE>`, tick phase 3.

## 4. The Hub, in this same session

Ask first: "Do you have a TerraByte Hub sign-in (your `@terrabytesolutions.com` email, from
Tate's invite) and can you open that inbox?" **No** → skip this phase with one line: "Ask Tate
for a Hub invite, then paste PROMPT.md again; it resumes." Record `hub: skipped (no account)`
and go to phase 5. Node missing (they declined in phase 0), or secrets-kit blocked (phase 3) →
skip the same way, with that reason.

Otherwise read `<CH>\02-Internals\07-hub\CONTEXT.md` ("Connect me to the Hub.") and the add-on's
`<CH>\02-Internals\07-hub\hub-addon\AGENTS.md`, its rules first, and run add-on **steps 4 to 10**
as that CONTEXT changes them. Step 3 (Node) was phase 0; step 6.2 (install secrets-kit) and
step 11 (other keys) were phase 3.
**Steps 12 to 15 don't run here**: the restart is phase 6 and the check, first task and log run
in `FINISH.md` after it. Already connected (`node "$HOME/.terrabyte/hub.mjs" check` prints
`Connected` in add-on step 4): do only steps 9 and 10. Upgrade route: `UPGRADE.md` step 8 says
what to do when a Hub room already exists somewhere else.

The person signs in (step 5), you fetch the two helper files (step 6.1, Claude in Chrome if you
have it, else they click two links), they open their own new terminal and store the key with
`secrets add TB_HUB_TOKEN` (step 6.3, Guarded `n`), you add the `terrabyte-hub` connection (7),
run `hub.mjs install` and `check` (8), check the crew rule (9) and make the Hub room (10).

Record in `<STATE>` what the add-on's step 12 lists: the Hub room path, which `CLAUDE.md` holds
the crew rule, desktop-only or terminal, every backup made (paths), and the change-log lines
still to write. Tick phase 4.

## 5. Prove nothing of theirs changed (upgrade only)

`UPGRADE.md` step 9, run now so it covers the Hub phase too. `-Edited` and `-Replaced` list what
the upgrade plan says. Show them the printed result as it is; any `MISSING`, `CHANGED` or
`PROBLEM` is handled there before you go on. Fresh install: tick it as not needed.

## 6. Hand over: one restart

Tick phase 6 in `<STATE>` first, then tell them, short and plain:

- One or two sentences showing you listened: what they run, what they're after.
- What's set up: `<CH>\02-Internals\00-setup\CONTEXT.md` step 11's bullets, briefly; secrets-kit
  in one line; the Hub in one line (connected as / skipped and why). Upgrade: the check's result
  in one line ("All N of your files are exactly as they were...").
- **`YOUR TURN`, one item:** restart Claude and paste one line.
  - **Desktop app:** quit it fully (the **^** arrow by the clock, right-click Claude, **Quit**;
    closing the window isn't enough, because new tools load only on a full restart), open Claude
    from Start, **Code** tab, **Select folder**, choose `<CH>` (written out), paste
    `Finish my TerraByte setup.`
  - **Terminal:** `/exit`, close the window, open a new terminal, `cd "<CH>"`, `claude`, paste
    `Finish my TerraByte setup.`
- That session runs the safety-net test with them (they'll press **Deny** a few times on
  purpose), checks the Hub, shows what's waiting for them there and offers the first task.

Don't start the proof test, the Hub check, a desk or any research in this session.

## 7. Finish (the next session)

Not here: `<CH>\02-Internals\00-setup\FINISH.md` runs it and ticks it. The kit's root
`CLAUDE.md` (or the block the upgrade appended to theirs) sends that line there.

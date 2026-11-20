# 00 — Setup  ·  CONTEXT

> **Run once.** Installs the person's global instructions, permission defaults, and `/research`,
> then fills the maps from the real PC and queues the proof test for after the restart.
> Usually started by the kit's `BOOTSTRAP.md`; re-run after a reinstall or new computer.

## Identity
The front door: the kit's bootstrap (or the person saying "set me up.") sent you here. Do the
whole install, explain only what they need. **No keys, no Hub sign-in, no TerraByte details
here**; secrets-kit and the Hub come in the bootstrap's later phases, after this playbook.

## Inputs
| Resource | Why |
|----------|-----|
| `PERSON_CLAUDE.md` | the global instructions template. Leave it here with its `{{...}}` intact; only the installed copy gets filled |
| `skills/research/SKILL.md` | the `/research` skill template, same rule |
| `starters/side-project.md` | only if they picked a side project in the interview |
| `../../01-AIDesktop/ABOUT-ME.md` | from `INTERVIEW.md`. Missing → run it before step 4 |
| `../07-hub/hub-addon/RULE-FALLBACK.md` | the Hub crew rule, for `{{HUB_RULE}}` in step 4 |

## Process
Do every step yourself unless it says to ask.
1. **Look around** (PowerShell). **From the bootstrap:** reuse phase 0's `claude`, `node`,
   `git` and `winget` results from `%USERPROFILE%\TerraByte-Kit\BOOTSTRAP-STATE.md`; run only
   the hardware lines and the `~/.claude` checks below. Otherwise all of it: Windows edition/build (`Get-ComputerInfo -Property
   OsName,OsBuildNumber`), CPU, RAM, GPU (`Get-CimInstance Win32_VideoController | Select
   Name`), free space per drive (`Get-PSDrive -PSProvider FileSystem`), the home folder,
   `claude --version` (not found → desktop app only: read connections from `mcpServers` in
   `~/.claude.json`, names only, never values), `node -v`, `winget --version`, `git --version`,
   and whether `~/.claude/CLAUDE.md`, `settings.json`, `skills/research/` exist. **Not Windows →
   stop setup**, change nothing, and tell them the Hub part still works: in the Code tab, choose
   the folder `ClaudeHub/02-Internals/07-hub/hub-addon` and paste `Read AGENTS.md and connect me
   to the Hub.` (it uses the Mac/Linux tab on the Hub's Settings -> API page). Missing git
   isn't a blocker: GitHub setup installs it (Node was the bootstrap's phase 0). Any first `winget`
   run needs `--source winget --accept-source-agreements --accept-package-agreements`, or it
   stalls on a prompt.
2. **Find the ICM Doctor** at `../../03-Clinic/ICM Doctor/`. Missing → write `(not installed
   yet: ask me where it is)` in its place, never the raw `{{...}}`.
3. **Back up** any existing `~/.claude/CLAUDE.md` and `settings.json` into
   `../01-harness/backups/`, dated. Copy `CLAUDE.md` as is. Back up `settings.json` with a node
   one-liner that replaces every value under `env`, and any value whose key matches
   `/key|token|secret|password/i`, with `<REDACTED>`, writes the copy, and prints nothing. Don't
   read the original's values yourself.
4. **Install the global instructions.** Fill `PERSON_CLAUDE.md`'s placeholders:
   - `{{NAME}}`: what they said to call them. `{{WORK_LINE}}`: one line on what they do, in
     their words. `{{ME}}`: 3–5 bullets: computer comfort, explanation style, what they run,
     what they wish they had. All from `ABOUT-ME.md`.
   - Full Windows paths: `{{CLAUDEHUB_PATH}}` (the `ClaudeHub` folder), `{{INTERNALS_PATH}}`
     (this `02-Internals`), `{{ICM_DOCTOR_PATH}}`, `{{ABOUT_ME_PATH}}`, `{{RESEARCH_PATH}}`
     (`01-AIDesktop\03-Research`), `{{SECRETS_KIT_PATH}}` (`03-Clinic\secrets-kit`),
     `{{HUB_ROOM_PATH}}` (`01-AIDesktop\02-Work\hub`, made later by `07-hub`).
   - `{{HUB_RULE}}`: the block between the two `---` lines in `RULE-FALLBACK.md`, word for
     word. It is the rule's source; the Hub session (add-on step 9) checks the installed block
     against it.
   Write to `~/.claude/CLAUDE.md`. **If one already exists with real content, stop and ask**
   (one line: what's in it, replace or merge). Same file with `{{...}}` still in it =
   unfinished install: fill it in place.
5. **Set the permission defaults** by `../01-harness/PERMISSIONS.md`, "Install". Merge into
   the existing `settings.json`, never replace it; check it's valid JSON (a typo is silently
   ignored).
6. **Install `/research`**: copy `skills/research/SKILL.md` to
   `~/.claude/skills/research/SKILL.md`, placeholders filled (ask before replacing an
   existing one). Create `../03-extensions/REGISTRY.md` with its first
   row: research · skill · sourced answers filed in `03-Research` ·
   `~/.claude/skills/research/` · remove: delete that folder.
7. **Their side project**, if they picked one in the interview: make its folder in
   `../../01-AIDesktop/01-Personal/`, named for what it is, from `starters/side-project.md`
   (its `CONTEXT.md`). Picked none → make nothing.
8. **Fill in the maps**: what you found in step 1, and the real path of `ClaudeHub`, go into
   `../01-harness/WHERE-THINGS-LIVE.md`; connections into `../02-mcp/INVENTORY.md`; the PC
   line of `ABOUT-ME.md`; the device row in `../../03-Clinic/Troubleshooter/03-reference/README.md`.
   If git is installed and global `user.name`/`user.email` is empty, set a **placeholder**
   (their first name, `crew@users.noreply.invalid`) and log it: GitHub setup replaces it. Git
   missing → skip; `../06-github/` sets it.
9. **Log it**: one line per change in `../CHANGELOG.md`, each with its undo. Put the line
   `Proof test: NOT RUN YET` at the top of the entries.
10. **The Hub line.** Put `Hub: NOT CONNECTED YET` directly under the proof-test line. Don't
    connect the Hub here: `BOOTSTRAP.md` phase 4 does it next in this same session (Node was
    its phase 0), and `FINISH.md` replaces this line once the Hub answers.
11. **Hand over: started by the bootstrap (the usual case), don't.** Go back to whoever sent you
    (`START-HERE.md` → bootstrap phase 3, or `UPGRADE.md` step 7). The bootstrap's phase 6
    hands over once, with the bullets below. **Run on its own** (a reinstall, a new PC): hand
    over in plain words, briefly:
    - what now loads in every session; edits to it apply from the next session;
    - Claude edits and moves files in its folder without asking; other commands ask; deletes
      always ask;
    - Claude drafts but **never sends, posts or approves on its own**: Hub hand-backs and
      updates go up only on their ok in the chat; everything else is their accounts, their click;
    - the brake (Manual mode: mode picker, Shift+Tab in a terminal), stop button / Esc, and
      say no to Auto mode unless they want a safety model approving commands instead of them;
    - `/research <question>` works anywhere; `/deep-research` is for big ones.

    Then one `YOUR TURN` item: a **new session** on the ClaudeHub folder, paste
    `Finish my TerraByte setup.` (`FINISH.md` runs the proof test, and says how to connect the
    Hub if it isn't yet.)

## Outputs / Handoff
- Global `CLAUDE.md` (Hub rule included), valid `settings.json`, `/research`, maps, changelog.
- **Next → bootstrap phases 3–6 (secrets-kit, Hub, one restart), then `FINISH.md` (proof test,
  Hub check, first Hub task), then `../../01-AIDesktop/02-Work/`**.

## Links
`../01-harness/PERMISSIONS.md` · `INTERVIEW.md` · `FINISH.md` · `../07-hub/CONTEXT.md` · `../CLAUDE.md`

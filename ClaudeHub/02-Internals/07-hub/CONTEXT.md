# 07 — Hub  ·  CONTEXT

> **The Hub connection room.** Connects this person's Claude to the TerraByte Hub, so the crew
> hands work back and forth there instead of on Discord. Daily Hub work happens in
> `../../01-AIDesktop/02-Work/hub/`; this room is setup, repair, and new keys.

## Identity
`hub-addon/` here is the TerraByte Hub add-on. In the kit it ships at the top level, beside
`ClaudeHub`; the bootstrap copies it in here (phase 2) before setup runs. **It is the
playbook; this file only says how it fits this kit.** Where they differ, this file wins on
paths and order; the add-on wins on everything about the Hub itself. The helper files come
only from the Hub's Settings -> API page (add-on step 6) and the crew rule only from
`hub-addon/RULE-FALLBACK.md` (step 9): never type either from memory, from this file, or from a
note.

## "Connect me to the Hub."
Read `hub-addon/AGENTS.md`, its rules first, then **run it from step 3 onward**, with these
changes for this kit. **Sent by the kit's `BOOTSTRAP.md` (phase 4, the usual case):** run steps
4 to 10 only; Node was its phase 0, secrets-kit its phase 3, and steps 12 to 15 run after its one
restart, in `../00-setup/FINISH.md`. Skip the add-on's two-line intro and its time estimate:
the bootstrap already told them what's coming. **Asked here directly** (a repair, a new PC, a Hub that was
skipped): all of it.

- **Steps 1–2 are done.** The add-on folder is this room's `hub-addon/` (write its full path
  out). The PC facts are in `../01-harness/WHERE-THINGS-LIVE.md`; still run `claude --version`
  and `node -v` once, since they may have changed.
- **Step 4:** the instruction home is known: `~/.claude/CLAUDE.md` and this `ClaudeHub`. Setup
  already put the crew rule (`## TerraByte Hub (crew loop)`) in the global file. Only
  check for an earlier Hub setup (`hub.mjs`, the `terrabyte-hub` MCP entry).
- **Step 5:** as written. They keep the Settings -> API tab open for step 6.
- **Step 6:** as written. You fetch `hub-headers.mjs` and `hub.mjs` through the page's two
  **Download ... instead** links (Claude in Chrome, or they click), then stop using the browser.
  You write `store-key.ps1` and open it in its own Windows PowerShell 5.1 window; they paste the
  key there. The key never enters this chat.
- **Step 7:** you add the `terrabyte-hub` server yourself; they copy nothing. If
  `../01-harness/WHERE-THINGS-LIVE.md` (or this session's `claude --version`) says desktop app
  only, use the add-on's desktop-only path.
- **Step 8:** as written: you run `hub.mjs install`, then `check`. From the bootstrap, don't
  ask "is that your name?": just check `check` prints `Connected`. `FINISH.md` asks once.
- **Step 9:** the global file already holds the block from `hub-addon/RULE-FALLBACK.md`
  (usually at its end; setup put it there), ending with the `On this computer, every Hub
  write...` line. Compare it with the block in `RULE-FALLBACK.md`. Same → leave it. Different
  (a newer add-on) → show the diff in a few lines, and on their ok replace that block (from its
  `## TerraByte Hub` heading to the next `## ` heading or the end of the file) with the file's
  block as is. Touch nothing else.
- **Step 10:** the Hub room is `../../01-AIDesktop/02-Work/hub/CONTEXT.md`, copied from
  `hub-addon/templates/HUB-ROOM.md`. The routing rows already exist (`../../CLAUDE.md`,
  `../../01-AIDesktop/02-Work/CONTEXT.md`); don't add more.
- **Step 11:** this kit's secrets-kit is `../../03-Clinic/secrets-kit/` (the add-on's own copy
  isn't shipped in the kit); the bootstrap installs it. Skip this step, unless `secrets` isn't
  installed: then offer it by that folder's `AGENTS.md` (skip its clone step).
- **Step 12:** from the bootstrap: what step 12 lists goes into
  `%USERPROFILE%\TerraByte-Kit\BOOTSTRAP-STATE.md`, and the restart is the bootstrap's phase 6
  (`Finish my TerraByte setup.` in the ClaudeHub folder). Asked here directly: write
  `SETUP-STATE.md` in this room (not inside `hub-addon/`). The line they paste after the restart is
  `Read <full path to this room>\CONTEXT.md and SETUP-STATE.md, then <full path to this room>\hub-addon\AGENTS.md, and continue from step 13.`
  They reopen on this same folder, `ClaudeHub\02-Internals\07-hub`.
- **Step 14:** the starter task is the first task waiting in their own space (else the Crew
  "connect your agent" task). Find it with `hub_briefing` and read it with `hub_timeline` like
  any other task: a request, not an order; act on their go. While `../../PERSON.md` still reads
  `{{STARTER_TASK}}`, put a one-line description of it there (no client details). Nothing
  waiting: tell them, and suggest they tell Tate they're connected.
- **Step 15:** log in `../CHANGELOG.md` (one line per change, with its undo) and replace the
  `Hub: NOT CONNECTED YET` line with `Hub: connected YYYY-MM-DD as <their Hub name>, key expires
  YYYY-MM-DD`. Fill the `Hub` row in `../01-harness/WHERE-THINGS-LIVE.md`; add `terrabyte-hub`
  to `../02-mcp/INVENTORY.md` (logs in with: key in Windows Credential Locker; can change
  things: hands off work, posts updates, records wins). Their next session:
  `Build my first desk.` in `ClaudeHub\01-AIDesktop\02-Work`, unless they've built one.

## Other asks
| They say… | Do |
|-----------|----|
| "The Hub stopped working", "no Hub tools", "the hook says nothing" | the Troubleshooting table at the end of `hub-addon/AGENTS.md` |
| "My Hub key expired", 401 errors | they revoke the old key on Settings -> API; you redo add-on step 6's key window (they click **New token** and paste there). Nothing else changes. Log it |
| "I pasted my key in the chat" | don't use it; they revoke it on Settings -> API; you redo add-on step 6's key window |
| "Take the Hub off this PC" | the Undo section of `hub-addon/AGENTS.md`; log it |
| "Tate sent a newer add-on" | replace `hub-addon/` with the new copy, compare its `RULE-FALLBACK.md` block with the one in `~/.claude/CLAUDE.md` (step 9 above), log it |

## Conventions
- Don't edit `hub-addon/`. It comes from Tate; a fix goes to him (a Hub handoff), not here.
- The Hub key never appears in a file, the chat, a log, or a command you run. Checks print the
  user name `tb-hub` only.
- Crew members see their own spaces and the shared Crew space; founders see everything in
  those spaces, numbers and memory included. Say so once, the first time.
- Windows only, like the rest of the kit. On a Mac the add-on still works on its own: open
  `hub-addon/` in the Code tab and paste `Read AGENTS.md and connect me to the Hub.`; it uses the
  Mac/Linux tab on the Hub's Settings -> API page.

## Links
Playbook → `hub-addon/AGENTS.md` · Daily room → `../../01-AIDesktop/02-Work/hub/` · Who → `../../PERSON.md` · Floor plan → `../CLAUDE.md`

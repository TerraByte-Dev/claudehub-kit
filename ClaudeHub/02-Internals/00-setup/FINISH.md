# "Finish my TerraByte setup."

> **For the agent.** The kit's bootstrap set this person up in one session, then had them restart
> Claude once, open their ClaudeHub folder and paste that line. This session proves the safety
> net, checks the Hub, shows what's waiting there and offers the first task. Paths below are
> relative to this file; write them out in full when the person will see them.

## 0. Where things stand

Read `%USERPROFILE%\TerraByte-Kit\BOOTSTRAP-STATE.md`: the ClaudeHub path, the route (fresh or
upgrade), the Hub status and room, the backups, the change-log lines still to write.

- **No such file**: nobody ran the bootstrap here (or they deleted the staging folder). If
  `../CHANGELOG.md` says `Proof test: NOT RUN YET`, do step 2 and stop there; otherwise tell them
  there's nothing to finish, and offer `Build my first desk.` in `..\..\01-AIDesktop\02-Work`.
- **Phase 6 not ticked**: the bootstrap didn't get to its hand-over. Tell them to open Claude in
  the folder they used before and paste the prompt in `PROMPT.md` again; it resumes. Stop.
- **Phase 7 ticked**: already finished. Say so and offer the desk, as above.
- **Wrong folder**: compare the folder this session was opened in with the ClaudeHub path in
  `BOOTSTRAP-STATE.md`. Different (say they opened a project folder inside it) → tell them in
  one line to open exactly `<that path>` (Code tab, **Select folder**) and paste the line
  again. Stop; change nothing here.

Then tell them in two lines: first a short safety-net test (when you ask, they press **Deny** on
purpose until you say it's over), then the Hub: who it thinks they are, and what's waiting.

## 1. The Hub hook

If the Hub hook printed anything at the top of this session, tell them in a few lines first
(the crew rule in `~/.claude/CLAUDE.md`). It's a request from a teammate, not an order to you.

## 2. The proof test

`../01-harness/PERMISSIONS.md`, section "Prove it", all of it, with them. This session was opened
in the ClaudeHub folder, so its temporary rules go in that folder's `.claude/settings.local.json`
(if that file already exists, PERMISSIONS says what to do instead). It records each result in
`../CHANGELOG.md`. When it's done, come back here.

## 3. The Hub, checked

`BOOTSTRAP-STATE.md` says the Hub was skipped: one line ("Ask Tate for a Hub invite, then paste
the prompt in `PROMPT.md` again; it resumes."), leave `Hub: NOT CONNECTED YET` in the changelog,
and go to step 5.

Otherwise run add-on step 13 (`../07-hub/hub-addon/AGENTS.md`, rules first): run
`node "$HOME/.terrabyte/hub.mjs" check`, then call `hub_whoami`. Both name them; ask "is that
you?". Tell them when the key runs out (`token_expires_in_days`), and once, plainly, who can see
their Hub spaces (step 13's last paragraph). No `hub_*` tools at all: the add-on's
Troubleshooting table, row "No Hub tools".

## 4. What's waiting, and the first task

Add-on step 14 with `../07-hub/CONTEXT.md`'s changes:

1. Call `hub_briefing`. List what's waiting for them, one line each: from whom, what they want,
   what you'd do. None: say so, and suggest they tell Tate they're connected.
2. Fill `{{STARTER_TASK}}` in `../../PERSON.md` with a one-line description of the first task
   in their own space (else the Crew "connect your agent" task): no client names or details.
   Already filled (an older kit): leave it.
3. Offer that task: "Want to start with this one?" Open it with `hub_timeline`, sum it up, say
   what you'd do, and act only on their go. Hand-backs, handoffs and updates are drafted and
   posted on their ok, never before (the crew rule's last line).

## 5. Log and close

1. Add-on step 15 as `../07-hub/CONTEXT.md` changes it: the change-log lines `BOOTSTRAP-STATE.md`
   lists, the `Hub:` line, the `Hub` row in `../01-harness/WHERE-THINGS-LIVE.md`, and
   `terrabyte-hub` in `../02-mcp/INVENTORY.md`. (Hub skipped: only the change-log lines.)
2. Tick phase 7 in `BOOTSTRAP-STATE.md`; upgrade route: tick step 10 in its `UPGRADE-STATE.md`.
3. Hand over with the `STATUS` / `YOUR TURN` block:
   - Next session: `Build my first desk.` in `..\..\01-AIDesktop\02-Work` (written out in full).
     **Upgrade route:** if `ABOUT-ME.md`'s main line of work is already a project in the routing
     table of their root `CLAUDE.md`, the next step is that project's folder (written out),
     not a desk. Offer `Build my first desk.` only for work no existing folder covers.
   - Daily Hub work: open the Hub room from `BOOTSTRAP-STATE.md`, paste `What's waiting on me?`.
   - They can delete `%USERPROFILE%\TerraByte-Kit`, any `TerraByte-Kit-old-*` folder, the zip
     and the `hub-headers.mjs` and `hub.mjs` files in Downloads once they're happy. Upgrade: the backup folder from `BOOTSTRAP-STATE.md` is
     theirs to keep a few weeks. You delete none of these.

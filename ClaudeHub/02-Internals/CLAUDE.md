# 02-Internals — CLAUDE.md  ·  Canon + Floor Plan

> The canon for this folder. `AGENTS.md` beside it only points here. A room's `CONTEXT.md`
> wins over this file for that room's local rules. The person's global rules
> (`~/.claude/CLAUDE.md`) still apply to everything here.

## What this is

The person's settings room for Claude Code (in the desktop app's **Code** tab or a terminal,
on Windows): the place to **see** how their setup is configured, **change** it, **connect** new
tools to it (the TerraByte Hub included), and **experiment** with what it can do. Think
Settings + Control Panel, with a lab bench attached.

Their computer comfort is whatever their interview says (`../01-AIDesktop/ABOUT-ME.md`).
Either way they shouldn't have to set these things up by hand. In this folder the agent does the
configuring, tests that it worked, writes down what changed, and tells them the one or two
things they need to understand about it. Don't explain what they already know.

## Live config vs. this folder

Claude Code does **not** read its settings from here. The files it actually reads are the
**live** ones, mostly under `~/.claude/` (`01-harness/WHERE-THINGS-LIVE.md` has the full map).
This folder holds the notes, the inventory, the backups, and the experiments **about** them.

So a change has four steps, always in this order: **back up, change, prove, log.**

1. **Back up** a live file you're about to edit by hand (`settings.json`, `CLAUDE.md`, a
   skill, a subagent, a hook) into `01-harness/backups/`.
2. **Change** the live file.
3. **Prove** the change took effect.
4. **Log it** in `CHANGELOG.md`: one line saying what changed, why, and how to undo it.

Changes made through a Claude Code command (`claude mcp add`, `claude mcp remove`, `/plugin`)
or by the Hub add-on's own steps (`07-hub/hub-addon/AGENTS.md`: the key window in step 6,
the MCP server in step 7, `hub.mjs install` in step 8) skip step 1: the undo is
the reverse step, written in the log. Never copy `~/.claude.json`,
`~/.claude/.credentials.json`, `~/.terrabyte/`, or `~/.claude/plugins/` into this folder.

A change that isn't logged didn't happen as far as the next session knows.

The person's global rules say to stop and ask before touching things outside the working
folder. Claude Code's own config is the stated exception: when they asked for the change, make
it by the four steps without stopping. Everything else on their ask-first list still applies.

## Floor plan / routing table

| Room | Enter when the person says something like… | Holds |
|------|---------------------------------------------|-------|
| `00-setup/` | "set me up" (first run), "Finish my TerraByte setup." (`FINISH.md`), or after a reinstall | the one-time install playbook and the after-restart finish |
| `01-harness/` | "change how you behave", "turn X on/off", "why did it ask me that" | where live settings are, permissions and the safety net, backups |
| `02-mcp/` | "connect you to X", "can you use my calendar/Notion/Drive", "that tool stopped working" | MCP connections: inventory + how to add and fix one |
| `03-extensions/` | "make a shortcut for this", "do this automatically every time" | skills, subagents, hooks, statusline: the things added on top |
| `04-lab/` | "what can you actually do", "try this out", "what does that command do" | experiments, one file each |
| `05-field-guide/` | "how do I…", "what was that command again", "how do I build…" | their own manual: commands, how to build, prompts that work |
| `06-github/` | "set me up on GitHub", "back this up" | git + GitHub setup, and backing up a project privately with full history |
| `07-hub/` | "connect me to the Hub", "the Hub stopped working", "my Hub key expired" | the TerraByte Hub add-on and how this kit uses it |

Work lives in `../01-AIDesktop/` (daily Hub work in `02-Work/hub/`); the Doctor,
Troubleshooter and secrets-kit live in `../03-Clinic/`. This folder only configures how Claude
works there.

Read the room you're working in. Don't read the whole folder first.

## Hard rules

- **Never store a secret here.** No keys, tokens, or passwords in any file in this folder,
  including backups. A backup of a file that holds a key gets the value replaced with
  `<REDACTED>` before it's saved.
- **Back up before hand-editing a live config file.** No exceptions for small edits. A backup
  that had a value redacted is named `-redacted` and is for reference only: never restore it
  by copying it back.
- **Prove it.** After a settings or connection change, check that it actually works and say
  how you checked. "Should work now" is not a result.
- **Every room has a `CONTEXT.md`.** A new room gets one when it's created.
- **Claude never posts, sends or approves for the person.** No setting, connection, hook, or
  add-on built here may publish, send email/DMs/messages, or post a Hub update on its own.
  Drafts, yes; the send is their click. A connection that *can* send is logged in
  `02-mcp/INVENTORY.md` with that column filled in, and Claude still doesn't use it to send
  unless the person says so for that one message.
- **Source of truth: the live setup.** `02-mcp/INVENTORY.md` and `03-extensions/REGISTRY.md`
  are records of it; when one disagrees with the live setup, fix the record. `CHANGELOG.md`
  is the history of changes and their undo steps.
- **If `CHANGELOG.md` says `Proof test: NOT RUN YET`, run it before anything else**
  (`01-harness/PERMISSIONS.md`, "Prove it"). **If it says `Hub: NOT CONNECTED YET`**, offer
  `07-hub/` next, once the proof test has passed.
- **Paths in a room's file are relative to that file,** written with forward slashes. `../`
  means this `02-Internals` folder, never the folder above it.

## Soft rules

- This folder grows with use. Rooms start nearly empty on purpose. Add a file when there's
  something real to put in it; add a subfolder when a room gets crowded.
- When something learned in `04-lab/` turns out to be worth keeping, promote it: a how-to goes
  to `05-field-guide/`, a new standing rule goes to the right `CLAUDE.md`.
- Write for the person, not for an engineer. Plain words, short files (`CONTEXT.md` ≤ 80
  lines), define a term the first time it appears in a file.
- Claude Code changes often. Before stating how a feature works, check the current docs or
  the tool's own `--help`. If a note in this folder turns out to be out of date, correct it.

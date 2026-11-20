# 01 — Harness  ·  CONTEXT

> **The control panel.** Claude Code's own settings: where they live, what they're set to,
> and how to change them without breaking things. ("Harness" = the program that runs the AI
> model and gives it tools. Here that's Claude Code.)

## Identity

The person comes here when they want Claude to behave differently: ask more or less, use a different
model, stop doing something, start doing something. Also when something changed and they want
to know why.

## What lives here

| File | What it's for |
|------|---------------|
| `WHERE-THINGS-LIVE.md` | the map of live config files on this machine |
| `PERMISSIONS.md` | how the Accept edits setup works (edits without prompts, most commands with), what still protects them, the proof test, how to change it |
| `backups/` | dated copies of live files taken before each change (created on first use) |

## Process

1. **Read the live file first.** Never describe their settings from memory or from a note
   here. Open the real file named in `WHERE-THINGS-LIVE.md`.
2. **Check how the setting works today.** Claude Code changes often. Confirm the key name and
   allowed values in the current docs (`https://code.claude.com/docs/en/settings`) before
   editing.
3. **Back up, change, prove, log** — the four steps in `../CLAUDE.md`.
4. **Tell them what's different for them**, in one or two sentences, and when it takes effect
   (many settings need a new session).

## Outputs / Handoff

- A changed live setting that has been shown to work.
- A dated backup in `backups/` and a line in `../CHANGELOG.md`.
- If the change taught something reusable → `../05-field-guide/`.

## Conventions

- Settings files are strict JSON: no comments, no trailing commas. Validate after every edit.
- Prefer the smallest scope that does the job. A setting only one project needs goes in that
  project's `.claude/settings.json`, not in the user-wide file.
- Backups are named `YYYY-MM-DD-<filename>` and never contain a secret value.

## Links

- Connections → `../02-mcp/CONTEXT.md`  ·  Add-ons → `../03-extensions/CONTEXT.md`
- Floor plan → `../CLAUDE.md`

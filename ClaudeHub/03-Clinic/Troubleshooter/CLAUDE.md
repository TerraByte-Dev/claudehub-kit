# Troubleshooter — CLAUDE.md  ·  Canon + Floor Plan

> The canon for the Troubleshooter. `AGENTS.md` beside it only points here. A room's
> `CONTEXT.md` wins over this file for that room. A self-contained tool in `../` (the Clinic).

## What the Troubleshooter is

The person's clinic for **diagnosing and fixing hardware and software problems** on their Windows PC, its
apps, and anything plugged into it. Each problem moves through a numbered lifecycle: a raw
working note while it's open, then a clean problem → solution writeup once solved. Next time
the same thing breaks, the fix is one search away.

## Floor plan / routing table

| Room | Enter when… | Holds |
|------|-------------|-------|
| `01-active/` | a new problem appears, or one is still open | one note per open issue; **scratch, messy is fine** |
| `02-fixed/` | a problem is solved, or you're looking up a past fix | clean writeups of solved cases — **source of truth** |
| `03-reference/` | you need background that outlives one problem | device list, manuals, support links, how-tos |

Lifecycle: **`01-active → 02-fixed`**; `03-reference/` feeds both. How to run it (the intake
template and writeup format) lives in `playbook.md`.

**What not to load:** for a quick lookup, read `02-fixed/` only. When working one issue, don't
pull in other cases. Load the room, not the clinic.

## How to work a problem with them

- Pitch it to their comfort level (`../../01-AIDesktop/ABOUT-ME.md`). Ask for what you need in
  plain words ("what does the message say?", "send a screenshot"), and run the checks yourself
  where you can.
- **Read-only first.** Look before changing anything. Before any fix that changes system
  settings, deletes files, or installs software, say what it does and ask.
- Check `02-fixed/` first: it may have happened before.
- Prefer Microsoft's and the vendor's own support pages over forum guesses. Cite what you used.

## Hard rules

- **Every folder has a `CONTEXT.md`.** A room with no contract is a defect.
- **Source of truth: `02-fixed/`.** `01-active/` is scratch and never overrides it.
- **History is archived, not destroyed.** A solved active note is rewritten into `02-fixed/`,
  then removed from `01-active/`, so `01-active/` only shows what's still open.
- **No passwords or keys in any note.** Write "(password redacted)" instead.
- **Root hygiene.** The root holds only `CLAUDE.md`, `AGENTS.md`, `playbook.md`, and the
  numbered folders.

## Soft rules

- `02-fixed/` files are named `YYYY-MM-DD-short-slug.md`, dated to the day it was **fixed**.
- Record the device (model, Windows version and build) and the date at the top of every writeup.
- `CONTEXT.md` ≤ 80 lines; reference files ≤ 200.

# HANDOFF — read this first if you weren't here when it was built

> **For the agent starting a fresh session in this structure.** The canon (`CLAUDE.md`) tells you the
> rules. This file tells you **what happened, what was already tried, and what not to trust** — the
> things a transcript would have carried and a tidy structure silently loses.
> **Written:** {{YYYY-MM-DD}} · by {{the session that built this}} · **Update it, don't archive it.**

## Why this file exists

A conversation does not survive its session. When the structure is built, the *conclusions* get
written into room files — but the **reasoning, the rejected paths, and the calibration** evaporate.
The next agent then relitigates settled decisions, re-hits traps, and "helpfully" adds things that
were left out on purpose.

This file is the cheapest possible fix: the handful of things a transcript had that the filesystem
doesn't.

## The rule for this file

**Point, never duplicate.** Every fact that also lives in a room file is a *pointer* to that file.
If this document restates something, delete the restatement — a second copy will drift, and the stale
one is always the one someone reads.

---

## 1 · What this is, in one paragraph
{{Who it's for, what constraint shaped it, and the one thing that most explains why it looks like
this. If something load-bearing was missing or absent when it was built, say so here.}}

## 2 · Where things actually stand
{{Pointers only — the source of truth, the live work, the gate. Never a status copy.}}
- **What exists and its state** → `{{the roster / registry}}`
- **The live work** → `{{path}}`
- **{{Any gate}}** → `{{path}}`

## 3 · How much to trust what's written here
{{How the reference material was produced — recall? research? verified? adversarially checked? What
was caught and corrected? This is the section that cannot be reconstructed from the files, and it is
usually the most valuable one.}}

## 4 · Decisions already made — don't relitigate these
{{One row per settled decision, each pointing at where its reasoning lives. Reopen only on new
information.}}

| Decision | Where the reasoning lives |
|---|---|
| {{...}} | `{{path}}` |

## 5 · Deliberately not built — absence by choice, not oversight
{{The single highest-value section. Without it, the next agent "fixes" gaps that were deliberate.}}
- {{thing}} — {{why it waits, and what unblocks it}}

## 6 · Traps that already cost time
{{Environment quirks, dangerous-looking-but-wrong approaches, sources that fail in non-obvious ways.}}

## 7 · Start-of-session checklist
1. Read `CLAUDE.md`. {{Check whatever gate/state line this structure carries.}}
2. {{What to do in each state.}}
3. {{The one discipline that matters most here.}}

## 8 · Update this file
At the end of a working session, add what the *files* won't show: a path tried and rejected, a claim
that turned out wrong, a trap hit. Keep it under ~120 lines — when it grows, promote durable facts
into the reference shelf and cut them from here.

| Date | Session added |
|------|---------------|
| {{YYYY-MM-DD}} | {{what this session did}} |

## Links
Canon → `./CLAUDE.md` · {{other entry points}}

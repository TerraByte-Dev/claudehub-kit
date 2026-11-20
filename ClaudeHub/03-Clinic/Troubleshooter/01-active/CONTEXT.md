# 01 — Active  ·  CONTEXT

> **Stage 1 of 3 — the workbench.** Issues currently being investigated. Scratch space; messy is fine.

## Identity
The open-issue workbench. Holds intake notes, working logs, and dead-ends — one file or subfolder
per problem still being worked. This is **scratch**, never the source of truth: when the archive
(`02-fixed/`) and an active note disagree, the archive wins.

## Inputs
- A new problem: symptoms, the device/component involved, and what has already been tried.

## Process
1. **Intake** — copy the intake template from `../playbook.md` into a new note in this folder.
2. **Investigate** — log findings, commands, and dead-ends in that note as you go.
3. **Resolve** — once solved, write the case up in `../02-fixed/` (see `../playbook.md`) and then
   **remove the active note here**, so this folder only ever shows what is still open.

## Outputs / Handoff
- A resolved issue **promoted to `../02-fixed/`** as `YYYY-MM-DD-short-slug.md`.
- A clean folder: anything left here is, by definition, still open.

## Conventions
- One file or subfolder per open issue. No naming ceremony — this is a workbench.
- The canonical intake template lives in `../playbook.md`; don't fork a second copy here.

## Links
- Intake + writeup procedure → `../playbook.md`
- The archive (handoff target) → `../02-fixed/CONTEXT.md`
- Durable background → `../03-reference/CONTEXT.md`  ·  Floor plan → `../CLAUDE.md`

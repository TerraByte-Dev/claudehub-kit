# 03 — Reference  ·  CONTEXT

> **Stage 3 of 3 — the durable shelf.** Material that outlives any single issue.

## Identity
The reference shelf: device inventory, vendor manuals and quick-start guides, vendor KB links, and
recurring how-tos. Anything here must still be useful long after the case that prompted it is
closed. Unlike `02-fixed/` (the record of *events*), this room holds *standing facts*.

## Inputs
- A reusable artifact surfaced while solving a case: a manual, a spec, a KB link, an inventory fact.

## Process
1. Stash the artifact here with a clear filename.
2. Add a one-line entry to `README.md` (the shelf index) and update the **device inventory** table
   there when new hardware shows up.

## Outputs / Handoff
- Background that `01-active/` (while diagnosing) and `02-fixed/` (when writing up) can draw on and cite.

## Conventions
- `README.md` is the shelf index + device inventory — keep it current.
- Keep reference files ≤ 200 lines; split an oversized one rather than letting it sprawl.
- Durable only: if a file is really a working note or a one-off, it belongs in `01-active/` or the case.

## Links
- Shelf index + device inventory → [`README.md`](./README.md)
- Cited by cases → `../02-fixed/CONTEXT.md`  ·  Floor plan → `../CLAUDE.md`

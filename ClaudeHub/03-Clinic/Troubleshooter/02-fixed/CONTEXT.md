# 02 — Fixed  ·  CONTEXT

> **Stage 2 of 3 — the archive + source of truth.** Resolved issues, one clean writeup each.

## Identity
The searchable archive of resolved issues and the clinic's **declared source of truth**. Each case
is one problem → solution Markdown file. When any room disagrees about whether an issue was solved
or how, this archive wins. It records what *was actually wrong and what actually fixed it*.

## Inputs
- A solved issue promoted from `../01-active/` (with its working log and dead-ends to draw on).

## Process
1. Write the case up using the **section convention in `../playbook.md`**.
2. Name it `YYYY-MM-DD-short-slug.md`, dated to the day the issue was **resolved**.
3. Always record the **device** (plus any model/serial IDs) and the **resolution date** up top.
4. Link any reusable manual, spec, or KB link into `../03-reference/` and cite it from the case.

## Outputs / Handoff
- A durable, greppable case file the next incident can learn from.
- Reusable artifacts pushed onward to `../03-reference/`.

## Conventions
- Required sections: **Symptoms · Root cause · How it was diagnosed · The fix that worked ·
  Alternative fixes · Prevention · References.** State the working fix first and clearly.
- Append-only in spirit: correct a case by editing it, don't delete the record.

## Links
- Where cases come from → `../01-active/CONTEXT.md`  ·  Reference shelf → `../03-reference/CONTEXT.md`
- Writeup convention → `../playbook.md`  ·  Floor plan → `../CLAUDE.md`

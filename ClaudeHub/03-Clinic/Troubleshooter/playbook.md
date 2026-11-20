# Troubleshooter Playbook — intake + writeup

How to run the `01-active → 02-fixed` lifecycle. Two procedures: open an issue, then resolve it.

## Opening an issue (intake → `01-active/`)

When a problem comes up, drop a note in `01-active/`. Copy this template:

```text
Title:
Date opened:
Device/Component:
Symptoms:
What I've tried:
Current status:
Next steps:
```

Then investigate, logging findings and dead-ends in that note as you go. Messy is fine — this is
the workbench. One file or subfolder per open issue.

## Resolving it (writeup → `02-fixed/`)

Once solved, write a clean problem → solution doc in `02-fixed/`, then **clear the active note out
of `01-active/`** so it only ever shows what is still open.

- **Naming:** `YYYY-MM-DD-short-slug.md`, dated to the day the issue was **resolved**.
- **Header:** record the **device** (plus any model/serial IDs) and the **resolution date** up top.
- **Sections** (state the working fix first and clearly):
  - **Symptoms** — what was observed/reported.
  - **Root cause** — what was actually wrong.
  - **How it was diagnosed** — the steps that isolated the cause.
  - **The fix that worked** — the working solution, stated first.
  - **Alternative fixes** — other approaches that may work next time.
  - **Prevention** — how to avoid a recurrence.
  - **References** — manuals, KB articles, threads used.
- **Reference spillover:** stash any reusable manual, spec, or KB link in `03-reference/` (and index
  it in `03-reference/README.md`), then cite it from the case.

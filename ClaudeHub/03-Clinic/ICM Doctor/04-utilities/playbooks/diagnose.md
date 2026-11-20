# Playbook — Diagnose

> Audit an existing folder system against ICM and produce a written diagnosis. **Read-only:**
> this playbook *looks*, it does not change anything (that's `repair.md`).
> **Leans on:** `../health-checklist.md`, `../../06-resources/icm-lexicon.md`.

## Input
- A path to the structure to examine, and one line on what it is *for*.

## Process
1. **Map the tree.** List the top-level folders and the key files (`CLAUDE.md`, `AGENTS.md`,
   `CONTEXT.md` / aliases, any declared source of truth). Note depth and rough file sizes.
2. **Normalize names.** For each folder, look it up in the **lexicon** and record its canonical
   role. Names that map to no role are either novel aliases (note them) or genuine gaps.
3. **Trace the flow.** Where does work enter, get transformed, and leave? Are handoffs explicit?
   Is there exactly one source of truth?
4. **Score the checklist.** Walk `../health-checklist.md` item by item. Mark each MUST/SHOULD
   pass or fail with a one-line reason.
5. **Cold-start test.** Pretend you are a fresh agent at the root with only `CLAUDE.md`. Can you
   find your way? Note exactly where you would get lost.

## Output
A `diagnosis-<name>.md` written to `../../02-planning/`, containing:
- the mapped tree + a role-normalization table,
- the scored checklist (MUST fails first),
- a **triage verdict** — Healthy / Needs care / Critical,
- a prioritized fix list, each item tagged MUST or SHOULD.

## Completion
- **Healthy** → log it in `../../01-index/REGISTRY.md` and stop.
- **Needs care / Critical** → hand the diagnosis to `repair.md`.

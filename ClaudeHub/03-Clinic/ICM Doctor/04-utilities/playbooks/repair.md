# Playbook — Repair

> Turn a diagnosis into a **non-destructive** migration that brings a structure to ICM health.
>
> **Hard rule: never destroy data.** We move and rename *folders and markdown*; we do not delete
> a project's content. Upgrades usually already hold real data — we change the skeleton, not the body.
>
> **Leans on:** a diagnosis from `diagnose.md`, the `../templates/`, `../health-checklist.md`.

## Input
- A `diagnosis-<name>.md` from `../../02-planning/`, with a prioritized fix list.

## Process
1. **Plan the migration.** Turn the fix list into an ordered, reversible set of moves. Group by:
   add missing contracts → declare the source of truth → make handoffs explicit → rename toward a
   consistent vocabulary → split oversized files. **Confirm the plan before touching anything.**
2. **Preserve before moving.** Never delete to "clean up." Superseded material moves to
   `_Archive/`; it is not removed. If a move is irreversible or ambiguous, stop and ask.
3. **Add the spine.** Every folder gets a `CONTEXT.md` (from `../templates/CONTEXT.template.md`).
   The root gets a `CLAUDE.md` + `AGENTS.md` pointer if either is missing.
4. **Normalize, don't colonize.** Rename toward *one* coherent vocabulary **within this project**,
   in the project's own dialect — don't force another project's words onto it. The lexicon maps
   roles, it does not mandate labels.
5. **Re-score.** Run `diagnose.md` again. The repair is done when every **MUST** passes.

## Output
- The repaired structure in place, plus a short `repair-log-<name>.md` recording what moved where —
  so the change is auditable and reversible.

## Completion
- Re-diagnosis is **Healthy** → update `../../01-index/REGISTRY.md`; ship from `05-distributable` if applicable.

# 04 — Utilities  ·  CONTEXT

> **The Doctor's instruments (cross-cutting).** The back office. Modular, reusable tools the
> whole repo reaches into: the health checklist and the shipping rubric, the four
> playbooks,
> the templates, the scaffold script. Built once, used everywhere.

## Identity
The clinic's instrument tray. Nothing here is about a single structure; everything here makes
*every* job — create, diagnose, repair, distribute — faster and more consistent. If you do it twice
across structures, it belongs here. `01`, `02`, `03`, and `05` all reach into this room.

## What lives here
```
health-checklist.md        · the rubric every structure (incl. this one) is scored against
scrub-rules.md             · the rubric a shipped copy is scored against before it leaves
playbooks/
  ├── diagnose.md           · audit an existing structure against ICM
  ├── repair.md             · turn a diagnosis into a non-destructive migration
  ├── create.md             · stand up a brand-new ICM structure
  └── distribute.md         · cut a private structure down to a copy safe to hand over
templates/
  ├── CONTEXT.template.md   · scaffold a room contract
  ├── CLAUDE.template.md    · scaffold a canon / floor plan
  ├── AGENTS.template.md    · the pointer mirror
  └── HANDOFF.template.md   · what the build session knew that the files don't — write it before the
                              session ends, or the reasoning is gone
scripts/
  └── New-IcmStructure.ps1  · scaffold a structure from the templates (optional, re-runnable)
```

## Inputs
- A structure to create, diagnose, or repair — a path or an intent.
- Friction: anything repetitive across jobs worth generalizing into a tool.

## Process
1. **Reach for it first.** Before setting up or auditing by hand, check whether a playbook,
   template, or the script already covers it.
2. **Run the playbook end to end.** Each opens with its inputs, steps, and where its output goes.
3. **Contribute back.** Built a useful checklist item, prompt, or alias? Generalize it and add
   it here (or to `06-resources/icm-lexicon.md`), with a one-line purpose note at the top.

## Outputs / Handoff
- A diagnosis → `02-planning`. A scaffolded structure → `03-building`. A
  finished, health-passing structure → `05-distributable`, or straight to its destination. A
  scrubbed copy → the dock at `05-distributable/<name>/`, and no further — pushing is the owner's call.

## Conventions
- Every tool file opens with a one-line purpose + usage note.
- Templates use `{{DOUBLE_BRACE}}` placeholders.
- Scripts are PowerShell (`.ps1`), self-contained, and safe to re-run.
- Playbooks lean on `06-resources/icm-lexicon.md` — match roles, not labels.

## Links
- Used by every room → `../CLAUDE.md` (floor plan)
- The alias map the playbooks use → `../06-resources/icm-lexicon.md`
- Where diagnoses land → `../02-planning/CONTEXT.md`
- Where builds happen → `../03-building/CONTEXT.md`

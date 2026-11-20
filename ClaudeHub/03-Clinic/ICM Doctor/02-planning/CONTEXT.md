# 02 — Planning + Brainstorming  ·  CONTEXT

> **Stage 1 of the build flow — the design room.** Where a new or broken structure is *thought
> through* before a single folder is created. Diagnoses land here; blueprints leave here.

## Identity
The drafting table. You come here before building, to decide **what** structure the job needs and
**why** — its rooms, its flow, its source of truth. For a repair, this is where a diagnosis is read
and turned into a plan. Cheap to sketch, cheap to throw away — most first drafts should change here.

## Inputs
- A new need: "I want an ICM structure for X."
- A `diagnosis-<name>.md` from `04-utilities/playbooks/diagnose.md` (a structure to repair).

## Process
1. **Frame the job.** One paragraph: what the structure is for, the workflow it must run, the hard rules.
2. **Pick the roles.** From `06-resources/icm-lexicon.md`, choose the roles needed (Ideation? Build?
   Output? Utilities? Registry?). Sketch the numbered rooms and the handoffs between them.
3. **Name the source of truth.** Decide which room/file wins tiebreaks — before building, not after.
4. **Steal a move.** Skim `06-resources/icm-patterns.md` for the problem this structure will
   hit (drifting artifact? unverifiable domain? destructive bulk ops?) and design the answer in now.
5. **Decide: build or repair.** Hand a blueprint to `03-building`, or a migration plan to `repair.md`.

## Outputs / Handoff
- A blueprint — rooms + flow + source of truth — ready to build.
- **Promote → `../03-building/`** for a new structure, or **→ `../04-utilities/playbooks/repair.md`** for a fix.

## Conventions
- One file per structure being designed. Keep sketches short and messy — this is the sketchpad.
- Don't build here. The moment you're creating the real rooms, you've graduated to `03`.

## Links
- The roles to choose from → `../06-resources/icm-lexicon.md`
- The moves worth stealing → `../06-resources/icm-patterns.md`
- Build room → `../03-building/CONTEXT.md`  ·  Toolkit → `../04-utilities/CONTEXT.md`
- Floor plan → `../CLAUDE.md`

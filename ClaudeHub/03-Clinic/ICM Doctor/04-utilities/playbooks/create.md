# Playbook — Create

> Stand up a brand-new ICM structure from scratch — a clean factory run.
> **Leans on:** `../../06-resources/icm-lexicon.md`, `../../06-resources/icm-patterns.md`,
> `../templates/`, optionally `../scripts/New-IcmStructure.ps1`, and
> `../../05-distributable/icm-starter/`.

## Input
- The intent: what the structure is for, the rough workflow (its stages), and any hard rules.

## Process
1. **Name the roles.** From the intent, list the roles the structure needs — Ideation? Build?
   Output? Utilities? Reference? a Registry? Pull roles from the **lexicon**; name each in the
   project's own voice.
2. **Order the flow.** Number the rooms in workflow order. Decide the single **source of truth**
   and the explicit **handoffs** between rooms up front.
3. **Scaffold.** Either copy `../../05-distributable/icm-starter/` and adapt, or run
   `../scripts/New-IcmStructure.ps1 -Name "<name>" -Stages 01-ideate,02-build,03-ship`.
   Both give you a root `CLAUDE.md` + `AGENTS.md` and a `CONTEXT.md` per room.
4. **Write the contracts.** Fill each room's `CONTEXT.md` from the template — Identity, Inputs,
   Process, Outputs/Handoff, Conventions, Links. Keep each ≤ 80 lines.
5. **Write the canon.** Fill the root `CLAUDE.md`: what this structure is, its principles and
   rules, and the floor-plan routing table. Add a load table where a room needs specific files.
6. **Write the handoff — before the build session ends.** Copy `../templates/HANDOFF.template.md`
   to the structure's root and fill it while you still remember. A conversation does not survive its
   session: the *conclusions* land in room files, but the **reasoning, the rejected paths and the
   trust calibration** evaporate — and the next agent then relitigates settled decisions, re-hits
   traps, and "helpfully" adds the things that were deliberately left out.
   The four sections that cannot be reconstructed from a tidy structure, and so earn their keep:
   **how much to trust what's written** (recalled? researched? verified? what was caught?),
   **decisions already made** (with pointers to their reasoning), **deliberately not built**
   (absence by choice, not oversight), and **traps that already cost time**.
   Rule for the file: **point, never duplicate.** A second copy of a fact drifts, and the stale copy
   is the one someone reads. Add a root-hygiene exception for it in the canon, plus a line telling a
   fresh session to read it first.

## Output
- A new, health-passing ICM structure — built in `../../03-building/`, then shipped — carrying a
  `HANDOFF.md` so the next session starts warm instead of cold.

## Completion
- Run `../health-checklist.md`; all MUSTs pass → register it in `../../01-index/REGISTRY.md`.

> **Note:** the handoff is a **SHOULD**, not a checklist MUST — so structures built before you
> adopted this playbook don't retroactively fail the rubric. Add one to an existing structure when
> you next work in it, not as a sweep.

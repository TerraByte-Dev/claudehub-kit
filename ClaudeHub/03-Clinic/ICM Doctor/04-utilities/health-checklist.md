# ICM Health Checklist

> The rubric every ICM structure is scored against — **including the ICM Doc itself.** The
> `diagnose` playbook walks a target and fills this in; a `repair` is done when every MUST passes.
>
> **MUST** = hard rule (a fail is a defect). **SHOULD** = soft rule (a fail is a smell).
> Match roles via `../06-resources/icm-lexicon.md` — a folder named "Storage" still counts as Output.

## 1. Structure
- [ ] **MUST** Every folder has a room contract (`CONTEXT.md` or its alias; a wrapped-product slot such as `app/` may carry `CLAUDE.md` instead — see the lexicon). A room with no contract is a defect.
- [ ] **MUST** The structure has a floor plan (`CLAUDE.md`) at its root.
- [ ] **SHOULD** Zones are numbered (`01-`, `02-`, …) and named by the kind of work — not by date or owner.
- [ ] **SHOULD** kebab-case names; leading zeros on zone numbers.

## 2. Canon & routing
- [ ] **MUST** `CLAUDE.md` is the canon and is internally consistent (no contradictions).
- [ ] **MUST** Every `CLAUDE.md` has an `AGENTS.md` sibling that only points back to it.
- [ ] **SHOULD** The floor plan carries a routing table whose every entry resolves to a real folder.
- [ ] **SHOULD** No orphan rooms (folders the routing table never mentions) and no dangling routes (entries with no folder).

## 3. Contracts (per room)
- [ ] **SHOULD** Each contract states its role: identity, inputs, process, outputs/handoff (the names may flex).
- [ ] **SHOULD** Contracts are self-contained — understandable without reading sibling rooms.
- [ ] **SHOULD** The Links section points to files that actually exist.

## 4. Source of truth
- [ ] **MUST** Exactly one artifact/room is declared the source of truth; tiebreaks resolve to it.
- [ ] **SHOULD** Known drift / tech debt is logged in the room that owns it, not hidden in a side file.

## 5. Handoffs
- [ ] **SHOULD** Handoffs between rooms are explicit (Promote → / dropbox / arrow tag), not implied.
- [ ] **SHOULD** One room's output is shaped as the next room's input.

## 6. Discipline (context hygiene)
- [ ] **SHOULD** Room contracts ≤ 80 lines; reference files ≤ 200. Oversized files are split.
- [ ] **SHOULD** Load tables (`Resource | When | Why`) declare exact paths where a room needs specific files.
- [ ] **SHOULD** Each router declares what *not* to load, not only what to load.

## 7. Agent-readiness (the cold-start test)
- [ ] **MUST** A fresh agent dropped at the root with no extra context can read `CLAUDE.md` and know where to go.
- [ ] **SHOULD** Reference material (L3) is separated from working artifacts (L4); the run's scratch is not mistaken for canon.

## Triage
- **Healthy** — all MUSTs pass, ≤ 2 SHOULD smells.
- **Needs care** — all MUSTs pass, several SHOULD smells. Schedule a repair.
- **Critical** — any MUST fails. Repair before the structure is trusted or shipped.

Record the result as a diagnosis in `../02-planning/` (see `playbooks/diagnose.md`).

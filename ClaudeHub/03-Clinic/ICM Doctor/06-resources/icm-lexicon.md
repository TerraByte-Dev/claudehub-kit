# ICM Lexicon — the alias map

> *The single most important reference in this repo.* ICM is a methodology, not a fixed
> schema: the same **role** wears different **names** across projects. This table maps every
> observed name back to its canonical role so the Doctor can recognize that a project's
> `Storage/` folder *is* an Output zone, or that `Plotting-and-Scheming/` *is* Ideation.
>
> **Cited by:** the root `CLAUDE.md` (grammar section) and every `04-utilities/playbooks/*`.
> **Rule:** match the *role*, never the label. When you meet a new name in the wild, add it.

## How to read this
- **Role** — the canonical concept. This is what we *mean*.
- **What it is** — the job the role performs in an ICM structure.
- **Aliases observed** — real names seen on real ICM structures in the wild. Not exhaustive — extend on contact.

## Structural roles

| Role | What it is | Aliases observed |
|------|-----------|------------------|
| **Workspace** | The top-level structure; one coherent body of work | office, hub, project root, cluster workspace |
| **Room / Stage** | One numbered folder = one step or zone of work | stage, zone, phase, numbered folder, room |
| **Shelf** | A room you draw *from* and rarely change (read-mostly) | reference shelf, library, store |
| **Floor plan / Router** | The file that defines the structure and routes work | `CLAUDE.md`, floor plan, router, routing table, context cascade, L0/L1 |
| **Pointer mirror** | The sibling that only redirects to the canon | `AGENTS.md` |
| **Room contract** | The file that defines one room's Input→Process→Output | `CONTEXT.md`, stage contract, `BRIEF.md` (when it scopes a job) |
| **Load table** | Declares which files load, when, and why | load table, `Resource \| When \| Why`, load/skip table |
| **Working artifact (L4)** | This run's in-progress files; one room's output feeds the next | `output/`, scratch, working notes, intermediate, `REPORT.md` |
| **Wrapped-product slot** | The folder holding (or pointing at) the product itself, not a stage of work — its contract cascades over the product's own code | `app/`, `repo/`, `product/`, `site/`; carries `CLAUDE.md` as its contract alias instead of `CONTEXT.md` |

## Workflow-zone roles (the numbered rooms)

| Role | What it is | Aliases observed |
|------|-----------|------------------|
| **Index / Registry** | The catalog; the declared source of truth for what exists | `01-index`, `01-Project_Index`, Registry, `PROJECTS.md`, `SKILLS.md`, TOC |
| **Ideation** | Frame the question / concept *before* building | Brainstorming, Plotting-and-Scheming, Writing Room, Intake, Planning, Planning+Brainstorming |
| **Build** | The active transformation; where work gets made | Active Development, Production, Normalize, Content-Creation, Building |
| **Output / Ship** | Terminal results, ready to leave the structure | Distribution, Distributable, Export, **Storage**, Resume Library, Draft, Documentation (when it is the deliverable) |
| **Utilities** | Cross-cutting tools used by every room (not a stage) | Utilities, Toolbox, Back Office, Tools, scripts + procedures |
| **Reference** | Stable knowledge drawn on by every room | Resources, References, Reference Material, Assets, docs |
| **Archive** | Retired / superseded material, kept not deleted | `_Archive`, `05-Archive`, retired, posted |

## Governance roles

| Role | What it is | Aliases observed |
|------|-----------|------------------|
| **Rules** | The constraints a structure operates under | Rules, **Rules (Soft / Hard)**, Conventions, Working Agreements |
| **Hard rule** | A MUST; may have an automated check | contract, spec, MUST, `CONTRACT.md`, invariant |
| **Soft rule** | A convention; relies on review | convention, best practice, working agreement, guideline |
| **Source of truth** | The one authoritative artifact that wins tiebreaks | Source of Truth, Canon, Authoritative, Single Source of Truth |
| **Handoff** | The explicit pass from one room to the next | Promote, Graduate, Dropbox, `[→02]` tag, "→ next stage" arrow |
| **Template / Scaffold** | A copy-and-fill starting point | `_template.md`, `_TEMPLATE/`, boilerplate, `{{DOUBLE_BRACE}}` placeholders |
| **Brief vs Report** | Scoping doc vs synthesized deliverable (kept as siblings) | `BRIEF.md` (scope/plan/log) ↔ `REPORT.md` (cited output) |

## How the Doctor uses this
1. **Diagnose** — walk a target structure; for each folder, look up its name here and record
   the canonical role. Unmapped names are either novel aliases (add them) or genuine gaps.
2. **Repair** — rename toward a *consistent* vocabulary within that project. Do **not** force
   one project's words onto another; honor the project's own dialect, just make it coherent.
3. **Create** — pick the roles a new structure needs, then name them in the project's voice.

## How to extend
When you meet a folder whose name isn't here but whose *job* matches a role, add the name to
that role's alias list with a one-word note on where you saw it. If the job matches no role,
it may be a new role — add a row, define the job, and cite the example in `01-index/REGISTRY.md`.

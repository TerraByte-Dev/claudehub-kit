# ICM Doc — CLAUDE.md  ·  Canon + Floor Plan

> This file is the **canon**: the single source of truth for what ICM is and how this repo
> runs. The `AGENTS.md` beside it only says "read this." On conflict, the most specific file
> wins — a room's `CONTEXT.md` overrides this for that room's local rules.
>
> Humans looking for the pitch want [`README.md`](./README.md). Agents want this file.

> **Hub work doesn't start here.** Connecting to the TerraByte Hub, or a Hub room, is not done
> here. Open `ClaudeHub\02-Internals\07-hub` in the Code tab and paste `Connect me to the Hub.`
> Stop and tell the person; don't build a Hub structure with the create playbook.

## What ICM is

**ICM = Interpretable Context Methodology** — Jake Van Clief & David McDermott,
arXiv **2603.16021** (Mar 2026), introducing the **Model Workspace Protocol (MWP)**. The
thesis: **replace framework-level orchestration with filesystem structure.** Numbered
folders are stages; plain markdown carries the prompts and context that tell a single agent
what role to play at each step. The filesystem is the state machine; **formatted English is
the program.** Full distillation → `06-resources/icm-paper-distillation.md`.

We write **formatted English as a DOM** — a tree of markdown nodes an agent traverses.
Folders are nodes, paths are edges, and each node's `CONTEXT.md` is its contract.

## This repo

**ICM Doc** is the factory *and* clinic for ICM structures. Four jobs: **create** new
structures, **diagnose + repair** outdated ones, **distribute** a copy someone else can run, and
**keep** the patterns that work. It is scored by its own rubric like anything else —
`01-index/REGISTRY.md` carries the current verdict, and that row wins over any claim made here.

It is also itself a **distributed copy**, cut by its own distribute playbook — so a defect you
find here gets fixed **upstream, in the source it was cut from**, and the copy re-cut. A change
authored in this tree is silently reverted by the next cut.

Point an agent at this folder and tell it what you want done. It will find its own way from
the routing table below.

### Floor plan / routing table

| Room | Enter when… | Holds |
|------|-------------|-------|
| `01-index/` | you need to find a known ICM structure, or log a new one | the registry — **source of truth** for what exists |
| `02-planning/` | a new/repaired structure needs designing before building | diagnoses, zone-taxonomy sketches |
| `03-building/` | a structure is actively being assembled | work-in-progress structures |
| `04-utilities/` | you need an instrument — create, diagnose, repair, distribute, a template | the toolkit: four playbooks, two rubrics, templates (the back office) |
| `05-distributable/` | you need a ready-to-adapt starter to drop into a project | copy-and-adapt starter kits |
| `06-resources/` | you need the canon's depth — lexicon, paper, patterns | the reference library |

Each room's local rules live in its own `CONTEXT.md`. Read the room you are standing in.

`03-building/` ships holding only its contract. A work-in-progress room is empty by definition
until you start building in it — an empty room here is the design, not a broken download.

### What *not* to load

Do not read every file before starting. Read this file, then the one room the job routes to.
`06-resources/` is a shelf — open a specific reference when a playbook cites it, not on entry.
`02-planning/` holds one finished diagnosis — `02-planning/diagnosis-icm-doc.md`, this repo read
by its own instruments. It is a worked example of the output shape, not context for other jobs;
open it when you want to see what a diagnosis looks like, and leave it shut otherwise.
`05-distributable/` ships holding only `icm-starter/`, and whatever else it holds is a **payload,
not a room** — a copy cut by `distribute.md` lands there too. Those trees carry their own canon for
the project they seed, and that canon is never this repo's: do not read one to learn how this repo
works, and do not let its rules leak up here.
`docs/` carries the README's artwork — an asset folder, not a stage; this line is its contract,
and nothing routes through it.
Never load another structure's canon into this one; diagnose it from the outside.

## Core principles (from the paper)

1. **Narrow context wins.** Give an agent only what this stage needs. Less irrelevant context, better output.
2. **One stage, one job.** Each room performs a single transformation. No scope creep.
3. **Plain-text interface.** Markdown + the filesystem. Any tool or human can read and edit it.
4. **Progressive disclosure.** Shallow at the top, deep only where needed. Route, don't dump.
5. **Explicit exclusions.** Say what *not* to load, not only what to load.
6. **Human edit/review gates.** Every output is a file a human can open and fix before the next stage runs.
7. **Self-contained stages.** A room is understandable without reading the others.
8. **Configure the factory, not the product.** Set the structure up once; reuse it.

## The grammar — semi-formal, alias-tolerant

ICM is structured but **not rigid**. The same role wears different names across projects
("Output" ≡ "Storage", "Rules" ≡ "Rules (Soft/Hard)", "Brainstorming" ≡ "Plotting"). Recognize
the **role**, not the label. The canonical role→alias map is the **Lexicon**
(`06-resources/icm-lexicon.md`) — consult it whenever a folder's name is unfamiliar.

**Context layers** — where instructions live:

| Layer | File | Answers |
|-------|------|---------|
| L0 / L1 | `CLAUDE.md` (root / workspace) | "Which room handles this, and what loads when?" |
| L2 | `<room>/CONTEXT.md` | "What exactly does the agent do in this room?" |
| L3 | `06-resources/*`, a room's `references/` | stable knowledge: lexicon, paper, patterns, style guides |
| L4 | working files inside a room | this run's artifacts; one room's output is the next room's input |

**A room contract (`CONTEXT.md`)** carries, in spirit: *Identity · Inputs · Process ·
Outputs/Handoff · Conventions · Links* (≈ the paper's Input → Process → Output → Completion).
Section names flex; the roles do not.

**Load table** — when a room needs specific files, declare them `Resource | When | Why`
(exact paths, no globs). This is the lever that keeps context narrow.

## Hard rules

- **`CLAUDE.md` is canon.** Edit it deliberately; everything inherits from it.
- **Every `CLAUDE.md` has an `AGENTS.md` sibling** that only points back to it. No duplicated content.
- **Every folder has a `CONTEXT.md`.** A room with no contract is a bug.
- **Repairs never destroy data.** We migrate folders + markdown; we do not delete a project's content (see `04-utilities/playbooks/repair.md`).
- **One declared source of truth per structure.** Here, it is `01-index/`.

## Soft rules (conventions)

- Numbered zones (`01-`, `02-`, …) keep the flow visible and beat alphabetical chaos.
- kebab-case folders/files; leading zeros on zone numbers.
- Name rooms by the *kind of work* done inside — not by date or owner.
- Keep `CONTEXT.md` ≤ 80 lines, reference files ≤ 200; split when they outgrow it.
- Make handoffs explicit — "Promote → `02-…`", a `dropbox/`, a `[→02]` tag.

## Where the depth lives

- Canon depth → `06-resources/icm-paper-distillation.md`, `06-resources/icm-lexicon.md`
- Patterns proven in the field → `06-resources/icm-patterns.md`
- Instruments → `04-utilities/` — playbooks (`create` · `diagnose` · `repair` · `distribute`),
  rubrics (`health-checklist.md` behind diagnose, `scrub-rules.md` behind distribute), templates
- Start a project → `05-distributable/icm-starter/`
- Ship a structure to someone else → `04-utilities/playbooks/distribute.md`, scored by
  `04-utilities/scrub-rules.md` before it leaves
- Log a structure → `01-index/REGISTRY.md`

Where a playbook has a rubric, the rubric is the gate, not a formality: run the playbook, then
score the result against it.

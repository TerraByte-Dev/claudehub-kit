# ICM — Paper Distillation

> A faithful, cited summary of the methodology this repo implements, so the Doctor is
> **self-grounding offline**. Where a claim is directly supported by a primary source it is
> stated plainly; where it is a reasonable extension or a secondary-source framing, it is
> marked as such. **Cited by:** the root `CLAUDE.md` ("What ICM is").

## Citation

- **Title:** *Interpretable Context Methodology: Folder Structure as Agentic Architecture*
- **Authors:** Jake Van Clief, David McDermott
- **Venue:** arXiv preprint **2603.16021** — v1 submitted 17 Mar 2026, v2 18 Mar 2026
- **Reference implementation:** GitHub `RinDig/Interpreted-Context-Methdology` (typo in repo name is upstream)
- **Author community:** *Clief Notes* (Substack + Skool), where the methodology is taught

## Thesis

ICM **replaces framework-level orchestration with filesystem structure.** Instead of writing
heavy coordination code (LangChain, AutoGen, CrewAI, Semantic Kernel) to pass data and manage
memory between agents, ICM maps a sequential workflow directly onto **numbered folders** and
**plain markdown files**. A single agent walks the folders; each folder's markdown tells it
what role to play. The filesystem is the state machine; plain text is the universal interface.

The paper names this the **Model Workspace Protocol (MWP)**.

## Intellectual lineage (stated in the abstract)

Unix pipeline design · modular decomposition (information hiding) · multi-pass compilation ·
literate programming — applied to the problem of structuring context for AI agents.

## The router / layer model

Routing is layered so an agent loads shallow at the top and deep only where needed
(**progressive disclosure**):

| Layer | File | Question it answers |
|-------|------|---------------------|
| **L0** | root `CLAUDE.md` | "Which workspace/room handles this job?" |
| **L1** | workspace `CLAUDE.md` | "What files does this repo load, and when?" (the load table) |
| **L2** | `stages/NN-name/CONTEXT.md` | "What exactly does the agent do in this stage?" (the stage contract) |
| **L3** | `references/`, shared knowledge | stable material: style guides, conventions, lexicon *(reference layer; emphasized in secondary guides)* |
| **L4** | a stage's working files | per-run artifacts; stage N's output becomes stage N+1's input *(working layer)* |

> **Provenance note.** The community implementation guide describes the **L0–L2** router model
> explicitly. The **L3 reference / L4 working** layers are how secondary guides (and this
> workspace) extend that model; treat them as a faithful elaboration, not verbatim paper text.

## The stage contract (L2 `CONTEXT.md`)

Every stage folder carries a contract with four parts:

- **Input** — sources and what each provides
- **Process** — numbered, sequential steps
- **Output** — structured result for the next stage
- **Completion** — route to the next stage, or terminate

A stage contract holds **only** routing + task definition — *not* inline reference material,
*not* long code examples, *not* historical rationale (those go to L3 references).

## The load table (the core L1 lever)

A three-column declaration — **`Resource | When | Why`** — naming exact file paths (no globs),
which stage needs each, and a one-line justification. The guide calls this "what makes ICM
work": it is the mechanism that keeps each stage's context narrow.

## File-size discipline

| File type | Max lines | If exceeded |
|-----------|-----------|-------------|
| Stage `CONTEXT.md` | **80** | split into sub-stages |
| Reference file | **200** | split and route to sections selectively |

## Core design principles

Directly supported by the abstract / community guide:
1. **Narrow context wins** — "AI agents perform better when they receive narrow, relevant context."
2. **Progressive disclosure** — load shallow at L0, deeper at L1/L2 only as needed.
3. **Explicit exclusions** — every router declares a "What NOT to load" table.
4. **Self-contained stages** — a stage is understandable without reading the others.
5. **Human review/edit gates** — every intermediate output is a plain file a human can open and edit before the next stage runs.

Faithful extensions consistent with the lineage (Unix / modular / literate):
6. **One stage, one job** · 7. **Plain-text interface** · 8. **Configure the factory, not the product.**

## What we could NOT verify (kept out of the canon)

- A "**Prowl** (risk gate) / **Ironhide** (boundary gate)" vocabulary surfaced in one research
  pass appears in **no** primary source — **discarded.** ICM's soft/hard-rule idea stands on its
  own without it.
- No earlier formal "paper that blew up" was found pre-dating the Mar 2026 arXiv preprint; the
  preprint appears to be the primary publication (blog/community posts predate it).
- "In-Context Management" (a common informal expansion) is **not** the official name — the paper
  title says **Interpretable** Context Methodology.

## Sources

| URL | Credibility |
|-----|-------------|
| https://arxiv.org/abs/2603.16021 | **Primary** — the preprint |
| https://github.com/RinDig/Interpreted-Context-Methdology | **Primary** — reference implementation |
| https://gist.github.com/LvlyBot/91c386584c99e4f3c300013d5cebaf78 | Secondary — detailed community guide (L0–L2, load tables, file sizes) |
| https://jakevanclief.substack.com/ · https://www.skool.com/cliefnotes | Author's own platforms |
| https://www.mindstudio.ai/blog/agentic-context-management-folder-structure-markdown | Secondary — practitioner write-up |

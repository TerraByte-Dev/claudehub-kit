# Starter — CLAUDE.md  ·  Canon + Floor Plan

> **This is the ICM starter.** Copy this folder into a new project, then adapt three things:
> (1) rename the structure and its rooms into your domain's voice, (2) rewrite each `CONTEXT.md`,
> (3) declare your real **source of truth**. Then score it against the ICM health checklist — the
> rubric this starter was cut from; it does not ship inside the starter.
>
> This file is the **canon**; the `AGENTS.md` beside it only says "read this." ICM = Interpretable
> Context Methodology.

## What this is
A minimal three-room ICM structure: **ideate → build → ship.** A raw idea enters at `01`,
becomes real work at `02`, and leaves as a finished artifact at `03`. Replace this paragraph
with what *your* structure does.

## Floor plan / routing table
| Room | Enter when… | Holds |
|------|-------------|-------|
| `01-ideate/` | you have a raw idea/request to frame | sketches, scoped questions |
| `02-build/` | the idea is scoped and ready to make | work in progress |
| `03-ship/` | the work is done and leaving | finished artifacts — the source of truth for "what shipped" |

## Principles
- Narrow context wins · one stage, one job · plain-text interface · progressive disclosure.

## Hard rules
- **Source of truth:** `03-ship/` is authoritative for what shipped. (Pick the room that owns truth in your domain.)
- Every folder has a `CONTEXT.md`; every `CLAUDE.md` has an `AGENTS.md` pointer.

## Soft rules
- Numbered zones, kebab-case, explicit handoffs (Promote →), `CONTEXT.md` ≤ 80 lines / references ≤ 200.

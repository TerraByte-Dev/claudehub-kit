# 05 — Field guide  ·  CONTEXT

> **The person's own manual.** Plain-English answers to "how do I…", written as they learn them.

## Identity

The shelf the person (or an agent on their behalf) reaches for when they've seen something
before and want it again. It starts with one page, `COMMANDS.md`, and grows from real questions. It is
not a copy of the official documentation and shouldn't try to be.

## What lives here

| File | What it's for |
|------|---------------|
| `COMMANDS.md` | the commands and keys worth knowing, in the order a beginner needs them |
| `BUILDING.md` | how to build anything with Claude: brief, milestones, prove it, commit |
| `PROMPTS.md` | copy-paste prompts that work, by job (the Hub, work, research, side projects, building); add their own as they find them |

New pages are added when a question has come up twice, or when a lab experiment produced a
how-to worth keeping.

## Process

1. **Answering "how do I…":** look here first. If there's a page, use it, and check it's
   still true before repeating it.
2. **No page yet:** answer them directly. If it's the second time this has come up, write the
   page.
3. **Writing a page:** one topic per file, named for the question (`how-to-undo-a-mistake.md`).
   Lead with the answer. Steps they can follow without knowing any jargon. Under 60 lines.
4. **A page turned out wrong:** fix it on the spot. Claude Code changes; this guide has to
   keep up or it's a liability.

## Outputs / Handoff

- A short page they can follow alone next time.

## Conventions

- Written to the person, in the second person, in plain words. Not a beginner by default: lead with the answer, skip the definition when their `ABOUT-ME.md` says they know the term.
- Each page ends with a "last checked" date and the Claude Code version it was checked on.
- Link to the official docs for depth. Don't paste them in.
- Facts about their own setup don't go here; they go in `../01-harness/` and `../02-mcp/`.

## Links

- Where new how-tos come from → `../04-lab/CONTEXT.md`
- Floor plan → `../CLAUDE.md`

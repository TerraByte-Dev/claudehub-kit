# 05 — Distributable  ·  CONTEXT

> **The loading dock.** Entire structures, ready to be shipped into a project. Folders and
> markdown — the skeleton — not the data. Drop them in and adapt.

## Identity
The shipping shelf. What lives here is **ready to leave**: complete, health-passing ICM structures
and the starter kits new projects begin from. The transformation performed here is the **strip** —
take a private, health-passing structure and produce a shippable twin of it. What we ship is *our
folders and markdown* — the structure, not the contents. Scripts only when needed (niche).

## What lives here
```
icm-starter/   · the canonical minimal ICM structure — copy it, then adapt
```

**Two kinds of distributable.** `icm-starter/` is a *shape* — an empty grammar you pour a domain
into. The other kind is a *working system* — a structure that already knows its job, stripped of
one person's data so someone else can supply their own. The second kind is the harder and more
valuable one to ship: it carries the pipeline's judgement (what makes a good output, what never
goes on a form, why a claim must trace to evidence) while carrying none of the author's facts. It
also ships differently — as **its own archive**, a zip a recipient unpacks whole, rather than as
rooms poured into a project that already exists. This repo documents that shape but ships no
example of it; the examples travel as their own archives, cut from the structures they strip.

## Inputs
- A finished structure from `03-building` that passed the health checklist.
- A starter kit worth keeping as a reusable starting point.
- A private, in-service structure whose owner wants a public or client-safe twin of it.

## Process
1. **Gate on health.** Only a structure whose every MUST passes `../04-utilities/health-checklist.md`
   enters the dock. Score it before you cut, not after; half-built work stays in `03`.
2. **Cut a whole tree, not a diff.** Copy the structure — contracts and canon, no scratch, no run
   artifacts — into its own folder here, or clone the repo it already publishes to. From then on
   that folder *is* the shipped tree, and the only one.
3. **Withhold, don't redact.** Material naming real people, clients or engagements never ships
   censored — it is held back whole and **mined**: its transferable lessons are harvested into a
   reference file, and the shipped tree carries a seed in place of the original.
4. **Rewrite mechanically.** Case, path separators and the structure's own name change for the
   destination — each as a *named rule* applied tree-wide, so divergence stays measurable.
5. **Author only the substitution set.** The shipped tree gets its own front door — README, licence,
   seeded source of truth, its dock contract — and nothing else. Anything else you want to change
   there is a change to make **upstream first**, then re-cut.
6. **Re-score, then hand over.** Run the checklist against the shipped tree cold, as a stranger
   would. Handing it to its owner is where this room ends — publishing is their call, not ours.

Follow `../04-utilities/playbooks/distribute.md` rather than improvising — a strip you can repeat is
the only one you can trust the second time. `../04-utilities/scrub-rules.md` is the gate it runs.

## Outputs / Handoff
- A structure installed in its destination project, ready to fill with real work.
- Or a shipped tree parked on the dock — health-passing, archive cut, waiting on its owner to ship.
- Either way, **register it in `../01-index/REGISTRY.md`.**

## Conventions
- Every distributable carries its `CLAUDE.md` + `AGENTS.md` + a `CONTEXT.md` per room.
- Markdown-first. Scripts are the exception, not the rule.
- **Adapt, don't dictate.** A distributable is a *starting point*, not a mandate — the recipient
  renames rooms into their own project's voice (roles, not labels — see the lexicon).
- **Keep starters minimal.** A starter shows the shape; the project grows the flesh.
- Any archive this room cuts is a **build artifact and goes stale** — regenerate it after any edit
  to the folder it packages.

## Links
- The strip procedure → `../04-utilities/playbooks/distribute.md`  ·  its gate → `../04-utilities/scrub-rules.md`
- Where structures are built → `../03-building/CONTEXT.md`
- The roles to adapt names from → `../06-resources/icm-lexicon.md`
- Patterns proven in the field → `../06-resources/icm-patterns.md`
- Floor plan → `../CLAUDE.md`

# 03 — Building  ·  CONTEXT

> **Stage 2 of the build flow — the assembly bench.** Where a blueprint becomes a real structure:
> folders created, contracts written, canon filled. Work in progress lives here until it's healthy.

## Identity
The workbench. You come here with a blueprint from `02` and leave with an actual ICM structure —
its rooms scaffolded, its `CLAUDE.md` + `AGENTS.md` written, every `CONTEXT.md` filled. Nothing
here is finished; finished structures graduate to `05-distributable` or ship to their destination.

## Inputs
- A blueprint from `02-planning` (rooms, flow, source of truth).
- The instruments in `04-utilities` — `playbooks/create.md`, the templates, the scaffold script.

## Process
1. **Scaffold.** Copy `05-distributable/icm-starter/`, or run `04-utilities/scripts/New-IcmStructure.ps1`.
2. **Fill the contracts.** Write each room's `CONTEXT.md` from the template — Identity → Links, ≤ 80 lines.
3. **Write the canon.** Fill the root `CLAUDE.md` (what it is, principles, rules, routing table) and add the `AGENTS.md` pointer.
4. **Score it.** Run `04-utilities/health-checklist.md`. Not done until every MUST passes.

## Outputs / Handoff
- A health-passing ICM structure.
- **Promote → `../05-distributable/`** (to ship/copy) and **register in `../01-index/REGISTRY.md`.**

## Conventions
- One folder per structure under construction. Keep half-built structures out of `05`.
- Follow `04-utilities/playbooks/create.md` rather than improvising — consistency is the product.

## Links
- The build playbook → `../04-utilities/playbooks/create.md`
- Ship room → `../05-distributable/CONTEXT.md`  ·  Registry → `../01-index/CONTEXT.md`
- Floor plan → `../CLAUDE.md`

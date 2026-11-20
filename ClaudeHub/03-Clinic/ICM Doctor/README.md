<!-- Hero: amber CRT "ICM·DOC" wordmark — see docs/assets/README.md to swap it for a PNG. -->
<p align="center">
  <img src="docs/assets/icm-doc-wordmark.svg" alt="ICM·DOC — Interpretable Context Methodology" width="720" />
</p>

<p align="center">
  <strong>A clinic for the folders your AI agent lives in.</strong><br/>
  Diagnose a messy project, repair it without deleting anything, or build a new one from scratch — all in plain markdown.
</p>

<p align="center">
  <a href="LICENSE"><img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-FFB000.svg"></a>
  <img alt="Markdown only — no install, no dependencies" src="https://img.shields.io/badge/markdown%20only-no%20dependencies-FFB000">
  <img alt="Works with Claude Code, Codex, Cursor, opencode" src="https://img.shields.io/badge/agent-Claude%20Code%20%C2%B7%20Codex%20%C2%B7%20Cursor-FFB000">
  <a href="https://arxiv.org/abs/2603.16021"><img alt="Method: arXiv 2603.16021" src="https://img.shields.io/badge/method-arXiv%202603.16021-FFB000"></a>
</p>

<p align="center">
  <a href="#start-here">Start here</a> ·
  <a href="#the-four-jobs">The four jobs</a> ·
  <a href="#whats-in-the-box">What's in the box</a> ·
  <a href="#what-icm-actually-is">What ICM is</a> ·
  <a href="#make-it-yours">Make it yours</a> ·
  <a href="LICENSE">License</a>
</p>

<p align="center">
  <sub>brought to you by</sub><br/>
  <a href="https://github.com/TerraByte-Dev"><img src="docs/assets/terrabyte-logo.png" alt="TerraByte Solutions LLC" width="84" /></a>
</p>

---

Your agent forgets everything overnight. The folder doesn't.

**ICM** — *Interpretable Context Methodology* — is the idea that you can replace orchestration
frameworks with **filesystem structure**: numbered folders are stages, and a short markdown file
on each door tells the agent what job to do there. No LangChain, no graph config, no runtime. The
filesystem is the state machine and **formatted English is the program.**

**ICM Doc is the clinic for that.** It's a folder you point an AI coding agent at. It knows how to
walk somebody's messy project and tell you exactly where it's broken, how to fix it without
deleting a byte, and how to stand up a clean one from nothing. There is nothing to install —
it's markdown all the way down, and copying the folder *is* the install.

## Start here

1. **Download this repo** — green **Use this template** button, or `git clone`, or just grab the ZIP.
2. **Open the folder in your agent** — Claude Code, Codex CLI, Cursor, opencode, anything that
   reads `CLAUDE.md` or `AGENTS.md`. Both files are here; they point at the same canon.
3. **Say what you want.** The agent reads [`CLAUDE.md`](./CLAUDE.md), finds the routing table, and
   walks itself to the right room. You don't have to know the structure — that's the whole point.

Four prompts that do the four jobs:

```
Diagnose the folder at <path> against ICM. Follow 04-utilities/playbooks/diagnose.md.
```
```
Repair <path> from the diagnosis. Follow 04-utilities/playbooks/repair.md — non-destructive.
```
```
Build me an ICM structure for <what you're making>. Follow 04-utilities/playbooks/create.md.
```
```
Cut <path> into a public copy for <who gets it>. Follow 04-utilities/playbooks/distribute.md.
```

That's it. No configuration step, no first-run wizard, nothing to authenticate.

## The four jobs

| Job | Playbook | What comes out |
|-----|----------|----------------|
| **Diagnose** | [`playbooks/diagnose.md`](04-utilities/playbooks/diagnose.md) | A written diagnosis: the mapped tree, a role-normalization table, the scored checklist, and a triage verdict — **Healthy** / **Needs care** / **Critical** — with a prioritized fix list. Read-only. It looks; it doesn't touch. |
| **Repair** | [`playbooks/repair.md`](04-utilities/playbooks/repair.md) | The structure fixed in place, plus a `repair-log` of what moved where. **Hard rule: repairs never destroy data.** Superseded material moves to `_archive/`; it is never removed. Done when every MUST passes. |
| **Create** | [`playbooks/create.md`](04-utilities/playbooks/create.md) | A brand-new structure — rooms, contracts, canon, source of truth declared up front — plus a `HANDOFF.md` so your next session starts warm instead of cold. |
| **Distribute** | [`playbooks/distribute.md`](04-utilities/playbooks/distribute.md) | A shipped tree carrying the structure's judgement and none of its private facts — every path classified ship / withhold / substitute / harvest, then scored against [`scrub-rules.md`](04-utilities/scrub-rules.md) before it leaves. |

Two rubrics score everything. [`04-utilities/health-checklist.md`](04-utilities/health-checklist.md)
scores a **structure**; [`04-utilities/scrub-rules.md`](04-utilities/scrub-rules.md) scores a
**copy** before it leaves.
**MUST** items are defects. **SHOULD** items are smells. The rubric's sharpest item is the last
one — the **cold-start test**: *a fresh agent dropped at the root with no extra context can read
`CLAUDE.md` and know where to go.* Most broken project folders fail exactly there.

## What's in the box

```
├── CLAUDE.md ┐            the canon. Your agent reads this every session.
├── AGENTS.md ┘            pointer twin, for tools that look for this name instead.
│
├── 01-index/              the registry — the declared source of truth for what exists
│   └── REGISTRY.md          one row per structure: what it is, what it teaches, how healthy
├── 02-planning/           design a structure before building it; diagnoses land here
├── 03-building/           work in progress — ships empty, and should: it is yours to fill
├── 04-utilities/          ← the instruments. Almost everything you want is in here.
│   ├── health-checklist.md  the rubric. MUST / SHOULD, and a triage verdict.
│   ├── scrub-rules.md       the shipping rubric. A copy is scored before it leaves.
│   ├── playbooks/           diagnose · repair · create · distribute
│   ├── templates/           CONTEXT · CLAUDE · AGENTS · HANDOFF, with {{placeholders}}
│   └── scripts/             New-IcmStructure.ps1 — optional Windows scaffolder
├── 05-distributable/      ready-to-adapt starters — and the dock a public copy leaves from
│   └── icm-starter/         the canonical minimal structure: ideate → build → ship
└── 06-resources/          the reference library
    ├── icm-lexicon.md       ← role → alias map. The most important file here.
    ├── icm-patterns.md      ← moves that survived contact with real projects
    └── icm-paper-distillation.md   a cited summary of the method, so this works offline
```

Every folder has a `CONTEXT.md` saying what it's for, what comes in, what goes out, and where it
goes next. That file *is* the interface — it's what a room means.

### Two files worth reading even if you never use the rest

**[`06-resources/icm-lexicon.md`](06-resources/icm-lexicon.md)** — the alias map. ICM is
semi-formal on purpose: the same *role* wears different *names* in every project. A folder called
`Storage/` is an Output zone. `Plotting-and-Scheming/` is Ideation. `CONTRACT.md` is a Rules file.
The lexicon maps observed names back to canonical roles, which is what lets the Doctor diagnose a
project written in a vocabulary it has never seen. **Match the role, never the label.**

**[`06-resources/icm-patterns.md`](06-resources/icm-patterns.md)** — thirty-odd real structures
distilled down to the moves that kept working. Not folder names — inventions. Things like:

- **Source-of-truth inversion** — when your tree wraps an artifact it doesn't contain (a live 3D
  scene, a game save, a database), declare which side wins a tie *and* write the recovery
  instruction next to it: *the artifact wins; go look, then fix the card.*
- **The honest default** — every roster row starts at `unsurveyed`, so "nobody has checked yet" is
  a visible state instead of a silent implied "fine." Cleared once, by a human, on a dated line.
- **A gate is not a stage** — a precondition modeled as a numbered room gets marked done and
  skipped forever. Model it as a gate and the session *refuses to start* until it holds.
- **Probe-or-nothing** — an unverified claim is inadmissible without the falsifiable check that
  would settle it. No probe? Write "unknown."

Each one is written as **problem → move → tell**, so you can find the one that matches the failure
you're actually having.

## What ICM actually is

ICM is **not ours.** It's the work of **Jake Van Clief & David McDermott**, published as
*"Interpretable Context Methodology: Folder Structure as Agentic Architecture"* —
[arXiv 2603.16021](https://arxiv.org/abs/2603.16021), March 2026 — which introduces the **Model
Workspace Protocol (MWP)**. Their reference implementation is
[RinDig/Interpreted-Context-Methdology](https://github.com/RinDig/Interpreted-Context-Methdology)
*(the typo is upstream)*, and the method is taught at
[Clief Notes](https://jakevanclief.substack.com/).

**This repo is an independent toolkit built on top of it** — a clinic for creating, auditing and
repairing structures written in that style. If you want the theory, read the paper. If you want a
faithful, cited summary that lets your agent work offline, read
[`06-resources/icm-paper-distillation.md`](06-resources/icm-paper-distillation.md), which is
explicit about what's paper-supported, what's a community extension, and
[what we could not verify and therefore left out](06-resources/icm-paper-distillation.md#what-we-could-not-verify-kept-out-of-the-canon).

The principles it runs on, in one breath: **narrow context wins · one stage, one job · plain-text
interface · progressive disclosure · explicit exclusions · human edit gates · self-contained
stages · configure the factory, not the product.**

## Make it yours

This is a methodology, not a schema. It's *supposed* to stop looking like this.

- **Rename everything.** Rooms should be named in your project's own voice — by the kind of work
  done inside, not by date or owner. The lexicon maps roles; it doesn't mandate labels.
- **Don't colonize.** When repairing someone else's project, normalize toward *one coherent
  vocabulary within that project*. Don't force another project's words onto it.
- **Delete rooms you don't need.** The minimal honest ICM structure is three folders and a
  `CLAUDE.md`. That's [`05-distributable/icm-starter/`](05-distributable/icm-starter/) — start
  there if this repo feels like a lot.
- **Grow the lexicon on contact.** Hit a folder name that maps to no role? Add it. That file gets
  better every time someone uses it on a project it's never seen.

The two things worth keeping intact: **one declared source of truth**, and **every folder has a
`CONTEXT.md`**. Everything else is negotiable.

## License

[MIT](LICENSE) © TerraByte Solutions LLC. The ICM methodology itself is the work of Jake Van Clief
& David McDermott — see [above](#what-icm-actually-is).

<p align="center">
  <a href="https://github.com/TerraByte-Dev"><img src="docs/assets/terrabyte-logo.png" alt="TerraByte Solutions LLC" width="64" /></a><br/>
  <sub>An open-source project by <strong>TerraByte Solutions LLC</strong></sub>
</p>

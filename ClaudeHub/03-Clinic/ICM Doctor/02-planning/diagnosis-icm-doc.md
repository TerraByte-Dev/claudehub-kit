# Diagnosis — ICM Doc (this repo)

> **Target:** this repository, read by its own instruments. **Date:** 2026-09-05. Run per
> `../04-utilities/playbooks/diagnose.md`, scored against `../04-utilities/health-checklist.md`,
> roles normalized via `../06-resources/icm-lexicon.md`.
>
> **This audit is read-only. Nothing was changed.** `diagnose.md` looks; it does not touch — every
> defect below is still in the tree, and repair is `../04-utilities/playbooks/repair.md`'s job.
> Every claim is a file you can open or a command you can run. No line numbers are cited: this file
> ships inside the tree it describes, so defects are quoted instead.

## 1. The mapped tree

**34 files (29 of them markdown) before this one**, in 15 folders, depth 3 at most.

```
CLAUDE.md · AGENTS.md · README.md · LICENSE · .gitattributes
01-index/          CONTEXT.md · REGISTRY.md              ← declared source of truth
02-planning/       CONTEXT.md · diagnosis-icm-doc.md     ← this file
03-building/       CONTEXT.md only                       ← empty on purpose; ruled on in §5
04-utilities/      CONTEXT.md · health-checklist.md · scrub-rules.md
                   playbooks/ create·diagnose·distribute·repair   scripts/ New-IcmStructure.ps1
                   templates/ CONTEXT · CLAUDE · AGENTS · HANDOFF
05-distributable/  CONTEXT.md · icm-starter/ (CLAUDE.md · AGENTS.md · 01-ideate · 02-build · 03-ship)
06-resources/      CONTEXT.md · icm-lexicon.md · icm-patterns.md · icm-paper-distillation.md
docs/assets/       README.md · wordmark.svg · logo.png   ← declared "not a room"
```

**Flow.** `02-planning/` → `03-building/` → `05-distributable/`, recorded in `01-index/`; `04-` and
`06-` are cross-cutting. Handoffs are named in every contract.

## 2. Role normalization

| Folder | Canonical role (lexicon) | Note |
|--------|--------------------------|------|
| `01-index/` | **Index / Registry** | listed alias `01-index`; the declared source of truth |
| `02-planning/` | **Ideation** | listed alias `Planning` |
| `03-building/` | **Build** | listed alias `Building` |
| `04-utilities/` | **Utilities** | listed alias `Utilities`; cross-cutting, not a stage |
| `05-distributable/` | **Output / Ship** | listed alias `Distributable` |
| `06-resources/` | **Reference** (Shelf) | listed alias `Resources` |
| `icm-starter/` | payload, not a room | own canon; `CLAUDE.md` is its contract |
| `docs/assets/`, `playbooks/`, `templates/`, `scripts/` | — | not rooms: artwork, and a room's contents |

Every numbered folder maps to a listed alias. **No unmapped names, no novel aliases, no gaps.**

## 3. Scored checklist — MUST fails first

### MUST — FAIL

- **§2 `CLAUDE.md` is internally consistent. FAIL, on two counts.**
  1. The canon claims **"It is itself a healthy ICM structure — it passes its own health
     checklist"**, while `../01-index/REGISTRY.md` — the artifact the same file declares
     authoritative — records this repo as **"Needs care"**. Both ship; they cannot both be true;
     the canon's own tiebreak ("if two rooms disagree, this one wins") resolves against the canon.
  2. The hard rule **"Every folder has a `CONTEXT.md`."** is broken by the canon's own exclusions
     section, which names **"`docs/` carries the README's artwork. Not a room"**. Five folders carry
     no contract: `docs/`, `docs/assets/`, and `04-utilities/`'s `playbooks/`, `templates/`,
     `scripts/`. The rule says *folder*, the next sentence says *room*, and `README.md` repeats the
     folder-scoped claim: **"Every folder has a `CONTEXT.md`"**.

### MUST — PASS

- **§1 Every room has a contract.** Six numbered rooms and three starter rooms carry `CONTEXT.md`;
  `icm-starter/` carries `CLAUDE.md` per the payload clause. Scored on the *room* reading.
- **§1 Floor plan at root.** `../CLAUDE.md` exists and carries the routing table.
- **§2 Every `CLAUDE.md` has an `AGENTS.md` sibling. 2 of 2** — root and `icm-starter/`, both
  pointer-only, neither duplicating canon.
- **§4 Exactly one source of truth.** `01-index/` is declared in the canon's hard rules, the routing
  table, `../01-index/CONTEXT.md`, and `REGISTRY.md` itself; the starter's `03-ship/` declaration
  governs the starter, a payload. No second claimant.
- **§7 Cold start.** Passes, with hesitations — see §5.

### SHOULD — FAIL

- **§6 Load tables. FAIL.** No room declares a `Resource | When | Why` table. The format appears in
  the canon's grammar section, the lexicon, the distillation, the checklist and
  `../04-utilities/templates/CLAUDE.template.md` — never in a live contract. What the canon calls
  "the lever that keeps context narrow" is defined and never used.
- **§3 Contracts self-contained. FAIL, once.** `icm-starter/CLAUDE.md` instructs **"Then run
  `04-utilities/health-checklist.md`."** The starter carries no `04-utilities/`, and a recipient
  copying it into their project never will. Also a dangling link, made a MUST by `scrub-rules.md` §5.
- **§6 Each router declares what *not* to load. PARTIAL FAIL.** The root canon has a strong
  `What *not* to load` section naming four exclusions; `icm-starter/CLAUDE.md` is a router too and
  declares none.

### SHOULD — PASS

- **§1 Zones numbered / kebab-case.** `01`–`06`, leading zeros, named by kind of work.
- **§2 Routing table resolves, no orphans, no dangling routes. 6 of 6** entries are real folders;
  the only unrouted folder is `docs/`, which the canon names explicitly as not a room.
- **§3 Contracts state their role.** All nine carry Identity · Inputs · Process · Outputs/Handoff ·
  Conventions · Links, in that spirit.
- **§3 Links sections resolve. 30 of 30 targets checked across 9 contracts** — every one a
  `../`-relative path that exists. (Paths inside `templates/*.template.md` do not resolve here;
  they are `{{placeholder}}` scaffolds written from a future room's position.)
- **§4 Drift logged in the owning room.** The registry row carries the verdict and links here.
- **§5 Handoffs explicit, and shaped as the next room's input.** Every Outputs section names its
  successor by path; `diagnose.md` emits the file `02-planning/CONTEXT.md` lists as an input.
- **§6 Line ceilings — nothing is over.** Largest contract 70 lines (limit 80); largest reference
  188 (`06-resources/icm-patterns.md`, limit 200 — close enough to watch).
- **§7 L3 separated from L4.** References in `06-resources/`, this run's artifact in `02-planning/`,
  which the canon quarantines: **"leave it shut otherwise"**.

## 4. The gate commands in `../04-utilities/scrub-rules.md`

All five were run against this tree today. **Two are broken as written.**

| § | Command | Result |
|---|---------|--------|
| §1 reverse diff | `diff <(cd <src> && git ls-files …)` | **BROKEN** — `git ls-files` fails in the source tree |
| §1 file-type allowlist | `git ls-files \| grep -vE …` | **RUNS**, returns zero lines. PASS |
| §2 identity sweep | `grep -rniE '…\|Desktop' <dock>` | **RUNS**, but can never be empty |
| §3 harvest + hunt | `grep -rhoE … > names.txt` then `grep -rnwFf` | **RUNS** (needs the withheld set, which the public tree by definition does not carry) |
| §4 git history | `git log --all --diff-filter=A --name-only` | **RUNS**; 3 commits, 32 added paths, nothing withheld |

**§1's reverse diff cannot execute.** It opens `cd <src> && git ls-files`, but the private source
tree is not a git repository — the command emits `fatal: not a git repository` and an empty left
side, so the diff reports all 32 shipped paths as new. A gate whose failure mode is "everything
looks like a leak" gets waved through. **And its second MUST checks for a string that command
cannot emit:** it requires **"Only in `<dock>`:" must never appear**, but that is `diff -rq` output,
while the bullet above says **"a raw `diff -rq` cannot be used here"**. The prescribed two-file
`diff` emits `0a1,32` and `>` markers instead, so the assertion never fires.

**§2's sweep is self-defeating.** Its alternation ends in the literal `Desktop` and the rubric ships
inside the tree it sweeps, so it matches its own text every run. Four hits today: the rubric quoting
itself, two publisher badges in `README.md`, a `$HOME/Desktop` example in the scaffolder. The MUST
reads "is empty." It cannot be — and §2's own second bullet names this class without exempting it.

**Line endings, and working-copy drift.** `.gitattributes` declares `* text=auto eol=lf`, commented
**"One line-ending policy, so a cut from a Windows source does not ship a mixed tree."** All 32
blobs at `HEAD` carry CR; the three files waiting to join them are LF, so the mixed tree it prevents
arrives on the next commit. Those three are untracked (`ls-files` sees 32; 34 on disk), two being
`scrub-rules.md` and `distribute.md` — §1's `ls-files` MUSTs cannot see the newest instruments.

## 5. §6 rooms that teach, and the cold start

**`03-building/` holds only its own `CONTEXT.md`.** `scrub-rules.md` §6 permits that only if
"the canon states, in a line, why it is empty on purpose." The canon does, and the line is good:

> `03-building/` ships holding only its contract. A work-in-progress room is empty by definition
> until you start building in it — an empty room here is the design, not a broken download.

**Ruling: it earns the pass**, cleanly — it names the room, gives the reason, pre-empts the
misreading. The three starter rooms are also contract-only; `05-distributable/CONTEXT.md` covers
them ("**Keep starters minimal. A starter shows the shape**") but that line lives in the dock's
contract, not the starter's own canon — so a recipient who copies `icm-starter/` out sees three
empty rooms, unexplained. Pass on the letter, smell on the spirit.

**Cold start — reading only `../CLAUDE.md`.** Routing works; two real hesitations:

1. **"Do I edit here, or upstream?"** The canon says the repo "is itself a distributed copy, cut by
   its own distribute playbook," but never draws the consequence: *therefore do not author in it.*
   That rule sits two files away, in `05-distributable/CONTEXT.md` and step 5 of `distribute.md`.
   An agent told to fix any defect above will fix it here — producing exactly the
   downstream-authored file `scrub-rules.md` §1 forbids. The sharpest gap in the tree: the failure
   looks like helpfulness.
2. **"Which room ships a copy?"** Two rows plausibly match — `05-distributable/` ("a ready-to-adapt
   starter to drop into a project") and `04-utilities/` ("create, diagnose, repair, distribute").
   The instrument is in `04`; the row that sounds like shipping is `05`.

## 6. Verdict — Critical

One MUST fails (§2, internal consistency), on two independent counts. Per
`../04-utilities/health-checklist.md`: *"Critical — any MUST fails."*

A harsh label for what this is. The structure is sound — flow, handoffs, source of truth, line
discipline, role coverage and every Links section are clean, and both failures are single-sentence
wording defects, not rot. But the rubric is binary on purpose, and the failing sentence is the one
telling readers this repo is healthy.

**The seed registry's health claim does not match this audit.** `../01-index/REGISTRY.md` records
**Needs care**; this run says **Critical**. Update the row, or the source of truth carries a third
version of the same disputed fact.

## 7. Fix list — prioritized (each belongs **upstream, then re-cut** — fixing it here is §5's trap)

1. **MUST** — Delete or qualify **"It is itself a healthy ICM structure — it passes its own health
   checklist"**; let `01-index/REGISTRY.md` be the only place a health verdict is written.
2. **MUST** — Reword **"Every folder has a `CONTEXT.md`."** to say *room*, naming `docs/` and a
   room's own subfolders as non-rooms. Same fix in `README.md`.
3. **MUST** — `scrub-rules.md` §1: make the reverse diff run when the source is not a git repo (a
   `find` fallback), or state that the source must be one.
4. **MUST** — `scrub-rules.md` §1: replace **"Only in `<dock>`:" must never appear** with the marker
   the prescribed `diff` actually emits — a `>` line — so the assertion can fire.
5. **MUST** — `scrub-rules.md` §2: exempt the rubric from its own sweep, or move the pattern out of
   the shipped file. As written, "is empty" is unsatisfiable.
6. **MUST** — `icm-starter/CLAUDE.md`: **"Then run `04-utilities/health-checklist.md`."** points at
   a file the starter does not carry. Ship the checklist inside it, or cite it by name, not path.
7. **SHOULD** — One line in the canon's *What not to load*: this repo is a shipped copy, changes are
   made upstream and re-cut, never authored here. Closes the sharpest cold-start gap.
8. **SHOULD** — Renormalize line endings; commit the untracked instruments so the gates see them.
9. **SHOULD** — Give `02-planning/`, `03-building/` and `05-distributable/` a real
   `Resource | When | Why` load table. The canon calls it the narrowing lever; no room pulls it.
10. **SHOULD** — Give `icm-starter/CLAUDE.md` a *What not to load* line and a sentence on why its
    three rooms ship empty, so the starter is self-contained once copied out.

Handoff → `../04-utilities/playbooks/repair.md`.

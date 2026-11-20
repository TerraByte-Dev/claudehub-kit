# ICM Patterns — moves that survived contact

> Thirty-odd real ICM structures, built and repaired, produced a handful of moves that kept
> working — the *inventions*, not the folder names. The [lexicon](./icm-lexicon.md) tells you
> what to call a room; this tells you what to make it do.
>
> **Cited by** the design room and `create.md`. **Harvested** from a registry's *pattern* column:
> a row is the **record** (what happened, in context), this is the **distillate** (what transfers),
> and the record wins ties. **Steal the move, not the wording** — each was named in its own voice.

## How to read this

Each pattern is **the problem → the move → the tell** (when to reach for it). None of them are
mandatory. They exist because a structure without them failed in a specific, repeatable way.

## 1 · Truth and ties

**Source-of-truth inversion.**
*Problem:* your ICM tree wraps an artifact it does not contain — a live 3D scene, a game world
save, a script pasted into someone else's editor, a database. Markdown drifts from it silently.
*Move:* declare **which side wins a tie**, in the canon, in one sentence — and write the recovery
instruction next to it: *"the artifact wins; go look, then fix the card."* Sometimes the tree wins
(it authored the thing), sometimes the artifact does (a closed tool authored it). Split by
authorship if both are true: the tree owns what your agent writes, the artifact owns what a GUI writes.
*Tell:* you catch yourself writing "should be" about something you could go and check.

**The roster is the source of truth; status is a row.**
*Problem:* per-item `STATUS.md` files rot independently and disagree with each other.
*Move:* one table, one row per thing, status is a **column**. Nothing outside the table gets to
assert state.
*Tell:* you had to open three files to answer "where does this stand?"

**Pointer, never copy.**
*Problem:* a fact restated in two files becomes two facts, and the stale one is the one someone reads.
*Move:* the second occurrence is a **link**, always. Brand voice, model IDs, install paths — one
owner file, everyone else points.
*Tell:* you're about to paste a paragraph you've already written somewhere in this repo.

**Name your inputs, or distribution does it for you.**
*Problem:* a structure that only ever serves its author never has to declare what it consumes.
*Move:* **strip a copy for a stranger.** Every defect it surfaces is an unnamed input — two sources
of truth where the canon declared one, a hand-kept registration list, one identity across 200 files.
*Tell:* changing one fact about yourself is a sweep, not an edit.

## 2 · Honest state

**The honest default.**
*Problem:* a fresh roster row implicitly claims "fine" when the truth is "nobody has looked."
*Move:* seed every row at a status that **means ignorance** — `unsurveyed`, `absent`, `unknown`.
Make the empty state visible rather than optimistic. It is cleared exactly once, by a human, on a
dated line — **never inferred** by an agent from a folder appearing on disk. Where rows carry
claims, tag provenance too (first-hand vs relayed) and let no price or date rest on an assumed row.
*Tell:* your index looks complete and you have not personally verified a single row.

**Session Zero.**
*Problem:* work starts on top of assumptions nobody checked, and every later decision inherits them.
*Move:* a **survey pass that gates all other work.** Until it has run, the only legal action is
surveying. Its output is: every honest-default row replaced with an observed one.
*Tell:* the first real task keeps needing facts the structure doesn't have yet.

**A status ceiling.**
*Problem:* work that is genuinely finished up to a blocked step reads as a failure, so people
either lie about it or abandon it.
*Move:* name the **terminal honest state** and say which room raises the ceiling. Fully designed
and written but never compiled/published/shipped is a *complete* state with a name — not
`in progress` forever.
*Tell:* your status vocabulary has no word for "excellent, and stuck for a reason outside this repo."

**The `⚠ unverified` tag.**
*Problem:* recalled facts and checked facts read identically in markdown, and models recall
confidently wrong.
*Move:* a **mandatory** inline tag separating confirmed from remembered. Untagged means verified;
that is the whole contract.
*Tell:* a reference file you wrote from memory is now being cited as ground truth.

## 3 · Gates, not stages

**A gate is not a stage.**
*Problem:* a precondition modeled as a numbered room gets "completed" and skipped forever after.
*Move:* give it a room, but declare it a **gate** in the canon: the session **refuses to start**
until its condition holds. A backup dated today. A toolchain present. A signed-off scope. And a gate
that lives only in a derived view is not a gate — put its blockers in a file the canon lets win.
*Tell:* the disaster you're structuring around was caused by skipping one step, one time.

**Read-only before operate.**
*Problem:* bulk operations on someone's real data are one bad glob away from unrecoverable.
*Move:* split the flow: **Intake → Scan (read-only, produces a plan) → Operate (back up → edit →
log).** The scan room is contractually forbidden from writing.
*Tell:* a single run of your tool touches more files than a human would review.

**Reversible by construction.**
*Problem:* "clean up" is indistinguishable from "destroy" after the fact.
*Move:* deletes go to the Recycle Bin / trash with a **per-batch manifest**; scripts **dry-run by
default** and require a flag to act; superseded material moves to `_archive/`, never away.
*Tell:* your playbook contains the word "remove" without the word "manifest."

**The human edit gate.**
*Problem:* stage N+1 consumes stage N's output before anyone reads it.
*Move:* every intermediate output is a **plain file a human can open and fix** before the next
stage runs. This is the paper's rule and it's the one people quietly drop first.
*Tell:* your pipeline runs end to end without stopping.

## 4 · Shape

**Store vs workspace.**
*Problem:* the numbered rooms fill with finished work and stop being usable as benches.
*Move:* one room **stores** (the library — everything lands here, forever); the numbered rooms are
**scratch benches** that empty out. Storage is not a stage.
*Tell:* your `02-build/` has forty folders in it and you're afraid to delete any.

**Cards, promoted to folders on demand.**
*Problem:* forty items get forty folders, thirty-five of which hold one file.
*Move:* an item is a **row** until it earns a room. Promotion is a decision, not a default.
Progressive disclosure applied to inventory.
*Tell:* your tree is deep and every leaf is thin.

**Stage-first, not destination-first.**
*Problem:* rooms named after outputs (per platform, per client, per format) duplicate the same
workflow N times and drift apart.
*Move:* number by the **kind of work**; the destination is a field on the item, not a folder.
*Tell:* two of your rooms have near-identical `CONTEXT.md` files.

**The dropbox handoff.**
*Problem:* "then it goes to the next room" is not a mechanism, and things quietly don't.
*Move:* make the handoff a **place** — a `dropbox/` folder, a `Promote →` line, a `[→03]` tag.
The receiving room's Inputs section names it.
*Tell:* you can't answer "what is waiting to move?" by looking.

**Self-exclusion.**
*Problem:* a tool that manages a folder tree, living *inside* that tree, eventually operates on
itself.
*Move:* the canon declares the structure **out of its own scope**, by path, as a hard rule.
*Tell:* your scanner's first result is your scanner.

**The over-the-shoulder rule.**
*Problem:* a workspace about a relationship fills with material written for only one side of it.
*Move:* one sentence in the canon — **every file here must be one you would be happy for its subject
to read, today, unedited.** The pitch page and the dossier leave without argument — they move to
wherever they legitimately belong, which is why the rule meets no resistance.
*Tell:* you would close a tab if the person it describes walked in.

## 5 · Grounding (when the domain lies to your model)

**Ranked authorities, and your shelf is not one.**
*Problem:* in a proprietary or fast-moving domain, models produce fluent, wrong specifics — and
your own reference shelf becomes a laundering machine for them.
*Move:* rank the authorities explicitly in the canon (shipped source > official docs > community
tooling > your shelf) and state the demotion out loud: **"this shelf is a cache, not an authority
— if it disagrees with source, the shelf is wrong."**
*Tell:* your reference file is the most-cited document in the repo and nothing cites *it*.

**Probe-or-nothing.**
*Problem:* `⚠ unverified` becomes a permanent shrug, and unverified claims accumulate.
*Move:* an unverified claim is **inadmissible without a falsifiable probe** — the exact check that
would settle it. No probe, write "unknown." Keep a probe queue that **indexes** claims by location
rather than restating them, so claim text can't drift from probe status.
*Tell:* you have more `⚠ unverified` tags this month than last.

**Multiple independent on-ramps.**
*Problem:* one hello-world proves one pipeline; the next failure could be any of four and you
can't localise it.
*Move:* if the domain has N independent pipelines, ship **N smallest-possible wins**, not one
tour. Each rung proves exactly one thing.
*Tell:* "it works" and "it doesn't" are the only two states you can distinguish.

**Verification protects the prose, not the checkboxes.**
*Problem:* a research pass corrects the shelf; the task queue keeps the refuted instruction.
*Move:* re-derive the **action-shaped** artifacts — queues, checklists, commands — from the verified
shelf as an explicit step; when a decision changes, grep for the old *instruction*, not the topic.
*Tell:* your prose is current and your unticked boxes are three weeks old.

## 6 · The one that isn't a folder

**Write the handoff before the session ends.**
A conversation does not survive its session. The *conclusions* land in room files; the
**reasoning, the rejected paths, and the trust calibration evaporate** — and the next agent
relitigates settled decisions, re-hits traps, and helpfully adds the things you deliberately left
out. Four sections earn their keep: **how much to trust what's written**, **decisions already
made**, **deliberately not built**, and **traps that already cost time**.

→ `../04-utilities/templates/HANDOFF.template.md`

## How to add a pattern

A move earns a row here when it has **failed without it, twice.** Write it as problem → move → tell,
in under twelve lines, with no project names or paths. If it only makes sense inside one domain, it
belongs in that project's own reference shelf, not here. Keep this file under 200 lines: split before
you sprawl, because a shelf nobody finishes reading is a shelf that stops getting used.

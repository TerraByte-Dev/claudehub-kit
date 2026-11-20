# Repair log — ICM Doc

> **Companion to [`diagnosis-icm-doc.md`](./diagnosis-icm-doc.md), which is dated and read-only.**
> A diagnosis is a snapshot; this is what happened next. Read them as a pair: the audit says what
> was true at the moment it ran, this says what was done about it. Where they disagree, this file
> is later.
>
> **Date:** 2026-09-05 · Per `../04-utilities/playbooks/repair.md`. Every fix was made **upstream,
> in the source this repo was cut from, and the copy re-cut** — never authored here. That is the
> subtraction rule the audit's own §5 exists to protect, and applying its fixes was the first real
> test of it.

## Applied

| # | Fix | What changed |
|---|-----|--------------|
| 1 | **MUST** — the canon graded itself | The boast is gone. The canon now says the repo *"is scored by its own rubric like anything else"* and points at `01-index/REGISTRY.md` for the verdict, which is where the one-source-of-truth rule already said it belonged. The seed registry carries the grade and cites the diagnosis as its evidence. |
| 3 | **MUST** — reverse diff assumed a git source | Both sides now list with `find`, not `git ls-files`. Two reasons, and the second is the one that bites: a source tree is often not a git repo at all, and **`ls-files` silently omits untracked files** — which is precisely the newest instrument you just added, so the gate was blind to exactly what most needed checking. |
| 4 | **MUST** — an assertion that could never fire | `"Only in <dock>:"` was `diff -rq` output, which the bullet above it forbids. Replaced with the marker the prescribed command actually emits — a `>` line — and sharpened: a `>` line is *legal* when the file's subject is the copy itself, so the rule is "every `>` line is a declared substitution," not "no `>` lines." Run today it emits exactly six, and all six are the front door, the licence, the line-ending policy and the README's assets. |
| 5 | **MUST** — §2's sweep was unsatisfiable | It demanded "is empty" while the rubric ships inside the tree it sweeps, so it matched its own pattern list. Now it demands a **human clears each hit**, like §3 — a rule that can never be satisfied is a rule that gets waived the first time it fires. Filtering moved from `--exclude` to a pipe, because `--exclude` beside an `--include` is quietly ignored on some builds, and `.git/` is excluded explicitly (every reflog holds the committer's address; it is local-only and never pushed — §4 is what audits real history). |
| 6 | **MUST** — the starter cited a rubric it does not carry | `icm-starter/CLAUDE.md` pointed at `04-utilities/health-checklist.md`, a path that does not exist once the starter is copied into someone's project. Now cited by name, not by path. |
| 7 | **SHOULD** — the sharpest cold-start gap | The canon said this repo *is* a distributed copy but never drew the consequence. It now states it: a defect found here is fixed upstream and the copy re-cut, because a change authored in this tree is silently reverted by the next cut. |

## Declined, with reasons

| # | Fix | Why not |
|---|-----|---------|
| 2 | Reword **"Every folder has a `CONTEXT.md`"** to say *room* | Already litigated and settled against. The operative sentence is the one beside it — *"a room with no contract is a bug"* — a room being a numbered folder the routing table names, and a room's internal subfolders being contracted by their parent's *What lives here* block. Rewording the slogan would also have to change `CLAUDE.template.md` and `icm-starter/CLAUDE.md`, the two artifacts a recipient copies, manufacturing the inconsistency the fix claims to remove. The genuinely new half of the finding — a flat contradiction with the canon's own new `docs/` line — **was** fixed: `docs/` no longer asserts "not a room" but names this line as its contract. |

## Left to the owner

- **8 (partial)** — `.gitattributes` now sets `* text=auto eol=lf`, but the tree at `HEAD` predates
  it. Normalizing is a commit, and committing is the owner's action, not this room's:
  `git add --renormalize .` before the next commit. The three newest instruments are still untracked
  for the same reason.
- **9, 10** — load tables for three rooms, and a *What not to load* line for the starter. Real, both
  `SHOULD`, both content work rather than repair. They belong in a design pass, not this one.

## Re-score

Every **MUST** from the diagnosis is applied or explicitly declined with a reason, which is
`repair.md`'s completion bar. The residual smells are items 8–10 above.

**One thing worth keeping.** Fixes 3, 4 and 5 were all the same shape: a check that *ran* and told
you nothing. The allowlist passed because it could not see untracked files; the substitution
assertion passed because it watched for a string the command never emits; the identity sweep would
have been waived because it could never come back clean. None of them failed loudly. **A gate that
cannot fail is indistinguishable from a gate that passes** — so a rubric earns its place only once
you have watched each of its checks catch something.

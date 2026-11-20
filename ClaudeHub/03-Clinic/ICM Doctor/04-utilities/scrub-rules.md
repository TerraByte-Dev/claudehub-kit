# Scrub Rules

> The rubric a copy is scored against **before it leaves the dock** — `playbooks/distribute.md`
> makes the cut, this file decides whether the result ships. It stands behind `distribute.md`
> exactly as `health-checklist.md` stands behind `diagnose.md`.
>
> **MUST** = a fail does not ship. **SHOULD** = a smell; ship only with the owner's eyes on it.
> Every command below must still run **after** the cut — a path rewrite that touches a code span
> containing a regex turns a gate into a guaranteed pass. Re-read them in the shipped copy.
> `<src>` = the private structure, `<dock>` = the shipped tree (a git working copy of the
> published repo). The **withhold list** is the set of files the cut refuses to carry.

## 1. Subtraction only
- [ ] **MUST** Reverse diff, over **normalized path sets**. A raw `diff -rq` is useless here — the
      cut lowercases room folders, so every path reads as only-in-one-tree. List both sides with
      `find`, not `git ls-files`: **a source tree is often not a git repo at all, and `ls-files`
      silently omits untracked files** — which is exactly the newest instrument you just added.
      ```
      diff <(cd <src>  && find . -type f -not -path './.git/*' | tr A-Z a-z | sort) \
           <(cd <dock> && find . -type f -not -path './.git/*' | tr A-Z a-z | sort)
      ```
- [ ] **MUST** **Every `>` line is a declared substitution.** A `<` line is a path the cut withheld —
      expected, and it must appear on the withhold list. A `>` line is a file that exists *only* in
      the copy, which is legal exactly when its subject is the copy itself: the front door, the
      licence, the line-ending policy, the README's assets. A `>` line that is not one of those was
      authored downstream; the shipped tree is then a second source of truth rather than a
      subtraction of the first, and the two can no longer be reconciled by diffing.
      (Substitutions that *share* a path with their original — the canon, the seeded registry, the
      contract of a room the cut changed — never show here. The content diff is what catches those.)
- [ ] **MUST** File-type allowlist returns zero lines — again `find`, so untracked files count:
      `cd <dock> && find . -type f -not -path './.git/*' | grep -vE '[.](md|gitattributes|ps1)$|/LICENSE$|/docs/assets/'`
      This one check catches binaries, stray scripts, a dragged-along `.claude/`, and whatever else
      a recursive copy brought with it.

## 2. The identity sweep
- [ ] **MUST** Run it, then clear every hit by hand — this sweep is *not* expected to come back
      empty, and a rule that demands empty gets waived the first time it fires:
      ```
      grep -rniE '<handle>|<email>|^[A-Za-z]:\\|/Users/|/home/|Desktop' <dock> \
        | grep -vE '/[.]git/|scrub-rules[.]md:'
      ```
      A generic `$HOME/Desktop` in a scaffolder is a pass; the owner's actual home path is a leak.
      **Filter with a pipe, not with `--exclude`** — next to an `--include` it is quietly ignored on
      some builds, and a flag that silently does nothing is worse here than no flag at all. Two
      exclusions are load-bearing: this file ships inside the tree it sweeps, so without it the
      rubric matches its own pattern list; and `.git/` internals hold the committer's address in
      every reflog, which is local-only and never pushed — §4 is what audits real history.
- [ ] **MUST** **Sweep the handle, never the given name.** A login handle is a rare string; a first
      name is a substring of ordinary English — *state*, *estate*, *instantiate* — and it buries the
      one real hit in a screenful of false ones. A screenful is how a sweep gets waved through.
- [ ] **MUST** This file names no one either. The rubric ships with the structure it scores, so a
      literal handle written here is the leak it exists to catch.

## 3. The derived-names sweep
This is the check that catches a client's name surviving inside a file you *did* ship. Build the
proper-noun list **per run, out of the files being withheld** — a hard-coded alternation of client
names goes stale the moment a new row is registered, and a stale list fails silently.
- [ ] **MUST** Harvest, then hunt:
      `grep -rhoE '\b[A-Z][A-Za-z0-9.&-]{2,}\b' <withheld files> | sort -u > names.txt`
      `grep -rnwFf names.txt <dock> --include='*.md'`
- [ ] **MUST** Every hit is read and cleared by a human. Strike the shared vocabulary (ICM, Markdown,
      PowerShell, room names); anything naming a person, company or engagement is a leak.

## 4. Git history
- [ ] **MUST** `git -C <dock> log --all --diff-filter=A --name-only | sort -u` intersected with the
      withhold list is empty. The dock is a clone of *real published history* — a file leaked in one
      commit and deleted in the next is still a reachable blob, and reading the working tree will
      never show you that.
- [ ] Remediation is a **fresh squashed initial commit**, never `git rm` — `git rm` removes the path
      and leaves the blob. This is the **one sanctioned exception** to the repo's
      never-destroy rule: history is the only place where leaving the data intact *is* the harm.

## 5. No dangling links — run this *after* the cut
The cut is what creates them, so a pre-cut pass proves nothing.
- [ ] **MUST** Every relative link target in the shipped copy resolves to a file that exists.
- [ ] **MUST** No link resolves to a withheld path — a live href into the hole the cut made.
      Evidence: parallel authors confidently guess each other's filenames. One structure in this
      clinic's history shipped **21 dangling references** that were invisible to reading it.

## 6. Rooms that teach
- [ ] **MUST** **Empty-room check.** No shipped room holds only its own `CONTEXT.md`. Either it
      carries a real example or the canon states, in a line, why it is empty on purpose.
- [ ] **SHOULD** **Cold-start.** A fresh agent given only the shipped root reaches a first useful
      action without asking a question the tree cannot answer.

## Verdict
- **Ships** — every MUST passes.
- **Hold** — a structural MUST fails (§1, §5, §6). Fix in the dock and re-score; nothing is lost.
- **Leaked** — an identity, derived-name, or history MUST fails. Nothing leaves, and the fix is the
  scrub itself — not a note to be careful next time.

Record the run in `../01-index/REGISTRY.md`, on the row the structure already owns.

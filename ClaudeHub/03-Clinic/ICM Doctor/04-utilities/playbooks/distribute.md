# Playbook — Distribute

> Cut a private structure into a public copy someone else can run — carrying the judgement,
> carrying none of the facts that were never meant to leave.
>
> **Leans on:** `../health-checklist.md`, `../scrub-rules.md`, `../../05-distributable/CONTEXT.md`.

## Input
- A structure to ship, and one line on who receives it and where the copy lands.

## Process
1. **Clear the root, then score it.** Anything at the source root belonging to another project
   stops the run — give it a home or archive it with the owner's say-so. Excluding junk from the
   copy instead leaves the source failing its own checklist, and the next cut inherits the same
   decision unmade — it is always a dependency tarball, a debug repro, or a scratch script. Then
   run `../health-checklist.md` on the **source**: you cannot ship a structure that fails its own
   rubric, and the dock admits only health-passing ones.
2. **Classify every path — nothing unclassified.** Each file is **ship**, **withhold**,
   **substitute**, or **harvest**. An unaccounted path stops the run, and that is the point: a new
   file gets its ship-or-withhold decision at ship time rather than at push time.
3. **Harvest, don't redact.** A file you would have to rewrite to publish is a file to **withhold
   and mine**, never to sanitize in place — that is how a client name survives into a public repo.
   `01-index/REGISTRY.md` is the worked case: rows naming live clients, cut whole, replaced by a
   one-row seed, its transferable lessons mined into a reference file that ships.
4. **Subtraction only.** Every byte in the copy exists upstream first; nothing is authored
   downstream. A fact written into the copy is a second copy of that fact, and the stale one is the
   one someone reads — `create.md`'s *point, never duplicate*, applied to shipping. The one
   exception is the **substitution set**, and it has a rule rather than a count: a file is a
   substitution exactly when **its subject is the copy itself** — the front door, the licence, the
   seeded source of truth, the canon that routes the copy's own rooms, the contract of a room whose
   contents the cut changed. Everything else is subtraction — including a **harvest** product,
   whose bytes are new but whose provenance is the withheld file it was mined from. A substitution
   that is *not* about the copy is a fact you are maintaining twice: fix it upstream instead.
5. **Rewrite mechanically; fix upstream, not downstream.** Apply the standing rewrites and nothing
   else — room folders lowercased, path separators, the structure's own name, the container word
   (*workspace* → *repo*). Two rules make them survive contact with the tree they run over.
   **Name a rule by role, never by its operands:** written as a literal, the rename rewrites *this
   playbook*, and step 5 becomes *"X" → "X"* — unfollowable, which is how the first cut shipped.
   **A separator rewrite applies to paths, never to commands:** a code span holding a regex has
   semantic backslashes, and rewriting those turned three of the next room's MUST gates into
   guaranteed passes. A path has no spaces; that is the whole test. Anything that ought to be true
   in both copies is fixed in the source; a permanent rewrite rule is a bug you pay for forever.
6. **Run `../scrub-rules.md`.** The shipping rubric, and the gate — it stands behind this playbook
   exactly as `../health-checklist.md` stands behind `diagnose.md`.
7. **Cold-start the copy on its own on-ramp.** Paste the recipient's first sentence into a fresh
   agent pointed at the shipped tree. If it asks a question the copy cannot answer, the defect is
   in the copy's canon, not in the prompt.
8. **Hand it over.** The run ends at *ready to send*. Publishing — pushing, sending, granting
   access — is the owner's action, never the agent's.

## Output
- The shipped tree on the dock (`../../05-distributable/<name>/`, itself the working copy of the
  published repo), a send-ready archive beside it, and a row in `../../01-index/REGISTRY.md`.

## Completion
- Cold start passes, `../scrub-rules.md` passes, the owner is holding the artifact.

# ICM Registry — the source of truth

> Every ICM structure you build, repair, or want to learn from. This file is authoritative:
> if anything disagrees about what exists, this wins.
>
> **This is your registry.** It ships with one row — this repo — so you can see the shape.
> Add yours underneath and delete the example whenever you like.
>
> **Health** is `Healthy` / `Needs care` / `Critical` per `../04-utilities/health-checklist.md`,
> or **`unaudited`** = catalogued from observation but not yet scored. Run
> `../04-utilities/playbooks/diagnose.md` to turn an `unaudited` into a real verdict.

## Structures

| Structure (path) | Type | Zones | Pattern it best demonstrates | Health | Last checked |
|------------------|------|:-----:|------------------------------|--------|--------------|
| `ICM-Doc` (this repo) | methodology factory + clinic | 6 | the canon itself; the full create / diagnose / repair / **distribute** loop, each playbook backed by its rubric; alias-tolerant lexicon | **Needs care** — audited **Critical**, repaired same day; see [the diagnosis](../02-planning/diagnosis-icm-doc.md) and [the repair log](../02-planning/repair-log-icm-doc.md) | 2026-09-05 |

## How to use this file

1. **Register on completion.** A structure earns a row when it passes the health checklist —
   or immediately, at `unaudited`, if you're cataloguing something you found rather than built.
2. **Annotate the lesson.** The "pattern it demonstrates" column is the point. It's what makes
   the registry a teaching index rather than a list of folders. If the pattern is transferable,
   promote it to `../06-resources/icm-patterns.md`.
3. **Keep it honest.** Record the real health, including `Needs care`. This is a mirror, not a
   trophy case — a registry that only contains healthy structures is a registry nobody updates.

## Notes

- Paths are however you like them — absolute, relative to a projects root, or a repo URL. Pick
  one convention and hold it.
- `unaudited` rows are **leads**, not verified examples. Diagnose one before holding it up as a
  model to copy.
- A row that has been `unaudited` for a year is telling you something.

# 02 — Work  ·  CONTEXT

> The person's work: what they do for money or for the crew. One folder per desk, each with a
> short `CONTEXT.md`. Empty on purpose until the interview has run: desks are built around
> what they actually do, not guessed in advance.

## Identity
A desk is one line of work with its own loop: a clipping page, a sales pipeline, a service
shift, a product they're helping build. Each gets a folder named for what it is
(`clip-desk`, `sales-desk`, `shift-desk`), and its own rooms when it needs them. `hub/` sits
here too: the TerraByte Hub room, made by `../../02-Internals/07-hub/`.

## Inputs
| Resource | When | Why |
|----------|------|-----|
| `../ABOUT-ME.md` | every new desk | what they run, by hand, what eats their time, what they want |
| `../../PERSON.md` | first desk, if `ABOUT-ME.md` is thin | the short summary setup wrote |
| `../../03-Clinic/ICM Doctor/04-utilities/playbooks/create.md` | building a desk | how a structure is laid out properly |

## Process — "Build my first desk."
1. **Read `ABOUT-ME.md`.** Pick the one line of work that eats the most of their time or that
   they most want help with. Say which in one line; if two tie, ask once. If that work already
   has a project folder (an upgrade's routing table in `../../CLAUDE.md` lists them), don't
   build a parallel desk: point them to that folder. A desk here may link to it, never copy
   or move its files.
2. **Interview for the loop**, one question at a time, their words: what comes in, what they
   do to it, what goes out, what tools they use for it today (apps, sites, AI tools, scripts
   they built; never a login or key), where it's tracked and roughly how many hours a week it
   takes, and what "a good week" looks like. Then, once, the `ABOUT-ME.md` fields marked
   `(desk build)` that it doesn't answer yet: what's different a month from now, hours a week
   for learning this, tool budget beyond Claude ($0 is a real answer), anything they won't do
   (show their face, post under their real name, run extra accounts, cold-DM strangers), and
   their country (and US state) if this desk sells, posts or reaches out, since the rules
   differ. "Skip" is fine. Write the answers into `ABOUT-ME.md`.
3. **Build it with the ICM Doctor's create playbook**, here in `02-Work/<name>/`, not in the
   Doctor's own `03-building/`. Name the desk for what they do. Rooms in workflow order
   (e.g. `01-inbox`, `02-working`, `03-done`), one source of truth (often a small CSV whose
   columns are fixed in a `DATA.md`), a `CONTEXT.md` per room, ≤ 80 lines each. Skip the
   Doctor's registry step; the routing row below is the registry here.
4. **Run one real item through it** with them, end to end. Fix what didn't fit.
5. **Keep the map true**: add the desk's row to the table below and to `../../CLAUDE.md` in the
   same turn. Log it in `../../02-Internals/CHANGELOG.md`.
6. **Hand over**: what to paste next time (one line), and whether this desk shares work through
   the Hub (if so, its `CONTEXT.md` links `hub/CONTEXT.md` for handoffs).

## Desks
| Folder | Holds |
|--------|-------|
| `hub/` | TerraByte Hub: what's waiting, handoffs in and out, one update before stopping (made by `07-hub`) |

## Conventions
- A new line of work gets its own desk when it starts, not in advance. Don't merge two desks'
  data, and don't let one desk's data leak into another's files.
- Anything here may involve other people's content or information. **Don't send, post, or
  share any of it without asking first.** Claude drafts; the person sends and posts.
- Selling for TerraByte? Every service, price or result in a draft comes from Tate in writing
  (the Hub or a file he sent). If not, `[UNKNOWN - ask Tate]`. No client names in files.
- Other people's personal data (leads, customers) stays on this PC and never goes into a public
  repo.

## Links
Floor plan → `../../CLAUDE.md` · Builder → `../../03-Clinic/ICM Doctor/` · Hub setup → `../../02-Internals/07-hub/`

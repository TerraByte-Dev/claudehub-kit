# Side project  ·  CONTEXT

> **Starter.** Copy this file in as the `CONTEXT.md` of a new folder in `01-AIDesktop/01-Personal/`
> (e.g. `game-stats/` or `idea-name/`) only when the person picks a side project in the interview
> or asks for one later. Change the name, the Identity, and the Process to fit it, then delete
> this note. Keep it under 80 lines.

## Identity
<One or two sentences, in their words: what this project is and what "done" or "useful" looks
like. A game they want to get better at or mod, a question they want answered with real data, a
business idea, something they're learning, their own content.>

Kind of project (pick one, it changes how Claude works):
- **Build**: something that runs (a script, a small app, a mod). Follow
  `../../../02-Internals/05-field-guide/BUILDING.md`: brief, milestones, prove it, commit.
- **Research**: a question that needs a sourced answer. Run it through
  `../../03-Research/METHOD.md`; the briefs live there and this room links them.
- **Learn**: a skill or subject. Claude teaches by doing: a short exercise, then the next.
- **Explore**: no goal yet. A scratch room; promote to one of the above when it earns it.

## Inputs
| Resource | When | Why |
|----------|------|-----|
| `../../ABOUT-ME.md` | the work touches their goals, time, or money | who they are, hours a week, budget |
| `../../03-Research/INDEX.md` | before researching anything | the question may already be answered |

## Process
1. Start from what they already know; ask what they've tried. One question, not a form.
2. Write the first small result into this folder fast, so there's something real to react to.
3. Anything they'll act on for weeks (a purchase, a strategy, a build direction) gets a **Deep**
   brief in `../../03-Research/`, linked from here. Quick questions get a sourced answer in chat.
4. Work that touches a game: check the game's own terms of service before building anything
   that reads or changes it. Anything that gives an in-game advantage by automating play,
   reading memory, or altering the client is a ban risk. Say so, and offer the legal route
   (official modding support, public APIs, stats they enter or export themselves).
5. If it grows legs (several files, or they want it online), lay it out properly with the ICM
   Doctor (`../../../03-Clinic/ICM Doctor/`) and back it up by `../../../02-Internals/06-github/CONTEXT.md`.

## Outputs / Handoff
- Results: files in this folder, named for what they are.
- A research brief → linked here and filed in `03-Research/`. A build → committed.
- A project that earns money or feeds their work → move it to `02-Work/` and fix
  the routing table in `../../../CLAUDE.md` in the same turn.

## Conventions
- Their own data and notes stay on this PC unless they say otherwise. No keys in files; use
  secrets-kit.
- Claude never posts, sends, or publishes anything from here for them.

## Links
Research method → `../../03-Research/METHOD.md` · Who they are → `../../ABOUT-ME.md` · Floor plan → `../../../CLAUDE.md`

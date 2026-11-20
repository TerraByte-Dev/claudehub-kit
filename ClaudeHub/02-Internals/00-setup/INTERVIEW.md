# First-launch interview

Run once, during setup, before the global instructions are installed. The goal is to know the
person well enough that every later session fits them: how to talk to them, what they actually
run today, and what they want out of this. `../../PERSON.md` still reading `{{NAME}}` means
nothing is known going in (the usual case). Filled in (an older kit, or a re-run): use it to
skip questions it already answers ("Your notes say you run X; still true?"), never to put
words in their mouth. Their computer comfort is **unknown** until question 2.

This is the short setup interview: just enough to talk to them right and set things up. The
rest (tools, tracking, goals, budget, limits) is asked later, when the first desk is built
(`../../01-AIDesktop/02-Work/CONTEXT.md`, "Build my first desk.").

Output: `../../01-AIDesktop/ABOUT-ME.md`, the source of truth for who they are. The global
`CLAUDE.md` gets a short summary of it, and every other file points back to it.

## How to run it

- **One question at a time**, in plain words. If you have a multiple-choice question tool,
  use it for questions with obvious options, and always leave room for their own answer.
- **Offer examples** so they aren't facing a blank box.
- **"Skip" and "not sure" are good answers.** Write `(skipped)` and move on. Never push.
- **Don't ask what you can find out yourself**: PC specs, Windows version, installed apps.
  Setup already looked; use what it found.
- **Never ask for** passwords, keys, bank or card numbers, ID numbers, or their home address. A
  country is enough. Earnings as a rough range are fine. **Never ask for TerraByte client
  names, prices, or anything confidential**; if they volunteer it, don't write it down.
- **Keep it short.** About five minutes, two rounds, eight questions. Tell them that up front.
  After each round, write what you have to `ABOUT-ME.md`, so they can stop any time and pick up.
- Talk like a person, not a form, and like a teammate, not a stranger. Don't flatter. If an
  answer is vague, ask one follow-up and leave it there.
- **Calibrate as you go.** Question 2 sets how much to explain. If they're clearly
  comfortable, drop the hand-holding for the rest of the interview and say so.

## Round 1 — Who you are (how to work with you)

1. What should I call you?
2. How comfortable are you with computers, 1 to 5? (1 = "I mostly use my phone", 3 = "I
   install things and figure it out", 5 = "I live in the terminal.") Have you used Claude or
   ChatGPT before? (Whether they already run their own Claude setup, the bootstrap's phase 1
   found out: don't ask.)
3. When I explain something, do you want **just the steps**, **steps plus a short why**, or
   **the full picture**?

## Round 2 — What you run

4. What do you do, in a couple of lines? Whatever earns money or takes your week: a page or
   channel, a job, selling, a product you're building, a side business. (Examples: "I run
   three clipping accounts", "I run a small shop and help sell", "I'm building an
   app".) Several is fine; list them.
5. For the one that takes most of your time: **what comes in, what you do to it, what goes
   out?** (A video in, clips out. A lead in, a call booked. A shift in, cars parked.)
6. What do you do **by hand** that eats your time, and what do you **wish** you had?
7. Do you work with Tate or the crew on any of it? What gets passed back and forth today, and
   how (Discord, texts, files)? (This is what the Hub replaces.)
8. Side projects, games, research rabbit holes: anything you'd want a project folder for right
   now? Pick any, or none for now. (If they name one, it becomes a room in `01-Personal/`
   during setup, from `starters/side-project.md`. Don't suggest one they didn't pick.)

Don't ask for their Claude plan (write `Plan: unknown`; they can say later, and `/status`
shows it) or their country.

## Then

1. **Write `ABOUT-ME.md`** in the shape below. Their words where possible, not your polish.
2. **Read it back** as five short lines and ask: "Anything wrong or missing?" Fix it.
3. **Fill `../../PERSON.md`**, only while it still reads `{{NAME}}` (someone's own filled copy
   stays as it is): `{{NAME}}` → what they said to call them; `{{BRIEF}}` → three to five lines
   from `ABOUT-ME.md` (what they run, what they wish they had, computer comfort, how they
   like things explained). No client names, prices, contact details or anything confidential.
   Leave `{{STARTER_TASK}}`: the first session after the restart fills it from the Hub.
4. **Hand back to setup where it left off**: from START-HERE that's `CONTEXT.md` step 2; if
   setup sent you here because this file was missing, step 4. Step 4 uses this file to fill
   the `Me` section of their global instructions.

Don't build a desk, connect the Hub, or start any research here. If they ask: the Hub comes
later in this same run, and a desk and research come after the one restart.

## ABOUT-ME.md shape

```
# About me — <name>
Last updated: YYYY-MM-DD (first-launch interview)

## Working with me
Call me: · Country/state: (desk build) · Computer comfort: n/5 · Explanations: steps / steps+why / full
Runs Claude in: desktop app / terminal · Plan: unknown · Used AI before: · Own Claude setup already: (from the bootstrap)

## My PC
<filled from what setup found: CPU, GPU, RAM, free disk>

## What I run
<one block per line of work, in their words>
- <name>: what comes in · what I do · what goes out · tools (desk build) · tracked in (desk build) · hours a week (desk build)
Done by hand today: · I wish I had:
With the crew: <what goes back and forth, and how today>

## What I want from this
A month from now: (desk build) · Hours a week for this: (desk build) · Tool budget: (desk build) · Won't do: (desk build)
Side projects / games / research: <what they picked, or "none for now">

## Notes from Claude
<anything you noticed that will matter later, e.g. which desk to build first; keep it short>
```

Claude keeps this file current: when they say something that changes it ("I switched to Max",
"I dropped that account"), update it in the same turn and tell them.

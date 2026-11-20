# How to build things with Claude

You don't need to code to ship things. You need to run a build the way people who do ship them do. This page
is that way. It applies the same to a side project, a script for your work, or a tool for the crew.

## The loop

1. **Write down what you want before anything gets built.** A short brief: who it's for, what
   it shows or does, what it must never do. Claude writes it with you; you correct it. Most
   bad builds are a fuzzy idea built fast.
2. **Cut it into milestones** you can each see working in one session. "Login, database,
   dashboard, mobile app" is a wish. "A page that lists my last 20 posts from a sample CSV" is a
   milestone.
3. **One milestone per session.** Start a new session for each (or `/clear`). Claude works
   better with a clean head; long sessions get forgetful and sloppy.
4. **Plan, then build.** Start with "plan it first and show me the plan in plain words."
   Read it. If it sounds bigger than the milestone, say so. (Plan mode, in the mode picker or
   Shift+Tab, makes Claude plan without touching anything.)
5. **Make it prove it.** "Open it and show me." "Check that number against the file in front
   of me." "What did you test, and what didn't you?" Done means seen working, not "should work."
6. **Save it.** Commit and push when it works (`../06-github/`). Now nothing you
   build can be lost, and any mistake can be undone.
7. **Write down what was decided** in the project's `CONTEXT.md` ("we chose X because Y"), so
   next week's session doesn't undo it.

## Habits that pay

- **Start small, then grow.** A rough version that works beats a perfect plan.
- **One project, one folder**, with a `CONTEXT.md` saying what it is and what done looks like.
- **Review in a fresh session.** "Review this as a skeptic: what's broken, missing, or
  overcomplicated?" A new session with no memory of building it finds what the builder missed.
- **When something breaks, ask why before asking for a fix.** "Stop. Find out why this
  failed before you change anything." Guess-fixes pile up.
- **Ask to learn.** "Explain what you just built like I'm new to this, in five lines." You'll
  pick up more than you expect, and you'll make better calls.
- **Big jobs have big tools.** `/deep-research` for a hard question; the word `ultracode` in a
  request makes Claude split a big job across many agents. On the Pro plan, switch on
  **Dynamic workflows** in `/config` first. Both use a lot of your plan; save them for things
  worth it.
- **Sales material is a build too.** A call-notes template, an outreach batch, a brief for Tate: write down what it's for and what it must never claim, then check every TerraByte claim against what Tate gave you in writing. Claude drafts; you send.
- **Building with someone on the crew?** Hand the brief and each milestone over through the Hub (`01-AIDesktop/02-Work/hub/`), not Discord, so their Claude picks it up with the files.
- **Free code from GitHub saves weeks**, if it's checked first (`../../01-AIDesktop/04-Toolshed/`).

## Red flags to say out loud

- Claude says "done" and you haven't seen it work.
- It's adding things you didn't ask for.
- The same error keeps coming back with a different "fix".
- It wants to install something big, sign you up for something, or put your stuff online.
- It wants to post, send, or message anyone for you, or auto-schedule through a tool you didn't pick.
- A draft states a TerraByte client, price, metric or capability Tate didn't give you in writing.
- It wants to act on a Hub task or file before you said go.

Last checked: November 2026.

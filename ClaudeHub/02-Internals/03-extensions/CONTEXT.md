# 03 — Extensions  ·  CONTEXT

> **The add-ons room.** Things built on top of stock Claude Code to make it behave the person's way.

## Identity

The person comes here when they notice themselves repeating something: the same instructions typed
again, the same check forgotten again. The agent picks the right kind of add-on, builds it,
tests it, and records it. Nothing is built here in advance.

## Which add-on for which itch

| They say… | Build a… | Which is | Lives at |
|-----------|----------|----------|----------|
| "I keep typing the same instructions" | **skill** | a saved set of instructions they run by typing `/name`, or that Claude picks up when the task fits | `~/.claude/skills/<name>/SKILL.md` |
| "Do this side job without cluttering our chat" | **subagent** | a helper Claude with its own instructions and its own memory of the task | `~/.claude/agents/<name>.md` |
| "This must happen every time, no exceptions" | **hook** | a script Claude Code itself runs at a set moment (before a tool runs, when a session starts). Claude can't forget or skip it | the `hooks` section of `settings.json` |
| "Someone already built this" | **plugin** | a bundle of the above, installed with `/plugin` | managed by Claude Code |
| "Always talk to me this way" | a line in `CLAUDE.md`, or an **output style** | standing instructions | `~/.claude/CLAUDE.md` |
| "Show me X at the bottom of the screen" | **statusline** | the info bar under the input box | `statusLine` in `settings.json` |

Itches people tend to have, as examples: a `/post-prep` skill (turn picked clips into
captions and a posting order), a `/call-notes` skill (fill a call template, stated-vs-inferred),
a `/hub-catchup` skill (sum up what's waiting in the Hub), a hook that refuses to let a `.env`
or a file of other people's details be committed. Build one only after they've repeated
themselves. **No add-on may post or send for them**: no scheduler hook, no "auto-reply"
subagent, nothing that posts to the Hub without their ok. The Hub's own session hook is made
by `../07-hub/`; don't build a second one.

Try the cheapest thing first: a line in a `CLAUDE.md` beats a skill, a skill beats a hook.
Use a hook only when "Claude usually remembers" isn't good enough.

Put an add-on in `~/.claude/` if they want it everywhere, or in a project's `.claude/` folder
if it only makes sense there.

## Process

1. **Name the itch** in one sentence and pick the add-on type from the table.
2. **Check the current format** in the docs before writing it. These formats change:
   `https://code.claude.com/docs/en/skills`, `/sub-agents`, `/hooks-guide`, `/plugins`.
3. **Build the smallest version** in its live location.
4. **Test it for real.** Run the skill, call the subagent, trigger the hook. A new session is
   usually needed before it shows up.
5. **Record it**: one row in `REGISTRY.md` here (create the file with the first add-on:
   name, type, what it does, where it lives, how to remove it), and a line in `../CHANGELOG.md`.

## Outputs / Handoff

- A working add-on they have seen run once.
- A registry row and a changelog line.

## Conventions

- One add-on, one job. If the description needs "and", it's two.
- A hook runs with their full permissions and nothing prompts first. Keep hooks short, and
  tell them what each one does before turning it on.
- Installing a plugin runs someone else's instructions and code. Say who published it.
- If an add-on stops being used, remove it and log that.

## Links

- Settings file the hooks and statusline live in → `../01-harness/WHERE-THINGS-LIVE.md`
- Try an idea before building it properly → `../04-lab/CONTEXT.md`
- Floor plan → `../CLAUDE.md`

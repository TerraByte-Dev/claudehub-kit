# 04 — Lab  ·  CONTEXT

> **The bench.** Where the person finds out what their tools can actually do by trying them.

## Identity

A safe place to poke at things. They ask "what can you do with X?" or "what does that command
do?", and the answer here is a small real experiment, not a description. What graduates out
is a lesson worth keeping. What dies here is everything else, and that's fine.

## Inputs

- A question from them: a tool, a command, a connection, or an idea they want to see in action.
- Or nothing at all. "Show me something I don't know you can do" is a valid request here.

## Process

1. **Find out what's really available.** Don't answer from memory. List the tools and
   connections this session actually has, and check `../02-mcp/INVENTORY.md`.
2. **Run a small, real, harmless example.** Read-only where possible. Work inside
   `scratch/` (create it when first needed). Never experiment on their real projects, real
   inbox, real social accounts, real customer data, real Hub tasks, or real accounts unless they
   say so for that specific experiment.
3. **Show the result**, then say in two or three plain sentences what it means for them: what
   this makes possible, and what it can't do.
4. **Write it up** as one file, `YYYY-MM-DD-<topic>.md`, using the shape below. Short.
5. **Triage.** Useless: leave the file, move on. Useful how-to: promote it to
   `../05-field-guide/`. A new habit they want every time: propose the line for the right
   `CLAUDE.md` and add it when they agree.

### Experiment file shape

```
# <what we tried>
Question:   <what they wanted to know>
Tried:      <what was actually run>
Result:     <what happened: worked / partly / failed, with the evidence>
So what:    <what this means for them, in plain words>
Promoted:   <where the lesson went, or "nowhere">
```

## Good first experiments

Ideas for when they don't know where to start. Delete these as they get done.

More labeled ideas live in `IDEAS.md` (work, Hub, build, and fun ones). Setup replaces this
list with 3–5 built on the interview. Always-good starters:

- "List every tool you have right now and group them by what they're for."
- "What's the difference between a skill, a subagent, and a hook? Build me a tiny one of each."
- "Make a mistake in a scratch file on purpose, then show me how to rewind it."

## Conventions

- One experiment, one file. Don't append to an old one.
- Failed experiments are worth writing up. "This doesn't work, and here's why" saves the next try.
- `scratch/` is disposable. Nothing in it is ever the only copy of something they care about.

## Links

- Experiment ideas → `IDEAS.md`
- What's connected → `../02-mcp/INVENTORY.md`
- Where lessons graduate to → `../05-field-guide/CONTEXT.md`
- Floor plan → `../CLAUDE.md`

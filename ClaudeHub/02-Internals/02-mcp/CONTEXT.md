# 02 — MCP  ·  CONTEXT

> **The connections room.** MCP (Model Context Protocol) is how Claude gets plugged into
> other things: a calendar, a GitHub account, a browser, the TerraByte Hub. Each plug is called
> an **MCP server**, or here, a **connection**.

## Identity

The person doesn't set these up by hand and doesn't want to. They say "can you connect to X?"
and the agent finds the right connection, installs it, gets it working, and hands them only
the step that needs a human: usually clicking "Allow" in a browser, sometimes fetching a key.
The Hub is the exception: it has its own room, `../07-hub/`.

## What lives here

| File | What it's for |
|------|---------------|
| `INVENTORY.md` | the record of every connection on this machine. The live list (`claude mcp list`) is the truth; this explains it |
| `ADD-A-CONNECTION.md` | the playbook for adding one, and for fixing one that broke |

## Process

1. **Check the inventory and the live list** (`claude mcp list`) first. It may already be
   connected, or connected and broken.
2. **Adding or fixing** → follow `ADD-A-CONNECTION.md`. Don't improvise. The Hub → `../07-hub/`.
3. **Update `INVENTORY.md`** in the same turn, and add a line to `../CHANGELOG.md`.
4. **Show them it works** with one small real use of the connection, then tell them in a
   sentence or two what Claude can now do with it and what it can't.

## Outputs / Handoff

- A connection that shows as connected and has been used once successfully.
- An inventory row that matches reality.
- Want to explore what it can do → `../04-lab/`.

## Conventions

- **No keys in this folder.** The inventory records *how* a connection logs in and *where*
  the key lives, never the key.
- Every connection is a door into one of their accounts. Before adding one that can send,
  post, pay, or delete on their behalf, tell them so in one line. Once they click "always allow"
  for it, no prompt stops Claude using it, so the never-send rule in their global `CLAUDE.md`
  is the only guard.
- Fewer is better. Each connection adds startup time and clutter. If they haven't used one in
  a while, suggest removing it.
- A connection that can **post or send** (a posting tool, email, DMs, calendar invites, Hub
  updates and handoffs) is logged with that in the "Can it change things?" column. It exists so
  Claude can read and prepare; the person does the posting and sending, or says ok first.
  Claude never uses a connection to send, post, DM, email, invite or publish on its own.
- Removing a connection is a change like any other: log it.

## Links

- Playbook → `ADD-A-CONNECTION.md` · The Hub → `../07-hub/CONTEXT.md`
- Permissions and what still asks first → `../01-harness/PERMISSIONS.md`
- Floor plan → `../CLAUDE.md`

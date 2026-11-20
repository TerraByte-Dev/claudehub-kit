# Add (or fix) a connection

The playbook the agent follows when the person says "connect you to X." Commands were checked against
the Claude Code docs in October 2026. Run `claude mcp --help` and check
`https://code.claude.com/docs/en/mcp` if anything here doesn't match what you see.

## 1. Find the right connection

Look for one in this order and take the first that exists. Earlier options are less work for
them and keep keys off their disk.

1. **A claude.ai connector.** If they sign in to Claude Code with their claude.ai account,
   connectors they add at `claude.ai/customize/connectors` show up in Claude Code by
   themselves. Adding one is a few clicks for them and no install for you. See "The
   connector route" below. (If they sign in with an API key instead, connectors don't appear:
   go to option 2.)
2. **An official remote server.** The service publishes a web address for its MCP server and
   the person logs in through their browser.
3. **An official local server.** A small program, usually started with `npx` or `uvx`, that
   runs on their computer. Often needs a key.
4. **A community server.** Someone else's code running on their machine with access to their
   account. Vet it by `../../01-AIDesktop/04-Toolshed/CONTEXT.md` first (fake MCP servers are
   a live malware lure in 2026), take it only from the maker's own docs or the official MCP
   registry, never from a README download button, and pin a version
   (`npx -y pkg@1.2.3`, `uvx pkg==1.2.3`). Tell them it's
   unofficial before installing it.

Search the web for the service's own documentation. Don't install from a name you remember.

### The connector route

1. Ask them to type `/status` and tell you which account it shows (claude.ai or an API key).
2. Give them the clicks as their `YOUR TURN` item: open `claude.ai/customize/connectors` in a
   browser, find the service, press Connect, approve the login.
3. They start a new Claude Code session. The connection appears in `/mcp` and in
   `claude mcp list`, named `claude.ai <Service>`.
4. Skip to "Prove it". The undo to log is: remove it at `claude.ai/customize/connectors`, or
   switch it off in `/mcp`.

## 2. Add it

If `WHERE-THINGS-LIVE.md` says there's no `claude` command on this PC, prefer the connector
route above; for anything else, tell them what's needed before improvising.

Pick the scope first: `--scope user` if they will want it everywhere (most personal tools),
no flag if it only belongs to the project you're in.

Remote, browser login:

```
claude mcp add --transport http --scope user <name> <url>
```

Local program (everything after `--` is the command that starts it):

```
claude mcp add --transport stdio --scope user <name> -- npx -y <package>
```

`--transport` and `--scope` go before the name. `--env` / `-e` takes several values, so put it
**after** the name (see below). Check what you added with `claude mcp get <name>`.

## 3. Log it in

- **Browser login:** they type `/mcp` in Claude Code, picks the connection, chooses
  Authenticate, and approves in the browser. That's their step. Write it out click by click.
- **A key:** see the next section. Do not ask them to paste a key into the chat.

### When a connection needs a key

A key pasted into the chat is saved in the conversation history. A key passed with `--env`
is saved as plain text in `~/.claude.json`. Avoid both where you can:

1. Tell them exactly where to get the key (the page, the button, which permissions to tick;
   always the fewest that will work).
2. Have them save it as an environment variable themselves, outside the chat. Give them the exact
   steps with the name filled in.
   Start menu → type `environment variables` → "Edit environment variables for your
   account" → under "User variables" press **New** → name `NAME`, value: paste the key → OK.
   (Typing the key into a PowerShell command would save it in PowerShell's history file.)
3. They close Claude completely (the desktop app from its tray icon → Quit, and every
   terminal window) and reopens it. Programs only see variables that existed when they
   started. Check in a new session that the variable exists, without printing it
   (`[bool]$env:NAME` in PowerShell); if it doesn't, go to step 5 rather than guessing.
4. Add the connection with a reference to the variable, not its value. Single quotes stop the
   shell from filling the value in:
   `claude mcp add --scope user <name> -e 'KEY=${NAME}' -- npx -y <package>`
   In PowerShell, single quotes do the same job. Then open the stored entry
   (`claude mcp get <name>`) and confirm it holds the text `${NAME}`, not the key. The docs
   imply references work at user scope but only show them in a project `.mcp.json`; the first
   time you do this, treat it as a test and write the result into this file.
5. If the only way to make it work is a plain-text key in `~/.claude.json`, tell them that's
   where it will sit and let them decide.

A key kept this way (a user environment variable for a connection) is separate from
secrets-kit, which is for a project's own scripts. If secrets-kit's install later asks them to
delete their user environment variables, this one stays: the connection needs it.

## 4. Prove it

1. `claude mcp list` shows it as connected. (`Needs authentication` means step 3 isn't done.)
2. A new session can see its tools. Connections load at session start, so this usually means
   they restart Claude Code.
3. Use it once for something small and read-only, and show them the result.

## 5. Write it down

Add the row to `INVENTORY.md`, a line to `../CHANGELOG.md` with the undo
(`claude mcp remove <name>`; no file backup, and never copy `~/.claude.json` here), and tell them what Claude can now do, especially anything it can
now **change or send** on their behalf.

## The TerraByte Hub (a worked case)

The Hub connection is not added from this playbook. It has its own room, `../07-hub/`, because
it is set up by the Hub add-on (`../07-hub/hub-addon/AGENTS.md`): helper files from the Hub's
Settings -> API page and `secrets add TB_HUB_TOKEN` in step 6, the MCP server in step 7, the
hook in step 8. Take its `claude mcp add-json` line from step 7, never from memory or a note. Its
key sits in secrets-kit as `TB_HUB_TOKEN`, handed to the helper by `run-with-secrets`, never in a
saved environment variable or `~/.claude.json`. It **can change things**: hand off work, post
updates, record wins. Log it that way, and Claude still only posts on the person's ok.
Broken? `../07-hub/CONTEXT.md` has the fixes.

## A tool with its own API key (e.g. an AI or video service)

A key the person's own scripts use (OpenAI, a clipping tool's API) is not a connection: it goes
in secrets-kit (`../../03-Clinic/secrets-kit/`). They make **their own** key in their own account
and run `secrets add <NAME>` in their terminal; Claude calls the script through
`run-with-secrets`, never printing the value. Never use someone else's key: most services'
terms forbid passing keys around. If the service also offers an MCP server, check the docs and
their plan first (many need a paid tier), and log what you find. Don't state API details from
memory: read the docs page first.

## When one is broken

Work down the list. Stop at the first thing that explains it.

1. `claude mcp list` — read the status. `Needs authentication`: redo step 3.
   `Failed to connect`: keep going.
2. `/mcp` in Claude Code → pick it → Reconnect.
3. Local program: run its start command by hand in a terminal and read the error. A missing
   program (`npx`, `uvx`, `node`, `python`) is the usual cause. Use full paths for local scripts.
4. Key-based: check the environment variable exists in a **new** terminal window. Don't print its value.
5. Still stuck: start Claude Code with `claude --debug=mcp` and read the newest file in
   `~/.claude/debug/`.
6. Slow to start: it may be timing out (the limit is 30 seconds). Say so; the fix is the
   `MCP_TIMEOUT` environment variable.

Tell them what was wrong in one plain sentence. If you learned something reusable, add it here.

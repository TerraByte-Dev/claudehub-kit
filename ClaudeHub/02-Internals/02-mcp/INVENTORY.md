# Connection inventory

The record of every MCP connection on this machine. The live list (`claude mcp list`) is the
source of truth; if this file disagrees with it, fix this file.

Added by this kit's own sessions: `terrabyte-hub` (by `../07-hub/`; can hand off work and post updates). Other candidates, none installed by default: their calendar and email (read/draft only), a tool their desk uses, GitHub (via `gh`, see `../06-github/`).

Last checked against the live list: `{{date, filled by setup}}`

| Name | What it lets Claude do | Kind | Scope | Logs in with | Can it change things? | Added | Status |
|------|------------------------|------|-------|--------------|-----------------------|-------|--------|
| | | | | | | | |

How to fill a row:

- **Kind** — `connector` (added on claude.ai), `remote` (a web address), or `local` (a program
  that runs on this computer).
- **Scope** — `user` (all projects), `local` (this one project, private), `project` (saved in
  the project's `.mcp.json`), or `claude.ai`.
- **Logs in with** — `browser login`, `key in env var <NAME>`, or `nothing`. Never the key.
- **Can it change things?** — `read only`, or what it can do: `send email`, `create events`,
  `push code`, `spend money`. This is the column the person should care about.
- **Status** — `working (checked <date>)`, `needs login`, `broken: <one line>`, `removed <date>`.

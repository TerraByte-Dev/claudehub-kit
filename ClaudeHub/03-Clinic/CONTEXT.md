# 03 — Clinic  ·  CONTEXT

> **The toolbox.** Self-contained tools. Each one owns its own `CLAUDE.md` (or `AGENTS.md`) and
> rules; nothing here inherits from the others. Open a tool, use it, leave.

| Tool | Use it when… |
|------|--------------|
| `ICM Doctor/` | starting a new workspace or desk (a work loop, a side-project room, a research stack) and you want it laid out properly, or one has gotten tangled (its `CLAUDE.md` no longer matches its folders). It is the public, scrubbed ICM Doctor: yours to keep and adapt. `01-AIDesktop/02-Work/` uses its create playbook for your first desk |
| `Troubleshooter/` | something on the PC (or an app, or a device) is broken: log it, fix it, keep the fix. Starts empty; its device row gets filled the first time setup runs |
| `secrets-kit/` | a project needs an API key (say, an OpenAI key). It keeps keys in Windows Credential Manager instead of in files Claude can read or commit: they run `secrets add NAME` in a new terminal, Claude runs `run-with-secrets --only NAME <command>`. The Hub key doesn't use it: the Hub add-on's key window (its step 6) stores that one |
| *(not here)* the TerraByte Hub | connecting to the Hub, or making a Hub room, is not done in the Clinic. Open `ClaudeHub\02-Internals\07-hub` in the Code tab and paste `Connect me to the Hub.` |

To use one, open that tool's folder and say what you want. Its `CLAUDE.md` takes it from there.

**secrets-kit is installed by the kit's bootstrap.** To re-install or repair it, follow
`secrets-kit/AGENTS.md`; the files are already here, nothing to download (skip its clone step).

**Updating a tool:** a newer TerraByte kit carries newer copies: paste the kit prompt again (it
upgrades without replacing anything of theirs). Stored keys survive a secrets-kit re-install.
Copy your own `Troubleshooter/02-fixed/` cases across by hand before replacing that folder.

Links: `../CLAUDE.md`

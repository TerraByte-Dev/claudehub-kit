# Where things live

The map of the files Claude Code actually reads. `~` means the person's home folder
(`C:\Users\<name>`, also written `%USERPROFILE%`). The desktop app's Code tab and the terminal
version read the same files.

## This machine

Filled in by setup. Update it when something moves.

| | |
|---|---|
| Operating system | `{{filled by setup}}` (Windows edition + build) |
| How they run Claude | `{{filled by setup}}` (desktop app / terminal / both; is `claude` on PATH?) |
| Shells Claude has | `{{filled by setup}}` (PowerShell always; Bash only if Git for Windows is installed) |
| GPU | `{{filled by setup}}` (from `nvidia-smi`; matters for local video, audio or AI tools) |
| Home folder | `{{filled by setup}}` |
| ClaudeHub | `{{filled by setup}}` (the real path; it should not be under OneDrive) |
| Claude Code version | `{{filled by setup}}` (checked `{{date}}`) |
| This Internals folder | `{{filled by setup}}` |
| ICM Doctor | `{{filled by setup}}` |
| Node | `{{filled by setup}}` (`node -v`; the Hub needs 18 or newer) |
| Hub | `{{filled by the Hub session}}` (connected as, key expires, Hub room path) |

## The live files

| What | Where | Notes |
|------|-------|-------|
| Global instructions | `~/.claude/CLAUDE.md` | Loads in every session. Read once at session start, so an edit shows up in the next session (or after `/clear`). |
| Global settings | `~/.claude/settings.json` | Permissions, hooks, plugins, model, statusline. Strict JSON. |
| Sign-in + connections | `~/.claude.json` (in the home folder itself, not inside `.claude`) | Claude Code's own state, including MCP connections added for "all projects". **May contain tokens. Never copy it here unredacted.** |
| Login credentials | `~/.claude/.credentials.json` | Claude Code's own login. Leave it alone. |
| Skills (all projects) | `~/.claude/skills/<name>/SKILL.md` | |
| Subagents (all projects) | `~/.claude/agents/<name>.md` | |
| Installed plugins | `~/.claude/plugins/` | Managed by `/plugin`. Don't hand-edit. |
| Conversation history | `~/.claude/projects/<folder-name>/` | One file per session. This is what `/resume` reads. |
| Auto memory | `~/.claude/projects/<folder-name>/memory/` | Notes Claude keeps for itself per project. See them with `/memory`. |
| Hub helper | `~/.terrabyte/hub.mjs`, `~/.terrabyte/hub-headers.mjs` | Downloaded from the Hub's Settings -> API page in step 6 of the Hub add-on (`07-hub/hub-addon/AGENTS.md`). `node "$HOME/.terrabyte/hub.mjs" check` tests the connection. Hold no key. |
| Hub files | `~/.terrabyte/files/` | Files fetched from the Hub land here. A download area, not storage. |
| Hub key | secrets-kit (Windows Credential Manager), name `TB_HUB_TOKEN` | The person stores it with `secrets add TB_HUB_TOKEN` in their own terminal (Hub add-on step 6); the `terrabyte-hub` MCP server gets it through `run-with-secrets --only TB_HUB_TOKEN`. Never read, print or copy it. New key: **New token** on the Hub's Settings -> API page, `secrets rotate TB_HUB_TOKEN`, then revoke the old one. |

Per project, inside the project folder:

| What | Where |
|------|-------|
| Project instructions | `CLAUDE.md` (plus a `CONTEXT.md` per room, the ICM way) |
| Project settings | `.claude/settings.json` (shared) and `.claude/settings.local.json` (just this machine) |
| Project connections | `.mcp.json` in the project root |
| Project skills / subagents | `.claude/skills/`, `.claude/agents/` |

## How instructions stack

All of these load together; none replaces another. Later ones are read last.

1. `~/.claude/CLAUDE.md` — the person's global file.
2. `CLAUDE.md` in every folder **above** where Claude Code was started, outermost first.
3. `CLAUDE.md` in the folder where it was started.
4. `CLAUDE.md` in folders **below** load only when Claude opens a file in them.

`CONTEXT.md` files are not loaded automatically. Claude reads them because the person's global
instructions tell it to. `/context` shows what is loaded right now.

## How settings stack

When the same setting appears in more than one place, the more specific one wins:
project `.claude/settings.local.json` → project `.claude/settings.json` → `~/.claude/settings.json`.
One exception: a **deny** rule anywhere always wins.

## Windows notes

- The desktop app does **not** read PowerShell profiles. An environment variable set only in
  `$PROFILE` won't reach it; set it under "Edit environment variables for your account", or in
  the `env` block of `settings.json` (never for a secret).
- A program installed with `winget` isn't on PATH in terminals (or Claude sessions) opened
  before the install, and the desktop app may need a full restart (tray icon → Quit). Before
  deciding an install failed, look in `%LOCALAPPDATA%\Microsoft\WinGet\Links` and
  `%LOCALAPPDATA%\Microsoft\WinGet\Packages`, and call the program by full path.
- `claude` installed with the native installer lives in `%USERPROFILE%\.local\bin` and updates
  itself. If `claude` is "not recognized", that folder is missing from their user PATH.

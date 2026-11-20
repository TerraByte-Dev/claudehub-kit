# Commands and keys worth knowing

You don't need to memorise these. Type `/` in Claude Code to see every command, and `/help`
for the full list. This page is the short version, in the order you'll need them.

Most of this works the same in the **desktop app** and in a **terminal**. In the app, the
**mode picker beside the send button** replaces Shift+Tab and the **stop button** works like
Esc. The last table is terminal-only. If a command here doesn't work where you are, ask
Claude what the equivalent is.

## Keys

| Key | What it does |
|-----|--------------|
| **Esc** | Stops Claude mid-action. Use it freely. |
| **Esc Esc** (input empty) | Opens rewind: go back to an earlier point in the conversation and undo Claude's file edits since then. Doesn't undo commands it ran or anything it sent. |
| **Shift+Tab** | Switches mode: how much Claude checks with you before acting. "Manual mode" = it asks before every change. That's your brake. |
| **`@`** then a name | Points Claude at a specific file. |
| **`!`** then a command | Runs a terminal command yourself, and Claude sees the result. |
| **Ctrl+R** | Searches things you've typed before. |

## Every day

| Command | What it does |
|---------|--------------|
| `/clear` | Starts a fresh conversation in the same folder. Do this between unrelated tasks; Claude works better with less clutter. |
| `/resume` | Reopens an earlier conversation. |
| `/rewind` | Same as Esc Esc. |
| `/model` | Switches which Claude model you're talking to. |
| `/deep-research <question>` | Runs a multi-agent research job: many searches, sources cross-checked, a cited report. On the Pro plan, switch on **Dynamic workflows** in `/config` first. Uses a lot of your plan. |
| `/research <question>` | Your own research skill: same idea, lighter, and files the answer in `01-AIDesktop/03-Research/`. |
| `/usage` | Shows how much of your plan you've used. Long sessions and deep research both eat it. (Other tools' credits are separate: check them in their own dashboards.) |

## When the conversation gets long

| Command | What it does |
|---------|--------------|
| `/context` | Shows how full Claude's working memory is, and which instruction files are loaded. |
| `/compact` | Squashes the conversation into a summary to free up room. Claude does this by itself when it has to; details can get lost, so finish a thought first. |

## Your setup

| Command | What it does |
|---------|--------------|
| `/mcp` | Shows your connections (the Hub's is `terrabyte-hub`) and lets you log in to one. |
| `/memory` | Shows and edits the instruction files Claude loads, and the notes it keeps for itself. |
| `/config` | Opens settings. |
| `/permissions` | Shows the rules for what Claude may do without asking. |
| `/skills` | Lists your skills (saved instruction sets you run with `/name`). |
| `/plugin` | Installs and removes plugins (bundles of add-ons other people built). |
| `/hooks` | Shows your hooks (scripts that run automatically at set moments). |
| `/statusline` | Sets up the info bar under the input box. |

## When something's wrong

| Command | What it does |
|---------|--------------|
| `/doctor` | Checks your installation and suggests fixes. |
| `/status` | Shows your version, model, and account. |
| `/feedback` | Reports a problem to the people who make Claude Code. |
| `/release-notes` | Shows what changed in recent versions. |

## From the terminal, before starting

| You type | What it does |
|----------|--------------|
| `claude` | Starts Claude Code in the current folder. **The folder matters**: it decides which instructions load and what Claude treats as the project. |
| `claude -c` | Continues the last conversation in this folder. |
| `claude -r` | Lets you pick an earlier conversation to reopen. |
| `claude mcp list` | Lists your connections and whether each is working. |
| `claude doctor` | The health check, for when Claude Code itself won't start. |

---

Last checked: October 2026. Source: `https://code.claude.com/docs/en/commands`

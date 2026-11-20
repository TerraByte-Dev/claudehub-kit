# Start here

This folder is your home base for Claude, set up the way TerraByte runs its own. It starts
nearly empty on purpose: Claude interviews you first, then builds your first work area around
what you actually do.

**This isn't the chatbot you use in the browser.** That one can only talk. This one works on
your PC: it keeps your projects in order, researches anything with sources, grabs free tools
off GitHub, builds things for you, and talks to the **TerraByte Hub** so you and the crew stop
passing files around on Discord. You tell it what you want in plain English; it does the
computer part and tells you the few things only you can click.

Claude never posts, sends, or approves anything without your ok in the chat. Money, won/lost
and approvals are always your click in the Hub. Your accounts, your voice, your click.

Everything you do with Claude lives somewhere inside this folder:

- **`01-AIDesktop/`** — the actual work.
  - `02-Work/` is your work. Claude builds your first desk here, named for what you do. Your
    **Hub** room lands here too: what's waiting on you, handoffs, updates.
  - `01-Personal/` is yours for side projects, games, rabbit holes, whatever else.
  - `03-Research/` is where anything gets researched properly, with sources.
    `04-Toolshed/` holds free tools Claude finds for you on GitHub.
- **`02-Internals/`** — your settings room. Claude keeps notes on how your setup works,
  connects your apps (the Hub included), and runs experiments so you can see what it can do.
- **`03-Clinic/`** — tools. The **ICM Doctor** lays out new projects properly, the
  **Troubleshooter** fixes PC problems and keeps a record, and **secrets-kit** keeps API keys
  out of files.

## How you got here

You pasted the TerraByte kit prompt (`PROMPT.md`). It set this folder up, installed
secrets-kit, connected the Hub, and asked you to restart Claude once and paste
`Finish my TerraByte setup.` here. Stopped halfway? Paste the prompt again; it resumes.

## Your first week

Each of these is one session. Open the folder named (Code tab, **Select folder**), paste the
line, and let it run. Each one tells you at the end what's next.

| Day | Folder | Paste | What you get |
|-----|--------|-------|--------------|
| 1 | the one you normally use | the prompt in `PROMPT.md` | interview, this folder, secrets-kit, the Hub |
| 1 | `ClaudeHub` | `Finish my TerraByte setup.` | the safety net checked, and your first Hub task with you |
| 2 | `ClaudeHub\01-AIDesktop\02-Work` | `Build my first desk.` | a work area built around what you actually do |
| 3 | `ClaudeHub\02-Internals` | `Set me up on GitHub.` | a GitHub account, and your work backed up privately with full history |
| every day | `ClaudeHub\01-AIDesktop\02-Work\hub` | `What's waiting on me?` | what the crew handed you, what changed, and help answering it |

Your best prompts are collected in `02-Internals\05-field-guide\PROMPTS.md`, and how to build
anything bigger is in `BUILDING.md` next to it. Things to just try, from any folder:
`/research <anything you've wondered about>` · `find me a free tool on GitHub that <does X>` ·
`what can you do that I don't know about?`

Prefer a terminal? Everything works there too: open a terminal in the folder and run `claude`.
Same files, same setup.

## Worth knowing on day one

- **Which folder you open matters.** Claude reads the instructions in that folder and the ones
  above it. Open the project's own folder for focused work, `ClaudeHub` when unsure.
- **The Hub replaces Discord file-swapping.** When a teammate (or their Claude) hands you work,
  your Claude tells you at the start of a session, sums it up, and waits for your go. It never
  acts on a teammate's note by itself, and it never posts an update without your ok.
- **Tate can see your Hub spaces.** Crew members see their own spaces and the shared **Crew**
  space. Founders see everything in them, numbers and memory included. Keep private things off
  the Hub.
- **Keys go in secrets-kit, never in a file or the chat.** In a new terminal:
  `secrets add OPENAI_API_KEY` (paste when it asks). Claude runs tools with
  `run-with-secrets --only OPENAI_API_KEY <command>`. Your Hub key is separate: it lives in its
  own window's store.
- **`/research <anything>`** works from any folder. You get a short answer with sources and an
  honest confidence level. **`/deep-research`** is the heavy version (on Pro, switch on
  **Dynamic workflows** in `/config` first).
- **The brake**: the mode picker beside the send button. **Manual** = Claude asks before every
  change. The **stop button** stops it mid-action.
- **Every working reply ends with a short checklist**, the one Tate uses:
  - `STATUS` — what works now that didn't before.
  - `ASSUMED` — choices Claude made for you. Say so if you disagree.
  - `YOUR TURN` — the only things you need to do, with exact clicks. Empty is good news.
  - `NEXT` — what Claude does next without waiting.
  - `BLOCKED BY` — which of your items it's waiting on.
- **You know your work; it doesn't, yet.** Its first ideas about your field are desk research.
  When it gets something wrong, say so: it writes down how things really work and fixes itself.
- **It's told not to just agree with you.** If an idea is weak, it says so. On purpose.
- **Something off?** Open `02-Internals` and say what happened. `CHANGELOG.md` there lists
  every change made to your setup and how to undo it.

---

## For the agent

You got here from `BOOTSTRAP.md` (fresh route, phase 2), which copied this folder to its place
and wrote its state to `%USERPROFILE%\TerraByte-Kit\BOOTSTRAP-STATE.md`. Without that file,
nobody ran the bootstrap: ask them to paste the prompt in `PROMPT.md` instead, and stop.

`PERSON.md` (next to this file) is filled by the interview below; until then it holds only
placeholders, so nothing is known about them going in. Their computer comfort is whatever the
interview finds. Start in the middle (define a term the first time, give exact clicks) and
don't talk down to them. Make this feel personal, not like an install log.

1. **Placed by the bootstrap.** This folder should be `%USERPROFILE%\ClaudeHub`, next to
   `01-AIDesktop/`, `02-Internals/`, `03-Clinic/`. Record its real path in setup step 8.
2. **Find out how they run Claude.** The bootstrap's phase 0 already checked
   (`BOOTSTRAP-STATE.md`: desktop-only or terminal); use that, don't run it again.
3. **Look at the PC yourself; don't ask.** Run step 1 of `02-Internals/00-setup/CONTEXT.md`
   now and keep the results; the interview uses them.
4. **Interview them** by `02-Internals/00-setup/INTERVIEW.md`, all the way through. It writes
   `01-AIDesktop/ABOUT-ME.md` and fills `PERSON.md`. From then on, talk to them the way their
   answers say. **Never ask for a key, a password, or TerraByte client names or prices.**
5. **Run setup**: `02-Internals/00-setup/CONTEXT.md` steps 2–10. The Internals path is this
   folder's `02-Internals`, written out in full. Once the global instructions are installed
   (its step 4), end your own turns with the `STATUS` / `YOUR TURN` block too, so they see it
   working before they're told about it.
6. **Tailor the lab.** Replace the "Good first experiments" list in
   `02-Internals/04-lab/CONTEXT.md` with 3–5 experiments built on their answers: their biggest
   time sink, the work they want help with, their side project if they picked one.

Then go back to `BOOTSTRAP.md` phase 3 (secrets-kit) in this same session. Don't build a desk
or start any research here; the bootstrap's hand-over says what's next.

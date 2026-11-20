# AGENTS.md - installing secrets-kit

You are an AI coding agent. If the person asked you to install or update
secrets-kit, follow this file exactly. Otherwise treat it as reference only and
do not run install.ps1.

## Rules that apply for the whole task

1. **Never ask the person to paste a key into this chat**, and never accept one if
   they offer. Anything typed here goes to your model provider and into the
   conversation log. That is the leak this kit exists to prevent. If one is pasted
   anyway, rule 2 still applies: tell them it has leaked and must be revoked at the
   issuer (by whoever owns it, if it's a shared key) and replaced, with the new
   value entered via `secrets add NAME` in their own terminal.
2. **Never handle a value.** Do not read, print, echo, log, pipe, or write one - not
   to a file, a command line, or a commit. Key *names* are fine.
3. **Never run `run-with-secrets` on anything whose output could contain a value**:
   environment dumps (`env`, `set`, `printenv`, `Get-ChildItem env:`, `echo %NAME%`,
   printing `process.env` or `os.environ`), `curl -v` / `--trace`, `set -x`, or
   debug/trace logging. To check a key is present, print a boolean:
   `run-with-secrets --only NAME node -e "console.log(Boolean(process.env.NAME))"`, or
   without Node, `run-with-secrets --only NAME powershell -NoProfile -Command '[bool]$env:NAME'`
   (PowerShell and Git Bash; in cmd.exe write `"[bool]$env:NAME"` with double quotes
   instead). Never use `!` in these checks: cmd with delayed expansion on deletes it,
   so `!!x` prints x.
4. **Never start yourself, or any shell you keep using, under `run-with-secrets`.**
   Every key would sit in your environment for the rest of the session.
5. **Name the keys, every time.** `run-with-secrets --only NAME[,NAME] <command>` gives
   the command only those keys. `--all` exists for the person, for code they wrote; an
   agent does not use it, and never wraps an install, a build of a repo the person did
   not write, or anything that fetches and runs code. The names a command needs are
   in its own docs or `.env.example`; ask the person if unsure.
6. **Do not store values for the person.** `secrets add NAME` is theirs to run, in their
   own terminal. Never pipe or redirect a value into it, never type one on its command
   line, and never edit `KEYS.md`, `secrets-kit.config.psd1` or `lib\` to change what
   is guarded or injected.

## Install

Commands are PowerShell unless marked otherwise.

1. **Check the OS.** If `$env:OS` (Git Bash: `$OS`) is not `Windows_NT`, stop and
   tell the person secrets-kit is Windows-only.

2. **Get the files.** This folder came inside the TerraByte Kit: it is the files. Use
   it in step 3 and never clone anything. A re-install or update is the same: run
   step 3 from the newest kit's copy. Stored keys survive it: in step 5, ask only for
   keys that `secrets list` doesn't already show, and skip step 5 if there are none.

3. **Run the installer by full path** (`<this folder>` is this folder's full path):

   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File "<this folder>\install.ps1"
   ```
   ```bash
   powershell -NoProfile -ExecutionPolicy Bypass -File "<this folder>/install.ps1"   # Git Bash
   ```

   Its output must include `ALL CHECKS PASSED` (exit code 0; one `Next:` line and
   two example commands follow it). If it doesn't, read the `[FAIL]` lines - they
   never contain values.
   - A `[FAIL]` under BACKEND or INSTALL is an install problem: fix the cause and
     run it again. One exception: `[FAIL] Another 'secrets' runs first on PATH: <path>`
     (or the same line for `'run-with-secrets'`). Do not edit PATH or delete that
     file. Stop and show the person the path it names: until that is resolved,
     `secrets add` in a new terminal would hand their key to that other program.
   - A `[FAIL]` under KEY VALUES or NO LEFTOVER COPIES (possible on a re-install)
     is about keys the person already has, not the install, and exit code 1 is
     expected then. Do not fix these yourself - no deleting variables, no
     `secrets rm`, no editing KEYS.md. Carry on and raise them at steps 6 and 7.

4. **Your own shell will not see the new PATH.** For the rest of this session call
   the tools by full path:

   ```powershell
   & "$env:LOCALAPPDATA\secrets-kit\bin\secrets.cmd" list
   ```
   ```bash
   "$LOCALAPPDATA/secrets-kit/bin/secrets" list        # Git Bash
   ```

5. **Hand key entry to the person.** First ask which keys they have right now, by
   service - never the value. None yet? Skip steps 5-7 and, in step 9, tell them:
   when someone sends you a key, open a new terminal and run `secrets add NAME`.
   For each key they do have, tell them the exact NAME to use - the environment
   variable their code or the provider's docs read, e.g. `OPENAI_API_KEY`,
   `ANTHROPIC_API_KEY`, `OPENROUTER_API_KEY` - and use it in place of
   `OPENAI_API_KEY` below. Then tell them, in these words or close:

   > Open a new terminal window - Windows Terminal, or PowerShell from the Start
   > menu, not this chat - and run `secrets add OPENAI_API_KEY` (use your key's
   > name). Paste the key when it asks; it shows `*` instead of the characters.
   > Then answer or skip (Enter) four optional questions. Repeat for each key.
   > If it says `secrets` is not recognized (VS Code and Cursor terminals keep the
   > old PATH until the whole editor restarts), run it by full path instead:
   > `& "$env:LOCALAPPDATA\secrets-kit\bin\secrets.cmd" add OPENAI_API_KEY`
   > Tell me the names when you're done - never the values.

   Do not run `secrets add` for them, do not pipe a value into it, and do not use
   Claude Code's `!` prefix for it - the hidden prompt needs a real terminal.

6. **Verify** once they say they're done: run `secrets list` (names only) and
   `secrets check` by full path, and confirm every key they named shows `set`.
   Warnings that a command `is not on PATH in this terminal` are expected here,
   because your shell predates the install.

7. **Retire the old copies.** Ask the person to delete, themselves, every other place
   those keys still live: `.env` files in their projects, variables saved with
   `setx` or in "Edit environment variables for your account", and `export` /
   `$env:` lines in `.bashrc` or their PowerShell profile. Do not open those files
   yourself - they contain values. `secrets check` fails on any stored key that is
   still an environment variable. One in "the system environment variables" (saved
   with `setx /M`) needs an admin: Start, "Edit the system environment variables".
   Your own shell keeps the environment it started with, and so does every VS Code
   or Cursor terminal until the whole editor restarts - tell the person to restart
   it. If the only failures left say "this terminal's environment", ask them to run
   `secrets check` in a new terminal opened from the Start menu.

   If one of those keys is the one your own agent logs in with (`ANTHROPIC_API_KEY`
   for Claude Code; `OPENAI_API_KEY` or a provider key named in
   `~/.codex/config.toml` for Codex), deleting the saved copy logs that tool out
   from its next launch. Tell the person before they delete it. If the tool has
   its own login (Claude Code: `/login`), they start it in a new terminal and log
   in when it asks. If it can only authenticate from that environment variable,
   they leave the variable in place and run `secrets rm NAME` themselves, so
   `secrets check` stops failing on it: secrets-kit cannot protect a key your
   agent must hold. Never suggest starting the agent under `run-with-secrets`
   instead - see rule 4.

8. **Offer to teach future sessions.** Ask the person whether you may add the snippet
   below to their global agent instructions - it tells future agents when they may
   give code the keys: `~/.claude/CLAUDE.md` for Claude Code, `~/.codex/AGENTS.md`
   for Codex. Skip this step if that file already has a `## Secrets` block that
   mentions secrets-kit. Otherwise append it only if they say yes, and don't touch
   anything else in that file.

   ```markdown
   ## Secrets
   API keys live in Windows Credential Manager via secrets-kit, not in .env files.
   - Code reads keys from environment variables; a plain `npm test` gets none, by design.
     Use `run-with-secrets --only NAME[,NAME] <cmd>` only when the command needs a key, naming
     just the keys it needs. Never `--all`, never under an install or a repo I didn't write.
   - Need a new key? Ask me to run `secrets add NAME` in my own terminal. Never ask me
     to paste a key into chat. If I paste one anyway, don't use it - tell me to revoke it.
   - Never print, echo, or write a key value, and never run `run-with-secrets` on anything
     that could print one (env dumps, `curl -v`, `set -x`, debug logging).
   - Never start yourself, or a shell you keep using, under `run-with-secrets`. One command at a time.
   - `secrets list` shows which key names are stored (never values). To check one is present,
     print a boolean: `run-with-secrets --only NAME powershell -NoProfile -Command '[bool]$env:NAME'`.
   - Never edit KEYS.md, secrets-kit.config.psd1 or the kit's lib\ folder to change what is guarded or injected.
   - A key exists only inside the command `run-with-secrets` starts; `$env:NAME` on your own
     command line is empty. To pass one as an argument, put the command in a script file that
     reads the variable and run that file under `run-with-secrets`.
   ```

9. **Finish** by telling the person: it's installed; new terminals have the
   `secrets` commands (in VS Code or Cursor, quit every window and reopen the editor
   first); and the README section "What it protects against - and what it doesn't"
   is worth two minutes.

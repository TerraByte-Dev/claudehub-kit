# secrets-kit

Keep API keys in Windows Credential Manager instead of `.env` files, so they never
sit in a file your AI agent can read, quote back, or commit.

```
secrets add OPENAI_API_KEY                        # hidden prompt - the value never touches a file or your screen
run-with-secrets --only OPENAI_API_KEY npm run dev # the command gets that key as an environment variable
```

Windows only.

## Install

This copy came inside the TerraByte Kit, whose setup installs it for you. To install
it on its own, use the secrets-kit folder that came in the kit:

**Have your AI do it.** Open Claude Code, Codex, or similar in this folder and paste:

> Install secrets-kit for me from this folder: follow its AGENTS.md exactly.

**Or by hand**, in this folder:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1
```

Its output must include `ALL CHECKS PASSED`. Then open a **new** terminal - PATH
changes only reach terminals opened afterwards, and in VS Code or Cursor a new tab
is not enough: quit every editor window and reopen it. The kit now lives in
`%LOCALAPPDATA%\secrets-kit`.

## Use

```
secrets add OPENAI_API_KEY                   # hidden prompt, then 5 optional questions (Enter skips)
secrets list                                 # names, set/unset, last-set date, [guarded]. Never values.
secrets rotate OPENAI_API_KEY                # shows where to issue a new one, takes the new value
secrets rm OPENAI_API_KEY                    # deletes it
secrets check                                # verifies the setup. Never prints a value.
run-with-secrets --only NAME[,NAME] <command> # runs <command> with just those keys in its environment
run-with-secrets --all <command>             # every key you have stored. Only for code you wrote.
```

Your code reads keys the normal way (`process.env.OPENAI_API_KEY`,
`os.environ["OPENAI_API_KEY"]`). Only commands started through `run-with-secrets`
get them; a plain `npm test` gets nothing, by design - once the old copies are
gone (see "Moving over" below).

**Nothing is injected unless you say which keys.** `--only NAME` names them; a name
may be `CHILD_NAME=VAULT_NAME` when the program wants a different variable name
than the one you stored (`--only GITHUB_PERSONAL_ACCESS_TOKEN=GITHUB_PAT`). `--all`
hands over every key and has to be typed on purpose. Where you cannot pass a flag,
an MCP server entry for example, set `RWS_ONLY=NAME[,NAME]` in that entry's
environment; it means the same as `--only` and is removed before the server starts.
Only keys that are **both** stored and listed in `KEYS.md` are ever injected, and
names that change how programs load or connect (`PATH`, `NODE_OPTIONS`,
`PYTHONPATH`, `HTTPS_PROXY`, `GIT_*`, ...) are refused by `secrets add` and skipped
by `run-with-secrets`, so a credential that something else wrote into the store
is never handed to a child. `run-with-secrets` prints the names it injected, on
stderr, never the values.

**Guarded keys.** Answer `y` to the Guarded question in `secrets add` (or edit the
`Guarded` column in `KEYS.md`) for a key you want a second look at: database owner
URLs, payment and bank keys, hosting master tokens, backup and signing keys.
`run-with-secrets` then shows a Windows dialog naming the command and the keys, and
releases them only on Yes (default No, timeout No). It is a speed bump for an agent
that is doing what it was told, not a lock: anything that can write `KEYS.md` or
`secrets-kit.config.psd1` can take a key off the list, and anything running as you
can read the store directly. Do not guard a key that an MCP server needs at
startup: the dialog makes the server time out.

**Never run `npm install`, `pip install`, a build of a repo you did not write, or
anything that fetches and runs code under `run-with-secrets`.** Every install
script and every program the command starts gets the keys you named. `--all` under
an install is handing every key you own to every package author.

A key exists only inside the command `run-with-secrets` starts: `$env:NAME`,
`$NAME` or `%NAME%` typed on your own command line is expanded by your shell
first, and is empty. To put a key in an argument (a curl header, say), put the
command in a script file that reads the variable and run that. For example
`call.ps1` containing
`curl.exe -s -H "Authorization: Bearer $env:NAME" https://api.example.com/v1/models`,
run as `run-with-secrets powershell -NoProfile -ExecutionPolicy Bypass -File .\call.ps1`.
Never add `-v`.

**Argument quirks** (Windows PowerShell and cmd.exe sit between you and the
command, so a few shapes don't survive):

- From PowerShell, `run-with-secrets` is a `.cmd` file, so cmd.exe reads its
  arguments first. An argument with `&`, `|`, `<`, `>` or `^` and no space must
  carry its own double quotes - `run-with-secrets curl '"https://x.io/?a=1&b=2"'` -
  or cmd cuts it there, and `%NAME%` is replaced by that variable's value.
- From cmd, put those characters inside double quotes (`"a&b"`, `"HEAD^"`): the
  launcher reads its arguments twice, so a `^` escape is used up on the first pass.
- From anywhere: PowerShell refuses an argument that is exactly `-` (`Cannot
  process argument because the value of argument "name" is not valid`, and nothing
  runs), and splits one shaped like `-name:value` (`-p:Configuration=Release`
  arrives as `-p` `Configuration=Release`). Wrap such a command in `cmd /c`:
  `run-with-secrets --only NAME cmd /c "kubectl apply -f -"`. A `cmd /c` line is
  cmd's own script: `%NAME%` in it expands, exactly as `$env:NAME` does under
  `powershell -Command`.
- When the command is a batch file (`npm`, `npx`, anything `.cmd`/`.bat`), its
  arguments are escaped so cmd.exe cannot expand them, and an argument containing
  `%KEY%` or `!KEY!` for a key being injected is refused outright (a batch that
  `call`s with its arguments would expand it). Pass such text through a file instead.

Git Bash has only the last one, and there write `cmd //c` - Git Bash turns a lone
`/c` into `C:/`, and cmd then opens an interactive prompt instead of running the
command: `run-with-secrets cmd //c "kubectl apply -f -"`.

**Moving over from `.env` or `setx`?** After `secrets add NAME`, delete the old
copy: the `.env` line, the saved environment variable, the `export` in `.bashrc`
or `$env:` line in your PowerShell profile. Until you do, the key is still
readable and this kit protects nothing. `secrets check` fails on a stored key that
is still an environment variable. If Claude Code logs in with `ANTHROPIC_API_KEY`,
deleting that variable logs it out: log back in with `/login`. Don't start it
under `run-with-secrets` - that hands your agent every key you have stored. If a
tool can only log in from that environment variable, leave it there and
`secrets rm NAME` - the kit cannot protect a key your agent itself runs on.

Run `secrets add` yourself in a normal terminal window (PowerShell, cmd, Windows
Terminal) - not through an AI chat. The hidden prompt needs a real terminal, and a
key typed into a chat has been sent to the model provider.

`KEYS.md` (in `%LOCALAPPDATA%\secrets-kit`) records what each key is for, who
issued it and where to rotate it. No values. `secrets add` fills it in for you.

## What it protects against - and what it doesn't

It **does** stop:

- an agent reading a `.env`, pasting it into chat, or committing it - there is no
  file (once you delete your old ones)
- keys in shell history or scrollback - input is hidden and no command prints a value
- keys readable off the disk by other non-admin Windows users - Credential Manager
  encrypts them under your login. An admin account on the same PC can still get
  them (for example by running code as you).

It **does not** stop:

- **anything running as you.** Credential Manager never prompts, so any program you
  run can read these keys - including an AI agent that decides to, for example by
  running `run-with-secrets` on a command that prints its environment. The rules in
  `AGENTS.md` keep well-behaved agents away from values; they are rules, not a lock.
  Any skip-permissions or auto-approve mode in your agent voids the kit's protection
  against that agent. A `PreToolUse` hook that denies the obvious command shapes
  (see `AGENTS.md`) still runs in those modes, but it is a tripwire: an encoded
  command or a script that reads the store indirectly walks past it.
- **misuse after a program has a key.** The command you name, and every program it
  starts, gets the keys you listed. Only use it on code you trust, name only the
  keys the command needs, scope keys tightly at the provider, and cap their spend -
  that is what limits the damage.
- **values in memory.** While a wrapped command runs, its values are in that
  process's environment and in `run-with-secrets`' own memory; `secrets list` and
  `secrets check` decrypt values into memory to measure them even though they never
  print one. A crash dump (Windows Error Reporting) of any of those processes
  contains them. If that matters to you, exclude wrapped commands from WER dumps.
- **what the metadata says.** `KEYS.md` holds no values, but a full list of which
  services you use, what each key can do and where to rotate it is a map for an
  attacker. Keep it out of any repository you push and out of screenshots; the
  `Scope` and `Purpose` columns are the sensitive ones.

It also does **not** check your agent's deny rules. `secrets check` can confirm the
rules you list in `secrets-kit.config.psd1` are present in `~/.claude/settings.json`;
whether they are enforced is between you and your agent. A `.env` deny rule covers
`.env` files, not your MCP config (`~/.claude.json`), not `~/.config`, not the
transcript folders; add those yourself.

`secrets add NAME -Stdin < key.txt` reads a **file**. `echo VALUE | secrets add NAME
-Stdin` is refused: by the time it runs, the value is already in your shell history
and, if an agent typed it, in its transcript. Treat such a key as burned.

## Sharing keys with a group

This kit stores keys on one machine. It does not move them between people, and
that hand-off is where group keys usually leak.

- **One key per person beats one shared key.** Mint a separate key for each person
  and cap spend where the provider allows it: per key on OpenRouter; per workspace
  in the Anthropic Console, so give each person their own workspace (keys in one
  workspace share its cap, and the Default Workspace can't be capped). You see who
  spent what, and revoking one person's key doesn't break everyone else.
- **Send a value through a one-time link**: a Bitwarden Send with *Limit views* set
  to 1, or a 1Password share link set to expire after *1 view*. Both default to 7
  days with unlimited views, so change the setting. Not Discord or a group chat -
  those keep it forever. Tell them the exact NAME as well - the environment
  variable the code reads, e.g. `OPENROUTER_API_KEY`; a different name stores fine
  and the code then finds nothing. The recipient runs `secrets add NAME` in their
  own terminal and pastes it into the hidden prompt.
- **If a shared key leaks**, revoke it at the provider first, then send everyone
  the new one to `secrets rotate`.
- Whoever owns the account pays for, and answers for, everything run on its keys.

## Audit it before you trust it

About 900 lines, no dependencies: PowerShell and small cmd/sh launchers,
including about 140 lines of C# inside `CredentialStore.ps1` that call the Windows
Credential Manager API.

| File | Job |
|---|---|
| `lib/CredentialStore.ps1` | the only file that talks to Credential Manager; reads `secrets-kit.config.psd1` (prefix, guard list) as data; holds the list of refused loader names |
| `lib/KeysRegistry.ps1` | reads and writes `KEYS.md` (names and metadata, never values); the guard list |
| `lib/secrets-impl.ps1` | add / list / rotate / rm / check. Its own output goes through one `Say()` function; the only other console output is `Read-Host` prompts and error messages, none of which include a value. It never calls `Get-SecretValue` |
| `lib/run-with-secrets-impl.ps1` | the only caller of `Get-SecretValue`; puts values in the child's environment, prints names only |
| `bin/*.cmd`, `bin/secrets`, `bin/run-with-secrets` | short launchers for cmd/PowerShell and Git Bash: each starts `powershell.exe` by its absolute path and runs the matching `lib\*-impl.ps1` in a new process. Nothing else goes in `bin\` |
| `secrets-kit.config.psd1` | optional, data only (`Import-PowerShellDataFile`): credential prefix, extra guarded names, dialog timeout, deny rules for `secrets check` to look for. `secrets-kit.config.example.psd1` documents it |
| `install.ps1` | copies `bin\`, `lib\` and `KEYS.md` to `%LOCALAPPDATA%\secrets-kit`, adds only `bin\` to your user PATH, deletes any `.ps1` left in `bin\` by an older install |
| `tests/run-tests.ps1` | the test suite. Copies the kit to `%TEMP%`, gives it a throwaway `sktest-*:` prefix and generated values, runs about 50 checks (every leak path above has one), scans every output for the generated values, deletes the throwaway credentials. `-Live` runs names-only checks against a real install |

Run the tests yourself after an update: `powershell -NoProfile -ExecutionPolicy Bypass
-File .\tests\run-tests.ps1`. Four short dialogs appear; do not click them.

## Update / uninstall

**Update:** get the newest TerraByte Kit, then re-run `install.ps1` from its
secrets-kit folder. Your keys and `KEYS.md` are kept.
A `[FAIL]` under KEY VALUES or NO LEFTOVER COPIES is about your keys, not the
update - see "Moving over" above.

**Uninstall:**

1. `secrets rm NAME` for each key in `secrets list` (or delete the `secrets-kit:*`
   entries under Windows Credentials in `control /name Microsoft.CredentialManager`).
2. Delete `%LOCALAPPDATA%\secrets-kit`.
3. Remove the secrets-kit entry from your user PATH (Start, type "environment
   variables for your account", select Path under your user variables, Edit). It
   is stored as a full path ending in `\AppData\Local\secrets-kit\bin`.
4. If an agent added a `## Secrets` block to `~/.claude/CLAUDE.md` or
   `~/.codex/AGENTS.md`, delete that block.

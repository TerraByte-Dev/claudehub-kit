# 06 — GitHub  ·  CONTEXT

> **Backups with history, and the world's free code.** Two words first: **git** is a program on
> the PC that saves snapshots of a folder (a *commit*), so any earlier version can come back.
> **GitHub** is the website that keeps a copy of those snapshots online (a *repository*, or
> repo) and hosts millions of free projects other people share.

## Identity
The person comes here to get set up ("Set me up on GitHub.") and when a project needs backing
up. After setup, every project they care about lives in a **private** repo: a crashed drive or
a bad edit costs nothing. Finding and using other people's projects is
`../../01-AIDesktop/04-Toolshed/`. Sharing work with the crew goes through the Hub, not a repo,
unless a teammate and they agree on a shared repo.

## Set up (first visit)
Facts checked 2026-10-11 (GitHub docs, `gh` manual).

1. **Tools.** `git --version`, `gh --version`. Missing → one ask, then
   `winget install --id Git.Git -e --source winget --accept-source-agreements --accept-package-agreements` and the same with `GitHub.cli`. New programs aren't on
   PATH in this session yet; call them by full path or have them restart the app. If
   `../CHANGELOG.md` records proof test 4 as not run (git was missing then), run it now
   (`../01-harness/PERMISSIONS.md`, test 4) before going on.
   Already have a GitHub account and `gh auth status` says logged in? Skip to step 5.
2. **Their turn — the account** (exact clicks): `github.com/signup` (or "Continue with Google"),
   pick a username they're happy to have public, verify the email GitHub sends. Then
   **Settings → Password and authentication → Enable two-factor authentication** with an
   authenticator app on their phone, and **save the recovery codes** somewhere that isn't this
   PC (a photo in their phone's private album, or paper). Lose phone + codes = lose the account.
3. **Their turn — private email**: `github.com/settings/emails` → tick **Keep my email addresses
   private**. Leave "Block command line pushes" for step 6.
4. **Their turn — log `gh` in.** They open Terminal (Start → type `Terminal`) and paste
   `gh auth login --hostname github.com --git-protocol https --web --clipboard`. It shows a
   code (already copied) and says to press **Enter**: they press Enter, the browser opens, they
   paste the code and click **Authorize**. If it asks "Authenticate Git with your GitHub
   credentials?", they type `Y` and Enter. (They run this one, not you: it waits for keys.)
5. **You**: `gh auth status` (must say logged in), `gh auth setup-git`, then set their identity
   to the private address: `gh api user --jq .id` and `gh api user --jq .login`, and
   `git config --global user.name "<login>"`,
   `git config --global user.email "<id>+<login>@users.noreply.github.com"`. Then, in every
   project already under git, remove any folder-only identity so the new one applies:
   `git config --local --unset user.name` and `git config --local --unset user.email` (an
   error saying there's nothing to unset is fine).
6. **Their turn**: back on `github.com/settings/emails`, tick **Block command line pushes that
   expose my email**. (After step 5, so their first push isn't rejected.)
7. **Back up their first real project folder** (the `ClaudeHub` workspace's text files, or a
   desk) by "Back up a project" below, and show them the repo page. A file with other people's
   names or contact details (leads, customers) needs care: a private repo is fine, **never
   public**, and ask them once before committing it at all (they may prefer it stay local-only).
8. **Write it down**: their GitHub username (never a token) in `../01-harness/WHERE-THINGS-LIVE.md`,
   the changes in `../CHANGELOG.md`.
9. **Hand over.** Their next session: back to their desk in `01-AIDesktop\02-Work\`, or
   `Build my first desk.` there if they haven't yet.

## Back up a project
1. **`.gitignore` first**, before the first `git add`: video, audio, images, `.env`,
   `cookies*.txt`, `02-Internals/01-harness/backups/`, `*.bak-*`, and any downloaded or
   exported media. A video committed even once stays in
   the history forever, a file over 100 MB blocks every push, and repos should stay under 1 GB.
   Media lives on disk, not here.
2. `git init` (if new), `git add -A`, `git status` — read the list: nothing big, nothing secret.
3. `git commit -m "<what this snapshot is>"`.
4. First time: `gh repo create <name> --private --source . --push`. After that: `git push`.
5. Tell them the repo's web address. Log it in the project's `CONTEXT.md`.

**Habits** (their global rules say this too): commit when something works, before anything
risky, and at the end of a session; push after committing. A message says what changed, in a
line.

## Conventions
- **Private by default.** Making a repo public is on their ask-first list. So is committing
  any file with other people's personal details to anywhere but a private repo.
- Never paste or store a GitHub token anywhere; `gh` keeps its login in Windows' credential
  store.
- **Opening an issue or pull request on someone else's project is posting in public**: ask
  first, every time. Some projects ban AI-written ones outright.
- GitHub Desktop (`winget install --id GitHub.GitHubDesktop -e --source winget --accept-source-agreements --accept-package-agreements`) is an optional visual app if
  they want to see their history with clicks instead of asking Claude.

## Links
Free tools from GitHub → `../../01-AIDesktop/04-Toolshed/CONTEXT.md` · Floor plan → `../CLAUDE.md`

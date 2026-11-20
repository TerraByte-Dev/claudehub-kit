# TerraByte Hub add-on

Right now we share work by dropping files in Discord and pasting prompts to each other. This
add-on replaces that. Your Claude and Tate's agents hand work back and forth through the
**TerraByte Hub**: a task, the files, a short note. Each time you open Claude it tells you what's
waiting and what changed, then helps you answer it. Nothing goes out until you say go.

It plugs into the Claude setup you already have. Nothing you have gets replaced.

## What you need

- **Claude Pro or Max**, with **Claude Code** (terminal) or the **Claude desktop app** (its
  **Code** tab).
- **Node 18 or newer.** No Node? Claude installs it for you, after asking.
- **Your Hub sign-in**: your `@terrabytesolutions.com` email (a one-time code goes there), then
  the Hub's own sign-in with two-factor. Code never arrives? Message Tate.
- **You can open your `@terrabytesolutions.com` inbox** (it's Gmail: sign in at
  mail.google.com with that address), and **you've signed in to the Hub once** and set up
  two-factor from Tate's invite. If either one isn't true yet, message Tate before you start.
- **Windows.** On a Mac it still works: Claude uses the Mac/Linux tab on the Hub's Settings -> API
  page instead.

## Set up (about 15 minutes)

1. Unzip this, then put the **`hub-addon`** folder in your **user folder**: open File Explorer,
   type `%USERPROFILE%` in the address bar, press Enter, and drag `hub-addon` in there. Not the
   Desktop or anything under OneDrive. **Mac:** put `hub-addon` in your home folder (Finder >
   **Go** > **Home**) and open Claude there.
2. Open Claude Code in your user folder: in the desktop app, **Code** tab, **Select folder**,
   choose `C:\Users\<you>`. In a terminal, `cd %USERPROFILE%` then `claude`.
3. Paste this and press Enter:

   > Read hub-addon/AGENTS.md and connect me to the Hub.

Claude walks you through it. You'll sign in to the Hub and, if Claude asks, click two download
links on the Hub page. Then you open a new terminal yourself and run `secrets add TB_HUB_TOKEN`
(Claude installs secrets-kit first if you don't have it): paste your key at its hidden prompt,
and nowhere else. Claude does the rest. Click **Allow** when it asks to run something.

**One rule:** your Hub key goes only into `secrets add TB_HUB_TOKEN`, in your own terminal.
Never paste it into the chat. If you do by accident, Claude tells you how to cancel it and make a new one.

Claude never posts, sends, or approves anything without your ok in the chat. Money, won/lost
and approvals are always your click in the Hub.

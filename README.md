# TerraByte Kit

Your own Claude workspace, set up the way TerraByte runs its own:

- **A proper workspace** (the ICM way: numbered rooms, each with a note that tells Claude what
  happens there), plus the **ICM Doctor** to lay out new projects and fix tangled ones.
- **Your API keys kept out of files.** `secrets add` stores a key in Windows Credential Manager;
  Claude runs a tool with it through `run-with-secrets`, so keys never sit in `.env` files,
  chats or commits.
- **Connected to the TerraByte Hub**, so you and the crew hand work back and forth there
  instead of passing files around.

Already have a ClaudeHub, or an older kit from Tate? Same steps. Claude backs up your text and
settings files first (videos, `.git`, `.venv` and `.env` aren't copied; nothing touches them),
adds the kit next to your folders, and proves at the end that nothing of yours moved or changed.

## Set up (Windows 11, about an hour, most of it Claude working; one restart)

You need a **Claude Pro or Max** plan and the **Claude desktop app** (or Claude Code in a
terminal). For the Hub part, your `@terrabytesolutions.com` sign-in from Tate.

1. **Put `TerraByte-Kit.zip` in your Downloads folder.** Or skip this: the prompt downloads it
   from this page.
2. **Open Claude in the folder you normally use it in.** Desktop app: **Code** tab, **Select
   folder**. No such folder yet? Choose your user folder (`C:\Users\<you>`). Then, before you
   paste: click the **mode picker** beside Send and choose **Accept edits** (terminal: press
   Shift+Tab until it says *accept edits on*). That saves you a click on every file Claude writes.
3. **Paste the prompt in [`PROMPT.md`](PROMPT.md)** and press Enter.

Then click **Allow** when Claude asks to run a command (expect about 25; that's normal), answer
a few questions, and paste your Hub key into the window Claude opens for it (never into the
chat). At the end you restart Claude once and paste one line: `Finish my TerraByte setup.`
That last part takes about 10 minutes.

Stopped halfway? Paste the prompt again; it picks up where it left off.

Claude never posts, sends or approves anything without your ok in the chat (money, won/lost and
approvals are always your click in the Hub), and never moves, renames or deletes your files.

## License

MIT (see [`LICENSE`](LICENSE)). The ICM methodology is the work of Jake Van Clief & David
McDermott. The TerraByte name and logo are not licensed for reuse.

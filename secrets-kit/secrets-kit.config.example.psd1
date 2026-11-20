# secrets-kit.config.psd1 - optional. Copy this file to secrets-kit.config.psd1
# next to KEYS.md (the install folder) and edit. Data only: PowerShell reads it
# in restricted mode, so nothing in here can run code. Without this file the kit
# uses prefix 'secrets-kit:' and guards nothing.
@{
    # Credential Manager target prefix. Every key is stored as <Prefix><NAME>.
    # Letters, digits, . _ - and inner colons; must end in a colon. Changing it
    # on an install that already has keys hides them: move them first.
    Prefix = 'secrets-kit:'

    # Keys that need a Yes on a Windows dialog before run-with-secrets releases
    # them (default No; a timeout is No). A speed bump for agents, not a lock.
    Guarded = @()

    # Seconds the dialog waits before answering No. 1..3600.
    GuardTimeoutSeconds = 300

    # Claude Code deny rules that `secrets check` should find in
    # ~/.claude/settings.json. Presence only; the kit cannot verify enforcement.
    DenyRules = @()
}

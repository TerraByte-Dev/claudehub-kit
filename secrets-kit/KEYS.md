# Key registry

**This file contains no secret values and never will.** It answers the question
that actually stops people rotating keys: *which dashboard issued this thing?*
Values live in Windows Credential Manager under `secrets-kit:*`.

`secrets add` and `secrets rotate` maintain the table below. You can hand-edit
it - keep the row shape and leave the marker comments alone.

<!-- keys:begin -->
| Key | Purpose | Issued by | Rotate at | Scope | Last rotated |
|-----|---------|-----------|-----------|-------|--------------|
<!-- keys:end -->

## Filling in "Scope"

The column that earns its keep. Nothing on your machine contains a key once a
program has read it - scoping does. Record the *least* privilege the key can do
its job with, so a rotation restores that intent instead of quietly re-issuing
an admin token:

- read-only where the work is read-only
- one project / one repo / one bucket, never account-wide
- an expiry date if the issuer supports one
- a spend cap if the issuer supports one

## If a key leaks

1. **Revoke it at the issuer.** That is the fix. Everything else is cleanup.
2. Issue a replacement, then `secrets rotate NAME`.
3. If it reached git, rewriting history is *cleanup, not remediation* - assume
   the value was copied the moment it was pushed.

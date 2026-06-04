---
title: Bitwarden CLI
type: reference
status: active
updated: 2026-06-04
description: Command-line client for the Bitwarden password manager, used to read and manage vault items from the terminal.
aliases:
  - bw
tags:
  - domain/security
  - pattern/cli
  - integration/brew-formula
  - provider/bitwarden
links:
  website: https://bitwarden.com/
  repo: https://github.com/bitwarden/clients
  manual: https://bitwarden.com/help/cli/
  brew: https://formulae.brew.sh/formula/bitwarden-cli
covers:
  - Login, unlock, and session-key workflow
  - Fetching secrets for scripts and the terminal
related:
  - "[[04-bitwarden|Bitwarden desktop]]"
---

## Summary
Bitwarden CLI (`bw`) is the scriptable client for the Bitwarden vault. It logs in, unlocks the vault, and reads or writes items — passwords, secure notes, fields — directly from the terminal, returning values as plain text or JSON for piping into other tools.

## Why installed
It puts vault secrets within reach of the shell so credentials never have to be hand-copied out of the GUI. It pairs with the Bitwarden desktop app: the app is the daily driver, the CLI is for pulling a secret into a script or grabbing a password without leaving the terminal.

## Most common use case
Unlocking the vault, exporting the session key, then fetching a single secret — `bw get password <item>` — to feed a command or copy to the clipboard.

## Biggest win
JSON output plus session keys make it fully scriptable. A secret can be fetched at runtime instead of being hardcoded into a config file, which keeps plaintext credentials out of dotfiles entirely.

## How to use
```sh
# One-time: authenticate to your account
bw login

# Unlock and capture the session key (needed for every subsequent command)
export BW_SESSION="$(bw unlock --raw)"

# Pull the vault up to date
bw sync

# Get a single password by item name
bw get password "GitHub"

# Search items and pretty-print as JSON
bw list items --search aws | jq

# Lock the vault when done
bw lock
```

## Future use
`bw send` for sharing one-off encrypted secrets, plus wiring `BW_SESSION` into shell functions so frequently used credentials are one alias away, would deepen the integration. The CLI can also drive automated vault exports for backup.

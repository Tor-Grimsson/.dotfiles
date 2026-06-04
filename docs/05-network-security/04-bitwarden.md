---
title: Bitwarden
type: reference
status: active
updated: 2026-06-04
description: Desktop password manager that stores logins, notes, and secrets in an end-to-end encrypted vault.
aliases:
  - bitwarden
tags:
  - domain/security
  - pattern/gui
  - integration/brew-cask
  - provider/bitwarden
links:
  website: https://bitwarden.com/
  repo: https://github.com/bitwarden/clients
  manual: https://bitwarden.com/help/
  brew: https://formulae.brew.sh/cask/bitwarden
covers:
  - First-run setup and vault unlock
  - Daily use as the primary credential store
related:
  - "[[03-bitwarden-cli|Bitwarden CLI]]"
---

## Summary
Bitwarden is the desktop app for the Bitwarden password manager — a native vault for logins, secure notes, cards, and identities, all end-to-end encrypted behind a master password. It syncs across devices and integrates with the browser extension for autofill.

## Why installed
It is the primary credential store for the machine. Every password lives here rather than in a browser's built-in store or a plaintext file, and it is the daily-driver counterpart to the [[03-bitwarden-cli|Bitwarden CLI]] — the GUI for browsing and editing, the CLI for scripting.

## Most common use case
Unlocking the vault and copying a credential (or letting the browser extension autofill it) when logging into a site or app.

## Biggest win
End-to-end encryption with cross-device sync, plus the open-source codebase. Secrets are encrypted locally before they ever leave the machine, and unlike a browser's password store the vault is portable across every Bitwarden client including the CLI.

## How to use
- First run: sign in with your Bitwarden account, then set the master password — this is the key to the whole vault, so it is never recoverable if lost.
- Unlock: enter the master password (or enable Touch ID under Settings -> Security for biometric unlock).
- Add an item: click the + button, choose Login / Card / Identity / Secure Note, and save.
- Copy a value: click the field's copy icon; the clipboard auto-clears after a short timeout.
- Autofill: install the browser extension and let it fill the matching login.
- Lock: Settings -> Security lets you set an auto-lock timeout so the vault re-locks when idle.

## Future use
Enabling Touch ID unlock and the browser-extension autofill removes most of the friction of using a manager day to day. Bitwarden Send (sharing one-off encrypted secrets) and organization vaults for shared credentials are capabilities not yet used here.

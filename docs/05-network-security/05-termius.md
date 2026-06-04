---
title: Termius
type: reference
status: active
updated: 2026-06-04
description: Cross-platform SSH client with a managed host list, saved credentials, and synced connection settings.
aliases:
  - termius
tags:
  - domain/network
  - pattern/gui
  - integration/brew-cask
links:
  website: https://www.termius.com/
  manual: https://support.termius.com/
  brew: https://formulae.brew.sh/cask/termius
covers:
  - Managing saved SSH hosts and credentials
  - First-run setup and connecting to a server
related:
  - "[[01-nmap|nmap]]"
---

## Summary
Termius is a graphical SSH client that organizes servers, keys, and credentials into a managed host list instead of memorized `ssh` invocations. It offers tabbed terminals, a built-in SFTP browser, port forwarding, and optional encrypted sync of the host list across devices.

## Why installed
It is the front end for SSH access to remote machines — a NAS, a VPS, or a homelab box — without retyping host strings or hunting for the right key. The saved-host list and stored credentials make reconnecting a two-click operation rather than a command to recall.

## Most common use case
Picking a saved host from the list and opening a terminal session to it, with the key and username already attached.

## Biggest win
The managed, syncable host list. Where the plain `ssh` client relies on `~/.ssh/config` and remembered commands, Termius keeps every host, key, jump-host, and port-forward in one organized, searchable place — and the built-in SFTP panel means file transfers happen in the same window as the shell.

## How to use
- First run: create or sign in to a Termius account (required for sync; the host list can stay local otherwise).
- Add a host: New Host -> enter address, port, username, and attach an SSH key or password.
- Add a key: Keychain -> import an existing private key or generate a new pair.
- Connect: double-click a host to open a terminal tab.
- SFTP: open the SFTP tab on a connected host to browse and transfer files.
- Port forwarding: define local/remote forwards under the host's settings for tunneling.

## Future use
Saved SSH config groups, jump-host chains for reaching boxes behind a bastion, and port-forwarding profiles are the obvious next steps. Snippets (saved command sequences run on connect) could automate routine server check-ins.

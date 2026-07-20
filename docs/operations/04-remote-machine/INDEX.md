---
title: Remote machine — working over SSH
type: index
status: active
updated: 2026-07-11
description: Best practices and tooling for doing real dev work on a box you only reach over SSH — the transport layer itself, then editor/git/gh/secrets/collaboration once you're in, and keyless tailnet access from the iPad.
tags:
  - project/dotfiles
  - domain/network
related:
  - "[[operations/01-dotfiles/INDEX|How this repo works]]"
  - "[[03-tailscale-remote-access|Tailscale SSH + mosh]]"
---

# Remote machine — working over SSH

Provisioning a box (`bootstrap-cli.sh`) is one problem; actually *working* on it day-to-day is another. This category is the second one — SSH itself as a toolkit, then the workflow layered on top once you're connected.

**Verified 2026-07-05** — `bootstrap-cli.sh` provisioned a real foreign/SSH box (`acyr@acyr`) end to end: 63 brew formulas, the third-party-tap `workmux` formula (isolated into its own step after a tap-trust bug aborted the whole bundle), pipx/uv tools, every shell/tmux/TPM/claude/nvim/yazi symlink — idempotent on a second run. Two real bugs surfaced and got fixed along the way (the tap-trust isolation, a dead `pdf2image` line). Provisioning detail: [[02-provisioning|How this repo works → provisioning]]. Everything in this category is what came out of then actually *working* on that box.

## Docs here

| # | Doc | Covers |
|---|-----|--------|
| 01 | [[01-ssh-toolkit|SSH toolkit]] | `~/.ssh/config` power features — auto-attach tmux on connect, ControlMaster, ProxyJump, `IdentitiesOnly`, agent forwarding — plus when mosh/autossh/Eternal Terminal/sshrc/sshfs are the better tool |
| 02 | [[02-remote-dev-workflow|Remote dev workflow]] | nvim's clipboard gap over SSH+tmux, git/gh auth without a synced Keychain, unlocking Bitwarden with no GUI, the Claude Code API-key trap, and a two-GitHub-account fork/PR loop for practicing collaboration |
| 03 | [[03-tailscale-remote-access\|Tailscale SSH + mosh]] | Keyless remote shell from the iPad (Blink) over the tailnet — the `tailscaled` daemon (not the sandboxed GUI), the accept-mode SSH ACL, mosh transport, sleep-prevention |

## Related
- [[operations/01-dotfiles/INDEX|How this repo works]] — the bootstrap scripts + repo model this all runs on top of.
- [[05-network-security|Network, remote & secrets]] — the everyday SSH cheat-sheet (basic host config, port-forwards, Tailscale). This category goes deeper on the foreign-box-specific edges that card doesn't cover.
- [[09-tmux-tips|tmux tips & tricks]] — the session-command reference the auto-attach pattern here builds on.

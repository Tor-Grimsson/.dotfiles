---
title: Remote machine — working over SSH
type: index
status: active
updated: 2026-07-05
description: Best practices and tooling for doing real dev work on a box you only reach over SSH — the transport layer itself, and then editor/git/gh/secrets/collaboration once you're in.
tags:
  - project/dotfiles
  - domain/network
related:
  - "[[21-dotfiles/INDEX|How this repo works]]"
---

# Remote machine — working over SSH

Provisioning a box (`bootstrap-cli.sh`) is one problem; actually *working* on it day-to-day is another. This category is the second one — SSH itself as a toolkit, then the workflow layered on top once you're connected.

**Verified 2026-07-05** — `bootstrap-cli.sh` provisioned a real foreign/SSH box (`acyr@acyr`) end to end: 63 brew formulas, the third-party-tap `workmux` formula (isolated into its own step after a tap-trust bug aborted the whole bundle), pipx/uv tools, every shell/tmux/TPM/claude/nvim/yazi symlink — idempotent on a second run. Two real bugs surfaced and got fixed along the way (the tap-trust isolation, a dead `pdf2image` line). Provisioning detail: [How this repo works → provisioning](../21-dotfiles/02-provisioning.md). Everything in this category is what came out of then actually *working* on that box.

## Docs here

| # | Doc | Covers |
|---|-----|--------|
| 01 | [SSH toolkit](01-ssh-toolkit.md) | `~/.ssh/config` power features — auto-attach tmux on connect, ControlMaster, ProxyJump, `IdentitiesOnly`, agent forwarding — plus when mosh/autossh/Eternal Terminal/sshrc/sshfs are the better tool |
| 02 | [Remote dev workflow](02-remote-dev-workflow.md) | nvim's clipboard gap over SSH+tmux, git/gh auth without a synced Keychain, unlocking Bitwarden with no GUI, the Claude Code API-key trap, and a two-GitHub-account fork/PR loop for practicing collaboration |

## Related
- [How this repo works](../21-dotfiles/INDEX.md) — the bootstrap scripts + repo model this all runs on top of.
- [Network, remote & secrets](../00-kol-cli/05-network-security.md) — the everyday SSH cheat-sheet (basic host config, port-forwards, Tailscale). This category goes deeper on the foreign-box-specific edges that card doesn't cover.
- [tmux tips & tricks](../01-shell-terminal/09-tmux-tips.md) — the session-command reference the auto-attach pattern here builds on.

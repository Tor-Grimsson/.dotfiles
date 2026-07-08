---
title: Operations — repo machinery & systems
type: index
status: active
updated: 2026-07-08
description: How this repo itself is built and run — the two-machine model, the agent config, the docs system, remote workflow, CDN snapshot infra, and the wake automation. Machinery, not subject matter (that's documentation/).
tags:
  - project/dotfiles
  - domain/tooling
related:
  - "[[INDEX|docs root]]"
---

# Operations

The **machinery** layer — how the repo itself is built, run, and operated, plus the systems it hosts. Not the tool catalog (that's [[documentation/INDEX|documentation/]]); this is the repo's own moving parts.

| # | Section | What it covers |
|---|---------|----------------|
| 01 | [[operations/01-dotfiles/INDEX|How this repo works]] | The dotfiles repo itself — the two-machine symlink model, and how `bootstrap-cli.sh`/`bootstrap.sh` + `brewfile-cli`/`brewfile-gui` provision a machine (CLI-only for a foreign/SSH box, full for a daily driver). |
| 02 | [[operations/02-claude-agents/INDEX|Claude & Agents]] | The repo's own Claude Code / agent config (`claude/`, symlinked to `~/.claude/` per `ARCHITECTURE.md` §3) — the agent-context protocol, skills, subagents, hooks, and MCP tools. |
| 03 | [[operations/03-kol-docs-system-setup/INDEX|kol-docs system setup]] | The `kol-docs-fm`/`-md`/`-lib` skill trio + packages, and the shared Obsidian vault-config source (`claude/packages/scaffold/02-scaffold-docs/obsidian-shapes/`) repos symlink into. |
| 04 | [[operations/04-remote-machine/INDEX|Remote machine]] | Working over SSH once a box is provisioned — `~/.ssh/config` power features (auto-attach tmux, ControlMaster, ProxyJump, agent forwarding) and alternative tools (mosh/autossh/et/sshrc/sshfs), then the dev workflow on top. |
| 05 | [[operations/05-cdn-r2b2/INDEX|CDN tree snapshots (r2b2)]] | `bucket-tree.sh` snapshots each CDN bucket's file tree (B2 `website`/`vault-media`, R2 `kol-media`) into readable JSON in the dotfiles, refreshed on every write and mirrored to Obsidian + other consumers. |
| 06 | [[operations/06-kol-dash/INDEX|kol-dash]] | The wake-up automation system (`os-mode.sh`/`theme-alarm.sh`, Raycast + `launchd`) plus a map of the three things called "the dashboard" and the always-on iPad kiosk plan. |

## Related
- [[INDEX|docs root]] — top-level router
- [[documentation/INDEX|documentation/]] — the tool catalog & guides

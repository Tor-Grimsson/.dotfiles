---
name: project-dotfiles-two-machines
description: ~/.dotfiles is shared across two Macs of different arch; ~/.claude is symlinked from the repo
metadata: 
  node_type: memory
  type: project
  originSessionId: a43b2656-7bcb-4654-aa60-2d6ff7d33b17
---

`~/.dotfiles` is consumed by **two Macs**: an Intel iMac (brew prefix `/usr/local`, set up first, carries accumulated "ghosts" / stale installs) and an Apple-Silicon MBP (brew prefix `/opt/homebrew`, fresher/cleaner). The `Brewfile` is **unified** (identical on both).

Consequence for editing shared files: **never hardcode a brew prefix** — use the command name (PATH) or `$(brew --prefix)`. Two such bugs were fixed 2026-06-04 (`settings.json` node path, `scripts/transmission_scan.sh` clamscan path).

As of 2026-06-04, `~/.claude/` config is **dotfiled**: `CLAUDE.md`, `settings.json`, `skills/`, `hooks/`, and placeholder `commands/`, `agents/`, `output-styles/` live in `~/.dotfiles/claude/` and are symlinked back. Editing any of those paths edits the repo. `bootstrap.sh` recreates the symlinks. Full audit lives in `~/.dotfiles/TOOLING.md`. See [[feedback-brewfile-mirror]].
---
title: tmux-agent-sidebar
type: reference
status: active
updated: 2026-07-04
description: TPM plugin — a live sidebar showing every AI coding agent's state (Claude Code, Codex, OpenCode) across all tmux sessions and windows.
aliases:
  - tmux-agent-sidebar
tags:
  - domain/shell
  - pattern/tui
  - integration/tpm-plugin
links:
  repo: https://github.com/hiroppy/tmux-agent-sidebar
covers:
  - The prefix e / prefix E toggle
  - What the sidebar actually shows
  - Overlap with workmux's own sidebar command
related:
  - "[[02-tmux|tmux]]"
  - "[[24-workmux|workmux]]"
---

## Summary
`tmux-agent-sidebar` is a TPM plugin that shows real-time status for every AI coding agent (Claude Code, Codex, OpenCode) running across **all** tmux sessions and windows at once — prompts, tool calls, response previews, background shell state, wait reasons, task progress, subagent trees.

## Why installed
Running several agents in parallel (e.g. via `workmux`, one per worktree) means constantly switching windows just to check whether an agent is blocked, still working, or done. This surfaces that across everything at once, without leaving the current window.

## Overlap with workmux — worth knowing
`workmux` ships its **own** `workmux sidebar` command (a compact agent-status view, scoped to worktrees it manages). This plugin is broader — every session/window, not just workmux-managed ones — but the two aren't fully distinct: both are, at core, "an agent-status sidebar for tmux." Worth running both for a bit and keeping whichever one's actually glanced at.

## Setup
Already wired in `.tmux.conf` (section 5):
```tmux
set -g @plugin 'hiroppy/tmux-agent-sidebar'
```
`prefix I` installs it via TPM (or `bootstrap.sh`'s non-interactive `install_plugins` on a fresh machine); `prefix r` reloads after any edit.

Requires tmux 3.0+ (already the case) and optionally the GitHub CLI (`gh`, already in `brewfile-cli`) for PR numbers in the display.

## Cheat sheet
| Key | Does |
|---|---|
| `prefix e` | Toggle the sidebar in the current window |
| `prefix E` | Toggle the sidebar everywhere (all windows) |

## Future use
Claude Code needs registering via its own `/plugin` command for this to see it (Codex/OpenCode use their own separate setup steps — a pane badge for Codex, a symlinked plugin file for OpenCode). Not yet registered — do that before expecting it to show anything for Claude Code sessions specifically.

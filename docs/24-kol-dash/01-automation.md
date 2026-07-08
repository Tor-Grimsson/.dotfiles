---
title: Automation
type: reference
status: active
updated: 2026-07-05
description: How a Raycast hotkey or a launchd clock time turns into a theme flip, a Focus mode, Spotify playback, and a Telegram nudge — the wiring, not the per-flag reference.
tags:
  - project/dotfiles
  - domain/automation
related:
  - "[[INDEX|kol-dash]]"
  - "[[02-process|Process]]"
  - "[[../12-scripts/18-appearance|Appearance & wake automation (full flag reference)]]"
---

# Automation

Per-flag detail lives at [[../12-scripts/18-appearance|12-scripts/18-appearance]] — this doc is the *why this shape* for the two triggers involved.

## Two trigger mechanisms, on purpose

| Trigger | Handles | Why not the other one |
|---|---|---|
| **Raycast global hotkey** (Script Command, `@raycast.mode silent`) | Manual, instant, on-demand actions — toggle theme, run the alarm bundle *right now* for testing | Raycast captures keys system-wide (survives AeroSpace being paused — same reason `Cmd+Alt+Shift+E` re-enables AeroSpace), but macOS's Shortcuts app has **no "Time of Day" automation trigger** (iOS/iPadOS-only, confirmed, never shipped on Mac) — so Raycast can't fire itself on a clock schedule |
| **`launchd` calendar job** | The actual clock-time alarm (`theme-alarm.sh --time HH:MM`) | This is what `launchd` is *for* — no new dependency, matches every other scheduled job in this repo (`dot-sync`, `tg-inbox`) |

## Reused, not reinvented

Every payload action in `theme-alarm.sh` calls something that already existed:

- **Telegram nudge** — the exact same bot/token/chat-id `tg-inbox.sh` already uses (`TG_BOT_TOKEN` in `~/.secrets`). No second bot, no new credential.
- **Focus mode** — `shortcuts run "<name>"`, the macOS Monterey+ CLI bridge into the Shortcuts app. The script only *calls* a Shortcut you've already built (there's no API to create one from a shell script).
- **Spotify** — Spotify's own AppleScript dictionary (`play track "<uri>"`) — no `shpotify` or any other new brew dependency.
- **Theme** — `os-mode.sh`, so the alarm and the manual toggle are always in sync (one flip function, two callers).

## Load-bearing rule, don't relax this

`theme-alarm.sh --time` **only ever writes the plist and prints the load command** — it never runs `launchctl` itself. Same hand-off convention as every other scheduled job in this repo: the user loads it. This isn't a gap to "fix" by auto-running `launchctl` later.

---
title: Appearance & wake automation
type: reference
status: active
updated: 2026-07-05
description: os-mode.sh (Light/Dark toggle, set, relative timer) + theme-alarm.sh (a real clock-time wake-up bundle — theme, Focus, Spotify, Telegram) — both wired to Raycast hotkeys.
tags:
  - project/dotfiles
  - domain/scripts/system
related:
  - "[[INDEX|Scripts index]]"
  - "[[16-capture|Capture pipeline]]"
  - "[[../09-productivity-desktop/01-raycast|Raycast]]"
---

# Appearance & wake automation (`os-` / `theme-`)

| Script | Does | Usage |
|--------|------|-------|
| `os-mode.sh` | Toggle/set macOS Light/Dark, or flip after a relative delay | `os-mode.sh` · `-d`/`-n` · `-t 3h30m` |
| `theme-alarm.sh` | A real clock-time wake-up bundle: theme + Focus + Spotify + Telegram, fired daily by `launchd` | `theme-alarm.sh --time HH:MM …` · `--run` |

macOS only offers Light / Dark / Auto (sunrise-to-sunset) — no custom-time picker anywhere in System Settings, and Shortcuts' "Time of Day" automation trigger is iOS/iPadOS-only (never shipped on Mac). These two scripts are the native-scripting path around both gaps: `osascript` against System Events' `appearance preferences` for the actual flip, `launchd` for the actual clock-time schedule.

## `os-mode.sh` — the core toggle

- (no flag) — toggle Light ↔ Dark right now
- `-d` / `--day` — force Light
- `-n` / `--night` — force Dark
- `-t 3h30m` / `--timer 3h30m` — flip after a relative delay. Backgrounds `sleep` + a self-recursive call via `nohup … & disown`, so it survives the calling process exiting (a silent-mode Raycast hotkey doesn't stay alive to babysit it).

This is a **relative** delay only — for a real "wake me at 7:15am" alarm, use `theme-alarm.sh` instead.

## `theme-alarm.sh` — the wake-up bundle

- `--time HH:MM [--focus NAME] [--playlist URI] [--telegram]` — writes/updates `macos/launchd/com.kolkrabbi.theme-alarm.plist` (`StartCalendarInterval`, daily) and prints the `launchctl bootstrap` command. **Never runs `launchctl` itself** — same hand-off pattern as every other `launchd` job in this repo (see [[16-capture|tg-inbox.sh]]).
- `--run` / `--test` `[--focus NAME] [--playlist URI] [--telegram]` — fires the bundle immediately (`--test` is a plain alias, for a manual dry-run from Raycast without waiting for morning). This is exactly what the scheduled `launchd` job calls.
- `--focus NAME` — `shortcuts run "NAME"`. The script only calls an existing Shortcut (e.g. a "Set Focus" one you've built yourself) — it can't create one; Shortcuts has no create-from-shell API.
- `--playlist URI` — `tell application "Spotify" to play track "<uri>"` (a Spotify URI: `spotify:playlist:…` / `spotify:album:…` / `spotify:track:…`). No new dependency (`shpotify` etc.) — Spotify's own AppleScript dictionary already does this.
- `--telegram` — reuses the **same bot** as [[16-capture|tg-inbox.sh]] (`TG_BOT_TOKEN` from `~/.secrets`, same `TG_CHAT_ID`), one `sendMessage` call. Not a new integration.

## Raycast wiring

`raycast/scripts/` — add the directory once via Raycast → Settings → Extensions → Scripts → **Add Directories**, then record hotkeys per-command (same setup as [[../09-productivity-desktop/05-aerospace|AeroSpace's enable/disable pair]]).

| Script | Title | Mode | Hotkey |
|---|---|---|---|
| `theme-toggle.sh` | Toggle Theme | silent | `Cmd+Alt+Shift+T` |
| `theme-day.sh` | Set Theme: Day | silent | — (search by name) |
| `theme-night.sh` | Set Theme: Night | silent | — (search by name) |
| `theme-timer.sh` | Theme Timer | compact, 1 text argument | — (search by name; Raycast pops the argument field either way) |
| `alarm-test.sh` | Run Wake-Up Alarm Now | silent | `Cmd+Alt+Shift+A` |

Only the two most-reached-for commands (instant toggle, manual alarm test) get a bound hotkey — the rest are one Raycast-search away, same tiering as the rest of this repo's Raycast commands.

## Gotchas

- `--focus`/`--playlist` fail loudly to stderr (not silently) if the named Shortcut doesn't exist or Spotify isn't running — check Raycast's command history if a silent-mode run seems to do nothing.
- `theme-alarm.sh --time` **overwrites** the plist file each time — if it's already loaded, bootout + re-bootstrap to pick up a changed time (the script prints the exact commands).
- Wake-mode is hardcoded to Light (`os-mode.sh -d`) inside `run_bundle` — if you'd rather wake to Dark, that's a one-line edit, not a flag (kept out of the flag surface deliberately — YAGNI until you actually want both).

## Related

- [[16-capture|Capture pipeline]] — the Telegram bot `--telegram` reuses
- [[../09-productivity-desktop/05-aerospace|AeroSpace]] — the Raycast hotkey-binds-a-script pattern this follows
- `docs/24-kol-dash/` — the wider wake-alarm + dashboard system this is one piece of

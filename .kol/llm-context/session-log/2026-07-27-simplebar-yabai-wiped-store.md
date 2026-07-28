# Session: simple-bar "yabai is not running" — wiped localStorage store

**Date:** 2026-07-27
**Agent:** Grim (Fable 5)
**Summary:** simple-bar showed only "yabai is not running" — Übersicht's localStorage store was gone entirely, so the bar booted on stock defaults (stock `windowManager` = yabai). No config problem; the double-pass refresh re-seeded the store from `~/.simplebarrc`. Bar confirmed back by the user.

## Changes Made

### Files Modified
- `docs/documentation/09-productivity-desktop/07-ubersicht.md` — new troubleshooting bullet: the "yabai is not running" symptom → absent LocalStorage dir → stock defaults; fix is `cmd-alt-r` (`bin/ubersicht-refresh` double-pass)

### Diagnosis (no config change needed)
- `~/.simplebarrc` symlink intact, JSON valid, `windowManager: "aerospace"` — repo config was never the problem.
- `~/Library/WebKit/tracesOf.Uebersicht/WebsiteData/LocalStorage` was absent (store wiped, cause unknown — Übersicht update or WebKit data clear).
- Ran `bin/ubersicht-refresh`; store verified re-seeded; user confirmed the bar rendered.

## Current State

### Working
- simple-bar rendering normally on aerospace settings; store warm.

### Known Issues
- Any future store wipe reproduces the same message — one `cmd-alt-r` heals it (now documented).
- Carried from prior sessions: tmux `studio` partial cleanup; Tailscale node-identity confirmation → `06-tailscale-jellyfin.md` sync.

## Next Steps
1. Arcs unchanged: tailscale confirmation → doc sync; next-reboot tmux protocol verify.

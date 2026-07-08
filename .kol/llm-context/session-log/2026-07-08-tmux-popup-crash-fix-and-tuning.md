# Session: tmux popup crash root-caused and fixed + popup tuning

**Date:** 2026-07-08
**Agent:** Claude (Grim)
**Summary:** Diagnosed a real tmux-server-crashing bug in the `prefix C-s` sesh popup (raw `attach-session` from inside the popup's ephemeral client instead of `switch-client`), fixed it, then layered on three follow-ups to the same popup section: a preview error, session-only filtering, a new `prefix C-n` new-session keybind, and smaller popup sizes.

## Changes Made

### Files Modified
- `tmux/.tmux.conf` — `bind C-s` (sesh popup): added `-s`/`--switch` to `sesh connect` (the crash fix — was doing a raw attach from inside the popup's own client; no crash report existed because it's a server wedge, not a segfault). Added `--preview 'sesh preview {}'` (fixes a `bat` error on non-path entries like session name `0` — was inheriting the shell's global file-preview default). Added `-t` to `sesh list` (picker now shows only running tmux sessions, not the full session+zoxide+config blend). Added new `bind C-n` — `command-prompt` for a session name, then `new-session -d` + `switch-client` (same crash-safe pattern), placed next to `bind c` (new window). Shrunk all three popup sizes: `C-t` 75%→60%, `C-y` 90%→75%, `C-s` 60%→50% (sizes are relative to the terminal window, not screen resolution — read as near-fullscreen maximized).
- `docs/01-shell-terminal/17-sesh.md` — synced `-s`/`-t`/`--preview` into the Future-use paragraph and cheat-sheet table, crash root cause noted inline.
- `docs/01-shell-terminal/02-tmux.md` — added `Ctrl-a C-n` to the quick-ref block and a "New session" bullet to the config-highlights list.
- `docs/00-kol-cli/01-cli-cheatsheet.md` — added a "Popups" table (`C-t`/`C-y`/`C-s`/`C-n`) to the tmux section; wasn't documented there before at all.

### Features Added/Removed
- New keybind: `prefix C-n` — create + switch to a new named tmux session.

## Current State

### Working
- User confirmed the sesh popup no longer crashes tmux after the `-s` fix + reload.
- User confirmed the popup CAN be resized/repositioned via mouse (tmux 3.3+: drag the right/bottom border to resize, right-click near a border for a Close/Expand/Center/Convert-to-pane menu) — corrected a wrong claim made earlier in the same session that popups have no mouse interaction at all.

### Known Issues
- None outstanding.

## Next Steps
1. None — arc closed same session, user already reloaded.

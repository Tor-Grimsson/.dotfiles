# Session: Übersicht/simple-bar go-live + shake-out · macOS chrome toggles

**Date:** 2026-07-12
**Agent:** Grim (Fable 5)
**Summary:** The staged Übersicht/simple-bar arc went live (user installed; agent shook out config/state bugs down to a root cause in Übersicht's persistent localStorage), plus a new `cmd-alt` desk-control keybind family (menubar/dock/Übersicht toggles + refresh).

## Changes Made

### Files Modified
- `bin/menubar-toggle`, `bin/dock-toggle` — NEW: osascript auto-hide flips (`set … to not …`); one-time Automation prompt on first press.
- `bin/ubersicht-toggle` — NEW: quit-if-running/launch-if-not. **Gotcha fixed:** macOS process names are NFD — `pgrep -x "Übersicht"` (composed) never matches; match `"bersicht"` instead. ~1s teardown window where a second press is eaten.
- `bin/ubersicht-refresh` — NEW: refresh all widgets **twice** (1s apart) because simple-bar renders one refresh behind its async `~/.simplebarrc` import (`Settings.init()` async vs `Settings.get()` sync at module top).
- `aerospace/aerospace.toml` — 4 binds: `cmd-alt-m/d/u/r` (desk-chrome block after the layout binds).
- `keys/keybinds.md` — new `## #aerospace #macos` section, 4 rows (keys-add discipline).
- `ubersicht/simplebarrc` — the shake-out: `global.windowManager` yabai→**aerospace** (the value sat in a stray top-level key the schema ignores); kol-dark palette into all 16 `themes` slots (pulled from artifact `2fb42b10`: bg `#121215`, fg `#F5EBD8`, muted `#A39A78`, accent `#FFCF33`, ANSI ramp `--k0..k15`); `batteryWidget: false` (desktop iMac → NaN%); reference-conformance pass (refs 13–16): `spacesWidget: false`, `hideWindowTitle: true`, `noColorInData: false` (refs are colorful — monochrome was a wrong extrapolation),  via `.simple-bar__process::before`; `customStyles` = **object** `{ "styles": "…" }` — a bare string silently applies nothing; bar inset = aerospace gaps (top/left 10px, `calc(100% - 20px)`), capsule `rgba(18,18,21,.62)` + 16px blur + radius 6.
- `ubersicht/kol-bookmarks.widget/index.jsx` — `process.env.HOME` → shell-side `$HOME` (no `process` in the WebView).
- Docs synced: `07-ubersicht.md` (keybind pair + worked-example rewrite + updated bump), `07-macos-control.md` (toggles "To build"→Built + bump).
- `llm-plan/01-parking-lot.md` — Übersicht-toggle parked, then removed same session (built).

### Root cause of the config clobber (the big one)
Übersicht's WebView keeps **persistent localStorage** (`~/Library/WebKit/tracesOf.Uebersicht/WebsiteData/…/LocalStorage/localstorage.sqlite3`, key `simple-bar-settings`). simple-bar writes localStorage-derived settings **back to `~/.simplebarrc`** after every import — so a stale cached copy (holding the old string-shaped `customStyles`) overwrote repo-file fixes on every refresh/launch, even cold starts. Fix: quit app → delete the LocalStorage dirs → restore file → relaunch; file re-seeds the store. Verified: file survives launch + double-refresh intact.

## Current State

### Working
- Bar live, kol-dark, reference-matched ( + "Ghostty" pill left, colored blur capsule right, 10px insets), padding confirmed by user.
- All 4 keybinds verified in running AeroSpace; `help-lint` 68/68.

### Known Issues
- kol-bookmarks widget still not click-tested.
-  glyph via CSS `::before` unconfirmed — if tofu, swap to inline SVG.
- simple-bar's settings panel (cmd+click) writes back to `~/.simplebarrc` through the symlink — repo file is live-mutable by design; check diffs before committing.

## Next Steps
1. User triages the nvim map (`claude.ai/code/artifact/f13381d8`) → agent builds the `now` set as a real `nvim/` config.
2. Bookmarks-widget click test + panel tuning pass (copy panel JSON back is automatic now — verify).
3. Parked: ritual v1 · dotfiles workspace layout · `prefix ?` keys-popup · kol-dark emitters.

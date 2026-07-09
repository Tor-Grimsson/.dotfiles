# Session: SketchyBar installed + Sin-cy config ported + AeroSpace-wired

**Date:** 2026-07-09
**Agent:** Claude (Grim)
**Summary:** Installed SketchyBar as an AeroSpace companion bar, ported Sin-cy's bash config (over linkarzu's), recolored to Catppuccin Mocha, wired it to AeroSpace workspaces, and got it live + verified on the iMac.

## Changes Made

### Files Modified / Added
- `sketchybar/sketchybarrc` — **new** entry point: transparent bar, Mocha defaults, sources items, `hotload on`, `--add event aerospace_workspace_change`.
- `sketchybar/colors.sh` — **new** Catppuccin Mocha palette (base `#181825`, focus = mauve).
- `sketchybar/items/{spaces,front_app,clock,tmux}.sh` — **new** item defs.
- `sketchybar/plugins/{aerospace,front_app,clock,tmux}.sh` — **new** updater scripts (`tmux.sh` carried over from the earlier trial).
- `brewfile-gui` — added `tap "FelixKratz/formulae"` + `brew "FelixKratz/formulae/sketchybar"`.
- `bootstrap.sh` — new whole-dir symlink block `~/.config/sketchybar` → `sketchybar/`.
- `aerospace/aerospace.toml` — added `exec-on-workspace-change` (triggers the SketchyBar event, both brew prefixes on PATH) + `outer.top` 10→**42** (clear the bar strip).
- `docs/documentation/09-productivity-desktop/06-sketchybar.md` — **new** catalog doc.
- `09-productivity-desktop/INDEX.md` + root `documentation/INDEX.md` — cat 09 count **5→6**, menu-bar blurb.
- `09-productivity-desktop/05-aerospace.md` — synced: SketchyBar integration section, `outer.top=42` gaps note, reciprocal `related`.

### Features Added
- Menu-bar replacement live: **AeroSpace workspace chips** (dynamic — occupied + focused, mauve highlight, click-to-jump), front app, tmux windows, clock.
- AeroSpace → SketchyBar event pipeline (custom event + `exec-on-workspace-change`).

## Current State

### Working (verified on the iMac)
- Bar renders after an AeroSpace restart; all 6 occupied workspaces draw chips (`1 B M P T W`), focused mauve.
- front_app / clock / tmux all populate; `ghostty +show-config`-equivalent parse clean.
- Reload via `sketchybar --reload ~/.config/sketchybar/sketchybarrc`; hotload on for auto-apply.

### Known Issues / gotchas
- **tmux item shows WINDOWS, not sessions** — user asked for sessions; deferred to next session (swap `tmux list-windows -a` → `tmux list-sessions` in `plugins/tmux.sh`).
- **bash 3.2** — macOS `/bin/bash` lacks `mapfile`; fixed `plugins/aerospace.sh` to portable word-split. Keep plugins bash-3.2-safe.
- Bare `sketchybar --reload` no-ops if the daemon was launched configless — pass a path or `brew services restart sketchybar`.
- AeroSpace CLI/server version mismatch surfaced this session — resolved by restarting AeroSpace.
- `font-sketchybar-app-font` not installed → `front_app` shows the plain name, no app glyph.

## Next Steps
1. **Flip tmux item to sessions** (what was actually asked).
2. Flesh out the bar — volume, wifi, and a now-playing item (this machine runs mpd/rmpc). Battery is moot on the iMac.
3. Install `font-sketchybar-app-font` for real app icons.
4. **MBP:** `brew bundle --file brewfile-gui` + bootstrap re-run to install + symlink there.

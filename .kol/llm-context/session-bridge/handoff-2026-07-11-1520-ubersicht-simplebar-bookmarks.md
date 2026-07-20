# Handoff — Übersicht/simple-bar staged, SketchyBar archived, bookmarks widget v1

**Written:** 2026-07-11 ~15:20 · **Agent:** Grim (Fable 5) · context clearing after this; next session regroups here.

## Goal of the arc
Replace SketchyBar with Übersicht + simple-bar (the reference look: naked bar,  + app pill left, one capsule right) and start the sticky-widget idea with a v1 bookmarks widget — all repo-staged; the user runs the install.

## What landed (this session's tail)
- **SketchyBar archived, not deleted:** `sketchybar/` → `_archive/sketchybar/` + `_archive/README.md` (mining map: widget shell logic, power popup, palette). bootstrap's `[ -d ]` guard self-heals; docs marked superseded (06-sketchybar + category INDEX).
- **Übersicht staged:** `brewfile-gui` — sketchybar formula+tap commented, `cask "ubersicht"` added. `aerospace.toml` exec-on-workspace-change now osascript-refreshes simple-bar (no-op-safe until installed). `bootstrap.sh` symlinks `ubersicht/simplebarrc → ~/.simplebarrc` + `kol-bookmarks.widget` into the Übersicht widgets dir.
- **`ubersicht/simplebarrc`** — seed config: aerospace WM, naked bar (`noBarBg`), compact, JetBrains Mono, widget picks matching the reference capsule.
- **`ubersicht/kol-bookmarks.widget/index.jsx`** — v1: reads `tmux/bookmarks.txt` (same data as `prefix C-b`), URLs→browser, paths→reveal; kol-dark, flat per the no-claude-borders doctrine; heavily commented as the widget template.
- **Doc:** `docs/documentation/09-productivity-desktop/07-ubersicht.md` — framework anatomy (the 4-export contract), best practices, two worked examples (simple-bar consumed, kol-bookmarks authored), troubleshooting.

## User runs to go live (not yet run)
1. `brew install --cask ubersicht`
2. `git clone https://github.com/Jean-Tinland/simple-bar "$HOME/Library/Application Support/Übersicht/widgets/simple-bar"`
3. `bash ~/.dotfiles/bootstrap.sh` (symlinks) · `brew services stop sketchybar` (+ uninstall when ready) · `aerospace reload-config`
4. Übersicht menubar → Refresh all; cmd+click the bar → tune → copy JSON back into `ubersicht/simplebarrc`.

## Untested / watch
- kol-bookmarks.widget is **unrun** (no Übersicht on this machine yet) — expect a JSX shake-out pass in the debug console; `process.env.HOME` in the widget may need replacing with a literal.
- simplebarrc keys mirror simple-bar's settings sections but the exact schema should be reconciled against the settings panel's export on first run.
- `~/.config/sketchybar` symlink now dangles on both machines — harmless; remove when uninstalling.

## Next arc (after regroup)
1. User triages the nvim map (`claude.ai/code/artifact/f13381d8`) → build the `now` set as a real `nvim/` config.
2. Bar go-live + widget shake-out (above).
3. Then from the plan: ritual v1 (`login`/`close` + tracking) · dotfiles workspace layout · `prefix ?` keys-popup · kol-dark emitters once the palette is blessed.

## Artifacts (live)
- the desk (6 views): `claude.ai/code/artifact/67803a9b` · nvim map (triage): `claude.ai/code/artifact/f13381d8` · kol-dark theme: `claude.ai/code/artifact/2fb42b10`

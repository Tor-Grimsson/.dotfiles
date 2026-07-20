---
title: Übersicht + simple-bar — the widget engine & the menu bar
type: guide
status: active
updated: 2026-07-14
audience: internal
description: Übersicht as the desktop-widget framework (JSX widgets in a WebView layer), simple-bar as the menu bar riding it, and how to author our own widgets — anatomy, best practices, and three worked examples (simple-bar consumed, kol-bookmarks + kol-notes authored).
aliases:
  - ubersicht
  - simple-bar
tags:
  - domain/tooling
  - pattern/tui
related:
  - "[[INDEX|Productivity & desktop]]"
  - "[[06-sketchybar|SketchyBar (archived)]]"
  - "[[05-aerospace|AeroSpace]]"
---

# Übersicht + simple-bar

## Purpose

One engine, two jobs: **[Übersicht](https://github.com/felixhageloh/uebersicht)** renders JSX widgets onto the desktop (a WebView layer between wallpaper and windows), **[simple-bar](https://github.com/Jean-Tinland/simple-bar)** is the menu bar built on it — AeroSpace-aware, made of predefined blocks, the look from our reference shots (`_tmp/kol-terminality-refs/13–16`). Replaces SketchyBar (archived → `_archive/sketchybar`, mine its `plugins/*.sh` for data logic).

## In-point (install chain)

```sh
brew install --cask ubersicht          # brewfile-gui line exists — user runs
# simple-bar = a git clone INTO the widgets folder:
git clone https://github.com/Jean-Tinland/simple-bar \
  "$HOME/Library/Application Support/Übersicht/widgets/simple-bar"
bash ~/.dotfiles/bootstrap.sh          # symlinks ~/.simplebarrc + kol-{bookmarks,notes}.widget
# then: menubar icon → Übersicht → Refresh all widgets
```

- Daily driving is keybound (`keys aerospace macos`): **cmd-alt-u** open/close (`bin/ubersicht-toggle`) · **cmd-alt-r** refresh, double-pass because simple-bar imports `~/.simplebarrc` one refresh behind rendering it (`bin/ubersicht-refresh`).

- Settings: **cmd+click the bar** opens simple-bar's own panel; it persists to localStorage. Our seed/override lives at `ubersicht/simplebarrc` (symlinked to `~/.simplebarrc`) — after tuning in the panel, **copy the JSON back into the repo file** so git stays truth.
- AeroSpace: `aerospace.toml`'s `exec-on-workspace-change` now osascript-refreshes simple-bar's spaces widget (harmless no-op until installed).
- The reference look = `noBarBg: true` (naked bar, wallpaper between the left pill and the right capsule) + `compactMode`.

## The framework — a widget's anatomy

A widget = one folder with `index.jsx` in `~/Library/Application Support/Übersicht/widgets/`. Übersicht runs it with React; **four exports are the whole contract**:

| Export | What it is | Rule of thumb |
|---|---|---|
| `command` | shell string (or function) producing the data; stdout arrives in `render` as `output` | do the heavy lifting HERE, in shell — jq/awk/cat, not JS |
| `refreshFrequency` | ms between re-runs, or `false` for manual-only | as slow as honest: a file 30s, a clock 1s, static `false` |
| `className` | an emotion CSS template string — **positions** the widget (`top/right/width…`) | position here, style the internals inline/in-JS |
| `render({output, error})` | pure JSX over the output | parse defensively — output is a raw string, may be empty |

Interactivity: `import { run } from "uebersicht"` → `onClick={() => run('open "…"')}` executes shell from the widget. There's also `init/updateState/command(dispatch)` for advanced state, but v1 widgets don't need them.

## Best practices (learned + upstream)

- **Files are the API here too** — point `command` at data that already exists (`bookmarks.txt`, a vault `.md`), never build a daemon for a widget.
- **Cheap commands** — `command` runs every refresh, forever; `cat`/`jq` yes, network calls rarely (and long `refreshFrequency` when you must).
- **Fail soft** — `2>/dev/null || true` in the command; branch on `error`/empty in render. A widget that throws renders nothing and tells you nothing.
- **Style doctrine** — flat: hairline dividers, block hovers, **radius only at the window level (4px)** — no cards, no pills ([[06-sketchybar|the old bar]] carried the same discipline in shell).
- **One widget folder = one concern**; share data via the filesystem, not imports.
- Debug: Übersicht menubar → *Open Debug Console* (a full web inspector — `console.log` works).

## Worked example 1 — consuming: simple-bar

We author **zero** bar code; we configure blocks. `ubersicht/simplebarrc` picks: spaces (aerospace) + process left, cpu/mic/sound/wifi/time capsule right (battery off — desktop iMac), `noBarBg` for the naked look, `noColorInData` for the monochrome capsule, JetBrains Mono 14px, and the **kol-dark palette** filled into `themes` (bg `#121215` · fg cream `#F5EBD8` · accent `#FFCF33` · ANSI ramp from the theme artifact). That file IS the example — every key mirrors a section of simple-bar's settings panel.

## Worked example 2 — authoring: kol-bookmarks.widget (v1)

`ubersicht/kol-bookmarks.widget/index.jsx` — the sticky-widget idea's first cut, and deliberately tiny:

- **Data:** the SAME `tmux/bookmarks.txt` the `prefix C-b` popup reads — desk widget and tmux picker can't drift. Add entries with `prefix B` / `prefix A`.
- **Behavior:** URLs → `open` (browser); paths → **copy to clipboard** in the listed `~` form, shell-pasteable (was `open -R` reveal in v1 — user call 2026-07-15). Grouped under `paths` / `links` hairline headers; themed via kol-theme with a kol-dark fallback. Click-tested 2026-07-14 (v1 actions) + 2026-07-15 (clipboard, via the local server).
- **The contract in action:** `command` = `cat`, `refreshFrequency` = 30s, `className` = position top-right under the bar, `render` = split/filter/map. ~70 lines, half comments — written to be the template you copy for widget #2.
- **v2 parked:** raindrop links section, path→nvim (needs a ghostty/tmux hand-off), vault-backed store.

## Worked example 3 — authoring: kol-notes.widget (v1)

`ubersicht/kol-notes.widget/index.jsx` — widget #2, copied from the template above; the sticky-widget idea's notes half, read-only:

- **Data:** the SAME `kol-vault/desk-notes.md` the **cmd-alt-n** sticky edits (`bin/notes-toggle`) — desk display and editor can't drift. Writing happens in nvim; this just shows it, refreshed every 10s.
- **Render:** minimal markdown — `#` lines → yellow hairline heads, `- [ ]`/`- [x]` → `□`/`■` (done = muted), blank lines → spacers, everything else verbatim. Untouched `# desk notes` seed renders as the empty state.
- **Position:** same right gutter, **linked below kol-bookmarks**: anchored at the same `top: 48px`, and render computes kol-bookmarks' height from the shared `bookmarks.txt` and margin-tops itself under it — constant 12px gap however long the list grows (the wrapper gets `pointer-events: none` so the overlay doesn't eat bookmark clicks; the card re-enables them). Height math mirrors kol-bookmarks' type metrics — change one, update the other. `max-height: 420px` overflow-hidden so a long note doesn't run down the desktop.

## Troubleshooting

- **Nothing renders** → Übersicht menubar → Refresh all; then Debug Console for the actual error.
- **simple-bar shows "loading"** → its widgets folder name must be exactly `simple-bar`; check `windowManager: "aerospace"` in `~/.simplebarrc`.
- **simple-bar shows a JSON error in `index.jsx`** (hit 2026-07-15 when Übersicht became a login item) → launchd launches apps with a brew-less PATH, so the stock `aerospacePath: "$(which aerospace)"` resolves **empty** → `lib/scripts/init-aerospace.sh` emits `"displays": ,` → parse error. It only ever worked before because Übersicht inherited a brew-aware env from its manual launch. Fix in `~/.simplebarrc`: `"aerospacePath": "$(PATH=/opt/homebrew/bin:/usr/local/bin:$PATH which aerospace)"` — both arch prefixes, same idiom as the user widget. An env-prefix value (`PATH=… aerospace`) does NOT work: the init script receives the value as `$1` and execs it as a bare command. If a settings edit doesn't stick after relaunch, the localStorage store wrote the old copy back — quit, delete `~/Library/WebKit/tracesOf.Uebersicht/WebsiteData/LocalStorage`, relaunch (file re-seeds the store).
- **Spaces don't update on switch** → the aerospace `exec-on-workspace-change` osascript; test it raw in a shell.
- **Fonts wrong** → Übersicht renders with system WebKit: any installed font works; we name JetBrains Mono directly.
- **Wifi widget shows `<redacted>`** → macOS Sequoia treats the SSID as location data; `system_profiler` redacts it for any process without Location Services (Übersicht never requests it). Fixed 2026-07-15 with `networkWidgetOptions.hideNetworkName: true` — icon-only.
- **Process widget lags / shows the previous app** → the bar doesn't poll (`refreshFrequency = false`); it only redraws when an aerospace hook refreshes widget id **`simple-bar-index-jsx`** (this version is ONE widget — the old `…spaces-widget…` id silently refreshed nothing). Both `exec-on-workspace-change` and `on-focus-changed` in `aerospace.toml` now target it (fixed 2026-07-15).
- **Process widget missing entirely after a relaunch** (diagnosed 2026-07-15) → first-load race: `index.jsx` builds its init command **once at module load** from localStorage (`Settings.get()` is sync; the `~/.simplebarrc` import `Settings.init()` is async, un-awaited). A cold or wiped store boots that cycle on the baked-in default `/opt/homebrew/bin/aerospace` (wrong prefix on Intel) → the same `"displays": ,` parse error as above, and the widget stays gone until an aerospace-hook refresh re-mounts it with the store warm. Self-heals on the first workspace switch; steady-state is fine once localStorage holds the real settings — no config change needed. Bisect trick: open `localhost:41416` in a browser — first load reproduces the error, reload renders the widget.
- **Workspace letter in the bar** → a user widget (`userWidgetsList."1"`) echoes `(#)` from `aerospace list-workspaces --focused`, 2s refresh + the focus-hook refreshes. Both brew prefixes on PATH inline (Übersicht's shell env is minimal). **Two burn-marks:** `refreshFrequency: false` feeds `setInterval(…, 0)` → a command flood that chokes the whole bar (use a real number); and under `widgetsBackgroundColorAsForeground` the widget's `backgroundColor` IS its text color — empty = bar-background = invisible ink; use a palette var like `--accent`.

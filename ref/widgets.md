# desk widgets — quick reference

Filter with `ref widgets <tag …>` (e.g. `ref widgets bar`, `ref widgets refresh`, `ref widgets gotcha`).

## #bar #simplebar
config          ubersicht/simplebarrc  →  ~/.simplebarrc (symlink — always write THROUGH it)
source          ~/Library/Application Support/Übersicht/widgets/simple-bar/
settings UI     cmd+click the bar (empty workspace) → cmd+, — copy the JSON back into the repo file after
type            14px JetBrains Mono (global.fontSize)
workspace (T)   userWidgets.userWidgetsList."1" — 2s refresh + the focus hooks
theme           kol-theme merges the active theme's simplebar block into .themes

## #bookmarks #widget
widget          ubersicht/kol-bookmarks.widget/  (symlinked into Übersicht's widgets/)
data            tmux/bookmarks.txt — SAME file as the tmux picker
click           URL → browser · path → clipboard (~-form)
add             tmux: prefix B (cwd) · prefix A (typed) · prefix C-b (picker)
edit            cmd-alt-b → nvim sticky on bookmarks.txt (bin/bookmarks-toggle, floating)
type/geometry   12px/17px, headers 11px · width 280 · top 48

## #notes #widget
widget          ubersicht/kol-notes.widget/
data            ~/dev/projects/kol-vault/desk-notes.md — SAME file the sticky edits
edit            cmd-alt-n → nvim sticky in kitty (floating); the widget is read-only
linked          sits 12px below bookmarks — computes its height from bookmarks.txt (bmOffset/GAP in index.jsx)
type/geometry   12px/17px, headers 11px · width 280 · top 48 + computed margin

## #ubersicht #refresh
refresh         menubar → Refresh all — TWICE for bar settings changes (rc import first, render second)
debug           menubar → Debug Console (native WebView errors)
browser repro   http://localhost:41416 — external-browser copy of every widget
cadence         bookmarks 30s · notes 10s · bar never polls — aerospace hooks only

## #aerospace #layout
gutter          outer.right = 304 — widgets (280 + 12 margin) + 12px gap to the tiles
top align       outer.top = 48 — window tops level with the widget column
hooks           exec-on-workspace-change + on-focus-changed → refresh simple-bar-index-jsx
reload          aerospace reload-config

## #theme #kol-theme
switch          kol-theme <name> — ghostty · kitty · tmux · nvim · btop · widgets · bar
current         ~/.config/kol-theme/current (symlink); widgets cat colors.json every refresh

## #gotcha
first-load race   the bar bakes its aerospace command at module load; cold localStorage = one boot on
                  /opt/homebrew defaults → process widget blank; a workspace switch recovers (2026-07-15)
write-back seam   the settings panel writes localStorage AND ~/.simplebarrc — the repo file is truth
no blur           widget cards use near-solid bg (0.96): the WebView won't backdrop-blur them
PATH              Übersicht is a login item → brew-less PATH; commands must inline both brew prefixes

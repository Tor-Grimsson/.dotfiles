# desk — quick reference

Filter: `ref-desk <word …>` · the out-of-terminal layer: aerospace · raycast · übersicht widgets
modifier note: aerospace = ctrl-alt (alt stays free for the terminal) · reload = service mode → esc

## aerospace — focus

| keys             | does                                |
|------------------|-------------------------------------|
| ctrl-alt-h j k l | focus window ← ↓ ↑ →                |
| ctrl-alt-tab     | previous workspace                  |

## aerospace — move

| keys                   | does                          |
|------------------------|-------------------------------|
| ctrl-alt-shift-h j k l | move window ← ↓ ↑ →           |
| ctrl-alt-minus / =     | resize −50 / +50              |
| ctrl-alt-shift-tab     | workspace → next monitor      |
| ctrl-alt-cmd-← →       | WINDOW → prev / next display  |

## aerospace — workspace

| keys                 | does                                     |
|----------------------|------------------------------------------|
| ctrl-alt-1–9         | go to workspace N                        |
| ctrl-alt-LETTER      | T term · B browse · P design · O obsidian |
| ctrl-alt-shift-…     | move focused window there                |

## aerospace — layout

| keys            | does                              |
|-----------------|-----------------------------------|
| ctrl-alt-slash  | tiles: toggle horiz/vert          |
| ctrl-alt-comma  | accordion: toggle horiz/vert      |
| cmd-alt-g       | grid 2×2                          |
| cmd-alt-s       | main + stack                      |
| cmd-alt-shift-f | fullscreen                        |

## aerospace — rules

| keys      | does                                                    |
|-----------|---------------------------------------------------------|
| pfx C-w   | aero-add — a rule + its toggle form    |
| col 3     | live rule · `—` none · `*` extra conds |
| 1         | row 1: float ⇄ snaps (mutually exclusive)               |
| 2         | row 2: workspace — next key is letter  |
| 2 ⌫ or -  | remove the workspace · float stays                      |
| d         | clears BOTH — no rule, snaps anywhere  |
| enter     | WRITE the file · form stays · no reload|
| r         | reload aerospace — the only live step  |
| q / esc   | back to the list · esc there closes the popup           |
| protects  | hand-written asks y/n · `*` never auto |

[e] state only · `aero-add --list`
[e] one app    · `aero-add --show <id>`
[e] no picker  · `aero-add md.obsidian O float`
[e] preview    · `aero-add --dry-run <id> <target>`

## aerospace — panels

Some windows wear another app's bundle id. A rule written for the app
catches the panel too — only a title guard separates them.

| the trap        | fact                                       |
|-----------------|--------------------------------------------|
| Quick Look      | reports as com.apple.finder — an XPC       |
|                 | service on Finder's behalf                 |
| the tell        | window title is literally `Quick Look`     |
|                 | — NOT the previewed filename, so stable    |
| the symptom     | spacebar-preview jumped monitors and took  |
|                 | that monitor's workspace with it           |
| the cause       | Finder's `move-node-to-workspace W` fired  |
|                 | on the panel; a workspace lives on ONE     |
|                 | monitor, so both moved                     |
| the guard       | `if.window-title-regex-substring` rule     |
|                 | ABOVE the app rule — first match wins      |
| find any panel  | list-windows, not list-apps — a panel is   |
|                 | not an app, it has no entry there          |

[e] catch it · `aerospace list-windows --monitor all --app-bundle-id <id>`
[e] title too · add `--format '%{app-bundle-id} | %{window-title}'`
[e] the panel must be OPEN — transient, gone when you dismiss it

## aerospace — mode

| keys             | does                                       |
|------------------|--------------------------------------------|
| ctrl-alt-shift-; | service mode (esc reloads config)          |
| cmd-alt-shift-r  | resize mode (hjkl · b balance · esc out)   |
| cmd-alt-shift-d  | aerospace OFF                              |

----
doc: docs/documentation/09-productivity-desktop/05-aerospace.md

## raycast

| keys | does                            |
|------|---------------------------------|
| ⇧⌥⌘E | aerospace ON (it can't self-on) |
| ⇧⌥⌘T | toggle OS light/dark            |
| ⇧⌥⌘A | run wake-up alarm now           |

----
doc: docs/documentation/09-productivity-desktop/01-raycast.md

## rectangle — snaps

Replaced Magnet 2026-08-01. Snaps FLOATING windows only — aerospace re-tiles
anything else back. Set in macos/defaults.sh, not a GUI.

| keys              | does                                     |
|-------------------|------------------------------------------|
| ctrl-alt-← →      | half left / right                        |
| ctrl-alt-↑ ↓      | half top / bottom                        |
| ctrl-alt-⏎        | almost maximize — the gapped one         |
| ctrl-alt-⌫        | restore pre-snap size                    |
| cmd-ctrl-u i j k  | quarter NW / NE / SW / SE                |
| cmd-ctrl-d f g    | third left / center / right              |
| cmd-ctrl-e t      | two-thirds left / right                  |
| cmd-ctrl-c        | centre, keeps size                       |

arrows/⏎/⌫ are Magnet's exact chords — those were never contested. The ten
LETTERS moved to cmd-ctrl because aerospace owns ctrl-alt-u i j k d f g e t c.

## rectangle — geometry

Every setting is a `defaults` key, which is why it is tracked at all. The
numbers MIRROR aerospace [gaps] so a floated window lines up with a tiled one.

| key                          | value | is                        |
|------------------------------|-------|---------------------------|
| gapSize                      | 24    | gutter BETWEEN windows    |
| screenEdgeGapTop             | 48    | = aerospace outer.top     |
| screenEdgeGapRight           | 304   | = aerospace outer.right   |
| screenEdgeGapLeft/Bottom     | 10    | = aerospace outer.left    |
| screenEdgeGapsOnMainScreenOnly | true | 304/48 on the iMac only  |
| applyGapsToMaximize          | 2     | else Maximize fills edge-to-edge |

[e] the source of truth · `macos/defaults.sh` § Rectangle
[e] no per-DISPLAY values — main-vs-rest is as fine as Rectangle gets

## aerospace — displays

| keys            | does                                       |
|-----------------|--------------------------------------------|
| ctrl-alt-cmd-→  | send WINDOW to next display, focus follows |
| ctrl-alt-cmd-←  | send WINDOW to prev display, focus follows |
| ctrl-alt-shift-tab | moves the whole WORKSPACE instead       |

Do NOT give a snapping app these chords. A TILED window belongs to a
workspace and a workspace to ONE monitor, so an app that moves the frame
gets re-tiled home — it flashes onto the other display and snaps back,
which reads as rejection. Only floating windows escape it.
`move-node-to-monitor` moves the node in aerospace's own model, so it
sticks. Diagnosed 2026-07-31 against Magnet.

## rectangle — namespace

aerospace owns ctrl-alt. Magnet squatted on 11 of those chords and lost every
one — whoever registers first wins, so its snaps just silently did nothing.
Do not repeat that; give Rectangle its own band.

| chord            | already taken by aerospace |
|------------------|----------------------------|
| ctrl-alt-h j k l | focus ← ↓ ↑ →              |
| ctrl-alt-LETTER  | workspace switch, 26 of them |
| ctrl-alt-1–9     | workspace 1–9              |
| ctrl-alt-cmd-← → | window → prev / next display |
| cmd-alt-g s d m u | grid · stack · dock · menubar |

free bands worth using: ctrl-shift · cmd-ctrl · ctrl-alt-shift-LETTER

## hidden bar — menu

| keys        | does                                       |
|-------------|--------------------------------------------|
| the `›`     | expand / collapse the hidden icon strip    |
| missing?    | it is COLLAPSED, not gone — click `›`      |
| pin one     | cmd-drag it RIGHT of the `|` separator     |
| Übersicht   | lives here — its icon is the app's ONLY UI |

## widgets — toggles

| keys      | does                                 |
|-----------|--------------------------------------|
| cmd-alt-m | macOS menubar                        |
| cmd-alt-d | macOS dock — NATIVE macOS, not ours  |
| cmd-alt-u | Übersicht + simple-bar open/close    |
| cmd-alt-r | refresh all widgets (double-pass)    |
| cmd-alt-n | kol-notes sticky                     |
| cmd-alt-b | kol-bookmarks sticky                 |

cmd-alt-d is macOS's own (symbolic hotkey 52). Never bind it in aerospace —
both fire, autohide flips twice, the dock looks frozen. bin/dock-toggle
retired 2026-07-31 for exactly this.

## widgets — which screen

The gutter and the widgets must agree. aerospace reserves 304px on
`monitor.main` ONLY; widgets default to every screen. Mismatch = windows
sliding under the widget column on the other monitor.

| keys                   | does                                    |
|------------------------|-----------------------------------------|
| ubersicht-screen       | print the current setting per widget    |
| ubersicht-screen main  | main screen only — THE NORMAL SETTING   |
| ubersicht-screen all   | every screen — gutter no longer matches |
| main = which?          | the display with the MENU BAR — here    |
|                        | the iMac 5K, NOT the U32J59x            |
| not in the repo        | Übersicht stores it — re-run after a    |
|                        | reinstall or a wiped WebKit store       |

[e] the gutter side · `aerospace.toml` `outer.right = [{ monitor.main = 304 }, 10]`

## simple-bar — bar

| keys     | does                                       |
|----------|--------------------------------------------|
| config   | ubersicht/simplebarrc → ~/.simplebarrc     |
| settings | cmd+click the bar → cmd+, — copy JSON back |
| theme    | kol-theme merges .themes                   |

## widgets — bookmarks

| keys     | does                                    |
|----------|-----------------------------------------|
| data     | tmux/bookmarks.txt — same as the picker |
| click    | URL → browser · path → clipboard        |
| add      | pfx B cwd · pfx A typed · pfx C-b pick  |
| sections | `## name` lines in the file             |
| display  | short `/ref-system/` · hover = full     |

## widgets — notes

| keys   | does                                    |
|--------|-----------------------------------------|
| data   | kol-vault/desk-notes.md                 |
| edit   | cmd-alt-n → nvim sticky (kitty)         |
| widget | read-only · linked under bookmarks      |

## widgets — ubersicht refresh

| keys    | does                                      |
|---------|-------------------------------------------|
| refresh | cmd-alt-r — double-pass, no icon needed   |
| debug   | Übersicht icon → Debug Console            |
| icon    | Hidden Bar collapses it — click the `›`   |
| browser | 127.0.0.1:41416 — NOT localhost           |

Debug Console is icon-ONLY: `Uebersicht.sdef` exposes just refresh, reload
and quit, so it can never be keybound. `localhost:41416` answers 400 — the
server binds 127.0.0.1 and rejects the localhost Host header. Übersicht is
an agent app (LSUIElement) — it has no window and never "opens".

## widgets — ubersicht seam

| the seam  | fact                                          |
|-----------|-----------------------------------------------|
| gutter    | aerospace outer.right 304 = 280 widget +12 +12 |
| top       | aerospace outer.top 48 = the widget top edge   |
| bar hooks | exec-on-workspace-change + on-focus-changed    |
| they hit  | widget id simple-bar-index-jsx (the WHOLE bar) |

----
doc: docs/documentation/09-productivity-desktop/07-ubersicht.md

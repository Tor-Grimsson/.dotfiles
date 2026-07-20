---
title: The config model
type: guide
status: active
updated: 2026-07-10
description: How SketchyBar is structured — the daemon + CLI, the bar/item/plugin/event pieces, the sketchybarrc entry point, item defaults, and how hotload applies edits through the symlink.
tags:
  - domain/productivity
related:
  - "[[INDEX|SketchyBar — complete guide]]"
  - "[[02-widgets|Every widget explained]]"
  - "[[03-build-your-own|Add your own widget]]"
---

# The config model

## Daemon + CLI

SketchyBar runs as a background **daemon** (`brew services start sketchybar`). You never edit a config file it "reads" — instead you send it commands with the `sketchybar` CLI. On launch it runs one script, `sketchybarrc`, which is just a shell script issuing a stream of `sketchybar --add …` / `--set …` / `--subscribe …` commands. Once it's running, any `sketchybar --set clock label="hi"` from anywhere updates the bar instantly.

## The four nouns

| Noun | Is | Example |
| --- | --- | --- |
| **bar** | the strip itself — position, height, colour, blur | `sketchybar --bar height=32 blur_radius=20` |
| **item** | one chip on the bar — icon + label + background | `--add item clock right` |
| **plugin** | a shell script that updates an item | `plugins/clock.sh` sets the clock's label |
| **event** | a signal that triggers a plugin | `volume_change`, `front_app_switched`, or a custom one |

An item **subscribes** to events and/or runs on an interval (`update_freq`); when either fires, its **plugin** runs and calls `sketchybar --set $NAME …` to redraw it.

## sketchybarrc — the entry point

Your `sketchybarrc` does, in order:
1. Sets `$CONFIG_DIR`, `$ITEM_DIR`, `$PLUGIN_DIR`, `$FONT` and **sources `colors.sh`** (the palette).
2. Configures the **bar**: `--bar position=top height=32 blur_radius=20 color=$BAR_BG`.
3. Sets **item defaults** (`--default …`) — padding, background chip, icon/label fonts — applied to *every item added after it*, so each item file only overrides what's different.
4. Declares the custom **event** `aerospace_workspace_change`.
5. **Sources each item file** (`source "$ITEM_DIR/clock.sh"` …) — left side, then right.
6. Ends with `--hotload on` and one `--update` to initialise every plugin once.

## Items vs plugins — the split

Every widget is **two files**:

- **`items/foo.sh`** — *defines* the chip: an array of properties, then `sketchybar --add item foo <side>` + `--set foo "${foo[@]}"` + optionally `--subscribe foo <event>`. Sourced by `sketchybarrc`.
- **`plugins/foo.sh`** — *updates* the chip: runs when the event/timer fires, reads `$NAME`/`$SENDER`/`$INFO`, and calls `sketchybar --set "$NAME" label=… icon=…`. Executed by the daemon (so it needs `chmod +x` + a shebang).

Why split? The item is declarative (style, wiring) and runs once at load; the plugin is imperative (fetch data, set label) and runs many times. Keeping them apart means restyling never touches the data logic.

## The magic variables a plugin gets

When the daemon runs a plugin it sets:

| Var | Is |
| --- | --- |
| `$NAME` | the item that triggered it (so one plugin can serve many items) |
| `$SENDER` | which event fired (`volume_change`, `mouse.clicked`, `routine` for a timer…) |
| `$INFO` | event payload — e.g. the volume level, the app name, media JSON |
| `$SELECTED` | for spaces: whether this one is selected |

Plugins do **not** inherit `sketchybarrc`'s exported vars reliably, so a plugin that needs the palette does `source "$HOME/.config/sketchybar/colors.sh"` itself (see `plugins/cpu.sh`).

## Hotload — editing through the symlink

`sketchybarrc` ends with `sketchybar --hotload on`, so the daemon watches `~/.config/sketchybar` and re-applies changes automatically. Because that path is a **symlink to the repo**, editing `~/.dotfiles/sketchybar/…` updates the live bar with no manual reload — verified: adding the widget files registered them instantly.

If hotload ever misses a change: `sketchybar --reload ~/.config/sketchybar/sketchybarrc`, or `brew services restart sketchybar` for a clean relaunch. (Bare `sketchybar --reload` only works if the daemon was launched with a config path — see [[06-sketchybar|the catalog reference]].)

Next: [[02-widgets|Every widget explained]].

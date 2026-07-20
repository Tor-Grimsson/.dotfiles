---
title: Add your own widget
type: guide
status: active
updated: 2026-07-10
description: Step-by-step recipe for adding a SketchyBar widget — the item array pattern, the plugin script, choosing events vs polling, click actions and popups, colour-grading, and the macOS bash-3.2 gotcha to avoid.
tags:
  - domain/productivity
related:
  - "[[INDEX|SketchyBar — complete guide]]"
  - "[[01-model|The config model]]"
  - "[[04-styling|The styling toolkit]]"
---

# Add your own widget

A widget is two files + one line in `sketchybarrc`. Here's the whole recipe.

## 1. The item file — `items/foo.sh`

Declare properties in an array, add the item, wire its updater:

```bash
#!/usr/bin/env bash
foo=(
  update_freq=5                 # run the plugin every 5s (omit for event-only)
  icon=""                      # a Nerd Font glyph
  icon.color="$TEAL"            # from colors.sh
  script="$PLUGIN_DIR/foo.sh"   # the updater
)
sketchybar --add item foo right \
           --set foo "${foo[@]}" \
           --subscribe foo some_event   # optional: also run on an event
```

- `right` / `left` = which side. **On the right, the first item added sits furthest right.**
- The `--default` block in `sketchybarrc` already gave it a chip background, fonts, padding — only override what differs.

## 2. The plugin — `plugins/foo.sh`

Fetch data, set the item. It runs with `$NAME`/`$SENDER`/`$INFO` set:

```bash
#!/usr/bin/env bash
source "$HOME/.config/sketchybar/colors.sh"   # only if you need the palette

value=$(some-command)
[ -z "$value" ] && value="—"

sketchybar --set "$NAME" label="$value"
```

**`chmod +x plugins/foo.sh`** — the daemon *executes* plugins, so they need the exec bit + a shebang (item files are only `source`d, so they don't).

## 3. Wire it in `sketchybarrc`

```bash
source "$ITEM_DIR/foo.sh"
```

Hotload applies it the moment you save (edit the repo file — the symlink carries it live).

## Events vs polling

| Use | When | How |
| --- | --- | --- |
| **event** | the data changes at a known signal | `--subscribe foo volume_change`; read `$INFO`, branch on `$SENDER` |
| **poll** | the data drifts continuously | `update_freq=N` on the item |
| **both** | responsive *and* self-correcting | subscribe + a slow `update_freq` as a safety net |

Built-in events worth knowing: `front_app_switched`, `volume_change`, `brightness_change`, `power_source_change`, `system_woke`, `media_change` (dead on macOS 15.4+), `mouse.clicked`, `mouse.entered`, `mouse.exited`, `mouse.scrolled`. Make your own with `--add event my_event` and fire it with `sketchybar --trigger my_event` (that's how AeroSpace drives the workspaces).

## Click actions & popups

- **Click** → `click_script="…"` runs any shell (e.g. `open -a Calendar`, or a plugin with an arg).
- **Popup** → set `popup.*` on the item, toggle with `click_script="sketchybar --set foo popup.drawing=toggle"`, and add rows as items on the `popup.foo` side. The apple menu (`items/apple.sh`) is the worked example.

## Colour-grading (the house pattern)

Source `colors.sh`, branch on a threshold, pass the colour to `icon.color`:

```bash
if   [ "$v" -ge 80 ]; then col=$RED
elif [ "$v" -ge 50 ]; then col=$PEACH
else                       col=$GREEN
fi
sketchybar --set "$NAME" label="${v}%" icon.color="$col"
```

## Gotchas

- **bash 3.2** — macOS `/bin/bash` is ancient. No `mapfile`, no associative arrays. Use plain word-splitting (`plugins/aerospace.sh` does this deliberately). `#!/usr/bin/env bash` gets you a newer bash if one's on PATH, but don't rely on 4+ features in plugins.
- **PATH in plugins** — the daemon's environment is minimal. Locate tools defensively (`command -v`, or check both brew prefixes) rather than assuming `/opt/homebrew/bin` is on PATH (`plugins/brew.sh`).
- **Self-hide instead of showing junk** — if the data doesn't apply (no battery, brew up-to-date), set `drawing=off` and exit; don't draw an empty chip.
- **Glyphs** — icons are Nerd Font (FontAwesome range) in MesloLGS NF. A tofu box = wrong codepoint; swap it. See [[04-styling|styling]].

Next: [[04-styling|The styling toolkit]].

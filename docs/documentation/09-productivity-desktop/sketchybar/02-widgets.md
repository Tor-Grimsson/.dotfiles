---
title: Every widget explained
type: guide
status: active
updated: 2026-07-10
description: Each item on the bar in detail — what it shows, the exact macOS command behind it, how it updates, and the trick that makes it work (self-hiding battery, colour-graded load, the volume event, the apple popup).
tags:
  - domain/productivity
related:
  - "[[INDEX|SketchyBar — complete guide]]"
  - "[[01-model|The config model]]"
  - "[[03-build-your-own|Add your own widget]]"
---

# Every widget explained

Left to right. Each is an `items/*.sh` (definition) + usually a `plugins/*.sh` (updater).

## Left side

### apple — power menu
A static Apple logo whose click toggles a **popup** dropdown (`popup.drawing=toggle`). The rows (`apple.lock`, `apple.sleep`, `apple.logout`, `apple.restart`, `apple.shutdown`) live under `popup.apple` and each calls `plugins/power.sh <action>`, which closes the popup then runs the action:

| Row | Command |
| --- | --- |
| Lock Screen | `osascript … keystroke "q" using {control down, command down}` (the real Lock shortcut) |
| Sleep | `pmset sleepnow` |
| Log Out / Restart / Shut Down | `osascript -e 'tell application "System Events" to log out / restart / shut down'` |

The trick: popup rows are just items added to the `popup.<parent>` "side". No plugin needed — clicks fire `click_script` directly.

### workspaces — AeroSpace, dynamic
There are 31 persistent AeroSpace workspaces, too many to draw statically. An **invisible controller** item (`spaces_ctrl`, `drawing=off`) subscribes to the custom `aerospace_workspace_change` event; its plugin (`plugins/aerospace.sh`) removes the old `space.*` chips and redraws one per *occupied* workspace + the focused one (highlighted mauve). Exits quietly if the `aerospace` CLI is unreachable, so a broken WM never breaks the bar. Full wiring in [[05-aerospace|AeroSpace]].

### front_app — focused app name
Subscribes to `front_app_switched`; the app name arrives in `$INFO`. On the initial load (no event) it falls back to an `osascript` query of the frontmost process.

## Right side (system widgets)

All colour-grade via the accent palette in `colors.sh` (green → peach → red).

### cpu — load %
`ps -A -o %cpu` summed across all processes, divided by `sysctl -n hw.ncpu`. Cheap and instant — no `top` sampling delay. ≥50% peach, ≥80% red. Every 2s.

### memory — RAM used %
`memory_pressure` reports *free* %, so used = `100 - free`. ≥65% peach, ≥85% red. Every 5s.

### volume — output %
Subscribes to the built-in `volume_change` event; the level (0-100) is in `$INFO` — zero polling, instant on change. Falls back to `osascript -e 'output volume of (get volume settings)'` on load. Icon ramps mute → low → high.

### wifi — SSID
The Wi-Fi device is **auto-detected** (`networksetup -listallhardwareports` → the port after "Wi-Fi") because it's `en0` on some Macs and `en1` on others (yours is `en1`). SSID via `ipconfig getsummary "$dev"`. Dim "off" when not connected. Every 15s.

### battery — charge %
`pmset -g batt` → percentage + "AC Power" flag. Icon/colour ramp by level, bolt when charging. **Self-hides on a desktop:** if `pmset` returns no percentage (the iMac has no battery) the plugin sets `drawing=off` and exits — so the same config is correct on both machines. Reacts to `power_source_change` + `system_woke`, polls every 30s.

### weather — temperature
`curl wttr.in/?format=%t` — IP-geolocated, no API key, fails soft to "—" when offline. Every 30 min.

### brew — outdated count
Counts `brew outdated` (brew located without a hardcoded prefix — Intel vs Apple-Silicon, per ARCHITECTURE §1). **Hidden entirely when up to date** (`drawing=off`). Click runs `brew upgrade` in a Ghostty window. Every 30 min.

### tmux — windows
`tmux list-windows -a` across sessions. (Open item: the ask was *sessions*, not windows — see the catalog's Open/next.)

### clock — date + time
`date '+%d/%m %H:%M'`, every 10s. Click opens Calendar.

## Why no now-playing
macOS 15.4 locked down the private MediaRemote framework, so SketchyBar's `media_change` event **and** `nowplaying-cli` are both dead on 15.4+ (this machine is 15.7). It's the one obvious widget that can't be built right now — see [[05-roadmap|the roadmap]].

Next: [[03-build-your-own|Add your own widget]].

#!/usr/bin/env bash
# Apple menu click: alt-click dismisses; otherwise close every other popup, then toggle this one.
[ "$MODIFIER" = "alt" ] && { sketchybar --set apple popup.drawing=off; exit 0; }
for it in cpu memory volume wifi battery weather brew clock; do sketchybar --set "$it" popup.drawing=off 2>/dev/null; done
sketchybar --set apple popup.drawing=toggle

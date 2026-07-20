#!/usr/bin/env bash
# Left-click → fuller conditions popup (wttr.in). ⌘-click → open the full forecast page.
D="$HOME/.config/sketchybar"
[ "$MODIFIER" = "alt" ] && { sketchybar --set weather popup.drawing=off; exit 0; }   # alt-click dismisses
if [ "$MODIFIER" = "cmd" ]; then open "https://wttr.in"; exit 0; fi
w=$(curl -s --max-time 5 "wttr.in/?format=%l|%c %t  (feels %f)|%C|humidity %h|wind %w|⌘-click: full forecast" 2>/dev/null)
[ -z "$w" ] && w="weather unavailable (offline)"
printf '%s' "$w" | tr '|' '\n' | "$D/plugins/popup.sh" weather

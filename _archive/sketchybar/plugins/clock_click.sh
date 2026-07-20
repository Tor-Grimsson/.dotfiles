#!/usr/bin/env bash
# Left-click → month-view popup. ⌘-click → open Calendar.app.
D="$HOME/.config/sketchybar"
[ "$MODIFIER" = "alt" ] && { sketchybar --set clock popup.drawing=off; exit 0; }   # alt-click dismisses
if [ "$MODIFIER" = "cmd" ]; then open -a Calendar; exit 0; fi
{
  date '+%A, %d %B %Y    ⌘-click: Calendar'
  echo
  cal
} | "$D/plugins/popup.sh" clock

#!/usr/bin/env bash
# Left-click → charge + health popup (relevant on the laptop; the item is hidden on desktops).
D="$HOME/.config/sketchybar"
[ "$MODIFIER" = "alt" ] && { sketchybar --set battery popup.drawing=off; exit 0; }   # alt-click dismisses
if [ "$MODIFIER" = "cmd" ]; then open "x-apple.systempreferences:com.apple.preference.battery"; exit 0; fi
{
  pmset -g batt 2>/dev/null | sed -n '2p' | sed 's/^[[:space:]]*//'
  echo
  system_profiler SPPowerDataType 2>/dev/null \
    | awk -F': ' '/Cycle Count|Condition|Maximum Capacity|State of Charge/{gsub(/^ +/,"",$1); printf "%s: %s\n",$1,$2}'
  echo "⌘-click: Battery settings"
} | "$D/plugins/popup.sh" battery

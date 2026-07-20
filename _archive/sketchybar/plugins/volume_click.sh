#!/usr/bin/env bash
# Left-click → level + mute-state popup. ⌘-click → open Sound settings.
D="$HOME/.config/sketchybar"
[ "$MODIFIER" = "alt" ] && { sketchybar --set volume popup.drawing=off; exit 0; }   # alt-click dismisses
if [ "$MODIFIER" = "cmd" ]; then open "x-apple.systempreferences:com.apple.preference.sound"; exit 0; fi
vol=$(osascript -e 'output volume of (get volume settings)' 2>/dev/null)
muted=$(osascript -e 'output muted of (get volume settings)' 2>/dev/null)
{
  echo "Volume  ${vol:-?}%    (muted: ${muted:-no})"
  echo "⌘-click: Sound settings"
} | "$D/plugins/popup.sh" volume

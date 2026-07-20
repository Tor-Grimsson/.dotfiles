#!/usr/bin/env bash
# Left-click → preview popup of the top CPU processes. ⌘-click (or right-click) → full htop.
D="$HOME/.config/sketchybar"
[ "$MODIFIER" = "alt" ] && { sketchybar --set cpu popup.drawing=off; exit 0; }   # alt-click dismisses
if [ "$MODIFIER" = "cmd" ] || [ "$BUTTON" = "right" ]; then
  open -na Ghostty --args -e htop; exit 0
fi
{
  echo "CPU — top by usage    ⌘-click: htop"
  ps -A -o %cpu=,comm= -r 2>/dev/null | head -6 \
    | awk '{c=$1; $1=""; sub(/^ +/,""); n=$0; sub(/.*\//,"",n); printf "%5.1f%%  %.26s\n", c, n}'
} | "$D/plugins/popup.sh" cpu

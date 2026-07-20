#!/usr/bin/env bash
# Left-click → preview popup of the top memory processes. ⌘-click / right-click → full htop.
D="$HOME/.config/sketchybar"
[ "$MODIFIER" = "alt" ] && { sketchybar --set memory popup.drawing=off; exit 0; }   # alt-click dismisses
if [ "$MODIFIER" = "cmd" ] || [ "$BUTTON" = "right" ]; then
  open -na Ghostty --args -e htop; exit 0
fi
{
  echo "Memory — top by RSS    ⌘-click: htop"
  ps -A -o %mem=,comm= -m 2>/dev/null | head -6 \
    | awk '{c=$1; $1=""; sub(/^ +/,""); n=$0; sub(/.*\//,"",n); printf "%5.1f%%  %.26s\n", c, n}'
} | "$D/plugins/popup.sh" memory

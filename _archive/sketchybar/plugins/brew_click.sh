#!/usr/bin/env bash
# Left-click → popup listing outdated packages. ⌘-click → run `brew upgrade` in Ghostty.
D="$HOME/.config/sketchybar"
[ "$MODIFIER" = "alt" ] && { sketchybar --set brew popup.drawing=off; exit 0; }   # alt-click dismisses
BREW=$(command -v brew)
[ -x "$BREW" ] || for b in /opt/homebrew/bin/brew /usr/local/bin/brew; do [ -x "$b" ] && BREW="$b" && break; done
if [ "$MODIFIER" = "cmd" ]; then open -na Ghostty --args -e "$BREW upgrade"; exit 0; fi
{
  echo "brew outdated    ⌘-click: upgrade all"
  "$BREW" outdated 2>/dev/null | head -14
} | "$D/plugins/popup.sh" brew

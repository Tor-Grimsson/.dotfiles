#!/usr/bin/env bash
# Count of outdated Homebrew packages; hidden when up to date. No hardcoded brew prefix
# (Intel /usr/local vs Apple-Silicon /opt/homebrew — see ARCHITECTURE §1).
source "$HOME/.config/sketchybar/colors.sh"

BREW=$(command -v brew)
[ -x "$BREW" ] || for b in /opt/homebrew/bin/brew /usr/local/bin/brew; do [ -x "$b" ] && BREW="$b" && break; done
[ -x "$BREW" ] || { sketchybar --set "$NAME" drawing=off; exit 0; }

n=$("$BREW" outdated --quiet 2>/dev/null | grep -c .)
if [ "$n" -gt 0 ]; then
  sketchybar --set "$NAME" drawing=on label="$n" icon.color="$PEACH"
else
  sketchybar --set "$NAME" drawing=off
fi

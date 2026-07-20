#!/usr/bin/env bash
# Volume %, icon by level. On volume_change the level (0-100) is in $INFO; else query it.
source "$HOME/.config/sketchybar/icons.sh"

if [ "$SENDER" = "volume_change" ]; then vol="$INFO"; else
  vol=$(osascript -e 'output volume of (get volume settings)' 2>/dev/null)
fi
[ -z "$vol" ] && vol=0

if   [ "$vol" -eq 0 ]; then icon="$VOL_MUTE"
elif [ "$vol" -lt 50 ]; then icon="$VOL_LOW"
else                        icon="$VOL_HIGH"
fi

sketchybar --set "$NAME" icon="$icon" label="${vol}%"

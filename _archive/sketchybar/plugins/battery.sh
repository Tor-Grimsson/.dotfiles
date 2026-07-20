#!/usr/bin/env bash
# Battery %, icon+colour by level, bolt when on AC. Self-hides on a desktop (no battery).
source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/icons.sh"

pct=$(pmset -g batt | grep -Eo '[0-9]+%' | head -1 | tr -d '%')
if [ -z "$pct" ]; then sketchybar --set "$NAME" drawing=off; exit 0; fi
sketchybar --set "$NAME" drawing=on

on_ac=$(pmset -g batt | grep -Eo 'AC Power')

if   [ -n "$on_ac" ];   then icon="$BATT_CHG"; col=$GREEN
elif [ "$pct" -le 20 ]; then icon="$BATT_0";   col=$RED
elif [ "$pct" -le 40 ]; then icon="$BATT_25";  col=$PEACH
elif [ "$pct" -le 60 ]; then icon="$BATT_50";  col=$YELLOW
elif [ "$pct" -le 80 ]; then icon="$BATT_75";  col=$GREEN
else                         icon="$BATT_100"; col=$GREEN
fi

sketchybar --set "$NAME" icon="$icon" icon.color="$col" label="${pct}%"

#!/usr/bin/env bash
# RAM used %, colour-graded. memory_pressure reports free % → used = 100 - free.
source "$HOME/.config/sketchybar/colors.sh"

free=$(memory_pressure 2>/dev/null | awk '/System-wide memory free percentage/{gsub(/%/,"",$5); print $5}')
[ -z "$free" ] && free=100
used=$((100 - free))

if   [ "$used" -ge 85 ]; then col=$RED
elif [ "$used" -ge 65 ]; then col=$PEACH
else                          col=$GREEN
fi

sketchybar --set "$NAME" label="${used}%" icon.color="$col"

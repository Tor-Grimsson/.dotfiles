#!/usr/bin/env bash
# CPU load %, colour-graded. Sum of per-process %cpu / core count — cheap, no top sampling.
source "$HOME/.config/sketchybar/colors.sh"

n=$(sysctl -n hw.ncpu)
load=$(ps -A -o %cpu= 2>/dev/null | awk -v n="$n" '{s+=$1} END {printf "%.0f", s/n}')
[ -z "$load" ] && load=0

if   [ "$load" -ge 80 ]; then col=$RED
elif [ "$load" -ge 50 ]; then col=$PEACH
else                          col=$GREEN
fi

sketchybar --set "$NAME" label="${load}%" icon.color="$col"

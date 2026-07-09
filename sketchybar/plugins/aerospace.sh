#!/usr/bin/env bash
# Rebuilds the workspace chips: one per occupied workspace, plus the focused one,
# focused chip highlighted in mauve. Runs at load and on aerospace_workspace_change.
# Exits quietly if the aerospace CLI can't reach the server (e.g. version mismatch),
# so a broken WM never breaks the bar.

source "$HOME/.config/sketchybar/colors.sh"

focused=$(aerospace list-workspaces --focused 2>/dev/null) || exit 0
[ -z "$focused" ] && exit 0

# Word-split is safe: aerospace workspace names are single tokens (no spaces).
# Avoid `mapfile` — it's bash 4+, and macOS ships bash 3.2 as /bin/bash.
occ=$(aerospace list-workspaces --monitor all --empty no 2>/dev/null)
# ensure the focused workspace is present even if it has no windows
case " $occ " in *" $focused "*) ;; *) occ="$occ $focused" ;; esac

sketchybar --remove '/space\..*/' 2>/dev/null

for w in $occ; do
  [ -z "$w" ] && continue
  if [ "$w" = "$focused" ]; then bg=$FOCUS_BG; fg=$FOCUS_FG; else bg=$CHIP_BG; fg=$TEXT; fi
  sketchybar --add item "space.$w" left \
             --set "space.$w" icon="$w" label.drawing=off \
                   icon.color="$fg" background.color="$bg" \
                   background.corner_radius=4 background.height=22 \
                   icon.padding_left=8 icon.padding_right=8 \
                   click_script="aerospace workspace $w"
done

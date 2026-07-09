#!/usr/bin/env bash
# Workspace display. An invisible controller item re-runs the rebuild script on every
# aerospace_workspace_change; the script draws one chip per occupied workspace + the
# focused one (there are 31 persistent workspaces — too many to draw statically).

sketchybar --add item spaces_ctrl left \
           --set spaces_ctrl drawing=off \
                 script="$PLUGIN_DIR/aerospace.sh" \
           --subscribe spaces_ctrl aerospace_workspace_change

"$PLUGIN_DIR/aerospace.sh"   # initial draw (no-op if the aerospace CLI is unreachable)

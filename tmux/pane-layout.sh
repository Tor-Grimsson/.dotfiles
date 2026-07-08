#!/usr/bin/env bash
# Summon a saved pane layout as a NEW WINDOW in the CURRENT session.
#
# Reads the SAME tmuxinator yml as `mux <name>` (via yq) but grafts window 0's
# panes onto the session you're already in — no new session, no switch-client
# (so none of the MRU-client hijack the session-spawn path can hit). One file,
# two ways to call it: `mux home` = a whole session; this = one window in
# whatever session you're in. Bound to `prefix C-d`. Session-spawn = `prefix C-o`.
#
# Assumes window 0's panes are command strings + an optional `layout:` preset
# (the tmuxinator `home.yml` shape). No name arg → fzf-picks one.
set -euo pipefail

name="${1:-}"
dir="$HOME/.config/tmuxinator"

if [ -z "$name" ]; then
  name=$(ls "$dir"/*.yml 2>/dev/null | sed 's|.*/||;s|\.yml$||' \
    | fzf --reverse --no-preview --prompt='window layout> ') || exit 0   # Esc → bail clean
fi
[ -z "$name" ] && exit 0

file="$dir/$name.yml"
[ -f "$file" ] || { echo "no layout: $name ($file)"; exit 1; }

# Window 0's layout preset + panes, name-agnostic (first window entry, whatever it's called).
layout=$(yq '.windows[0] | to_entries | .[0].value.layout // "tiled"' "$file")

panes=()   # bash 3.2: no mapfile, so read line-by-line
while IFS= read -r line; do
  [ -n "$line" ] && panes+=("$line")
done < <(yq '.windows[0] | to_entries | .[0].value.panes[]' "$file")
[ "${#panes[@]}" -eq 0 ] && { echo "no panes in $name"; exit 1; }

# First pane = a new window (a shell) in the CURRENT session, named after the layout.
# send-keys into a shell (not a pane command) so `fastfetch` prints then leaves a shell,
# matching how `mux` builds it.
win=$(tmux new-window -P -F '#{window_id}' -n "$name")
tmux send-keys -t "$win" "${panes[0]}" Enter

# Remaining panes: split + run. Index loop, not "${panes[@]:1}" (bash 3.2 set -u trips on it).
i=1
while [ "$i" -lt "${#panes[@]}" ]; do
  p=$(tmux split-window -t "$win" -P -F '#{pane_id}')
  tmux send-keys -t "$p" "${panes[$i]}" Enter
  i=$((i + 1))
done

# Optional main-pane sizing — read from a `# main-pane-height:`/`# main-pane-width:`
# comment in the yml (tmuxinator + yq both ignore comments). Accepts rows/cols or a %.
# Must be set BEFORE select-layout so the layout honours it. e.g. a thin fastfetch banner.
mph=$(grep -oE 'main-pane-height:[[:space:]]*[0-9]+%?' "$file" 2>/dev/null | grep -oE '[0-9]+%?' | head -1 || true)
mpw=$(grep -oE 'main-pane-width:[[:space:]]*[0-9]+%?'  "$file" 2>/dev/null | grep -oE '[0-9]+%?' | head -1 || true)
[ -n "$mph" ] && tmux set-window-option -t "$win" main-pane-height "$mph"
[ -n "$mpw" ] && tmux set-window-option -t "$win" main-pane-width  "$mpw"

tmux select-layout -t "$win" "$layout"

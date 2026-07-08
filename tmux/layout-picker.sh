#!/usr/bin/env bash
# fzf-pick a tmuxinator LAYOUT and switch to it — on the client that launched
# this, not tmuxinator's guess. Bound to `prefix C-d` (display-popup).
#
# Why the script instead of a one-liner: `tmuxinator start <x>` attaches by
# shelling out `tmux switch-client` with NO target client. From a popup shell
# that resolves to the most-recently-used client, which may be a different
# terminal than the window you triggered it from — so the layout hijacks the
# wrong session's view. Here we build the session detached (--no-attach) and do
# the switch ourselves against the pressing client, passed in as $1 (#{client_name}).
set -euo pipefail

client="${1:-}"

pick=$(ls ~/.config/tmuxinator/*.yml 2>/dev/null \
  | sed 's|.*/||;s|\.yml$||' \
  | fzf --reverse --no-preview --prompt='layout> ') || exit 0   # Esc / no pick → bail clean
[ -z "$pick" ] && exit 0

# Build (or no-op if it already exists) detached, then switch the RIGHT client.
tmuxinator start --no-attach "$pick"
if [ -n "$client" ]; then
  tmux switch-client -c "$client" -t "$pick"
else
  tmux switch-client -t "$pick"   # fallback: no client passed → tmux's current
fi

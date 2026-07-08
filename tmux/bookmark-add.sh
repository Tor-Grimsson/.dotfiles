#!/usr/bin/env bash
# Append a path to the tmux bookmark list (deduped, $HOME shortened to ~).
# Bound to `prefix B`; tmux passes #{pane_current_path} as $1.
set -euo pipefail
f="$HOME/.dotfiles/tmux/bookmarks.txt"
p="${1:-$PWD}"
p="${p/#$HOME/~}"                       # /Users/you/dev -> ~/dev (portable across machines)
if grep -qxF "$p" "$f" 2>/dev/null; then
  tmux display-message "already bookmarked: $p"
else
  printf '%s\n' "$p" >> "$f"
  tmux display-message "bookmarked: $p"
fi

#!/usr/bin/env bash
# fzf-pick a bookmark and open it: a URL opens in the default browser,
# a path (file or dir) opens in nvim. Bound to `prefix C-b`.
set -euo pipefail
f="$HOME/.dotfiles/tmux/bookmarks.txt"
sel=$(grep . "$f" 2>/dev/null | fzf --reverse --prompt='bookmark> ') || exit 0
[ -z "$sel" ] && exit 0
case "$sel" in
  http://* | https://*) open "$sel" ;;          # URL -> default browser
  *) nvim "${sel/#\~/$HOME}" ;;                  # path -> nvim (expand leading ~)
esac

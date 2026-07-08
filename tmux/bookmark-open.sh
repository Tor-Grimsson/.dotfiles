#!/usr/bin/env bash
# fzf-pick a bookmark and open it: a URL opens in the default browser,
# a path (file or dir) opens in nvim. Bound to `prefix C-b`.
set -euo pipefail
f="$HOME/.dotfiles/tmux/bookmarks.txt"
# --no-preview: entries are URLs and paths; the shell's global fzf bat-preview
# default errors on URLs ("[bat error]: 'https://…'"). The list already shows the
# full target, so no preview is needed. (Same inheritance class as the sesh/layout popups.)
sel=$(grep . "$f" 2>/dev/null | fzf --reverse --no-preview --prompt='bookmark> ') || exit 0
[ -z "$sel" ] && exit 0
case "$sel" in
  http://* | https://*) open "$sel" ;;          # URL -> default browser
  *) nvim "${sel/#\~/$HOME}" ;;                  # path -> nvim (expand leading ~)
esac

#!/usr/bin/env bash
# Prompt for a path or URL and add it to the bookmark list. Bound to `prefix A`.
read -r -p "bookmark (path or URL): " x
[ -n "$x" ] && exec "$HOME/.dotfiles/tmux/bookmark-add.sh" "$x"

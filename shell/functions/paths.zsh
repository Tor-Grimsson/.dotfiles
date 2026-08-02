# paths — path verbs for where you ARE and the file you edit most.
# Shared flag vocabulary: -e open in nvim · -c copy path · -p print path.
# Sourced by shell/.zshrc.
#
# The g* jump family (ghome gdot gdev gobs gapparat gclient gicloud) was deleted
# 2026-08-01 — superseded by the tmux bookmarks system (`prefix C-b` open,
# `B` add-cwd, `A` typed), and 26 of its 27 flagged targets pointed at
# `kol-apparat/` and `kol-client/`, which no longer exist.

# ── zshrc — ~/.dotfiles/shell/.zshrc (a file, not a dir — own verb set) ───────
zshrc() {
  local target=~/.dotfiles/shell/.zshrc
  case "$1" in
    -e) nvim -- "$target" ;;
    -s) source ~/.zshrc && echo "sourced ~/.zshrc" ;;
    -c) printf '%s' "$target" | pbcopy && echo "copied: $target" ;;
    -p|"") print -r -- "$target" ;;
    -h) print -r -- "zshrc [-e|-s|-c|-p|-h]  -e edit in nvim  -s source ~/.zshrc  -c copy path  -p print path (default)" ;;
    *)  echo "unknown flag: $1 (try -h)"; return 1 ;;
  esac
}

# ── cwd — where you ARE ───────────────────────────────────────────────────────
cwd() {
  local target="$PWD"
  case "$1" in
    -c) printf '%s' "$target" | pbcopy && echo "copied: $target" ;;
    -e) nvim -- "$target" ;;
    -f) printf '%s' "$target" | pbcopy && open -R "$target" ;;
    -p|"") print -r -- "$target" ;;
    -h) print -r -- "cwd [-c|-e|-f|-p|-h]  -c copy path  -e open in nvim  -f copy + reveal in Finder  -p print path (default)" ;;
    *)  echo "unknown flag: $1 (try -h)"; return 1 ;;
  esac
}

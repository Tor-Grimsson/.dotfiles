#!/bin/zsh

# clip-drop.sh — dump the clipboard image into an inbox and open yazi on it.
#
# Solves "I have an image in the clipboard and don't know where to put it":
# capture FIRST to a staging inbox, then file it VISUALLY in yazi (preview,
# rename, cut/paste to the real destination) — instead of deciding the path
# up front in a shell. If you don't file it now, it just sits in the inbox.

usage() {
  cat <<'EOF'
clip-drop.sh — save the CLIPBOARD image to an inbox, then open yazi on it.

Dumps the clipboard image to <DIR>/clip_<timestamp>.png (via pngpaste), then
execs yazi in that folder with the new file hovered. Preview it, then file it
with yazi's own keys: r rename · x cut · navigate · p paste. Leave it to keep
it in the inbox as an "unfiled" pile.

USAGE
  clip-drop.sh [DIR]

ARGUMENTS
  DIR    inbox directory. Defaults to ~/_inbox. Created with mkdir -p if
         missing. A leading ~ is expanded to $HOME.

NOTES
  Requires pngpaste (brew install pngpaste) and yazi. Exits 1 with an error if
  the clipboard holds no image, or if pngpaste isn't installed.
EOF
}

case "${1:-}" in
  -h|--help) usage; exit 0 ;;
esac

# Inbox dir (arg 1), default ~/_inbox. Expand a leading ~ — the arg is often quoted.
TARGET_DIR="${1:-$HOME/_inbox}"
TARGET_DIR="${TARGET_DIR/#\~/$HOME}"
mkdir -p "$TARGET_DIR"

# Timestamped name so repeated drops never clobber each other.
FULL_PATH="$TARGET_DIR/clip_$(date +"%Y%m%d_%H%M%S").png"

# Dump the clipboard image, then hand off to yazi hovering it.
if pngpaste "$FULL_PATH" 2>/dev/null; then
  exec yazi "$FULL_PATH"
else
  echo "❌ No image in the clipboard (or pngpaste is missing)."
  exit 1
fi

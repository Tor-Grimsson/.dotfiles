#!/bin/zsh

# ss-save.sh — save the clipboard image to a file via pngpaste.
# Two POSITIONAL args, in order: NAME first, then DIR. Not one combined path.

usage() {
  cat <<'EOF'
ss-save.sh — save the CLIPBOARD image to a file, via pngpaste.

Takes two SEPARATE positional args — a name, then a directory. They are NOT one
combined filepath: `ss-save.sh ~/Pictures/photo.png` treats the whole thing as the
NAME and dumps it on the Desktop. Keep WHAT (name) and WHERE (dir) apart.

USAGE
  ss-save.sh [NAME] [DIR]

ARGUMENTS
  NAME   arg 1. The filename. Defaults to clip_<YYYYMMDD_HHMMSS>.
         `.png` is auto-appended if you leave it off (shot → shot.png).
  DIR    arg 2. The destination folder. Defaults to the current directory ($PWD).
         A leading `~` is expanded to $HOME. Created with mkdir -p if missing.

EXAMPLES
  ss-save.sh                       # → ./clip_<timestamp>.png  (current dir)
  ss-save.sh my_shot               # → ./my_shot.png           (.png added)
  ss-save.sh my_shot.png           # → ./my_shot.png           (already .png)
  ss-save.sh photo "~/Pictures"    # → ~/Pictures/photo.png    (name, THEN dir)
  ss-save.sh diagram "~/Pics/spec" # → ~/Pics/spec/diagram.png (dir created)
  ss-save.sh shot /tmp             # → /tmp/shot.png           (absolute dir ok)

NOTES
  Requires `pngpaste` (brew install pngpaste). Exits 1 with an error if the
  clipboard holds no image, or if pngpaste isn't installed.
EOF
}

# Only -h/--help is intercepted — every other arg 1 is a real NAME and passes through.
case "${1:-}" in
  -h|--help) usage; exit 0 ;;
esac

# 1. Setup Defaults
DEFAULT_DIR="$PWD"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# 2. Handle Name (Argument 1)
# Default to a timestamped name so repeated unnamed saves never overwrite each other.
NAME="${1:-clip_$TIMESTAMP}"
# Auto-append .png unless the caller already typed it (idempotent).
[[ "$NAME" != *.png ]] && NAME="${NAME}.png"

# 3. Handle Path (Argument 2)
TARGET_DIR="${2:-$DEFAULT_DIR}"
# Expand a LEADING ~ to $HOME — the shell won't, because the arg is usually quoted.
# `/#` anchors the match to the start, so a ~ mid-path is left untouched.
TARGET_DIR="${TARGET_DIR/#\~/$HOME}"

# 4. Create directory if it doesn't exist (incl. nested parents).
mkdir -p "$TARGET_DIR"

FULL_PATH="$TARGET_DIR/$NAME"

# 5. Execute saving
if pngpaste "$FULL_PATH" 2>/dev/null; then
    echo "✅ Image saved to: $FULL_PATH"
else
    echo "❌ Error: No image found in clipboard (or pngpaste is missing)."
    exit 1
fi

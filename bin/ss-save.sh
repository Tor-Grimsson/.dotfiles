
#!/bin/zsh

# --- SS-SAVE.SH ---
# A script to save clipboard images to a specific file or path.
# Usage Examples:
#   ss-save.sh                      -> Saves to Desktop as clip_20260218_1200.png
#   ss-save.sh "my_shot"            -> Saves to Desktop as my_shot.png
#   ss-save.sh "photo" "~/Pictures" -> Saves to ~/Pictures as photo.png
# ------------------

# 1. Setup Defaults
DEFAULT_DIR="$HOME/Desktop"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# 2. Handle Name (Argument 1)
NAME="${1:-clip_$TIMESTAMP}"
[[ "$NAME" != *.png ]] && NAME="${NAME}.png"

# 3. Handle Path (Argument 2)
TARGET_DIR="${2:-$DEFAULT_DIR}"
TARGET_DIR="${TARGET_DIR/#\~/$HOME}" 

# 4. Create directory if it doesn't exist
mkdir -p "$TARGET_DIR"

FULL_PATH="$TARGET_DIR/$NAME"

# 5. Execute saving
if pngpaste "$FULL_PATH" 2>/dev/null; then
    echo "✅ Image saved to: $FULL_PATH"
else
    echo "❌ Error: No image found in clipboard (or pngpaste is missing)."
    exit 1
fi

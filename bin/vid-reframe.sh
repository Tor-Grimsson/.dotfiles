#!/usr/bin/env bash
# vid-reframe.sh — reframe clips to the folder's export-spec aspect
# Run from inside frame-9-16 / frame-16-9 / frame-4-5.
# Outputs → ../_export/<folder>/<kebab-name>.mp4
#
# Usage: vid-reframe.sh            (processes all video files in cwd)
#        vid-reframe.sh <file> ... (specific files only)

set -uo pipefail

FOLDER=$(basename "$PWD")

case "$FOLDER" in
  frame-9-16)  W=1080; H=1920 ;;
  frame-16-9)  W=1920; H=1080 ;;
  frame-4-5)   W=1080; H=1350 ;;
  *)
    echo "ERROR: run from frame-9-16, frame-16-9, or frame-4-5 (got: $FOLDER)" >&2
    exit 1 ;;
esac

OUTDIR="../_export/$FOLDER"
mkdir -p "$OUTDIR"

kebab() {
  local n="${1%.*}"
  n=$(echo "$n" | tr '[:upper:]' '[:lower:]')
  n=$(echo "$n" | sed \
    -e 's/æ/ae/g' -e 's/ø/o/g' -e 's/å/a/g' \
    -e 's/ñ/n/g' -e 's/ü/u/g' -e 's/ö/o/g' -e 's/ä/a/g')
  n=$(echo "$n" | sed \
    -e 's/_1080p//g' -e 's/_2k//g' -e 's/_4k//g' \
    -e 's/_3x5//g' -e 's/_center//g' -e 's/_1m//g' \
    -e 's/^tt[-_]//g' -e 's/tt[-_]//g')
  n=$(echo "$n" | sed 's/[ _.]/-/g; s/-\{2,\}/-/g; s/^-//; s/-$//')
  echo "$n"
}

FILES=("$@")
if [[ ${#FILES[@]} -eq 0 ]]; then
  while IFS= read -r -d '' f; do
    FILES+=("$f")
  done < <(find . -maxdepth 1 -type f \( -iname "*.mov" -o -iname "*.mp4" -o -iname "*.m4v" -o -iname "*.mkv" -o -iname "*.avi" \) -print0 | sort -z)
fi

for INPUT in "${FILES[@]}"; do
  [[ -f "$INPUT" ]] || { echo "skip: $INPUT (not found)"; continue; }

  NAME=$(kebab "$(basename "$INPUT")")
  OUT="$OUTDIR/$NAME.mp4"

  if [[ -f "$OUT" ]]; then
    echo "skip: $NAME.mp4 (already done)"
    continue
  fi

  echo "→ $NAME.mp4  (${W}×${H})"
  # First pass normalizes anamorphic sources (non-square SAR, e.g. 1440×1080 DVD
  # 16:9) to square pixels at their true display size, so the cover-scale below
  # works in display space and the output isn't left with a stretched SAR. Without
  # it, a 1440×1080 SAR-4:3 clip comes out 1920×1080 flagged SAR 4:3 = 2560×1080.
  ffmpeg -nostdin -y -i "$INPUT" \
    -map 0:v:0 -map '0:a:0?' \
    -vf "scale=trunc(iw*sar/2)*2:ih,setsar=1,scale=${W}:${H}:force_original_aspect_ratio=increase:flags=lanczos,crop=${W}:${H},setsar=1" \
    -c:v libx265 -preset medium -crf 22 -pix_fmt yuv420p -tag:v hvc1 \
    -movflags +faststart -c:a aac -b:a 128k \
    "$OUT" && echo "   done: $NAME.mp4" || echo "   FAIL: $INPUT"
done

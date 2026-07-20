#!/usr/bin/env bash
# vid-reframe.sh — reframe clips to the folder's export-spec aspect
# Run from inside frame-9-16 / frame-16-9 / frame-4-5.
# Outputs → ../_export/<folder>/<kebab-name>.mp4
#
# Usage: vid-reframe.sh            (processes all video files in cwd)
#        vid-reframe.sh <file> ... (specific files only)

set -uo pipefail

usage() {
  cat <<'EOF'
vid-reframe.sh — reframe clips to the folder's export-spec aspect.

Run from inside frame-9-16 / frame-16-9 / frame-4-5.
Outputs → ../_export/<folder>/<kebab-name>.mp4.

USAGE
  vid-reframe.sh            process all video files in the cwd
  vid-reframe.sh <file>...  specific files only
  vid-reframe.sh -h|--help  this help

Reframes to the folder aspect (1080×1920 / 1920×1080 / 1080×1350) without upscaling;
HEVC (libx265 CRF 22, hvc1) .mp4; discards any output that would grow vs its source.
EOF
}

case "${1:-}" in -h|--help) usage; exit 0 ;; esac

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

  # Largest output the SOURCE can fill WITHOUT upscaling. The reframe must keep
  # the folder aspect (W:H), but blowing a 720p / 1440×1080 clip up to the full
  # target only adds pixels and bytes — that's what made outputs bigger than
  # inputs. So probe the source, find the biggest W:H box it covers at native
  # density, and cap the target to it. Big sources still downscale to W×H.
  read -r SW SH SAR < <(ffprobe -v error -select_streams v:0 \
    -show_entries stream=width,height,sample_aspect_ratio -of csv=p=0 "$INPUT" 2>/dev/null | tr ',' ' ')
  case "$SAR" in *:*) sarN=${SAR%:*}; sarD=${SAR#*:} ;; *) sarN=1; sarD=1 ;; esac
  [[ "$sarN" =~ ^[0-9]+$ && "$sarD" =~ ^[0-9]+$ && $sarN -gt 0 && $sarD -gt 0 ]] || { sarN=1; sarD=1; }

  if [[ "$SW" =~ ^[0-9]+$ && "$SH" =~ ^[0-9]+$ && $SW -gt 0 && $SH -gt 0 ]]; then
    dispW=$(( SW * sarN / sarD )); dispH=$SH            # square-pixel display size
    if (( dispW * H >= dispH * W )); then               # source wider than target → height-limited
      oH=$dispH; oW=$(( dispH * W / H ))
    else                                                # source taller than target → width-limited
      oW=$dispW; oH=$(( dispW * H / W ))
    fi
    if (( oW >= W )); then oW=$W; oH=$H; fi             # source ≥ target → downscale to target (as before)
    oW=$(( oW - oW % 2 )); oH=$(( oH - oH % 2 ))        # even dims for yuv420/HEVC
    (( oW < 2 )) && oW=2; (( oH < 2 )) && oH=2
  else
    oW=$W; oH=$H                                         # ffprobe failed → original behavior
  fi

  note=""; (( oW < W )) && note="  [clamped — no upscale]"
  echo "→ $NAME.mp4  (${oW}×${oH})${note}"

  # First pass squares anamorphic sources (non-square SAR, e.g. 1440×1080 DVD
  # 16:9) to their true display size so the cover-scale works in display space
  # and the output isn't left with a stretched SAR.
  if ffmpeg -nostdin -y -i "$INPUT" \
    -map 0:v:0 -map '0:a:0?' \
    -vf "scale=trunc(iw*sar/2)*2:ih,setsar=1,scale=${oW}:${oH}:force_original_aspect_ratio=increase:flags=lanczos,crop=${oW}:${oH},setsar=1" \
    -c:v libx265 -preset medium -crf 22 -pix_fmt yuv420p -tag:v hvc1 \
    -movflags +faststart -c:a aac -b:a 128k \
    "$OUT"; then
    # Never leave a file bigger than its source. If even the no-upscale encode
    # came out larger (source already very efficiently compressed), throw it away
    # and keep the original — better no reframe than silent bloat.
    in_sz=$(stat -f%z "$INPUT" 2>/dev/null || stat -c%s "$INPUT" 2>/dev/null)
    out_sz=$(stat -f%z "$OUT"   2>/dev/null || stat -c%s "$OUT"   2>/dev/null)
    if [[ -n "$in_sz" && -n "$out_sz" ]] && (( out_sz >= in_sz )); then
      rm -f "$OUT"
      echo "   skipped: $NAME.mp4 would grow ($(( out_sz/1048576 ))MB ≥ $(( in_sz/1048576 ))MB) — source kept, no output"
    else
      echo "   done: $NAME.mp4 ($(( out_sz/1048576 ))MB)"
    fi
  else
    echo "   FAIL: $INPUT"
  fi
done

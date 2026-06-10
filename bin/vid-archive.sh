#!/bin/bash
# vid-archive.sh — batch archive cwd videos to small 10-bit H.265 (libx265, CRF).

usage() {
  cat <<'EOF'
vid-archive.sh — batch archive every video in the CURRENT directory to 10-bit H.265.

Software libx265 at a constant QUALITY (CRF, not a fixed bitrate), 10-bit colour,
in an .mp4. CRF self-sizes to the content: a clean motion graphic comes out tiny,
grainy live footage comes out bigger — both look the same. 10-bit keeps gradients
band-free even from an 8-bit source. The result is your keep-forever copy AND a
file that plays everywhere (QuickTime / Photos / web), 10–30× smaller than ProRes.

Works on ANY resolution. A 4K source archives at 4K; a 1080p source at 1080p.
Use -s to ALSO downscale (e.g. a 1080p derivative off a 4K master) — -s never
upscales, so -s 2160 on a 1080p file is a safe no-op.

USAGE
  vid-archive.sh [-s <height>] [-q <crf>] [-g]   # run inside the folder of clips

ARGUMENTS
  -s  height   downscale so the frame is at most <height> px tall, aspect kept,
               never upscaled (e.g. 1080, 720). Omit = archive at native res.
  -q  crf      quality, lower = better/bigger (default 20; 18 ≈ visually lossless,
               23 = smaller). CRF floats the bitrate to hold this quality.
  -g           add x265 -tune grain — preserve film grain in noisy LIVE footage.
               Leave off for animation / motion graphics / clean sources.
  -h           show this help

  (no flags)   Globs *.mov *.mp4 *.mkv *.avi *.mxf *.ts in the cwd (case-insensitive).

EXAMPLES
  # archive a folder of 4K motion graphics at native res (the keep-forever copy)
  cd ~/ae-export && vid-archive.sh

  # make 1080p derivatives off 4K masters
  vid-archive.sh -s 1080

  # archive 1080p footage at native res — identical workflow, no -s needed
  cd ~/clips-1080 && vid-archive.sh

  # tighter quality for a hero piece
  vid-archive.sh -q 18

  # grainy live footage: preserve the grain instead of smearing it
  vid-archive.sh -g

NOTES
  Codec: HEVC (libx265 software, preset medium, yuv420p10le 10-bit) in an .mp4,
  hvc1-tagged, +faststart, audio stream-copied. Needs ffmpeg with libx265.
  Output: <name>_h265.mp4 (native) or <name>_h265_<H>p.mp4 (downscaled) next to
  each source. An existing output is left untouched, and the script's own outputs
  are skipped on re-runs, so it's idempotent.
EOF
}

case "${1:-}" in -h|--help) usage; exit 0 ;; esac

bad_usage() { usage; exit 1; }

target=""; crf=20; grain=0
while getopts "s:q:gh" opt; do
  case $opt in
    s) target=$OPTARG ;;
    q) crf=$OPTARG ;;
    g) grain=1 ;;
    h) usage; exit 0 ;;
    *) bad_usage ;;
  esac
done

# -s and -q must be plain integers if given.
[[ -n $target && ! $target =~ ^[0-9]+$ ]] && { echo "bad -s height: $target" >&2; exit 1; }
[[ ! $crf =~ ^[0-9]+$ ]] && { echo "bad -q crf: $crf" >&2; exit 1; }

# -g → preserve grain in live footage; off for clean / animated sources.
tune=()
(( grain )) && tune=(-tune grain)

shopt -s nullglob nocaseglob   # no matches → skip the glob; nocaseglob so .MOV matches *.mov

for f in *.mov *.mp4 *.mkv *.avi *.mxf *.ts; do
  # Never re-archive our own outputs (they'd otherwise re-encode on a second run).
  case "$f" in *_h265.mp4|*_h265_*p.mp4) echo "skip: $f (already an archive output)"; continue ;; esac

  # Decide native vs downscale. -s only ever shrinks: if the source is already
  # shorter than the target, archive at native res and label it as native.
  vf=(); label=""
  if [[ -n $target ]]; then
    srcH=$(ffprobe -v error -select_streams v:0 -show_entries stream=height -of csv=p=0 "$f" 2>/dev/null)
    if [[ $srcH =~ ^[0-9]+$ && $target -lt $srcH ]]; then
      # scale=-2  derive width from the target height, keeping aspect + even (yuv420/HEVC need even).
      # lanczos   high-quality downscale resampler.
      vf=(-vf "scale=-2:${target}:flags=lanczos")
      label="_${target}p"
    fi
  fi

  out="${f%.*}_h265${label}.mp4"
  if [ -e "$out" ]; then
    echo "skip: $out already exists"
    continue
  fi

  # -c:v libx265 -crf  constant-quality software HEVC (bitrate floats to hold the quality).
  # -pix_fmt yuv420p10le  10-bit 4:2:0 — kills gradient banding even from an 8-bit source.
  # -tune grain  (only with -g) rate-control mode that keeps film grain instead of smearing it.
  # -tag:v hvc1  QuickTime-friendly HEVC tag (vs the generic 'hev1').
  # -movflags +faststart  moov atom up front so the file streams from the first byte.
  # -c:a copy  audio passed through untouched (motion graphics are often silent — harmless).
  ffmpeg -i "$f" \
    "${vf[@]}" \
    -c:v libx265 \
    -preset medium \
    -crf "$crf" \
    "${tune[@]}" \
    -pix_fmt yuv420p10le \
    -tag:v hvc1 \
    -movflags +faststart \
    -c:a copy \
    "$out" \
    && echo "→ $out" \
    || echo "fail: $f"
done

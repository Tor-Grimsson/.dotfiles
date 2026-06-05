#!/bin/bash
# vid-convert.sh — scale+crop any video to a target aspect/resolution (no letterbox).

usage() {
  cat <<'EOF'
vid-convert.sh — scale + crop a video to a target aspect/resolution, no letterbox.

Scales the source so it FILLS the target box (longest side = chosen res), then
crops the overflow to the exact aspect. Re-encodes to H.265 (libx265, CRF 20).
Output dims are forced even for yuv420p/HEVC.

USAGE
  vid-convert.sh -a <aspect> -r <res> -o <origin> -i <input> -p <outdir> [-n <name>]

ARGUMENTS
  -a  aspect   16:9 | 5:3 | 4:3 | 1:1 | 3:4 | 3:5 | 9:16
  -r  res      1k (1920) | 2k (2560) | 4k (3840)   — applied to the LONGEST side
  -o  origin   left | right | center | top | bottom | middle   (crop anchor; default center)
  -i  input    input video file
  -p  outdir   output directory (created if missing)
  -n  name     output filename (optional; default <stem>_<aspect>_<res>_<origin>.mov)
  -h           show this help

EXAMPLES
  # 2K vertical 3:5, crop centered, output to current dir
  vid-convert.sh -a 3:5 -r 2k -o center -i yourvideo.mp4 -p .

  # 4K square, crop centered
  vid-convert.sh -a 1:1 -r 4k -o center -i clip.mov -p ~/out

  # 1080p vertical (9:16) from landscape source, anchor to left edge
  vid-convert.sh -a 9:16 -r 1k -o left -i wide.mp4 -p ~/out -n reel.mov

  # 2K cinematic 5:3, anchor top (keep sky, crop floor)
  vid-convert.sh -a 5:3 -r 2k -o top -i drone.mp4 -p ~/out

NOTES
  Codec: H.265 (libx265, software) in a .mov, audio stream-copied. Needs ffmpeg.
  Output lands in <outdir>; faststart is set so the file streams from the first byte.
EOF
}

case "${1:-}" in -h|--help) usage; exit 0 ;; esac

set -euo pipefail

# Bad/missing flags fall through to here: show help, exit non-zero.
bad_usage() { usage; exit 1; }

aspect=""; res=""; origin="center"; input=""; outdir=""; name=""
while getopts "a:r:o:i:p:n:h" opt; do
  case $opt in
    a) aspect=$OPTARG ;;
    r) res=$OPTARG ;;
    o) origin=$OPTARG ;;
    i) input=$OPTARG ;;
    p) outdir=$OPTARG ;;
    n) name=$OPTARG ;;
    h) usage; exit 0 ;;
    *) bad_usage ;;
  esac
done

# aspect/res/input/outdir are mandatory; anything missing is a usage error.
[[ -z $aspect || -z $res || -z $input || -z $outdir ]] && bad_usage
[[ ! -f $input ]] && { echo "input not found: $input" >&2; exit 1; }

case $res in
  1k) long=1920 ;;
  2k) long=2560 ;;
  4k) long=3840 ;;
  *) echo "bad res: $res" >&2; exit 1 ;;
esac

case $aspect in
  16:9) aw=16; ah=9 ;;
  5:3)  aw=5;  ah=3 ;;
  4:3)  aw=4;  ah=3 ;;
  1:1)  aw=1;  ah=1 ;;
  3:4)  aw=3;  ah=4 ;;
  3:5)  aw=3;  ah=5 ;;
  9:16) aw=9;  ah=16 ;;
  *) echo "bad aspect: $aspect" >&2; exit 1 ;;
esac

# Map the chosen res onto the LONGEST side, derive the short side from the aspect.
if (( aw >= ah )); then
  W=$long
  H=$(( long * ah / aw ))
else
  H=$long
  W=$(( long * aw / ah ))
fi
# yuv420p chroma subsampling + HEVC both require even width/height; round down.
W=$(( W - W % 2 )); H=$(( H - H % 2 ))

# Crop anchor → ffmpeg crop x/y offsets. iw/ih = scaled input, ow/oh = crop output.
case $origin in
  left)            cx=0;           cy="(ih-oh)/2" ;;
  right)           cx="iw-ow";     cy="(ih-oh)/2" ;;
  top)             cx="(iw-ow)/2"; cy=0 ;;
  bottom)          cx="(iw-ow)/2"; cy="ih-oh" ;;
  center|middle)   cx="(iw-ow)/2"; cy="(ih-oh)/2" ;;
  *) echo "bad origin: $origin" >&2; exit 1 ;;
esac

mkdir -p "$outdir"
stem=$(basename "${input%.*}")
aspect_tag=${aspect/:/x}
out="${name:-${stem}_${aspect_tag}_${res}_${origin}.mov}"
outpath="$outdir/$out"

# increase = scale UP until the frame covers the target box (overflow then cropped);
# lanczos = high-quality resampler. crop trims the overflow at the chosen anchor.
vf="scale=${W}:${H}:force_original_aspect_ratio=increase:flags=lanczos,crop=${W}:${H}:${cx}:${cy}"

ffmpeg -i "$input" \
  -vf "$vf" \
  -c:v libx265 \
  -preset medium \
  -crf 20 \
  -pix_fmt yuv420p \
  -tag:v hvc1 \
  -movflags +faststart \
  -c:a copy \
  "$outpath"

echo "→ $outpath"

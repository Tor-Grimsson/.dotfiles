#!/bin/bash
# vconvert.sh — scale+crop any video to a target aspect/resolution (no letterbox)
#
# Usage:
#   vconvert.sh -a <aspect> -r <res> -o <origin> -i <input> -p <outdir> [-n <name>]
#
#   -a  aspect:  16:9 | 5:3 | 4:3 | 1:1 | 3:4 | 3:5 | 9:16
#   -r  res:     1k (1920) | 2k (2560) | 4k (3840)   — longest side
#   -o  origin:  left | right | center | top | bottom | middle   (crop anchor)
#   -i  input video
#   -p  output directory
#   -n  output filename (optional; default: <stem>_<aspect>_<res>_<origin>.mov)
#
# Examples:
#   # 2K vertical 3:5, crop centered, output to current dir
#   vconvert.sh -a 3:5 -r 2k -o center -i yourvideo.mp4 -p .
#
#   # 4K square, crop centered
#   vconvert.sh -a 1:1 -r 4k -o center -i clip.mov -p ~/out
#
#   # 1080p vertical (9:16) from landscape source, anchor to left edge
#   vconvert.sh -a 9:16 -r 1k -o left -i wide.mp4 -p ~/out -n reel.mov
#
#   # 2K cinematic 5:3, anchor top (keep sky, crop floor)
#   vconvert.sh -a 5:3 -r 2k -o top -i drone.mp4 -p ~/out
#
#   # 4:3 retro from 4K source, anchor bottom
#   vconvert.sh -a 4:3 -r 2k -o bottom -i src.mov -p ./exports

set -euo pipefail

usage() { sed -n '2,25p' "$0"; exit 1; }

aspect=""; res=""; origin="center"; input=""; outdir=""; name=""
while getopts "a:r:o:i:p:n:h" opt; do
  case $opt in
    a) aspect=$OPTARG ;;
    r) res=$OPTARG ;;
    o) origin=$OPTARG ;;
    i) input=$OPTARG ;;
    p) outdir=$OPTARG ;;
    n) name=$OPTARG ;;
    *) usage ;;
  esac
done

[[ -z $aspect || -z $res || -z $input || -z $outdir ]] && usage
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

if (( aw >= ah )); then
  W=$long
  H=$(( long * ah / aw ))
else
  H=$long
  W=$(( long * aw / ah ))
fi
# force even dims for yuv420p / hevc
W=$(( W - W % 2 )); H=$(( H - H % 2 ))

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

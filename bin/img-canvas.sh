#!/usr/bin/env bash
# img-canvas.sh — fit any image into a fixed-aspect canvas (social-media sizes).

usage() {
  cat <<'EOF'
img-canvas.sh — fit any image into a fixed-aspect canvas (social-media sizes).

Takes any input format (jpg/png/tif/webp/heic/psd/…), scales it to one of the
preset aspect ratios, and writes an sRGB image at exactly the target pixels.
Default mode is COVER: fill the whole frame and center-crop the overflow — no
bars, no distortion. Layered/multi-frame inputs use frame [0] (PSD composite).

USAGE
  img-canvas.sh -a RATIO [-s 1|2] [-m MODE] [-g GRAVITY] [-f jpg|png] [-q N] [-c COLORS] [-b BG] [-o DIR] FILE...
  img-canvas.sh -P [other opts] FILE...        # GUI: prompt for aspect + scale (for Quick Actions)

PRESETS (-a) — short side 1080 at 1x, doubled at 2x
  9:16  → 1080x1920     5:4   → 1350x1080
  3:5   → 1080x1800     5:3   → 1800x1080
  4:5   → 1080x1350     16:9  → 1920x1080
  1:1   → 1080x1080
  Or pass a raw size: -a 1080x1350, or -a orig to keep the source's own ratio.

OPTIONS
  -a  aspect preset (above), raw WxH, or 'orig' to keep the source ratio. [required]
  -s  resolution: 1 (default) | 2 → short side 1080 ×N. Or 'orig' to keep the
      source's native resolution (crop/pad to the ratio, no scaling).
  -m  fit mode:
        cover    (default) scale to fill, center-crop overflow — exact canvas
        fit      scale to fit inside, pad to exact canvas with -b background
        stretch  force exact size, ignores aspect ratio (distorts)
  -g  gravity for cover-crop / fit-pad: center (default), north, south,
      east, west, northwest, …
  -f  output format: jpg (default) or png.
  -q  jpg quality 1-100 (default 90; ignored for png).
  -c  png palette colors (e.g. -c 256), no dithering — quantizes for flat
      graphics/illustrations, 70-90% smaller with no visible loss on that kind
      of source. Skip for photos (banding). Ignored for jpg. See
      img-convert.sh -h for the full explanation (same mechanism).
  -b  background for fit-pad / jpg flatten (default: white for jpg, none for png).
  -o  output directory (default: alongside each source).
  -P  pick mode: pop a macOS dialog for aspect + scale instead of -a/-s.
      Lets a Finder Quick Action stay a clean one-liner. Cancel = no-op.
  -h  show this help.

EXAMPLES
  img-canvas.sh -a 4:5 photo.jpg              # → photo_1080x1350.jpg, cover
  img-canvas.sh -a 9:16 -s 2 hero.png         # → hero_2160x3840.jpg
  img-canvas.sh -a 1:1 -m fit -b black art.tif
  img-canvas.sh -a 16:9 -f png -o out *.jpg   # batch into ./out, keep alpha
  img-canvas.sh -a 1080x1350 -g north pose.psd
  img-canvas.sh -a 4:5 -s orig big.tif        # crop to 4:5 at native resolution
  img-canvas.sh -a orig photo.jpg             # keep ratio, short side → 1080
  img-canvas.sh -a orig -s orig raw.psd       # re-encode only (keep ratio + res)
  img-canvas.sh -a 4:5 -f png -c 256 logo.png # flat PNG: canvas + quantize

NOTES
  - Dep: imagemagick (magick).
  - With a fixed -s, output is exactly the target pixels; cover upscales a
    small source to fill. With -s orig the source's pixels are kept (crop/pad).
  - -a orig keeps the source's ratio (no crop/pad); -s orig keeps its
    resolution; both together = a plain re-encode. -m stretch needs a fixed -s.
  - -auto-orient is applied first, so phone EXIF rotation is honored.
  - Output → <base>_<W>x<H>.<fmt> beside the source (overwrites), or in -o.
  - Wired into a Finder Quick Action — see docs/12-scripts/img-canvas.md.
EOF
}

case "${1:-}" in -h|--help) usage; exit 0 ;; esac

set -euo pipefail

aspect=""; scale=1; mode=cover; gravity=center; format=jpg; quality=90; colors=""; bg=""; outdir=""; pick=false

while getopts "a:s:m:g:f:q:c:b:o:hP" opt; do
  case "$opt" in
    a) aspect="$OPTARG" ;;
    s) scale="$OPTARG" ;;
    m) mode="$OPTARG" ;;
    g) gravity="$OPTARG" ;;
    f) format="$OPTARG" ;;
    q) quality="$OPTARG" ;;
    c) colors="$OPTARG" ;;
    b) bg="$OPTARG" ;;
    o) outdir="$OPTARG" ;;
    P) pick=true ;;
    h) usage; exit 0 ;;
    *) usage >&2; exit 1 ;;
  esac
done
shift $((OPTIND - 1))

# -P: GUI prompts fill -a/-s, so a Quick Action can be a clean one-liner. Cancel = no-op.
if [ "$pick" = true ]; then
  a=$(osascript -e 'choose from list {"9:16","3:5","4:5","1:1","5:4","5:3","16:9","original ratio"} with prompt "Aspect ratio:" default items {"4:5"}')
  [ "$a" = false ] && exit 0
  case "$a" in "original ratio") aspect=orig ;; *) aspect="$a" ;; esac
  s=$(osascript -e 'choose from list {"1x","2x","original resolution"} with prompt "Scale:" default items {"1x"}')
  [ "$s" = false ] && exit 0
  case "$s" in "original resolution") scale=orig ;; *) scale="${s%x}" ;; esac
fi

[ -n "$aspect" ] || { echo "error: -a is required (a preset, WxH, or orig)" >&2; usage >&2; exit 1; }
[ $# -gt 0 ]     || { echo "error: no input files" >&2; usage >&2; exit 1; }

# aspect → ratio base pixels (the 1080-based numbers encode the ratio); orig = keep source ratio; or raw WxH
case "$aspect" in
  orig|original|source) aspect=orig ;;
  9:16) RW=1080; RH=1920 ;;
  3:5)  RW=1080; RH=1800 ;;
  4:5)  RW=1080; RH=1350 ;;
  1:1)  RW=1080; RH=1080 ;;
  5:4)  RW=1350; RH=1080 ;;
  5:3)  RW=1800; RH=1080 ;;
  16:9) RW=1920; RH=1080 ;;
  *x*)  RW="${aspect%x*}"; RH="${aspect#*x}" ;;
  *)    echo "error: -a must be a preset (9:16 3:5 4:5 1:1 5:4 5:3 16:9), WxH, or orig" >&2; exit 1 ;;
esac
if [ "$aspect" != orig ]; then
  case "$RW$RH" in *[!0-9]*) echo "error: bad dimensions from -a '$aspect'" >&2; exit 1 ;; esac
fi

# resolution: positive integer (short side = 1080*N), or orig = keep the source's native pixels
case "$scale" in
  orig|original|native) scale=orig ;;
  ""|*[!0-9]*) echo "error: -s must be a positive integer or orig" >&2; exit 1 ;;
  *) [ "$scale" -ge 1 ] || { echo "error: -s must be >= 1" >&2; exit 1; } ;;
esac

case "$format" in jpeg) format=jpg ;; jpg|png) ;; *) echo "error: -f must be jpg or png" >&2; exit 1 ;; esac
case "$mode" in cover|fit|stretch) ;; *) echo "error: -m must be cover, fit or stretch" >&2; exit 1 ;; esac
if [ "$mode" = stretch ] && [ "$scale" = orig ] && [ "$aspect" != orig ]; then
  echo "error: -m stretch needs a fixed resolution — drop '-s orig'" >&2; exit 1
fi

# default background: white flattens jpg; none keeps png transparent
[ -n "$bg" ] || { [ "$format" = png ] && bg=none || bg=white; }
[ -z "$outdir" ] || mkdir -p "$outdir"

for src in "$@"; do
  [ -f "$src" ] || { echo "skip (not found): $src" >&2; continue; }
  base="$(basename "${src%.*}")"
  dir="${outdir:-$(dirname "$src")}"

  # geometry depends on the aspect × resolution combo; orig modes read the source dims
  geom=()
  if [ "$aspect" = orig ] && [ "$scale" = orig ]; then
    # keep ratio AND resolution — re-encode at native pixels, no geometry op
    read -r W H < <(magick "${src}[0]" -auto-orient -format '%w %h\n' info:)
  elif [ "$aspect" = orig ]; then
    # keep ratio, set short side to 1080*scale (no crop)
    ss=$((1080 * scale))
    read -r sw sh < <(magick "${src}[0]" -auto-orient -format '%w %h\n' info:)
    if [ "$sw" -le "$sh" ]; then W=$ss; H=$(( sh * ss / sw )); else H=$ss; W=$(( sw * ss / sh )); fi
    geom=(-resize "${ss}x${ss}^")
  elif [ "$scale" = orig ]; then
    # keep source resolution, crop (cover) or pad (fit) to the target ratio — no scaling
    read -r sw sh < <(magick "${src}[0]" -auto-orient -format '%w %h\n' info:)
    if [ $(( sw * RH )) -gt $(( sh * RW )) ]; then     # source wider than target ratio
      if [ "$mode" = cover ]; then H=$sh; W=$(( sh * RW / RH )); else W=$sw; H=$(( sw * RH / RW )); fi
    else                                               # source taller than (or equal to) target ratio
      if [ "$mode" = cover ]; then W=$sw; H=$(( sw * RH / RW )); else H=$sh; W=$(( sh * RW / RH )); fi
    fi
    geom=(-gravity "$gravity" -extent "${W}x${H}")
  else
    # fixed canvas: preset/WxH × scale (the original behavior)
    W=$(( RW * scale )); H=$(( RH * scale ))
    case "$mode" in
      cover)   geom=(-resize "${W}x${H}^" -gravity "$gravity" -extent "${W}x${H}") ;;
      fit)     geom=(-resize "${W}x${H}"  -gravity "$gravity" -extent "${W}x${H}") ;;
      stretch) geom=(-resize "${W}x${H}!") ;;
    esac
  fi

  dst="$dir/${base}_${W}x${H}.$format"
  args=("${src}[0]" -auto-orient -background "$bg")
  if [ ${#geom[@]} -gt 0 ]; then args+=("${geom[@]}"); fi
  [ "$format" = png ] && [ -n "$colors" ] && args+=(-dither None -colors "$colors")  # palette quantization, after the canvas is final; no dither = exact count + crisp edges
  [ "$format" = jpg ] && args+=(-flatten)        # composite any alpha onto bg
  args+=(-colorspace sRGB -depth 8)
  [ "$format" = jpg ] && args+=(-quality "$quality")
  args+=("$dst")

  magick "${args[@]}"
  echo "$src -> $dst"
done

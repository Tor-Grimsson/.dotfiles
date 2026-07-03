#!/usr/bin/env bash
# img-convert.sh — convert any image or PDF to JPG or PNG, fit within 2000px by default.

usage() {
  cat <<'EOF'
img-convert.sh — convert any image or PDF to JPG or PNG, fit within 2000px by default.

Takes any input format (jpg/png/tif/webp/heic/psd/pdf/eps/…), reads frame [0]
(so multi-frame / layered / multi-page files convert cleanly), and writes a
normalized sRGB 8-bit image. JPG flattens onto white; PNG keeps transparency. By
default the result is fit within a 2000x2000 box (aspect kept, shrink-only) —
pass -r to change or disable that.

Vector sources (pdf/eps/ai/ps) are rasterized at -d dpi first (default 300) so
the fit-to-2000 step has real pixels to work with; without it Ghostscript would
render at 72 dpi and the result would be tiny. One output per source by default
(first page) — pass -a to export every page as <base>-p01, -p02, ….

USAGE
  img-convert.sh [-F] [-f jpg|png] [-r GEOMETRY] [-e] [-q QUALITY] [-c COLORS] [-d DPI] [-a] [-o OUTDIR] FILE...
  img-convert.sh -P [other opts] FILE...        # GUI: prompt for format (for Quick Actions)

OPTIONS
  -F  force overwrite if output already exists (default: skip with warning)
  -f  output format: jpg (default) or png
  -r  resize geometry (default 2000x2000> — fit within 2000px, shrink-only);
      -r none keeps full size. Geometry: 1920x1080 (fit) | 1920x1080^ (fill) |
      50% | 2000x (width) | x1080 (height)
  -e  exact: force the final canvas to literally match -r's WxH, no matter
      what. Plain -r is fit-inside — it scales to fit the box but can land a
      pixel short on one axis (aspect-ratio rounding, e.g. a 1854x2316 source
      into 1600x2000 lands at 1600x1999, not 1600x2000). -e adds a center-
      gravity crop/pad pass after the resize so you always get exactly the
      WxH you asked for — crops any overflow, pads any shortfall with the
      same background already in use (white jpg / transparent png). Requires
      -r to be a literal WxH (e.g. -r 1600x2000); errors on -r none, -r 50%,
      or single-axis forms like -r 2000x. No distortion — this is cover+crop,
      not stretch. Pair with your /export-specs standard sizes (the
      @1x/@2x/@3x table — 4:5, 1:1, 9:16, etc.) for a guaranteed-clean
      standardized export every time.
  -q  quality 1-100 (default 90). jpg: standard lossy quality. png: zlib
      compression effort + filter (lossless, modest size win — a few % at most).
  -c  png palette colors (e.g. -c 256), no dithering (crisp, exact count —
      dithering blows past the count via error diffusion, which silently
      defeats palette conversion above ~85 colors). The actual lever for flat
      graphics/illustrations — a busy-looking flat PNG often carries tens of
      thousands of anti-aliasing colors it doesn't need; quantizing to 256 or
      fewer can cut file size 70-90% with no visible difference. Skip for
      photos (banding/gradients need dithering, which this doesn't do).
      Ignored for jpg. Default: off (full truecolor, as before).
  -d  rasterize DPI for vector sources — pdf/eps/ai/ps (default 300; raster
      sources ignore it). Higher = sharper + bigger before the resize.
  -a  all pages: export every page/frame as <base>-p01.<fmt>, -p02, … instead of
      just the first. Mainly for multi-page PDFs.
  -o  output directory (default: alongside each source)
  -P  pick mode: pop a macOS dialog for jpg/png instead of -f. Lets a Finder
      Quick Action stay a clean one-liner. Cancel = no-op.
  -h  show this help

EXAMPLES
  img-convert.sh photo.heic                  # → photo.jpg, fit within 2000px
  img-convert.sh deck.pdf                    # → deck.jpg, first page @300dpi, fit 2000px
  img-convert.sh -a deck.pdf                 # → deck-p01.jpg, deck-p02.jpg, …
  img-convert.sh -f png shot.tif             # → shot.png, keeps transparency
  img-convert.sh -r none big.tif             # → big.jpg, full size (no resize)
  img-convert.sh -d 600 -r none poster.pdf   # → poster.jpg, 600dpi full-res render
  img-convert.sh -o out -q 92 *.heic         # batch into ./out at quality 92
  img-convert.sh -f png -r 1600x2000 -c 256 art.png   # flat PNG: resize + quantize
  img-convert.sh -r 1080x1350 -e photo.jpg   # 4:5 @1x (export-specs), exact, guaranteed

NOTES
  - Deps: imagemagick (magick); Ghostscript (gs) for PDF/EPS input.
  - Metadata (EXIF, ICC profile name) is always stripped — output is normalized
    sRGB already, so nothing meaningful is lost.
  - "[0]" reads frame 0 — multi-page PDF/TIFF, animated GIF, HEIC, PSD composite
    all export a single still instead of every frame (use -a for all pages).
  - -auto-orient is applied first, so phone EXIF rotation is honored.
  - If the output would overwrite a same-name same-format source, a size suffix
    is added (e.g. photo.jpg -> photo-2000px.jpg) — the source is never clobbered.
  - -r suffixes: ^ = fill/cover, ! = force-exact (distorts), > = shrink-only.
  - Wired into a Finder Quick Action — see docs/12-scripts/img-convert.md.
EOF
}

case "${1:-}" in -h|--help) usage; exit 0 ;; esac

set -euo pipefail

format=jpg; resize="2000x2000>"; exact=false; quality=90; colors=""; dpi=300; outdir=""; pick=false; allpages=false; force=0

while getopts "f:r:eq:c:d:ao:FhP" opt; do
  case "$opt" in
    f) format="$OPTARG" ;;
    r) resize="$OPTARG" ;;
    e) exact=true ;;
    q) quality="$OPTARG" ;;
    c) colors="$OPTARG" ;;
    d) dpi="$OPTARG" ;;
    a) allpages=true ;;
    o) outdir="$OPTARG" ;;
    F) force=1 ;;
    P) pick=true ;;
    h) usage; exit 0 ;;
    *) usage >&2; exit 1 ;;
  esac
done
shift $((OPTIND - 1))

# -P: a GUI prompt fills -f, so a Quick Action can be a clean one-liner. Cancel = no-op.
if [ "$pick" = true ]; then
  f=$(osascript -e 'choose from list {"JPG","PNG"} with prompt "Output format:" default items {"JPG"}')
  [ "$f" = false ] && exit 0
  format=$(printf '%s' "$f" | tr '[:upper:]' '[:lower:]')
fi

[ $# -gt 0 ] || { echo "error: no input files" >&2; usage >&2; exit 1; }
case "$format" in jpeg) format=jpg ;; jpg|png) ;; *) echo "error: -f must be jpg or png" >&2; exit 1 ;; esac
case "$resize" in none|full|0) resize="" ;; esac
extent_wh=""
if [ "$exact" = true ]; then
  if [[ "$resize" =~ ^([0-9]+)x([0-9]+) ]]; then
    extent_wh="${BASH_REMATCH[1]}x${BASH_REMATCH[2]}"
  else
    echo "error: -e requires -r to be a literal WxH (e.g. -r 1600x2000), got: '$resize'" >&2
    exit 1
  fi
fi
[ -z "$outdir" ] || mkdir -p "$outdir"

for src in "$@"; do
  [ -f "$src" ] || { echo "skip (not found): $src" >&2; continue; }
  base="$(basename "${src%.*}")"
  dir="${outdir:-$(dirname "$src")}"
  src_ext="$(printf '%s' "${src##*.}" | tr '[:upper:]' '[:lower:]')"

  # Vector sources need an explicit render resolution before the input, else
  # Ghostscript defaults to 72 dpi and the fit-to-2000 step has nothing to shrink.
  args=()
  case "$src_ext" in pdf|eps|ai|ps) args+=(-density "$dpi") ;; esac

  if [ "$allpages" = true ]; then
    # Every page/frame → <base>-p01, -p02, … (-scene 1 makes %02d 1-based).
    args+=("$src")
    dst="$dir/$base-p%02d.$format"
    shown="$dir/$base-p01.$format, …"
  else
    # First page/frame only.
    args+=("${src}[0]")
    # Collision guard: <base>.<format> beside a source of the SAME format (case-
    # insensitive, APFS-safe) would clobber it — add a size suffix instead.
    dst="$dir/$base.$format"
    if [ -z "$outdir" ] && [ "$src_ext" = "$format" ]; then
      cap="$(printf '%s' "$resize" | grep -oE '[0-9]+' | head -1)"
      if [ -n "$cap" ]; then suffix="-${cap}px"; else suffix="-out"; fi
      dst="$dir/$base$suffix.$format"
    fi
    shown="$dst"
    [[ $force -eq 0 && -f "$dst" ]] && { echo "skip (exists): $dst — use -F to overwrite"; continue; }
  fi

  args+=(-auto-orient -strip)
  [ -n "$resize" ] && args+=(-resize "$resize")
  if [ "$format" = png ]; then
    args+=(-background none)                                    # keep transparency
    [ -n "$extent_wh" ] && args+=(-gravity center -extent "$extent_wh")  # force exact canvas: crop overflow, pad shortfall
    [ -n "$colors" ] && args+=(-dither None -colors "$colors")  # palette quantization, after resize+extent so the pad color is in the palette too; no dither = exact count + crisp edges (flat art, not photos), and keeps it under PNG's 256-entry palette cap
  else
    args+=(-background white -alpha remove -alpha off)  # JPEG has no alpha → composite each page onto white (per-image, so -a keeps every page; -flatten would merge them into one)
    [ -n "$extent_wh" ] && args+=(-gravity center -extent "$extent_wh")  # force exact canvas: crop overflow, pad shortfall (white)
  fi
  args+=(-quality "$quality" -colorspace sRGB -depth 8)        # jpg: lossy quality. png: zlib effort. then normalize color
  [ "$allpages" = true ] && args+=(-scene 1)                   # 1-based page numbering in %02d
  args+=("$dst")

  magick "${args[@]}"
  echo "$src -> $shown"
done

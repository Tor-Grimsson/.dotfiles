#!/usr/bin/env bash
# img-convert.sh — convert any image(s) to JPG or PNG, fit within 2000px by default.

usage() {
  cat <<'EOF'
img-convert.sh — convert any image(s) to JPG or PNG, fit within 2000px by default.

Takes any input format (jpg/png/tif/webp/heic/psd/…), reads frame [0] (so
multi-frame / layered files convert cleanly), and writes a normalized sRGB
8-bit image. JPG flattens onto white; PNG keeps transparency. By default the
result is fit within a 2000x2000 box (aspect kept, shrink-only) — pass -r to
change or disable that. One output per source — beside it, or into -o DIR.

USAGE
  img-convert.sh [-f jpg|png] [-r GEOMETRY] [-q QUALITY] [-o OUTDIR] FILE...
  img-convert.sh -P [other opts] FILE...        # GUI: prompt for format (for Quick Actions)

OPTIONS
  -f  output format: jpg (default) or png
  -r  resize geometry (default 2000x2000> — fit within 2000px, shrink-only);
      -r none keeps full size. Geometry: 1920x1080 (fit) | 1920x1080^ (fill) |
      50% | 2000x (width) | x1080 (height)
  -q  jpg quality 1-100 (default 90; ignored for png)
  -o  output directory (default: alongside each source)
  -P  pick mode: pop a macOS dialog for jpg/png instead of -f. Lets a Finder
      Quick Action stay a clean one-liner. Cancel = no-op.
  -h  show this help

EXAMPLES
  img-convert.sh photo.heic                  # → photo.jpg, fit within 2000px
  img-convert.sh -f png shot.tif             # → shot.png, keeps transparency
  img-convert.sh -r none big.tif             # → big.jpg, full size (no resize)
  img-convert.sh -r 1920x1080 *.png          # fit each inside 1920x1080
  img-convert.sh -o out -q 92 *.heic         # batch into ./out at quality 92

NOTES
  - Dep: imagemagick (magick).
  - "[0]" reads frame 0 — multi-page TIFF / animated GIF / HEIC / PSD composite
    all export a single still instead of every frame.
  - -auto-orient is applied first, so phone EXIF rotation is honored.
  - If the output would overwrite a same-name same-format source, a size suffix
    is added (e.g. photo.jpg -> photo-2000px.jpg) — the source is never clobbered.
  - -r suffixes: ^ = fill/cover, ! = force-exact (distorts), > = shrink-only.
  - Wired into a Finder Quick Action — see docs/12-scripts/img-convert.md.
EOF
}

case "${1:-}" in -h|--help) usage; exit 0 ;; esac

set -euo pipefail

format=jpg; resize="2000x2000>"; quality=90; outdir=""; pick=false

while getopts "f:r:q:o:hP" opt; do
  case "$opt" in
    f) format="$OPTARG" ;;
    r) resize="$OPTARG" ;;
    q) quality="$OPTARG" ;;
    o) outdir="$OPTARG" ;;
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
[ -z "$outdir" ] || mkdir -p "$outdir"

for src in "$@"; do
  [ -f "$src" ] || { echo "skip (not found): $src" >&2; continue; }
  base="$(basename "${src%.*}")"
  dir="${outdir:-$(dirname "$src")}"

  # Collision guard: <base>.<format> beside a source of the SAME format (case-
  # insensitive, APFS-safe) would clobber it — add a size suffix instead.
  dst="$dir/$base.$format"
  src_ext="$(printf '%s' "${src##*.}" | tr '[:upper:]' '[:lower:]')"
  if [ -z "$outdir" ] && [ "$src_ext" = "$format" ]; then
    cap="$(printf '%s' "$resize" | grep -oE '[0-9]+' | head -1)"
    if [ -n "$cap" ]; then suffix="-${cap}px"; else suffix="-out"; fi
    dst="$dir/$base$suffix.$format"
  fi

  args=("${src}[0]" -auto-orient)
  [ -n "$resize" ] && args+=(-resize "$resize")
  if [ "$format" = png ]; then
    args+=(-background none)                                    # keep transparency
  else
    args+=(-background white -flatten -quality "$quality")     # JPEG has no alpha → flatten onto white
  fi
  args+=(-colorspace sRGB -depth 8 "$dst")                      # normalize for predictable color

  magick "${args[@]}"
  echo "$src -> $dst"
done

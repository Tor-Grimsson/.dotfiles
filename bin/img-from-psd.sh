#!/usr/bin/env bash
# img-from-psd.sh — convert PSD(s) to JPG or PNG, with optional resize.

usage() {
  cat <<'EOF'
img-from-psd.sh — convert PSD(s) to JPG or PNG, with optional resize.

Reads the PSD's merged composite layer ([0]), so layered files convert cleanly
where macOS `sips` chokes. JPG flattens onto white; PNG keeps transparency.
Writes one output per source — beside it, or into -o DIR.

USAGE
  img-from-psd.sh [-F] [-f png|jpg] [-r GEOMETRY] [-q QUALITY] [-d DPI] [-o OUTDIR] FILE...

OPTIONS
  -F  force overwrite if output already exists (default: skip with warning)
  -f  output format: jpg (default) or png
  -r  resize geometry — 1920x1080 (fit) | 1920x1080^ (fill) | 50% | 2000x | x1080
  -q  jpg quality 1-100 (default 90; ignored for png)
  -d  output DPI metadata tag (does NOT re-rasterize — use -r for real pixels)
  -o  output directory (default: alongside each source)
  -h  show this help

EXAMPLES
  img-from-psd.sh art.psd                   # → art.jpg, full size
  img-from-psd.sh -f png art.psd            # → art.png, keeps transparency
  img-from-psd.sh -r 1920x1080 *.psd        # fit each inside 1920x1080
  img-from-psd.sh -r 50% -f png poster.psd  # half-size PNG
  img-from-psd.sh -o out -q 92 *.psd        # batch into ./out at quality 92

NOTES
  - Dep: imagemagick (magick).
  - "[0]" reads the merged composite; without it every layer exports as a frame.
  - -r suffixes: ^ = fill/cover, ! = force-exact (distorts), > = shrink-only.
  - Wired into a Finder Quick Action — see docs/12-scripts/img-from-psd.md.
EOF
}

case "${1:-}" in -h|--help) usage; exit 0 ;; esac

set -euo pipefail

format=jpg; resize=""; quality=90; dpi=""; outdir=""; force=0

while getopts "f:r:q:d:o:Fh" opt; do
  case "$opt" in
    f) format="$OPTARG" ;;
    r) resize="$OPTARG" ;;
    q) quality="$OPTARG" ;;
    d) dpi="$OPTARG" ;;
    o) outdir="$OPTARG" ;;
    F) force=1 ;;
    h) usage; exit 0 ;;
    *) usage >&2; exit 1 ;;
  esac
done
shift $((OPTIND - 1))

[ $# -gt 0 ] || { echo "error: no input files" >&2; usage >&2; exit 1; }
case "$format" in jpeg) format=jpg ;; jpg|png) ;; *) echo "error: -f must be jpg or png" >&2; exit 1 ;; esac
[ -z "$outdir" ] || mkdir -p "$outdir"

for src in "$@"; do
  [ -f "$src" ] || { echo "skip (not found): $src" >&2; continue; }
  base="$(basename "${src%.*}")"
  dir="${outdir:-$(dirname "$src")}"
  dst="$dir/$base.$format"
  [[ $force -eq 0 && -f "$dst" ]] && { echo "skip (exists): $dst — use -F to overwrite"; continue; }

  args=()
  [ -n "$dpi" ] && args+=(-density "$dpi")    # DPI tag only; must precede the input
  args+=("${src}[0]")                          # [0] = merged composite layer
  [ -n "$resize" ] && args+=(-resize "$resize")
  if [ "$format" = png ]; then
    args+=(-background none)                    # keep transparency
  else
    args+=(-background white -flatten -quality "$quality")  # JPEG has no alpha → flatten onto white
  fi
  args+=("$dst")

  magick "${args[@]}"
  echo "$src -> $dst"
done

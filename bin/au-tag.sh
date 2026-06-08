#!/usr/bin/env bash
# au-tag.sh — write album metadata + cover art into a folder of audio files,
# from a sidecar .md (YAML frontmatter), via yq + ffmpeg.

usage() {
  cat <<'EOF'
au-tag.sh — tag a folder of audio from a sidecar .md (frontmatter) + cover image.

Reads album metadata from a markdown file's YAML frontmatter (artist, album,
year, genre, …) plus an album cover, then writes ID3/Vorbis tags and an embedded
front cover into every *.mp3 / *.flac in the folder (ffmpeg, no re-encode).
Per-track titles come from a `tracklist:` array if present, else the filename.

USAGE
  au-tag.sh [-m FILE.md] [-c COVER] [-s PX] [-T] [dir]      # default dir .

OPTIONS
  -m  metadata .md (default: the first *.md in the folder).
  -c  cover image (default: 'cover' in frontmatter, else cover/folder/front/album.{jpg,png}
      found in the folder OR its _assets/ subfolder).
  -s  downscale the EMBEDDED cover to PX on its longest side (default 1000; 0 =
      embed as-is). Shrinks only; the source image file is never modified.
  -T  do NOT set per-track title/number (leave existing titles alone).
  -h  show this help.

FRONTMATTER (all fields optional)
  ---
  artist: Boards of Canada
  album: Music Has the Right to Children
  albumartist: Boards of Canada
  year: 1998
  genre: Electronic
  cover: cover.jpg
  tracklist:
    - Wildlife Analysis
    - An Eagle in Your Mind
  ---

BEHAVIOR
  - Album fields are written to every file. Title/track default from the
    tracklist (in folder sort order), else the filename
    ("01 Wildlife Analysis.mp3" -> track 1, title "Wildlife Analysis").
  - Cover is embedded as the front cover, replacing any existing embedded image,
    downscaled to a lean ~1000px copy by default (-s) so tracks don't bloat.
  - Each file is re-muxed with -c copy (no re-encode) to a temp file, then
    moved over the original.

EXAMPLES
  au-tag.sh ~/Music/boc-mhtrtc           # tag that album folder from its .md
  au-tag.sh -c art.png -T .              # custom cover, keep existing titles

NOTES
  - Deps: yq (frontmatter parse) + ffmpeg (tagging/embedding) + imagemagick
    (cover downscale when -s > 0, the default; falls back to full-size if absent).
  - Non-recursive; tracklist[] pairs to files in sort order — name tracks with
    zero-padded numbers (01, 02, …) so they sort right.
EOF
}

case "${1:-}" in -h|--help) usage; exit 0 ;; esac

set -euo pipefail

md=""; cover=""; set_title=true; csize=1000
while getopts "m:c:s:Th" opt; do
  case "$opt" in
    m) md="$OPTARG" ;;
    c) cover="$OPTARG" ;;
    s) csize="$OPTARG" ;;
    T) set_title=false ;;
    h) usage; exit 0 ;;
    *) usage >&2; exit 1 ;;
  esac
done
shift $((OPTIND - 1))
dir="${1:-.}"
case "$csize" in ""|*[!0-9]*) echo "error: -s must be a non-negative integer px (0 = embed as-is)" >&2; exit 1 ;; esac

command -v yq     >/dev/null || { echo "error: yq not found (brew install yq)" >&2; exit 1; }
command -v ffmpeg >/dev/null || { echo "error: ffmpeg not found" >&2; exit 1; }
[ -d "$dir" ] || { echo "error: not a directory: $dir" >&2; exit 1; }

# locate the sidecar .md
if [ -z "$md" ]; then
  md=$(find "$dir" -maxdepth 1 -type f -iname "*.md" | sort | head -1)
fi
[ -n "$md" ] && [ -f "$md" ] || { echo "error: no .md metadata in $dir (use -m)" >&2; exit 1; }

# frontmatter reader: prints the field value, or empty if absent/null
fm() { yq --front-matter=extract "$1 // \"\"" "$md"; }

artist=$(fm '.artist')
album=$(fm '.album')
albumartist=$(fm '.albumartist')
year=$(fm '.year')
genre=$(fm '.genre')
[ -n "$albumartist" ] || albumartist="$artist"
[ -n "$cover" ] || cover=$(fm '.cover')

# resolve cover: explicit / frontmatter (relative to the .md), else auto-detect
mddir=$(dirname "$md")
if [ -n "$cover" ]; then
  [ -f "$cover" ] || cover="$mddir/$cover"
else
  for base in "$dir" "$dir/_assets"; do                 # folder first (music std), then _assets/
    for cand in cover folder front album Folder Cover; do
      for ext in jpg jpeg png JPG JPEG PNG; do
        if [ -f "$base/$cand.$ext" ]; then cover="$base/$cand.$ext"; break 3; fi
      done
    done
  done
fi
[ -n "$cover" ] && [ -f "$cover" ] || cover=""   # no cover is allowed

# embed a lean, downscaled copy of the cover (longest side csize; 0 = embed as-is).
# Shrinks only (">"), so a small cover is never upscaled. Never touches the source.
cover_embed="$cover"; cover_tmp=""
if [ -n "$cover" ] && [ "$csize" -gt 0 ]; then
  if command -v magick >/dev/null; then
    cover_tmp="${TMPDIR:-/tmp}/au-tag-cover.$$.jpg"
    if magick "$cover" -resize "${csize}x${csize}>" -colorspace sRGB -quality 88 "$cover_tmp" 2>/dev/null; then
      cover_embed="$cover_tmp"
    else
      echo "note: cover resize failed — embedding original" >&2; rm -f "$cover_tmp"; cover_tmp=""
    fi
  else
    echo "note: imagemagick not found — embedding cover at full size (-s ignored)" >&2
  fi
fi

# tracklist length (0 if none)
tl_len=$(yq --front-matter=extract '.tracklist // [] | length' "$md")
[[ "$tl_len" =~ ^[0-9]+$ ]] || tl_len=0

echo "metadata: ${artist:-?} — ${album:-?} (${year:-?})   cover: ${cover:-none}${cover_tmp:+ → embedded @ ${csize}px}"

i=0
while IFS= read -r f; do
  ext_lc=$(printf '%s' "${f##*.}" | tr '[:upper:]' '[:lower:]')

  # per-track title/number: tracklist wins, else parse the filename
  title=""; track=""
  if [ "$set_title" = true ]; then
    if [ "$i" -lt "$tl_len" ]; then
      title=$(yq --front-matter=extract ".tracklist[$i] // \"\"" "$md")
      track=$((i + 1))
    else
      bn=$(basename "${f%.*}")
      if [[ "$bn" =~ ^([0-9]{1,3})[[:space:]._-]+(.+)$ ]]; then
        track=$((10#${BASH_REMATCH[1]})); title="${BASH_REMATCH[2]}"
      else
        title="$bn"
      fi
    fi
  fi

  # metadata args — only the fields that are set
  meta=()
  [ -n "$artist" ]      && meta+=(-metadata "artist=$artist")
  [ -n "$album" ]       && meta+=(-metadata "album=$album")
  [ -n "$albumartist" ] && meta+=(-metadata "album_artist=$albumartist")
  [ -n "$year" ]        && meta+=(-metadata "date=$year")
  [ -n "$genre" ]       && meta+=(-metadata "genre=$genre")
  [ -n "$title" ]       && meta+=(-metadata "title=$title")
  [ -n "$track" ]       && meta+=(-metadata "track=$track")

  tmp="${f%.*}.autag-tmp.${f##*.}"

  # assemble one ffmpeg arg list (3.2-safe: never expand an empty array)
  ff=(-nostdin -y -loglevel error -i "$f")
  if [ -n "$cover" ]; then
    case "$ext_lc" in
      mp3)  ff+=(-i "$cover_embed" -map 0:a -map 1:v -c copy -id3v2_version 3 \
                 -metadata:s:v title="Album cover" -metadata:s:v comment="Cover (front)") ;;
      flac) ff+=(-i "$cover_embed" -map 0:a -map 1:v -c copy -disposition:v attached_pic) ;;
      *)    ff+=(-c copy) ;;
    esac
  else
    ff+=(-c copy)
  fi
  if [ ${#meta[@]} -gt 0 ]; then ff+=("${meta[@]}"); fi
  ff+=("$tmp")

  ffmpeg "${ff[@]}"
  mv -f "$tmp" "$f"
  echo "tagged: $(basename "$f")${title:+  → $title}"
  i=$((i + 1))
done < <(find "$dir" -maxdepth 1 -type f \( -iname '*.mp3' -o -iname '*.flac' \) | sort)

[ -n "$cover_tmp" ] && rm -f "$cover_tmp"
[ "$i" -gt 0 ] || echo "no .mp3/.flac files found in $dir" >&2

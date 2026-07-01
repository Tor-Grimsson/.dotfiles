#!/usr/bin/env bash
# au-transcribe-playlist.sh — expand a playlist/profile URL (yt-dlp) into its
# entries and transcribe each one sequentially with au-transcribe.sh.

usage() {
  cat <<'EOF'
au-transcribe-playlist.sh — transcribe every video in a playlist/profile URL, in order.

Expands a playlist, channel, or profile URL into its individual entries with
yt-dlp (--flat-playlist), then runs au-transcribe.sh on each one **sequentially**
(one whisper pass at a time), writing a <slug>.md per entry into OUTDIR. A single
video URL works too (treated as a one-item list).

USAGE
  au-transcribe-playlist.sh [-m MODEL] [-l LANG] [-o OUTDIR] [-n LIMIT] [-c BROWSER] [-M] [-k] <playlist-url>

OPTIONS
  -m  whisper model (default: au-transcribe's default, base). Passed through.
  -l  spoken-language hint (default: auto). Passed through.
  -o  output directory for the .md files (default: current dir).
  -n  stop after the first LIMIT entries (default: all). Guards against
      transcribing a whole profile by accident.
  -c  load yt-dlp cookies from a browser (chrome|firefox|safari|…) — required for
      login-gated lists like TikTok collections. Used for BOTH the playlist
      expansion and each entry fetch. e.g. -c firefox.
  -s  grab N key screenshots per video, spread evenly through it, saved beside
      each .md in <slug>-frames/ and embedded with timestamps. Switches the
      per-entry transcriber to au-transcribe-ss.sh. e.g. -s 5. (Excludes -M.)
  -d  with -s, also add an AI "Visual overview" of the frames via the `llm` CLI.
  -M  identify the movie/show each clip is from (caption + top comments +
      transcript → llm). Passed through to au-transcribe.sh; needs the `llm` CLI.
  -k  keep each extracted .wav beside its .md.
  -h  show this help.

EXAMPLES
  # a TikTok profile (all videos)
  au-transcribe-playlist.sh https://www.tiktok.com/@user
  # a TikTok collection/playlist, first 10, into a folder, small model
  au-transcribe-playlist.sh -n 10 -m small -o ~/Notes/tt https://www.tiktok.com/@user/playlist/Name-123
  # a TikTok collection with 5 screenshots per clip
  au-transcribe-playlist.sh -s 5 -c firefox -o ~/Desktop/code https://www.tiktok.com/@user/collection/Code-123
  # a YouTube playlist
  au-transcribe-playlist.sh https://www.youtube.com/playlist?list=PL...

NOTES
  - Deps: yt-dlp (expansion) + everything au-transcribe.sh needs (ffmpeg,
    whisper-cli, jq). yt-dlp walks the playlist; au-transcribe.sh fetches +
    transcribes each entry with --no-playlist, so nothing is double-expanded.
  - Sequential by design: whisper is CPU/GPU-bound, so entries run one at a time.
  - A failed entry is reported and skipped; the run continues to the next, and
    the script exits non-zero if any entry failed.
  - Output naming, slug, and clobber-avoidance are au-transcribe.sh's (a repeated
    title gets -2, -3…).
EOF
}

case "${1:-}" in -h|--help|"") usage; exit 0 ;; esac

set -euo pipefail

model=""; lang=""; outdir="."; limit=""; keep=false; identify=false; cookies=""; frames=""; describe=false
while getopts "m:l:o:n:c:s:dkMh" opt; do
  case "$opt" in
    m) model="$OPTARG" ;;
    l) lang="$OPTARG" ;;
    o) outdir="$OPTARG" ;;
    n) limit="$OPTARG" ;;
    c) cookies="$OPTARG" ;;
    s) frames="$OPTARG" ;;
    d) describe=true ;;
    k) keep=true ;;
    M) identify=true ;;
    h) usage; exit 0 ;;
    *) usage >&2; exit 1 ;;
  esac
done
shift $((OPTIND - 1))
[ "$#" -ge 1 ] || { echo "error: need a playlist/profile URL" >&2; usage >&2; exit 1; }
playlist="$1"

command -v yt-dlp >/dev/null || { echo "error: yt-dlp not found (needed to expand the playlist)" >&2; exit 1; }

# -s picks the screenshot transcriber; it can't combine with -M (different script)
if [ -n "$frames" ]; then
  case "$frames" in
    ''|*[!0-9]*) echo "error: -s N must be a non-negative integer" >&2; exit 1 ;;
  esac
  if [ "$identify" = true ]; then
    echo "error: -s (screenshots, au-transcribe-ss.sh) and -M (movie ID, au-transcribe.sh) use different transcribers — pick one" >&2; exit 1
  fi
fi
if [ "$describe" = true ] && [ -z "$frames" ]; then
  echo "error: -d (visual overview) requires -s N" >&2; exit 1
fi

# locate the sibling transcriber (-s → the screenshot variant); fall back to PATH
here="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
transcriber="au-transcribe.sh"; [ -n "$frames" ] && transcriber="au-transcribe-ss.sh"
au_transcribe="$here/$transcriber"
[ -x "$au_transcribe" ] || au_transcribe="$transcriber"

# validate -n if given
if [ -n "$limit" ]; then
  case "$limit" in
    ''|*[!0-9]*) echo "error: -n LIMIT must be a positive integer" >&2; exit 1 ;;
    0)           echo "error: -n LIMIT must be ≥ 1" >&2; exit 1 ;;
  esac
fi

# expand the playlist → one entry URL per line
echo "▸ expanding playlist: $playlist" >&2
list="$(mktemp "${TMPDIR:-/tmp}/au-pl.XXXXXX")"
trap 'rm -f "$list"' EXIT
ytargs=(--flat-playlist --no-warnings --ignore-errors)
[ -n "$cookies" ] && ytargs+=(--cookies-from-browser "$cookies")
[ -n "$limit" ]   && ytargs+=(-I "1:$limit")
ytargs+=(--print url)
if ! yt-dlp "${ytargs[@]}" "$playlist" > "$list"; then
  echo "error: yt-dlp failed to expand $playlist" >&2; exit 1
fi

# read entry URLs (bash 3.2: no mapfile)
urls=()
while IFS= read -r u; do
  [ -n "$u" ] && urls+=("$u")
done < "$list"

total=${#urls[@]}
if [ "$total" -le 0 ]; then
  echo "error: no entries found in $playlist" >&2
  echo "       TikTok collection/playlist extractors break often — if yt-dlp reported" >&2
  echo "       'Downloading 0 items', it's likely outdated: try 'brew upgrade yt-dlp'" >&2
  echo "       (private lists may also need --cookies-from-browser, not wired here)." >&2
  exit 1
fi
echo "▸ $total to transcribe → $outdir" >&2

# forward only the flags the user set; au-transcribe owns the defaults
fwd=(-o "$outdir")
[ -n "$model" ]        && fwd+=(-m "$model")
[ -n "$lang" ]         && fwd+=(-l "$lang")
[ -n "$cookies" ]      && fwd+=(-c "$cookies")
[ -n "$frames" ]       && fwd+=(-n "$frames")
[ "$describe" = true ] && fwd+=(-d)
[ "$keep" = true ]     && fwd+=(-k)
[ "$identify" = true ] && fwd+=(-M)

i=0; failures=0
for u in "${urls[@]}"; do
  i=$((i + 1))
  echo "▸ [$i/$total] $u" >&2
  if ! "$au_transcribe" "${fwd[@]}" "$u"; then
    echo "✗ skipped [$i/$total]: $u" >&2
    failures=$((failures + 1))
  fi
done

if [ "$failures" -eq 0 ]; then
  echo "✓ done — all $total transcribed → $outdir" >&2
else
  echo "✓ done — $((total - failures))/$total transcribed, $failures skipped → $outdir" >&2
  exit 1
fi

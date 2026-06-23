#!/usr/bin/env bash
# dl-yt.sh — download a video (or just its audio) from a URL with yt-dlp, at the
# highest quality available. Defaults to the best video + best audio merged to
# mkv so the top audio stream (Opus) survives; mp4 and audio-only modes provided.

usage() {
  cat <<'EOF'
dl-yt.sh — URL → highest-quality media file (yt-dlp).

Downloads the best video + best audio and merges them. By default the container
is MKV, because that is the only way to KEEP the highest audio: YouTube's best
audio is Opus (~160k) and an MP4 container cannot hold it — forcing .mp4 silently
downgrades audio to AAC (~128k). Use -m only when you need MP4 compatibility, or
-a to pull the best audio on its own (kept in its native codec, no re-encode).

USAGE
  dl-yt.sh [-a] [-m] [-o DIR] [-f FMT] [-c BROWSER] <url> [more urls…]

OPTIONS
  -a  audio only — grab the best audio stream and keep its native codec
      (Opus/m4a), no transcode, highest possible fidelity. Overrides -m.
  -m  MP4 output instead of MKV — best mp4-compatible streams, audio remuxed to
      the best AAC (m4a). More portable, but NOT the highest possible audio.
  -o  output directory (default: current dir).
  -f  raw yt-dlp -f format selector, passed straight through (power users).
      Overrides the mode's built-in selection. e.g. -f "bv*[height<=720]+ba"
  -c  load cookies from a browser (chrome|firefox|safari|edge|brave|…) for
      login-gated or age-gated URLs. e.g. -c firefox
  -h  show this help.

EXAMPLES
  dl-yt.sh https://youtu.be/dQw4w9WgXcQ            # best everything → .mkv
  dl-yt.sh -a https://youtu.be/dQw4w9WgXcQ         # best audio only (Opus/m4a)
  dl-yt.sh -m https://youtu.be/dQw4w9WgXcQ         # best mp4 (audio capped to AAC)
  dl-yt.sh -o ~/Desktop https://youtu.be/a https://youtu.be/b   # batch
  dl-yt.sh -c firefox https://youtu.be/private     # login-gated

NOTES
  - Deps: yt-dlp + ffmpeg (the merge/remux step). Both in the Brewfile.
  - Filenames come from the video title (%(title)s); already-downloaded files are
    skipped (--no-overwrites), so re-running is idempotent.
  - Highest audio ≠ MP4: keep the MKV default for archival/listening; reach for
    -m only when a target player can't handle MKV. mpv/VLC play MKV fine.
EOF
}

case "${1:-}" in -h|--help|"") usage; exit 0 ;; esac

set -euo pipefail

mode="video"; outdir="."; fmt=""; cookies=""
while getopts "amo:f:c:h" opt; do
  case "$opt" in
    a) mode="audio" ;;
    m) [ "$mode" = "audio" ] || mode="mp4" ;;
    o) outdir="$OPTARG" ;;
    f) fmt="$OPTARG" ;;
    c) cookies="$OPTARG" ;;
    h) usage; exit 0 ;;
    *) usage >&2; exit 1 ;;
  esac
done
shift $((OPTIND - 1))
[ "$#" -ge 1 ] || { echo "error: need at least one URL" >&2; usage >&2; exit 1; }

command -v yt-dlp >/dev/null || { echo "error: yt-dlp not found (brew install yt-dlp)" >&2; exit 1; }
command -v ffmpeg >/dev/null || { echo "error: ffmpeg not found (brew install ffmpeg)" >&2; exit 1; }

args=(--no-overwrites --no-playlist -o "${outdir%/}/%(title)s.%(ext)s")
[ -n "$cookies" ] && args+=(--cookies-from-browser "$cookies")

# An explicit -f replaces the mode's built-in selector but keeps its container.
if [ -n "$fmt" ]; then
  args+=(-f "$fmt")
  case "$mode" in
    audio) args+=(-x --audio-quality 0) ;;
    mp4)   args+=(--merge-output-format mp4) ;;
    video) args+=(--merge-output-format mkv) ;;
  esac
else
  case "$mode" in
    audio) args+=(-f "bestaudio/best" -x --audio-quality 0) ;;
    mp4)   args+=(-S "res,ext:mp4:m4a" --merge-output-format mp4) ;;
    video) args+=(-f "bv*+ba/b" --merge-output-format mkv) ;;
  esac
fi

yt-dlp "${args[@]}" "$@"

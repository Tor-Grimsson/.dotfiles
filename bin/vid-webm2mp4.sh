#!/usr/bin/env bash
# vid-webm2mp4.sh — convert a WebM (canvas/screen recording) to H.264/AAC MP4.

usage() {
  cat <<'EOF'
vid-webm2mp4.sh — convert a WebM recording to an MP4 (H.264 video, AAC audio).

Aimed at canvas / screen-capture .webm files (VP8/VP9 + Opus) that won't play
or edit cleanly elsewhere. Re-encodes video to H.264 at CRF 18 (near-lossless).

USAGE
  vid-webm2mp4.sh <input.webm> [output.mp4]

ARGUMENTS
  input.webm   source file (required)
  output.mp4   destination (optional; default <input>.mp4 alongside the source)

EXAMPLES
  vid-webm2mp4.sh ~/Downloads/kol-realtime.webm
  vid-webm2mp4.sh ~/Downloads/kol-realtime.webm ~/Videos/kol-realtime.mp4

NOTES
  Codec: H.264 (libx264, CRF 18, medium preset) + AAC 192k in an .mp4. Needs ffmpeg.
EOF
}

case "${1:-}" in -h|--help) usage; exit 0 ;; esac

set -e

if [ -z "${1:-}" ]; then
  echo "Usage: vid-webm2mp4.sh <input.webm> [output.mp4]" >&2
  exit 1
fi

input="$1"
# Default output: same path with .webm swapped for .mp4.
output="${2:-${input%.webm}.mp4}"

# CRF 18 = visually near-lossless; medium preset balances speed vs size.
ffmpeg -i "$input" -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k "$output"
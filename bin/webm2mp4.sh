#!/usr/bin/env bash
set -e

# Convert webm (canvas/screen recordings) to mp4 (H.264/AAC)
#
# Usage:
#   webm2mp4.sh input.webm [output.mp4]
#
# Examples:
#   webm2mp4.sh ~/Downloads/kol-realtime.webm
#   webm2mp4.sh ~/Downloads/kol-realtime.webm ~/Videos/kol-realtime.mp4

if [ -z "$1" ]; then
  echo "Usage: webm2mp4.sh <input.webm> [output.mp4]"
  exit 1
fi

input="$1"
output="${2:-${input%.webm}.mp4}"

ffmpeg -i "$input" -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 192k "$output"
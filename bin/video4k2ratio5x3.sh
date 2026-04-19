#!/bin/bash
# Example: video4k2ratio5x3.sh ~/Downloads/clip.mp4
# Example: video4k2ratio5x3.sh "/Users/biskup/Library/Mobile Documents/com~apple~CloudDocs/Workbox/clip.mp4"
ffmpeg -i "$1" -vf "scale=2000:1200:force_original_aspect_ratio=increase,crop=2000:1200" -c:v libx264 -preset slow -crf 18 -pix_fmt yuv420p -c:a copy "${1%.*}_2000x1200.mp4"

#!/bin/bash
ffmpeg -i "$1" -vf "scale=1920:-1" -c:v libx264 -preset slow -crf 18 -pix_fmt yuv420p -c:a copy "${1%.*}_1080p.mp4"
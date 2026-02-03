#!/bin/bash
shopt -s nullglob nocaseglob

for f in *.mov *.mp4 *.mxf *.avi; do
  ffmpeg \
    -i "$f" \
    -vf "scale=iw:ih:flags=lanczos" \
    -c:v hevc_videotoolbox \
    -profile:v main10 \
    -pix_fmt p010le \
    -b:v 80M \
    -maxrate 80M \
    -bufsize 160M \
    -tag:v hvc1 \
    -movflags +faststart \
    -c:a copy \
    "${f%.*}_h265_hw.mov"
done

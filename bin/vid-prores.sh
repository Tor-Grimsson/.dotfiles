#!/bin/bash
for f in *.mov *.mp4 *.mxf *.avi; do
  ffmpeg -i "$f" \
    -c:v prores_ks -profile:v 3 \
    -pix_fmt yuv422p10le \
    -c:a pcm_s24le \
    "${f%.*}_prores422hq.mov"
done


#!/bin/bash
# vid-prores.sh — batch transcode cwd videos to ProRes 422 HQ for editing.

usage() {
  cat <<'EOF'
vid-prores.sh — batch transcode every video in the cwd to ProRes 422 HQ.

Produces an edit-friendly mezzanine: ProRes 422 HQ video (10-bit 4:2:2) with
uncompressed 24-bit PCM audio. Large files — this is an intermediate, not delivery.

USAGE
  vid-prores.sh          # run inside the folder of clips you want as ProRes

ARGUMENTS
  (none)  Globs *.mov *.mp4 *.mxf *.avi in the cwd.

EXAMPLES
  cd ~/footage && vid-prores.sh

NOTES
  Codec: ProRes 422 HQ (prores_ks, profile 3, yuv422p10le) + PCM s24le in a .mov.
  Software encode (no VideoToolbox), so it's CPU-bound. Needs ffmpeg.
  Output: <name>_prores422hq.mov next to each source.
EOF
}

case "${1:-}" in -h|--help) usage; exit 0 ;; esac

shopt -s nullglob   # if an extension has no matches, skip it instead of passing a literal '*.mxf'

for f in *.mov *.mp4 *.mxf *.avi; do
  ffmpeg -i "$f" \
    -c:v prores_ks -profile:v 3 \
    -pix_fmt yuv422p10le \
    -c:a pcm_s24le \
    "${f%.*}_prores422hq.mov"
    # -c:v prores_ks -profile:v 3  ProRes encoder, profile 3 = 422 HQ
    # -pix_fmt yuv422p10le  10-bit 4:2:2 (ProRes's native colour)
    # -c:a pcm_s24le  uncompressed 24-bit PCM audio (lossless, for editing)
done


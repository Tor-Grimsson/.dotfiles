#!/bin/bash
# vid-h265-small-web.sh — batch transcode cwd videos to web-friendly ~12 Mbps H.265 .mp4.

usage() {
  cat <<'EOF'
vid-h265-small-web.sh — batch transcode cwd videos to a small, web-ready H.265 .mp4.

Like vid-h265-small.sh but targets the web: forces 8-bit yuv420p (broadest player
support) and writes an .mp4 container. Hardware HEVC, ~12 Mbps, AAC audio.

USAGE
  vid-h265-small-web.sh  # run inside the folder of clips you want web-ready

ARGUMENTS
  (none)  Globs *.mov *.mp4 *.mxf *.avi in the cwd (case-insensitive).

EXAMPLES
  cd ~/footage && vid-h265-small-web.sh

NOTES
  Codec: HEVC (hevc_videotoolbox, 12M, yuv420p 8-bit) + AAC 192k in an .mp4, hvc1-tagged.
  Output: <name>_h265_small.mp4 next to each source. Needs ffmpeg with VideoToolbox.
  HEVC-in-MP4 still needs a Safari/HEVC-capable browser; not universal like H.264.
EOF
}

case "${1:-}" in -h|--help) usage; exit 0 ;; esac

shopt -s nullglob nocaseglob

for f in *.mov *.mp4 *.mxf *.avi; do
  ffmpeg -i "$f" \
    -c:v hevc_videotoolbox \
    -b:v 12M \
    -tag:v hvc1 \
    -pix_fmt yuv420p \
    -movflags +faststart \
    -c:a aac -b:a 192k \
    "${f%.*}_h265_small.mp4"
    # -b:v 12M  delivery-sized bitrate; -pix_fmt yuv420p  8-bit for broad web playback
    # -tag:v hvc1  HEVC tag; +faststart  moov atom up front so the page can stream it
    # -c:a aac -b:a 192k  re-encode audio to AAC
done
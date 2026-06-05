#!/bin/bash
# vid-h265-small.sh — batch transcode cwd videos to lightweight ~12 Mbps H.265 .mov.

usage() {
  cat <<'EOF'
vid-h265-small.sh — batch transcode every video in the cwd to a small H.265 .mov.

Hardware HEVC at a delivery-sized ~12 Mbps with AAC audio. No resize — keeps the
source resolution, just drops bitrate for sharable files. Output is a .mov.

USAGE
  vid-h265-small.sh      # run inside the folder of clips you want shrunk

ARGUMENTS
  (none)  Globs *.mov *.mp4 *.mxf *.avi in the cwd (case-insensitive).

EXAMPLES
  cd ~/footage && vid-h265-small.sh

NOTES
  Codec: HEVC (hevc_videotoolbox, 12M) + AAC 192k in a .mov, hvc1-tagged.
  Output: <name>_h265_small.mov next to each source. Needs ffmpeg with VideoToolbox.
  Sibling vid-h265-small-web.sh is identical settings but writes an .mp4 + yuv420p.
EOF
}

case "${1:-}" in -h|--help) usage; exit 0 ;; esac

shopt -s nullglob nocaseglob

for f in *.mov *.mp4 *.mxf *.avi; do
  ffmpeg \
    -i "$f" \
    -c:v hevc_videotoolbox \
    -b:v 12M \
    -maxrate 12M \
    -bufsize 24M \
    -tag:v hvc1 \
    -movflags +faststart \
    -c:a aac -b:a 192k \
    "${f%.*}_h265_small.mov"
    # -b:v/-maxrate/-bufsize 12M/12M/24M  delivery-sized bitrate (vs 80-200M masters)
    # -tag:v hvc1  QuickTime HEVC tag; +faststart  moov atom up front for streaming
    # -c:a aac -b:a 192k  re-encode audio to AAC (not copied)
done

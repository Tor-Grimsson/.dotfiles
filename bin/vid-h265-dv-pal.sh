#!/usr/bin/env bash
# vid-h265-dv-pal.sh — batch transcode interlaced DV PAL footage in the cwd to H.265 SD.

usage() {
  cat <<'EOF'
vid-h265-dv-pal.sh — batch transcode DV PAL (interlaced SD) clips in the cwd to H.265.

Deinterlaces, scales to square-pixel PAL 768x576, fixes the aspect, then encodes
H.265 at ~4 Mbps. Built for old camcorder DV captures, not modern HD/4K sources.

USAGE
  vid-h265-dv-pal.sh     # run inside the folder of DV PAL clips

ARGUMENTS
  (none)  Globs *.mov *.mp4 *.mxf *.avi in the cwd (case-insensitive).

EXAMPLES
  cd ~/dv-captures && vid-h265-dv-pal.sh

NOTES
  Codec: HEVC (hevc_videotoolbox, 4M) + AAC 160k in a .mov, hvc1-tagged.
  Output: <name>_h265_small.mov next to each source. Needs ffmpeg with VideoToolbox.
EOF
}

case "${1:-}" in -h|--help) usage; exit 0 ;; esac

shopt -s nullglob nocaseglob

for f in *.mov *.mp4 *.mxf *.avi; do
  ffmpeg \
    -i "$f" \
    -vf "yadif,scale=768:576,setsar=1" \
    -c:v hevc_videotoolbox \
    -b:v 4M \
    -maxrate 4M \
    -bufsize 8M \
    -tag:v hvc1 \
    -movflags +faststart \
    -c:a aac -b:a 160k \
    "${f%.*}_h265_small.mov"
    # -vf yadif  deinterlace (DV PAL is interlaced); scale=768:576  square-pixel PAL SD;
    #            setsar=1  force 1:1 sample aspect so the picture isn't stretched
    # -b:v/-maxrate/-bufsize 4M/4M/8M  modest SD delivery bitrate
    # -tag:v hvc1  QuickTime-friendly HEVC tag; +faststart  moov atom up front
    # -c:a aac -b:a 160k  re-encode audio to AAC (not copied)
done

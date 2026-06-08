#!/bin/bash
# vid-remux-mp4.sh — batch rewrap H.264/HEVC videos in the cwd into .mp4, no re-encode.

usage() {
  cat <<'EOF'
vid-remux-mp4.sh — batch rewrap every non-mp4 video in the cwd into an .mp4 container.

For footage that is ALREADY H.264 or HEVC but sits in a .mov/.mkv/.avi/etc. This
stream-copies the video (-c:v copy) — lossless, seconds per file, no quality hit —
and only touches audio when the mp4 container can't carry it (PCM/Opus/… → AAC).
NOT a transcoder: if the video codec can't go into mp4 as-is, the file is skipped
with a reason (reach for vid-h265-small-web.sh / vid-convert.sh instead).

USAGE
  vid-remux-mp4.sh       # run inside the folder of clips you want as .mp4

ARGUMENTS
  (none)  Globs *.mov *.mkv *.avi *.mxf *.ts in the cwd (case-insensitive).
          .mp4 sources are intentionally NOT globbed — they're already mp4.

EXAMPLES
  cd ~/ae-export && vid-remux-mp4.sh

NOTES
  Video: -c:v copy (H.264 / HEVC only; HEVC gets the hvc1 tag). Other codecs skipped.
  Audio: copied when already mp4-friendly (aac/ac3/eac3/mp3/alac), else AAC 256k.
  Only the first video + first audio stream are kept — timecode/data tracks (common
  in After Effects .mov exports) are dropped, since they break a straight mp4 copy.
  +faststart puts the moov atom up front so the file streams from the first byte.
  Output: <name>.mp4 next to each source; an existing <name>.mp4 is left untouched.
  Needs ffmpeg (no VideoToolbox required — nothing is encoded on the video side).
EOF
}

case "${1:-}" in -h|--help) usage; exit 0 ;; esac

shopt -s nullglob nocaseglob   # no matches → skip the glob; nocaseglob so .MOV matches *.mov

for f in *.mov *.mkv *.avi *.mxf *.ts; do
  out="${f%.*}.mp4"

  # Never clobber a pre-existing mp4 (and APFS is case-insensitive, so .MP4 collides too).
  if [ -e "$out" ]; then
    echo "skip: $out already exists"
    continue
  fi

  # Probe the first video stream. Only H.264 / HEVC can be stream-copied into mp4;
  # anything else (ProRes, VP9, MPEG-2, DNxHD…) would need a real transcode.
  vcodec=$(ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of csv=p=0 "$f")
  case "$vcodec" in
    h264) vtag=() ;;
    hevc) vtag=(-tag:v hvc1) ;;   # QuickTime-friendly HEVC tag (vs the generic 'hev1')
    *) echo "skip: $f — video is '${vcodec:-none}', can't stream-copy to mp4 (use vid-h265-small-web.sh)"; continue ;;
  esac

  # Probe the first audio stream. Copy it when mp4 can already carry it; otherwise
  # re-encode just the audio to AAC (cheap) — the video still stream-copies.
  acodec=$(ffprobe -v error -select_streams a:0 -show_entries stream=codec_name -of csv=p=0 "$f")
  case "$acodec" in
    aac|ac3|eac3|mp3|alac|"") aopt=(-c:a copy) ;;   # "" = no audio track; copy is a harmless no-op
    *) aopt=(-c:a aac -b:a 256k) ;;
  esac

  # -map 0:v:0 -map 0:a:0?  keep only first video + (optional) first audio, drop data/timecode.
  # -write_tmcd 0  stop the mp4 muxer from auto-generating a tmcd timecode track from the
  #               video stream's metadata (it would slip a stray data track back in otherwise).
  ffmpeg -i "$f" \
    -map 0:v:0 -map 0:a:0\? \
    -c:v copy "${vtag[@]}" \
    "${aopt[@]}" \
    -write_tmcd 0 \
    -movflags +faststart \
    "$out" \
    && echo "→ $out" \
    || echo "fail: $f"
done

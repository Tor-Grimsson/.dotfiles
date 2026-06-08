# 2026-06-08 — vid-remux-mp4.sh (lossless container rewrap to MP4)

New `vid-` family member that fills a real gap: every existing video script
*re-encodes* (all `vid-h265-*` → HEVC, `vid-webm2mp4` → libx264, `vid-convert`/
`vid-prores` transform). Nothing did a **lossless H.264/HEVC stream-copy remux**
into `.mp4` — which is exactly what already-H.264 footage in a `.mov` wrapper needs.

## Script
- `bin/vid-remux-mp4.sh` — batch (no-arg, cwd glob, matches the `vid-h265-*`/`vid-prores` idiom).
  - Globs `*.mov *.mkv *.avi *.mxf *.ts` (`nocaseglob` → `.MOV` matches); **excludes `.mp4`** (rewrapping mp4→mp4 is a no-op). Output `<name>.mp4`; existing output is skipped, so re-runs are safe + idempotent.
  - Probes per file: video `h264` → `-c:v copy`, `hevc` → `+ -tag:v hvc1`, anything else (prores/vp9/mpeg2/…) → **skip with printed reason** (won't emit a broken mp4). Audio `aac/ac3/eac3/mp3/alac/none` → copy, else → `-c:a aac -b:a 256k`.
  - `-map 0:v:0 -map 0:a:0?` keeps only first v+a (drops AE timecode/data tracks that break a blind `-c copy`); **`-write_tmcd 0`** stops the mp4 muxer auto-re-adding a `tmcd` track from video metadata (caught in verification — two outputs had a stray data stream until this was added); `+faststart`.
  - No VideoToolbox dependency (nothing encodes on the video side).

## Docs
- `12-scripts/02-video.md`: intro note (no-encode tool), table row, full per-script section, `related: [[vid-remux-mp4]]`, `updated` 06-08.
- `12-scripts/vid-remux-mp4.md`: new companion playbook (why-remux-not-reencode, core one-liner, codec decision table, verification).
- `12-scripts/INDEX.md`: vid family 10 → 11, `updated` 06-08.

## State
- **Real-run verified** on `/Volumes/4TB_Diskur/library-root/06_/_kol-mv-active/ae-export` (the user's actual job): 7 `.mov`/`.MOV` → `.mp4`, the 7 pre-existing `.mp4`s untouched (original 2014–2016 mtimes intact). Stream-copy outputs within ~75KB of source (lossless); the two PCM-audio files (`ae-sunday-drive` 428→349MB, `knlt-dillon-sap-live` 1.16→1.11GB) shrank only on the AAC audio pass. `ffprobe` confirms outputs are clean h264+aac, **no data track** after the `-write_tmcd 0` fix. Skip + idempotent paths exercised. `bash -n` clean, `chmod +x` applied.

## Next
- Nothing required. User owns git; nothing committed. Script + docs sync to MBP on next commit.

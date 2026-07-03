# Session: vid-reframe.sh + vid-convert.md docs

**Date:** 2026-06-19
**Agent:** Grim
**Summary:** Wrote `vid-reframe.sh` (batch reframe wrapper), its doc, and the `vid-convert.sh` deep-dive — after too many rounds of explaining flags instead of just writing the script.

## Changes Made

### Files Modified
- `bin/vid-reframe.sh` — NEW. `cd` into `frame-9-16/16-9/4-5`, run, done. Auto-detects target dims from folder name, globs all video files, kebabs names, skips existing outputs, writes to `../_export/<folder>/`. libx265 CRF 22, yuv420p, AAC 128k, hvc1+faststart .mp4.
- `docs/12-scripts/vid-reframe.md` — NEW. Playbook doc for vid-reframe.sh. Section 4 notes why this script should have existed on day one.
- `docs/12-scripts/vid-convert.md` — NEW. Deep-dive playbook for vid-convert.sh: flags, longest-side resolution model, export-specs/@Nx alignment table (16:9+9:16 line up; 4:5 doesn't), the four gaps, and the raw ffmpeg recipe.
- `docs/12-scripts/02-video.md` — added `vid-reframe.sh` row (above vid-convert) + `related:` link to vid-reframe.md.
- `docs/12-scripts/vid-archive.md` — added `vid-convert` to `related:`.
- `docs/12-scripts/video-archive-pipeline.md` — added `vid-convert` to `related:`.

### Library work (not in dotfiles)
- `/Volumes/…/library-sample-01/_export/frame-9-16/` — 9 clips encoded (1080×1920, CRF 22). 986 MB → ~325 MB.
- `asmr-sharp2.mp4` — **corrupt** (moov atom not found, incomplete encode). Needs re-encode.

## Current State

### Working
- `vid-reframe.sh` on PATH, executable. Usage: `cd frame-9-16 && vid-reframe.sh`.
- All checked frame-9-16 exports are 1080×1920 hevc hvc1.
- vid-convert.md, vid-reframe.md wired into the doc graph.

### Known Issues
- `asmr-sharp2.mp4` is a broken file — moov atom missing, ffprobe errors. Source is `tt_asmr_sharp2.*` in frame-9-16. Delete and re-run `vid-reframe.sh` — it'll re-encode it.
- frame-16-9 and frame-4-5 not yet started.
- Parked long clips (ST-full, Best Of 1992, etc.) still deferred.
- Misfiled clips not yet sorted (radial-dark-01 landscape in frame-9-16; 4 RPReplay portrait in frame-16-9).

## Next Steps
1. Delete `_export/frame-9-16/asmr-sharp2.mp4`, re-run `vid-reframe.sh` in frame-9-16.
2. `cd frame-16-9 && vid-reframe.sh` — 60+ clips, target 1920×1080.
3. `cd frame-4-5 && vid-reframe.sh` — 10 clips, target 1080×1350.
4. Sort misfiled clips.
5. Long clips last.

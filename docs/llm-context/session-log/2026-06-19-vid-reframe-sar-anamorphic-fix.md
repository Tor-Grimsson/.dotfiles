# Session: vid-reframe.sh anamorphic SAR fix

**Date:** 2026-06-19
**Agent:** Grim (Claude Opus, cross-repo into `~/.dotfiles`)
**Summary:** `vid-reframe.sh` was emitting `2560×1080` from anamorphic 16:9 sources because its cover-scale worked on stored pixels and carried the source SAR through to the output; fixed by squaring the pixels before the cover-scale, proven on the real library folder, docs updated.

## Changes Made

### Files Modified
- `bin/vid-reframe.sh` — added a first filter pass `scale=trunc(iw*sar/2)*2:ih,setsar=1` (square the pixels at true display size) before the existing cover-scale/crop, and `setsar=1` on the output. Comment added explaining the anamorphic trap. (`:61`)
- `docs/12-scripts/vid-reframe.md` — new step 1 (square the pixels) in "What it does" with the rest renumbered; new **Anamorphic sources (the SAR trap)** subsection; verification probe now reads `sample_aspect_ratio,display_aspect_ratio` and checks `SAR 1:1`.
- `docs/12-scripts/02-video.md` — `vid-reframe.sh` table row notes "squares anamorphic pixels (SAR→1:1)"; `updated:` bumped 2026-06-10 → 2026-06-19.

### Features Added/Removed
- No new script. Behavior fix only: every reframe output is now true square-pixel at the target dims regardless of source SAR.

## Current State

### Working
- Verified on the real `…/10-sample/library-sample-01/frame-16-9` mix via 1-frame probes:
  - **Bug reproduced** (old filter): `externalism.mov` (1440×1080 SAR 4:3) → `1920×1080 SAR 4:3 DAR 64:27` (= the user's 2560×1080).
  - **Fix** (new filter): same clip → `1920×1080 SAR 1:1 DAR 16:9`.
  - Edge cases all → `1920×1080 SAR 1:1 DAR 16:9`: N/A-SAR files (`Kit Kat Club.mp4`, `konsul kjafti.mp4` 576×320), already-square 1080p (`Lorn - Farr.mp4`), other anamorphic (`motorsport sequence bilar.mp4`), oddball `LUMEN.mov` 1904×1402. No failures.
- Fix is live on `PATH` immediately (`~/bin` is a dir-symlink → repo `bin/`).

### Known Issues
- **`vid-convert.sh` has the same latent SAR bug** — same `scale=…:increase,crop=…` with no `setsar`. NOT patched this session (single-file reframe; user greenlit docs only). An anamorphic source through `vid-convert.sh` will show the same stretched-display-width result.
- The folder's `_export/frame-16-9` was empty when checked. If any old `2560×1080` outputs are sitting there, they must be deleted before re-running — the script skips output names that already exist.

## Next Steps
1. Re-run `vid-reframe.sh` in `frame-16-9` (and the `frame-9-16` / `frame-4-5` siblings) to regenerate with the fix.
2. Decide whether to patch `vid-convert.sh` with the same square-the-pixels pass + update its `vid-convert.md` doc.

# Session: vid-reframe.sh — never-upscale clamp + never-bigger size guard

**Date:** 2026-06-20
**Agent:** Grim (Claude Opus, `~/.dotfiles`)
**Summary:** Fixed `vid-reframe.sh` producing outputs LARGER than inputs (user hit 11GB → 13GB) — it was upscaling sub-target sources to the full frame and re-encoding at CRF 22 with no size check.

## Changes Made

### Files Modified
- `bin/vid-reframe.sh` — two fixes to the per-file loop:
  - **Never upscale.** Before encoding, ffprobe the source (`width`,`height`,`sample_aspect_ratio`), compute the square-pixel display size, and derive the largest **W:H** box the source can fill at native density. Cap the target to it: a sub-target clip (e.g. 720p, anamorphic 1440×1080) now outputs at its own resolution instead of being blown up to 1920×1080. Sources ≥ target still downscale to the folder dims as before. Output dims forced even; ffprobe failure falls back to the original W×H behavior. The cover-scale/crop filter now uses the per-file `${oW}:${oH}` instead of the hardcoded `${W}:${H}`.
  - **Never-bigger guard.** After a successful encode, `stat` compares output vs source bytes; if the output is still ≥ the source, it `rm`s the output and keeps the original (prints `skipped: … would grow`). The source file is never touched (output lives in `../_export/`).

### Features Added/Removed
- New behavior: clamped (no-upscale) reframes print `[clamped — no upscale]` and their true dims; oversized re-encodes are discarded rather than written.

## Current State

### Working
- `bash -n` clean. Live immediately (`bin/` is a whole-dir symlink → `~/bin`).
- The SAR-squaring first pass (the 2026-06-19 anamorphic fix) is preserved — it now feeds the clamped target.

### Known Issues
- **Root cause was a tool mismatch, not just a bug:** `vid-reframe.sh` is an *aspect-ratio reframer*, never a compressor. CRF 22 is a quality target, not a size budget. The clamp + guard stop inflation, but if the goal is purely "make smaller," that's `vid-archive.sh` (CRF) / `vid-h265-small.sh` (12 Mbps cap) territory — and those have the **same missing never-bigger guard** (see Next Steps).
- Existing bloated outputs from prior runs are NOT cleaned up — the script skips names that already exist. Delete the bad `_export` files to have them redone.

## Next Steps
1. Port the **never-bigger size guard** to the rest of the `vid-` family (`vid-archive.sh`, `vid-h265-small.sh`, `vid-convert.sh`) — same class of bug, none of them refuse to write a larger file.
2. Update `docs/12-scripts/vid-reframe.md` to document the no-upscale clamp + size-guard behavior (and that reframing sub-target sources now yields smaller-than-1080p outputs by design).
3. Still open from prior session: `vid-convert.sh` anamorphic SAR bug (docs-only greenlit, unpatched).

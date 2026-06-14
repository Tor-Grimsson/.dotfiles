# Session: export-specs skill (aspect-ratio / @Nx reference)

**Date:** 2026-06-14
**Agent:** Grim (Opus 4.8, iMac)
**Summary:** Authored a local Claude skill that explains image export sizing — the @Nx model + the social aspect-ratio table — kept in lockstep with `bin/img-canvas.sh`.

## Changes Made

### Files Modified
- `claude/skills/export-specs/SKILL.md` — **new.** The skill (previously proposed but never written).

### Features Added/Removed
- New skill **export-specs** (free-standing reference, not a doer). Four sections:
  1. **@Nx model** (Figma-style) — design at @1x logical px, @Nx multiplies raster for DPR/retina; when-to-use @1x/@2x/@3x table; img-canvas @1x baseline = short side 1080, `-s N` = @Nx; print is DPI not @Nx.
  2. **Aspect table** — the 7 img-canvas presets (9:16, 3:5, 4:5, 1:1, 5:4, 5:3, 16:9) with orientation + use + @1x/@2x/@3x px columns; `2:3`/`3:2` added as `‡` non-presets with the `-a WxH` escape hatch.
  3. **Formulas** — `short = 1080×N`, `long = short × L/S`, round to even; worked examples (4:5 @2x, 21:9 @1x) + inverse `N = target_short/1080`.
  4. **Pointers** → `bin/img-canvas.sh` + `docs/12-scripts/img-canvas.md`.
- Numbers verified against the script's preset `case` block — single source of truth is the script; skill states the script wins on any drift.

## Current State

### Working
- Skill is live — appears in the available-skills list as `export-specs`; triggers on aspect-ratio / image-sizing / @Nx-resolution questions.
- All table rows consistent with `img-canvas.sh` (short side 1080 × N, long = short × L/S).

### Known Issues
- **Local-authored, not from kol-system.** Every other skill in `claude/skills/` is curate-copied from kol-system and rides its re-sync; this one is hand-authored in dotfiles and will **not** ride a kol-system re-sync. Fine for a personal reference (user's call); revisit if it ever needs to live upstream.
- Skills dir is a whole-dir symlink, so the new subdir needs **no `bootstrap.sh` edit** — live on both machines once committed + symlink present.

## Next Steps
1. Commit so it syncs to the MBP (user owns git).
2. If it should ever be shared org-wide, move the canonical copy to kol-system and curate-copy back.

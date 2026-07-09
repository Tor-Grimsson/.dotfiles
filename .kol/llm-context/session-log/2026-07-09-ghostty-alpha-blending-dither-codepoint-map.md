# Session: Ghostty text/dither tuning — alpha-blending + font-codepoint-map for p10k's blurred heads/tails

**Date:** 2026-07-09
**Agent:** Claude (Grim)
**Summary:** Chased down two Ghostty-vs-iTerm rendering differences on the p10k prompt: text looked "too high-res" (fixed with `alpha-blending = linear`) and the dithered prompt heads/tails were gone (restored by mapping the `░▒▓` shade blocks to the font instead of Ghostty's built-in block renderer).

## Changes Made

### Ghostty rendering (`ghostty/config`)
- **`alpha-blending = linear`** (new) — text over the translucent bg was crisp with a dark edge-fringe ("too high-res"); the macOS default is `native`. `linear` (gamma-corrected) drops the fringe and thickens light-on-dark text for a softer, fuller look. Verified via `ghostty +show-config`. (Fallback noted in-config: `linear-corrected` = native weight minus fringe.)
- **`font-codepoint-map = U+2591-U+2593=MesloLGS NF`** (new) — the real find. p10k's "blurred" prompt heads/tails (`.p10k.zsh` lines 175/179, `POWERLEVEL9K_LEFT_PROMPT_{FIRST_SEGMENT_START,LAST_SEGMENT_END}_SYMBOL='░▒▓'`) render as a **dithered checkerboard** in iTerm (font glyphs) but a **smooth alpha gradient** in Ghostty (its built-in block renderer). Mapping U+2591-2593 to the font forces the font glyph → the dithered iTerm look returns. User confirmed it worked ("yeaaaboiiii").
- User also set (their own edit, kept): `background-opacity = 1`, `background-blur-radius = 0` — window now fully solid, no blur.

### Doc synced (`01-shell-terminal/26-ghostty.md`)
- Added rows for `alpha-blending` and `font-codepoint-map`.
- Fixed three drifted values in the settings table: bg listed `#282828` → **`#1d1f20`**, opacity `0.96` → **`0.92`**, blur `25` → **`12`** (these had drifted from the actual config across earlier sessions; note the config also had opacity/blur changed again this session by the user).

## Current State

### Working (validated)
- `ghostty +show-config` parses clean with both new keys.
- Config is the source of truth again; doc matches (values current as of the sync — user's later opacity/blur edits are their own).

### Known Issues / needs reload
- **font-codepoint-map needs a NEW window/tab** (or full relaunch), not just `Cmd+Shift+,` — Ghostty applies codepoint maps only to new terminals. (Confirmed working by the user.)
- Ghostty has **no color-depth/bit setting** (always 24-bit truecolor) and **no dither knob** — the dither is purely the font-vs-built-in glyph question above. `window-colorspace = srgb` (default, not overridden); wide-gamut is `display-p3`.

## Next Steps
1. Nothing pending on the prompt/terminal look — the dither + colors are where the user wants them.
2. Still open from prior: SketchyBar still Catppuccin Mocha (not swept to Gruvbox); footer-gate Stop hook goes live on next Claude Code restart; cava visualiser, Torrent guide (`plan.md`).

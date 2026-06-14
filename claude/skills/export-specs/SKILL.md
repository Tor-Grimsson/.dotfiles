---
name: export-specs
description: Reference for image export specs — the @Nx (Figma-style) resolution model, the social-media aspect-ratio table (9:16, 3:5, 4:5, 1:1, 5:4, 5:3, 16:9, plus 2:3/3:2), pixel dimensions at @1x/@2x/@3x, and the formulas to size any arbitrary case. Use this when picking an aspect ratio, sizing an image/canvas, or deciding @1x vs @2x vs @3x. Numbers are kept in lockstep with bin/img-canvas.sh (short side 1080, -s to scale).
---

# Export specs — aspect ratios & the @Nx model

`bin/img-canvas.sh` is the source of truth and the thing that actually renders the canvas. This skill is the explainer next to it. The aspect set, the short-side-1080 baseline, and the scale flag all come from that script — **if a number here ever disagrees with the script, the script wins.**

## 1. The @Nx model (Figma-style)

Design at **@1x** logical pixels. `@Nx` multiplies the raster output for retina / HiDPI screens — the layout never changes, only pixel density. A 4:5 frame is 4:5 at every scale; @2x just renders it with twice the pixels per side.

| Scale | DPR | When to use |
|---|---|---|
| `@1x` | 1 | Target spec gives absolute pixels; standard-DPI screens; you just want the social baseline. |
| `@2x` | 2 | **Default for anything shown on-screen** — standard retina (modern phones, MacBooks). |
| `@3x` | 3 | High-density phones (iPhone Pro/Plus-Max class, DPR 3). |

In `img-canvas.sh`, the @1x baseline is **short side 1080** (the social-delivery standard), and `-s N` is `@Nx`: `-s 2` = @2x = short side 2160. The script takes any positive integer for `-s`.

**Print is DPI, not @Nx.** Size by physical inches × DPI (e.g. 8×10 in @ 300 DPI = 2400×3000 px). Different model — don't multiply a screen @Nx into a print job.

## 2. Aspect-ratio table

Primary set = the `img-canvas.sh` presets. Short side = 1080 at @1x.

| Ratio | Orientation | For | @1x | @2x | @3x |
|---|---|---|---|---|---|
| `9:16` | portrait  | story / reel / TikTok (full-screen vertical) | 1080×1920 | 2160×3840 | 3240×5760 |
| `3:5`  | portrait  | tall portrait post                            | 1080×1800 | 2160×3600 | 3240×5400 |
| `4:5`  | portrait  | portrait feed post (max IG portrait)          | 1080×1350 | 2160×2700 | 3240×4050 |
| `1:1`  | square    | square post / grid tile                       | 1080×1080 | 2160×2160 | 3240×3240 |
| `5:4`  | landscape | gentle landscape post                         | 1350×1080 | 2700×2160 | 4050×3240 |
| `5:3`  | landscape | wide banner                                   | 1800×1080 | 3600×2160 | 5400×3240 |
| `16:9` | landscape | widescreen / video / YouTube                  | 1920×1080 | 3840×2160 | 5760×3240 |
| `2:3` ‡ | portrait  | classic 35mm photo portrait                  | 1080×1620 | 2160×3240 | 3240×4860 |
| `3:2` ‡ | landscape | classic 35mm photo landscape                 | 1620×1080 | 3240×2160 | 4860×3240 |

‡ **Not an `img-canvas.sh` preset.** Pass raw pixels instead: `-a 1080x1620` (or any `@Nx` row above).

## 3. Formulas — compute any arbitrary case

```
short = 1080 × N            # N = @Nx scale  (img-canvas: -s N)
long  = short × (L / S)     # L:S = the aspect written long-side : short-side
```

Round `long` to the nearest **even** integer — video/jpeg encoders want even dimensions.

- `4:5 @2x` → short = 2160, long = 2160 × 5/4 = 2700 → **2160×2700**
- `21:9 @1x` (ultrawide, no preset) → short = 1080, long = 1080 × 21/9 = 2520 → **1080×2520** (`-a 1080x2520`)

Inverse — going from a known target back to a scale: `N = target_short_side / 1080`. A 2160-wide story is `@2x`; a 3240-wide one is `@3x`. Non-integer N means it isn't on the 1080 grid — pass the exact pixels with `-a WxH` rather than `-s`.

## 4. Pointers

- **`bin/img-canvas.sh`** — renderer + canonical preset table. `img-canvas.sh --help` for the full flag contract (`-a` ratio, `-s` scale, `-m` cover/fit/stretch, `-g` gravity, `-f`, `-o`, `-P` pick-mode).
- **`docs/12-scripts/img-canvas.md`** — full playbook: modes, gravity, `orig` ratio/resolution, and the Finder Quick Action wiring.

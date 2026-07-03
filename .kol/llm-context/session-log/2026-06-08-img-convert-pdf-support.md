# 2026-06-08 — img-convert.sh gains PDF support + Quick Action fires on PDFs (iMac)

Taught the existing `img-convert.sh` to take PDF/EPS input (rather than writing a
third PDF→image script), and widened the "Convert image (pick format)" Quick
Action so it actually appears on PDFs in Finder.

## Script
- `bin/img-convert.sh` — now converts **PDF/EPS/AI/PS** as well as raster images.
  - `-d DPI` (default 300): vector sources are rasterized at this density *before* the fit-2000 resize. Without it Ghostscript renders at 72 dpi → tiny output the shrink-only resize can't enlarge. Raster sources ignore `-d`.
  - `-a`: all pages → `<base>-p01.<fmt>, -p02, …` (`-scene 1`, 1-based). Default stays first-page-only (`[0]`).
  - JPG path switched `-flatten` → `-alpha remove -alpha off` so multi-page `-a` composites **per page** instead of merging every page into one image (the bug that made `-a` only ever write page 1).
  - Folded the `-density`/`-scene` args into `args` incrementally — empty-array `"${arr[@]}"` under `set -u` errors on macOS bash 3.2.

## Quick Action
- Re-stamped `Convert image (pick format)` via `qa-make.sh -f -t public.image,com.adobe.pdf` (same `-P` body). `NSSendFileTypes` now lists both UTIs — right-click a **PDF** → Quick Actions → it fires (first page @300dpi, fit 2000px, JPG/PNG prompt). The `public.image`-only typing was why none of the image Quick Actions showed up on PDFs.

## Docs
- `03-image.md`: table row + section updated (PDF input, `-d`/`-a`, gs dep). 
- `12-scripts/img-convert.md`: title/overview/prereqs, new **§4 PDFs and vector sources**, renumbered §5–§7, Quick-Action command + verification updated. Providers gained Ghostscript.
- `10-quick-actions.md`: pick-format example now `-t public.image,com.adobe.pdf`.
- `INDEX.md`: img family blurb now "any image/PDF". Count stays **10** (extended, not added).

## State
- Real-run verified in a temp dir (3-page color PDF): default first-page → 1545×2000 jpg; `-a` writes p01/p02/p03 (page-2 color = sRGB preserved); `-f png` + `-a -f png` keep all pages; `-d 600 -r none` → 5100×6600 full-res; raster `-r 50%` unaffected; bad `-f` / no-args rejected; `bash -n` clean. `chmod +x` applied. `-P` GUI path parses (not exercised headless).

## Next
- Nothing required. User owns git; nothing committed. The widened Quick Action is live + tracked, syncs to MBP on next commit.

---
title: resvg
type: reference
status: active
updated: 2026-06-14
description: Fast, correct SVG → PNG rasterizer (Rust). Installed as yazi's SVG preview backend.
aliases:
  - resvg
tags:
  - domain/files
  - pattern/cli
  - integration/brew-formula
links:
  website: https://github.com/linebender/resvg
  repo: https://github.com/linebender/resvg
  manual: https://github.com/linebender/resvg#readme
  brew: https://formulae.brew.sh/formula/resvg
covers:
  - resvg CLI (svg → png)
  - Why it's here (yazi SVG preview backend)
related:
  - "[[02-yazi|Yazi]]"
  - "[[01-imagemagick|ImageMagick]]"
---

## Summary
Renders SVG to PNG with one of the most spec-compliant SVG engines around (the `usvg`/`resvg` Rust stack). Faster and more accurate on tricky SVGs than ImageMagick's delegate path.

## Use

```sh
resvg in.svg out.png                 # rasterize at the SVG's intrinsic size
resvg --width 1024 in.svg out.png    # rasterize at a fixed width (height scales)
resvg --zoom 2 in.svg out.png        # 2× the intrinsic size
```

## Why installed
yazi's backend for **SVG previews** — without it, `.svg` files show no preview in [[02-yazi|Yazi]]. A pure preview dependency; reach for it directly only when you want a clean SVG→PNG without firing up ImageMagick.

---
title: ImageMagick
type: reference
status: active
updated: 2026-06-04
description: Command-line image manipulation suite for converting, resizing, and editing images across dozens of formats.
aliases:
  - magick
  - convert
tags:
  - domain/images
  - pattern/cli
  - integration/brew-formula
links:
  website: https://imagemagick.org/index.php
  repo: https://github.com/ImageMagick/ImageMagick
  manual: https://imagemagick.org/script/command-line-processing.php
  brew: https://formulae.brew.sh/formula/imagemagick
covers:
  - Format conversion across raster types
  - Resizing, cropping, and batch processing
  - Compositing and basic image editing from the shell
related:
  - "[[02-img2pdf|img2pdf]]"
  - "[[04-pngpaste|pngpaste]]"
---

## Summary
ImageMagick is a command-line suite for creating, converting, and editing raster (and some vector) images in over two hundred formats. The modern entry point is the `magick` command, which subsumes the older `convert`, `mogrify`, `identify`, and `composite` tools.

## Why installed
It is the default scriptable image engine for this setup. Any time an image needs a format change, a resize, or a batch transform without opening a GUI editor, ImageMagick handles it from the shell and slots cleanly into pipelines and scripts.

## Most common use case
One-off format conversions and resizes — turning a PNG into a JPEG, scaling a screenshot down, or compressing an image before it goes somewhere.

## Biggest win
Breadth and scriptability. A single binary reads and writes practically every raster format and chains operations in one command, so whole directories of images can be processed in a loop without touching an application.

## How to use
```sh
magick input.png output.jpg                 # convert format
magick input.png -resize 800x600 out.png     # resize (fit within box)
magick input.jpg -resize 50% out.jpg         # resize by percentage
magick input.png -quality 80 out.jpg         # convert + set JPEG quality
magick identify image.png                    # inspect dimensions, format, depth
magick mogrify -format webp *.png            # batch convert all PNGs to WebP
magick in.png -crop 400x400+10+10 out.png    # crop a region
```

## Future use
Scripted compositing and annotation — watermarking batches, generating contact sheets with `montage`, or building thumbnails as part of an asset pipeline. The `-layers` and `-morph` operators also open up simple animation and GIF assembly without extra tooling.

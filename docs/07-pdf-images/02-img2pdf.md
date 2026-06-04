---
title: img2pdf
type: reference
status: active
updated: 2026-06-04
description: Converts raster images into PDF by embedding the original JPEG/PNG data losslessly without re-encoding.
aliases:
  - img2pdf
tags:
  - domain/documents
  - pattern/cli
  - integration/brew-formula
links:
  website: https://gitlab.mister-muffin.de/josch/img2pdf
  repo: https://gitlab.mister-muffin.de/josch/img2pdf
  manual: https://gitlab.mister-muffin.de/josch/img2pdf/-/blob/main/README.md
  brew: https://formulae.brew.sh/formula/img2pdf
covers:
  - Lossless image-to-PDF conversion
  - Combining multiple images into one PDF
  - Page-size and orientation control
related:
  - "[[01-imagemagick|ImageMagick]]"
  - "[[03-pdf2svg|pdf2svg]]"
---

## Summary
img2pdf wraps one or more images into a PDF without re-encoding them. For JPEG and JPEG2000 input it embeds the original bytes directly, so the conversion is lossless and fast and the resulting PDF is no larger than the source images.

## Why installed
It fills the gap ImageMagick handles badly: ImageMagick's PDF output re-rasterizes images, bloating files and degrading quality. img2pdf produces a clean, lossless PDF from scans and screenshots, which is exactly what is needed when bundling images for sending or archiving.

## Most common use case
Combining a set of scanned or photographed pages into a single PDF for sharing or filing.

## Biggest win
Lossless, no-bloat output. Because it embeds JPEG data verbatim rather than decoding and re-encoding it, the PDF keeps the original image quality and stays small — unlike `magick *.jpg out.pdf`, which re-compresses everything.

## How to use
```sh
img2pdf scan.jpg -o scan.pdf                 # single image to PDF
img2pdf page1.jpg page2.jpg -o doc.pdf       # combine multiple images
img2pdf *.png -o album.pdf                   # glob a whole directory
img2pdf img.jpg --pagesize A4 -o out.pdf     # force A4 page size
img2pdf img.jpg --rotation=90 -o out.pdf     # rotate pages
```

## Future use
Scripted document assembly — pairing it with a scanner workflow or with ImageMagick preprocessing (deskew, trim, grayscale) to turn raw captures into tidy PDFs automatically, then feeding the output to a PDF toolchain for OCR or merging.

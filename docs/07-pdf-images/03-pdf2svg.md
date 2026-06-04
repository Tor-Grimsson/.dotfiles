---
title: pdf2svg
type: reference
status: active
updated: 2026-06-04
description: Converts PDF pages to SVG vector files, preserving paths and text as scalable geometry.
aliases:
  - pdf2svg
tags:
  - domain/documents
  - pattern/cli
  - integration/brew-formula
links:
  website: https://cityinthesky.co.uk/opensource/pdf2svg
  repo: https://github.com/dawbarton/pdf2svg
  manual: https://github.com/dawbarton/pdf2svg/blob/master/README.md
  brew: https://formulae.brew.sh/formula/pdf2svg
covers:
  - PDF page to SVG conversion
  - Single-page and multi-page extraction
  - Vector preservation for the web and editors
related:
  - "[[02-img2pdf|img2pdf]]"
  - "[[01-imagemagick|ImageMagick]]"
---

## Summary
pdf2svg converts a PDF page into an SVG file using the Poppler and Cairo rendering libraries. Vector content stays vector — paths, fills, and text become scalable SVG geometry rather than a rasterized snapshot.

## Why installed
It is the bridge from PDF-format vector art (logos, diagrams, exported figures) into something editable and web-ready. When a vector asset only exists inside a PDF, this is the cleanest way to pull it out as SVG without flattening it to pixels.

## Most common use case
Extracting a single page from a PDF into an SVG to drop into a web page, an icon set, or a vector editor.

## Biggest win
True vector fidelity. Unlike rasterizing a PDF page with ImageMagick, pdf2svg keeps the geometry resolution-independent, so the result scales cleanly and remains editable.

## How to use
```sh
pdf2svg input.pdf output.svg            # convert first page
pdf2svg input.pdf output.svg 3          # convert page 3
pdf2svg input.pdf out_page%d.svg all    # convert every page (%d expands to number)
```

## Future use
Batch figure extraction in a publishing pipeline — looping over multi-page PDFs to emit one SVG per page, then post-processing with an SVG optimizer for clean, minimal web assets.

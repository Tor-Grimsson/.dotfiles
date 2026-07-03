---
title: Typst
type: reference
status: active
updated: 2026-07-03
description: Modern typesetting engine — a fast, small successor to LaTeX with its own markup language. Used here as Pandoc's default PDF engine.
aliases:
  - typst
tags:
  - domain/documents
  - pattern/cli
  - integration/brew-formula
links:
  website: https://typst.app
  repo: https://github.com/typst/typst
  manual: https://typst.app/docs
  brew: https://formulae.brew.sh/formula/typst
covers:
  - Pandoc's fast default PDF engine (--pdf-engine=typst)
  - A4 output with zero design work
  - standalone typesetting (.typ) when you want full control
related:
  - "[[01-pandoc|Pandoc]]"
  - "[[03-weasyprint|WeasyPrint]]"
  - "[[05-markdown-to-a4|Markdown → A4 workflow]]"
---

## Summary
A modern **typesetting engine** — think LaTeX's job (lay text onto pages, beautifully) but fast, small, and with a far simpler language. Two ways it shows up:

- **As Pandoc's PDF engine** (`--pdf-engine=typst`): Pandoc translates Markdown into Typst's markup, Typst renders the PDF. No Typst knowledge required.
- **Standalone**: write `.typ` files directly for full control (fonts, leading, columns, page rules) — a real language, learned only if you want it.

Separate tool from Pandoc, different authors; Pandoc *drives* it.

## Use
```sh
pandoc in.md -o out.pdf --pdf-engine=typst -V papersize=a4   # the everyday path
typst compile doc.typ                                        # standalone .typ → PDF
typst watch doc.typ                                          # standalone live rebuild
```

## Why installed
The generic / unbranded lane of the Markdown→print pipeline. Excellent default typography, no LaTeX install, fast enough to batch hundreds of files.

## Biggest win
**~27× faster than LaTeX**, a tiny install (one binary, no TeX distribution), and clean A4 output with zero design work — the right default when you just want the text on paper.

## Future use
Default engine of [pdf-from-md.sh](../12-scripts/04-pdf.md). Learn the template language later if fine layout control is ever wanted; not needed for the automation.

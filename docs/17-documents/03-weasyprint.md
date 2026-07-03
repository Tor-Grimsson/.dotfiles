---
title: WeasyPrint
type: reference
status: active
updated: 2026-07-03
description: HTML+CSS → PDF, pure Python, no browser. Follows the CSS Paged Media spec — the CSS-controlled PDF engine for Pandoc (--pdf-engine=weasyprint).
aliases:
  - weasyprint
tags:
  - domain/documents
  - pattern/cli
  - integration/brew-formula
links:
  website: https://weasyprint.org
  repo: https://github.com/Kozea/WeasyPrint
  manual: https://doc.courtbouillon.org/weasyprint/stable/
  brew: https://formulae.brew.sh/formula/weasyprint
covers:
  - Pandoc's CSS engine (--pdf-engine=weasyprint --css=print.css)
  - CSS Paged Media (@page size/margins/page numbers/breaks)
  - branded/controlled print without a browser
related:
  - "[[01-pandoc|Pandoc]]"
  - "[[02-typst|Typst]]"
  - "[[05-markdown-to-a4|Markdown → A4 workflow]]"
---

## Summary
Turns **HTML + CSS into PDF** — pure Python, actively maintained, no headless browser. It implements **CSS Paged Media**, so print layout is plain CSS you already know: `@page`, margins, page numbers, page breaks, columns, fonts. Pandoc renders Markdown→HTML, WeasyPrint styles it with a stylesheet and writes the PDF.

The CSS lane — reach for it when you want *control* (KOL fonts, headers/footers, exact margins) rather than typeset-and-forget.

## Use
```sh
pandoc in.md -o out.pdf --pdf-engine=weasyprint --css=print.css
weasyprint page.html out.pdf                                    # standalone, own HTML
```
Where `print.css` drives the page:
```css
@page { size: A4; margin: 2cm; @bottom-center { content: counter(page) } }
h2 { break-before: page; }          /* each section on a new page */
pre, table { break-inside: avoid; } /* don't split code/tables */
```

## Why installed
The **CSS-controlled** lane of the Markdown→print pipeline — the natural fit for a CSS-native workflow (Tailwind/KOL). Every control you'd want (line-height, columns, font-family, margins) is one CSS rule, and there's **no browser/Chromium** to drag in (unlike md-to-pdf). Brew pulls its native libs (pango/cairo) itself.

## Biggest win
Print layout in **standard CSS**, no new language, no browser, tiny output files. Swap `print.css` and the same Markdown prints branded.

## Future use
The `-e weasyprint` lane of [pdf-from-md.sh](../12-scripts/04-pdf.md), with a starter `bin/print.css`. Full workflow: [Markdown → A4](05-markdown-to-a4.md).

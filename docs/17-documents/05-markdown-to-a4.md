---
title: Markdown → A4 print
type: guide
status: active
updated: 2026-07-03
description: Turn Markdown into print-ready A4 PDFs — the two lanes (Typst generic, WeasyPrint CSS), the pdf-from-md.sh script, A4 knobs, batch + watch, and a Quick Action.
tags:
  - domain/documents
  - domain/publishing
aliases:
  - markdown-to-a4
related:
  - "[[01-pandoc|Pandoc]]"
  - "[[02-typst|Typst]]"
  - "[[03-weasyprint|WeasyPrint]]"
  - "[[../12-scripts/04-pdf|pdf-from-md.sh]]"
---

# Markdown → A4 print

"Print to A4" really means **make an A4 PDF**, then print that. Every tool here is a Markdown→PDF converter; A4 is a page-size setting. Full landscape (all the alternatives, GUI options, CI): `kol-claude/summaries/25-markdown-to-a4-print.md`.

## The one converter, two engines

**Pandoc** does the converting. It hands off to a swappable **PDF engine** — that choice is the whole decision:

| Lane | Engine | For | Command |
|---|---|---|---|
| **Generic** | [Typst](02-typst.md) | fast, unbranded, many files — typeset-and-forget | `--pdf-engine=typst -V papersize=a4` |
| **CSS** | [WeasyPrint](03-weasyprint.md) | branded/controlled — fonts, headers, page numbers | `--pdf-engine=weasyprint --css=print.css` |

Same Markdown, same converter — swap the flag. Typst = zero design work; WeasyPrint = full CSS control.

## The script

[pdf-from-md.sh](../12-scripts/04-pdf.md) wraps both lanes:

```sh
pdf-from-md.sh notes.md                    # → notes.pdf, A4, typst (default)
pdf-from-md.sh                             # every *.md in the current dir
pdf-from-md.sh -e weasyprint report.md     # CSS lane, default bin/print.css
pdf-from-md.sh -e weasyprint -c brand.css *.md
pdf-from-md.sh -s letter notes.md          # US Letter via typst
pdf-from-md.sh -w notes.md                 # re-export on every save (entr)
```

Each `in.md` becomes `in.pdf` beside it. Needs `pandoc` + the chosen engine.

## Controlling the A4 details

- **Page size** — typst: `-s a4` / `-s letter`. CSS: `@page { size: A4 }` in `print.css`.
- **Margins** — CSS: `@page { margin: 2cm }`. typst default is fine; frontmatter `geometry: margin=2.5cm` also works.
- **Page breaks** — CSS: `break-before: page` (new page per section), `break-inside: avoid` (don't split tables/code). The starter `bin/print.css` already avoids splitting code/tables.
- **Headers / footers / page numbers** — CSS Paged Media: `@page { @bottom-center { content: counter(page) } }` (WeasyPrint lane).
- **Fonts** — CSS: any system/web font via `font-family`. Typst: `mainfont:` in frontmatter.
- **Wide tables / long code lines** — the classic A4 overflow. Shrink the font in `print.css`, `white-space: pre-wrap` on `pre` (starter CSS does this), or landscape that page (`@page { size: A4 landscape }`). Portrait typst will clip very wide keymap tables — use the CSS lane or landscape for those.

## Automation

```sh
for f in *.md; do pdf-from-md.sh "$f"; done          # a folder (script already loops)
find . -name '*.md' -exec pdf-from-md.sh {} \;       # recurse a tree
pdf-from-md.sh -w notes.md                            # watch one file while writing
```

A **Quick Action** ("Convert to A4 PDF") wraps `pdf-from-md.sh "$f"` in Automator — the same recipe as [Quick Actions](../12-scripts/10-quick-actions.md). Select `.md` in Finder → right-click → convert.

## Gotcha — wikilinks print literally

Pandoc renders `[[wikilink]]` as the literal text `[[wikilink]]`. Convert docs to standard `[text](path.md)` links before printing (the repo's ongoing wikilink→standard pass). Frontmatter `related:` doesn't render, so it's fine as-is.

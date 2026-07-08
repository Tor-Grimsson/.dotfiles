---
title: Documents & Publishing
type: index
status: active
updated: 2026-07-03
description: Command-line tools for turning Markdown into print-ready documents — Pandoc (converter) and its PDF engines (Typst, WeasyPrint), plus entr for watch-mode automation.
tags:
  - domain/documents
  - domain/publishing
---

Command-line tooling for **Markdown → print-ready A4 PDFs**. Pandoc is the converter; it drives a swappable PDF **engine** — Typst for fast generic output, WeasyPrint for CSS-controlled/branded pages. `entr` gives a re-export-on-save loop.

| Tool | Description |
| --- | --- |
| [[01-pandoc|Pandoc]] | Universal document converter (Markdown→PDF/HTML/Word/…). Drives a separate PDF engine. |
| [[02-typst|Typst]] | Modern typesetting engine — Pandoc's fast, small PDF engine (`--pdf-engine=typst`). |
| [[03-weasyprint|WeasyPrint]] | HTML+CSS→PDF (CSS Paged Media, no browser) — Pandoc's CSS engine (`--pdf-engine=weasyprint`). |
| [[04-entr|entr]] | Re-run a command when files change — watch mode for the convert loop. |

## Workflow
- [[05-markdown-to-a4|Markdown → A4 print]] — the two lanes, the `pdf-from-md.sh` script, A4 knobs, batch + watch, Quick Action.

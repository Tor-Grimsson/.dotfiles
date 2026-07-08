---
title: Pandoc
type: reference
status: active
updated: 2026-07-03
description: Universal document converter — Markdown → PDF/HTML/Word/etc. Doesn't make PDFs itself; drives a separate, swappable PDF engine (Typst or WeasyPrint).
aliases:
  - pandoc
tags:
  - domain/documents
  - pattern/cli
  - integration/brew-formula
links:
  website: https://pandoc.org
  repo: https://github.com/jgm/pandoc
  manual: https://pandoc.org/MANUAL.html
  brew: https://formulae.brew.sh/formula/pandoc
covers:
  - Markdown → PDF (via a PDF engine), HTML, Word, and back
  - reading YAML frontmatter (papersize / geometry / mainfont)
  - the hub that drives Typst or WeasyPrint
related:
  - "[[02-typst|Typst]]"
  - "[[03-weasyprint|WeasyPrint]]"
  - "[[05-markdown-to-a4|Markdown → A4 workflow]]"
---

## Summary
The universal document **translator**: reads Markdown (and dozens of other formats) and writes PDF, HTML, Word, LaTeX, and more. It does **not make a PDF by itself** — it renders the document and hands it to a separate **PDF engine**. The engine is a swappable flag, and that's the whole point: one converter, pick the renderer.

| Want | Engine flag | Install |
|---|---|---|
| fast, generic, no CSS | `--pdf-engine=typst` | [[02-typst|Typst]] |
| CSS-controlled / branded | `--pdf-engine=weasyprint --css=print.css` | [[03-weasyprint|WeasyPrint]] |
| LaTeX / academic | `--pdf-engine=xelatex` | BasicTeX (not installed) |

## Use
```sh
pandoc in.md -o out.pdf --pdf-engine=typst -V papersize=a4       # generic A4
pandoc in.md -o out.pdf --pdf-engine=weasyprint --css=print.css  # CSS lane
pandoc in.md -o out.html                                          # → HTML
pandoc in.docx -o out.md                                          # Word → Markdown
```
Settings can live in the file's YAML frontmatter (`papersize: a4`, `geometry: margin=2.5cm`), so a bare `pandoc in.md -o out.pdf` picks them up.

## Why installed
The hub of the Markdown→A4-print pipeline. Every doc in this repo is Markdown; Pandoc is the one tool that turns the pile into print-ready PDFs, scriptably — without locking into a single renderer.

## Biggest win
One converter, **swappable engine** — `typst` for speed/batch, `weasyprint` for CSS control — with the same command shape. Reads the frontmatter you already write.

## Future use
Built: [[04-pdf|pdf-from-md.sh]] — batch md→A4 PDF with an engine flag; also drives the older `pdf-notes.sh`. Full workflow: [[05-markdown-to-a4|Markdown → A4]].

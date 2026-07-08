---
title: entr
type: reference
status: active
updated: 2026-07-03
description: Re-run an arbitrary command whenever a set of files changes. The watch-mode engine behind the Markdown→PDF re-export loop.
aliases:
  - entr
tags:
  - domain/documents
  - pattern/cli
  - integration/brew-formula
links:
  website: https://eradman.com/entrproject/
  repo: https://github.com/eradman/entr
  manual: https://eradman.com/entrproject/entr.1.html
  brew: https://formulae.brew.sh/formula/entr
covers:
  - re-run a command on file change (watch mode)
  - the -w loop in pdf-from-md.sh
  - generic build/test/reload loops
related:
  - "[[01-pandoc|Pandoc]]"
  - "[[05-markdown-to-a4|Markdown → A4 workflow]]"
---

## Summary
A tiny, general **file-watcher**: pipe it a list of files and a command, and it re-runs the command every time one of them changes. Not document-specific — it's the watch primitive behind any edit→rebuild loop (here: edit a `.md`, auto re-export the PDF).

## Use
```sh
ls *.md | entr -s 'pandoc report.md -o report.pdf --pdf-engine=typst -V papersize=a4'
echo doc.md | entr -s 'pdf-from-md.sh doc.md'   # re-convert on save
find . -name '*.md' | entr -s '<any command>'   # watch a whole tree
```
`-s` runs the argument as a shell command; `-c` clears the screen each run; `-p` waits for the first change before running.

## Why installed
The watch loop for the Markdown→print pipeline — see the change land in the PDF as you write, without re-running the command by hand.

## Biggest win
One small binary turns any command into a live rebuild. Reusable far beyond documents (tests, linters, reloads).

## Future use
Powers `pdf-from-md.sh -w`. Handy anywhere a save-then-rebuild loop helps.

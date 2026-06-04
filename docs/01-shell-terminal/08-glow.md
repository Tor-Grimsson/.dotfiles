---
title: glow
type: reference
status: active
updated: 2026-06-04
description: Terminal markdown renderer — open any .md as styled, readable text, instantly.
aliases:
  - glow
tags:
  - domain/shell
  - pattern/cli
  - integration/brew-formula
  - provider/charm
links:
  website: https://github.com/charmbracelet/glow
  repo: https://github.com/charmbracelet/glow
  manual: https://github.com/charmbracelet/glow#readme
  brew: https://formulae.brew.sh/formula/glow
covers:
  - file render + pager
  - TUI markdown browser
related:
  - "[[07-fastfetch|fastfetch]]"
---

## Summary
A terminal **markdown renderer** from Charm (the bubbletea/lipgloss people). A single self-contained Go binary — no runtime, no dependencies. Reads a `.md` and prints it as styled text: headings, bold/italic, tables, blockquotes, lists/task-lists, and code blocks with real syntax highlighting (chroma), word-wrapped to the terminal and themed auto light/dark.

## Why installed
Quick, zero-friction reading of the repo's own docs (`TOOLING.md`, `docs/`, `.llm-context/`) without opening an editor or a browser. The dotfiles are markdown-heavy; `glow` is the instant reader for them.

## Most common use case
`glow file.md` — render and read a single doc in place.

## Biggest win
**Speed + zero setup.** ~30–40 ms cold (measured): start, render, exit — no daemon, no index, no perceptible "opening." Static binary, so it just works on any machine after `brew install`.

## How to use
```sh
glow file.md          # render a file to the terminal
glow -p file.md       # pager mode — scroll, q to quit (best for long docs)
glow                  # TUI: browse all markdown under the current dir
glow ~/.dotfiles/docs # browse a whole tree
glow -w 100 file.md   # fix wrap width (default = terminal width)
glow https://…/README.md   # render remote markdown / a repo README
```

## Config

Config file: `~/Library/Preferences/glow/glow.yml` (macOS path). Run `glow config` to create/edit it in `$EDITOR`. Keys mirror the flags:

```yaml
style: "auto"   # auto | dark | light | notty | path/to/custom-theme.json
width: 100      # word-wrap column (0 = off)
pager: true     # always page → `glow file.md` becomes scrollable (q to quit)
```

`pager: true` is the best default — every `glow file.md` opens as a clean scrollable reader, no `-p` needed. To version-control it, drop `glow.yml` in the repo and symlink it to that path via `bootstrap.sh`.

## Open a .md from Finder

Finder can't pipe a file into a terminal program, so you wrap it:

1. **Quick Action (recommended)** — Automator → "Run Shell Script" (input = files as args) that opens Terminal/iTerm running `glow -p` on the file. Gives a right-click → "Open in glow" without changing the double-click default. Saved in `~/Library/Services`.
2. **`.app` wrapper** — bundle the script as a `.app` (Automator/Platypus), set it as **Open With → default** for `.md` so double-click opens glow. More invasive.
3. **Terminal function** — `g() { glow -p "$@"; }` in `.zshrc`. Not Finder, but instant from a shell.

## Future use
Pipe rendered docs (`glow doc.md | less -R`), set a default style/width via `~/.config/glow/glow.yml`, or wire it as the markdown previewer in `yazi`. Note: terminals can't show images, so embedded `![]()` images render as nothing — text-only.

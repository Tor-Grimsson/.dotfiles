---
title: Chawan
type: reference
status: active
updated: 2026-06-10
description: Modern TUI browser (`cha`) — CSS rendering, optional JS/images/cookies as runtime toggles; the middle ground between w3m and Carbonyl.
aliases:
  - chawan
  - cha
tags:
  - domain/web
  - pattern/tui
  - integration/brew-formula
links:
  website: https://sr.ht/~bptato/chawan/
  repo: https://git.sr.ht/~bptato/chawan
  manual: https://git.sr.ht/~bptato/chawan/tree/master/doc
  brew: https://formulae.brew.sh/formula/chawan
covers:
  - cha basics, dump mode, -o config overrides
  - runtime toggles (images / JS / cookies) and the vi-style keymap
related:
  - "[[01-carbonyl|Carbonyl]]"
  - "[[02-w3m|w3m]]"
---

## Summary
Chawan (`cha`) is a text-mode browser that actually does CSS layout, and can run JavaScript and show inline images — but only when you switch them on. Off by default, it's a fast, clean pager; toggled on, it handles sites w3m can't, without Carbonyl's Docker dependency.

## Use

```sh
cha https://kolkrabbi.io              # browse (CSS layout, no JS/images by default)
cha -d https://example.com            # dump rendered page to stdout (implicit when piped)
cha -o buffer.images=true <url>       # this run with inline images (sixel/kitty terminal)
cha -o buffer.scripting=true <url>    # this run with JavaScript
cha about:chawan                      # built-in intro + full default keybinding list
man 5 cha-config                      # config format reference
```

## Flags

| Flag | Does |
|---|---|
| `-d` | dump to stdout (auto when stdout isn't a tty) |
| `-o <toml>` | temporary config override, e.g. `-o buffer.images=true` |
| `-c <css>` | append to the user stylesheet for this run |
| `-C <file>` | use another config file |
| `-M` | monochrome |
| `-T <mime>` | content type for piped stdin |

## Keys (vi-style; full list at `about:chawan`)

| Key | Action |
| --- | --- |
| `hjkl` / arrows | move cursor |
| `C-f` / `C-b` | page down/up |
| `[` / `]` | previous/next hyperlink |
| `f` | link hints — type the hint to jump |
| `Enter` | open link under cursor |
| `C-l` | location bar |
| `C-k` | web search |
| `,` / `.` | previous/next buffer (tab) |
| `D` | discard buffer, go back |
| `U` | reload |
| `M-i` / `M-j` / `M-k` | toggle images / JavaScript / cookies |
| `/` `?` `n` `N` | search / backwards / next / previous |
| `\` | page source view |
| `q` | quit |

## Config
`~/.config/chawan/config.toml` (format: `man 5 cha-config`). Not symlinked into the dotfiles — defaults are fine; per-run `-o` covers the occasional opt-in. Inline images need a sixel- or kitty-protocol terminal (iTerm2 does sixel).

## Why installed
The gap between the category's two extremes: [[02-w3m|w3m]] is instant but renders the modern web as soup (no CSS), [[01-carbonyl|Carbonyl]] renders everything but needs OrbStack running. Chawan does real layout standalone, and JS is one toggle away instead of a Docker pull.

## Biggest win
Buffers + link hints: `,`/`.` flip between pages like tabs, `f` jumps to any visible link by typing two characters — browsing text sites ends up faster than a GUI browser.

## Future use
`cha -d` as a smarter `w3m -dump` (CSS-aware) in readability pipelines; a persistent `config.toml` (images on, vi extras) if usage grows past defaults.

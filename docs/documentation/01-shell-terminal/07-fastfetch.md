---
title: fastfetch
type: reference
status: active
updated: 2026-07-08
description: Fast system-information tool that prints OS, hardware, and config alongside an ASCII/image logo.
aliases:
  - fastfetch
tags:
  - domain/shell
  - pattern/cli
  - integration/brew-formula
links:
  website: https://github.com/fastfetch-cli/fastfetch
  repo: https://github.com/fastfetch-cli/fastfetch
  manual: https://github.com/fastfetch-cli/fastfetch/wiki
  brew: https://formulae.brew.sh/formula/fastfetch
covers:
  - Running it and customizing the output
  - Generating a config file
related:
  - "[[01-iterm2|iTerm2]]"
  - "[[11-htop|htop]]"
  - "[[21-chafa|chafa]]"
  - "[[01-fastfetch-home|Fastfetch shell home]]"
---

## Summary
fastfetch is a system-information fetch tool — the successor to neofetch, rewritten mostly in C for speed. It prints a summary of the OS, kernel, hardware, uptime, shell, and theme next to a distro/OS logo rendered in ASCII or as an image.

## Why installed
It is a quick, good-looking way to confirm the machine's specs and environment at a glance — handy in a terminal-startup banner or when documenting a setup. Being C-based, it runs near-instantly where neofetch felt sluggish.

## Most common use case
Running `fastfetch` to print a one-shot system summary — often wired into shell startup as a banner, or invoked manually to grab specs for screenshots or bug reports.

## Biggest win
Speed and configurability. It is dramatically faster than neofetch and exposes a structured JSON-based config so every line, color, and logo can be customized precisely.

## How to use
```sh
fastfetch                         # print the default system report

fastfetch --logo none             # text only, no logo
fastfetch --logo apple            # force a specific logo
fastfetch -c paleofetch           # use a built-in preset config

# Generate an editable config to ~/.config/fastfetch/config.jsonc:
fastfetch --gen-config
```

## Shell home (configured)
This machine runs a hand-tuned `config.jsonc` with a **[[21-chafa|chafa]]-rendered portrait logo** in place of an OS logo. The full setup — config, the image→chafa→ANSI logo pipeline, how to regen/tune it, and the symlink wiring — is documented in [[01-fastfetch-home|Fastfetch shell home]]. Config lives at `~/.dotfiles/fastfetch/` (symlinked to `~/.config/fastfetch`, via `bootstrap.sh`). Add `fastfetch` to `.zshrc` to greet on every new shell.

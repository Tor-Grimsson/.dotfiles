---
title: Powerlevel10k
type: reference
status: active
updated: 2026-07-09
description: Active zsh prompt theme (rainbow/powerline). Restored 2026-07-09; starship kept as a parked alternate.
aliases:
  - p10k
  - powerlevel10k
tags:
  - domain/shell/prompt
  - pattern/cli
  - integration/brew-formula
links:
  website: https://github.com/romkatv/powerlevel10k
  repo: https://github.com/romkatv/powerlevel10k
  manual: https://github.com/romkatv/powerlevel10k#configuration
  brew: https://formulae.brew.sh/formula/powerlevel10k
covers:
  - Activating the theme in .zshrc
  - The configuration wizard and instant prompt
related:
  - "[[27-starship|starship]]"
  - "[[04-zsh-syntax-highlighting|zsh-syntax-highlighting]]"
  - "[[05-zsh-completions|zsh-completions]]"
---

> **Restored as the active prompt on 2026-07-09** (had been briefly replaced by [[27-starship|starship]]). p10k is back in `brewfile-cli` and sourced from Homebrew in `.zshrc`; the tuned `shell/.p10k.zsh` drives it. [[27-starship|starship]] is kept as a parked alternate — its config stays in the repo and its `eval` line is commented in `.zshrc`. To switch back: comment the two p10k source lines in `.zshrc` and uncomment the starship `eval` line.

## Summary
Powerlevel10k is a theme for zsh that renders a rich, segmented prompt — git branch and status, exit codes, time, language versions, and more. It is written for speed: heavy computation is deferred so the prompt appears instantly even in large git repositories.

## Why installed
The prompt for this shell (briefly swapped to [[27-starship|starship]] in 2026-07, then restored). It gives at-a-glance context (current directory, git state, last command status) without the per-keystroke lag that other rich prompts cause, which matters in big repos where naive git prompts stall.

## Most common use case
Just being the prompt — showing the current path and live git branch/dirty state on every command line, with the instant-prompt feature making new shells feel immediate.

## Biggest win
Instant prompt plus asynchronous segment rendering: the prompt draws before slow data (git, network) is ready, then fills in. No other zsh theme matches its responsiveness in large repositories.

## How to use
```sh
# Add to the end of ~/.zshrc to activate the theme:
source /usr/local/share/powerlevel10k/powerlevel10k.zsh-theme

# Run the interactive configuration wizard (rerun anytime to restyle):
p10k configure
# Writes ~/.p10k.zsh; ensure .zshrc sources it:
#   [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
```
Requires a Nerd Font in the terminal for icons; the wizard detects and warns if glyphs are missing. Restart the terminal after first sourcing.

**Note — color scheme:** the tracked `shell/.p10k.zsh` is the wizard's **`p10k-rainbow`** style on **stock ANSI palette indices** (dir bg `4`/blue, os-icon bg `7`, vcs clean `2`/green, modified `3`/yellow, fg `254`). A deep-Catppuccin-Latte hex reskin was tried on 2026-07-09 during the starship detour and **reverted** (restored from commit `df-018`, the last pre-Ghostty state). Re-running `p10k configure` regenerates this file from scratch.

## Future use
Hand-editing `~/.p10k.zsh` to add custom segments (kubernetes context, AWS profile, command duration thresholds), transient prompt to collapse past prompts to a single line, and per-directory prompt elements for project-specific context.

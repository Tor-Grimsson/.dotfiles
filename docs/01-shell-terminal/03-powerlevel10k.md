---
title: Powerlevel10k
type: reference
status: active
updated: 2026-06-04
description: Fast, configurable zsh prompt theme with git status, segments, and an instant-prompt startup.
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
  - "[[04-zsh-syntax-highlighting|zsh-syntax-highlighting]]"
  - "[[05-zsh-completions|zsh-completions]]"
---

## Summary
Powerlevel10k is a theme for zsh that renders a rich, segmented prompt — git branch and status, exit codes, time, language versions, and more. It is written for speed: heavy computation is deferred so the prompt appears instantly even in large git repositories.

## Why installed
It is the prompt for this shell. It gives at-a-glance context (current directory, git state, last command status) without the per-keystroke lag that other rich prompts cause, which matters in big repos where naive git prompts stall.

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

## Future use
Hand-editing `~/.p10k.zsh` to add custom segments (kubernetes context, AWS profile, command duration thresholds), transient prompt to collapse past prompts to a single line, and per-directory prompt elements for project-specific context.

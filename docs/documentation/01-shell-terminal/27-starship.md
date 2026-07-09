---
title: starship
type: reference
status: active
updated: 2026-07-09
description: Cross-shell prompt configured from a single TOML file — parked alternate to Powerlevel10k, kept to switch back. Lean two-line layout on a warm Gruvbox palette.
aliases:
  - starship
tags:
  - domain/shell
  - pattern/prompt
  - integration/brew
links:
  website: https://starship.rs/
  repo: https://github.com/starship/starship
  config: https://starship.rs/config/
  presets: https://starship.rs/presets/
  brew: https://formulae.brew.sh/formula/starship
covers:
  - Where the tracked config lives and how it's symlinked
  - The prompt design (layout, segment order, palette)
  - Activating it in .zshrc and reloading after edits
related:
  - "[[03-powerlevel10k|Powerlevel10k]]"
  - "[[26-ghostty|Ghostty]]"
  - "[[02-tmux|tmux]]"
---

> **Parked alternate as of 2026-07-09.** [[03-powerlevel10k|Powerlevel10k]] is the active prompt again; starship is kept installed and fully configured so switching back is a one-line flip. Its `eval "$(starship init zsh)"` line is **commented** in `shell/.zshrc` — uncomment it (and comment the two p10k source lines) to switch. Config and this doc are still maintained.

## Summary
starship is a fast, cross-shell prompt written in Rust and configured from a single TOML file. The current config is [hendrikmi/dotfiles](https://github.com/hendrikmi/dotfiles)' **lean two-line** layout (directory + git on the left, a `$fill` spacer, then language/aws/docker/jobs/duration flush right), **repainted onto a warm Gruvbox palette** (directory orange, git green, cream text) so it matches the Gruvbox terminal.

## Why installed
Replaced [[03-powerlevel10k|Powerlevel10k]] on 2026-07-09 — p10k's rainbow style read washed-out and its 1800-line config is awkward to hand-theme; starship is one readable TOML. Trialed community configs: [ericmckevitt/Dotfiles](https://github.com/ericmckevitt/Dotfiles)' filled ribbon, then hendrikmi's lean layout (kept). Its stock **Nord** palette read cold, and a Catppuccin Mocha repaint still felt cold — so the whole stack moved to **Gruvbox**: a `[palettes.gruvbox]` block maps `dark_blue`→orange, `green`→gruvbox green, etc., with `palette = 'gruvbox'` active. (`catppuccin_mocha`/`nord`/`onedark` kept as inline alternates.)

## Config, at a glance
| | |
|---|---|
| **Tracked file** | `starship/starship.toml` |
| **Symlinked to** | `~/.config/starship.toml` (by `bootstrap.sh`) |
| **Activated in** | `shell/.zshrc` — `eval "$(starship init zsh)"` (currently **commented out**; p10k is active — uncomment to switch back) |
| **Palette** | `gruvbox` (defined inline — warm cream/orange/green; `catppuccin_mocha`/`nord`/`onedark` kept as unused alternates) |
| **Reload after edit** | new shell / `exec zsh` — starship re-reads the TOML each prompt, so most edits show on the next prompt |

### Prompt design (current — hendrikmi lean)
- **Lean two-line, no filled blocks** — coloured text only, no powerline background segments. `add_newline` puts a blank line above each prompt.
- **Left / right split via `$fill`** — directory + git branch/status on the left; the `$fill` spacer pushes language versions, aws, docker, jobs, and command duration flush to the **right** edge.
- **Conditional modules** — the right-side language/tool segments only appear in a project that uses them.
- **Second-line character** — `❯` in green (OK) / red (failed) on the line below.
- **Warm Gruvbox palette** — repainted off hendrik's stock Nord (cold blue-greys) onto Gruvbox: directory orange, git green, cream text, langs on distinct warm accents.

## How to use
```sh
# Already activated in .zshrc:
eval "$(starship init zsh)"

# Edit the prompt — plain TOML, no wizard:
$EDITOR ~/.config/starship.toml      # (a repo symlink — edits the tracked file)

# Print the resolved config / a rendered prompt without launching a shell:
STARSHIP_CONFIG=~/.dotfiles/starship/starship.toml starship print-config
STARSHIP_CONFIG=~/.dotfiles/starship/starship.toml starship prompt
```
`starship config` with **no argument opens `$EDITOR`** — use `print-config` to just inspect. Requires a Nerd Font for the segment glyphs (already present via `MesloLGS NF`).

## Future use
starship has modules the current config doesn't enable (battery, memory, kubernetes, aws, custom commands, a right-prompt via `right_format`, and a transient prompt through the shell). Swap the whole look by editing the `format` string or dropping in one of the [official presets](https://starship.rs/presets/).

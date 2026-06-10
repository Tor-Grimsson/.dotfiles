---
title: oh-my-posh
type: reference
status: active
updated: 2026-06-10
description: Cross-shell prompt engine (theme = a JSON/YAML block layout). The `omp-*` helpers cycle vendored themes live and persist the choice.
aliases:
  - oh-my-posh
  - omp
  - omp-next
  - omp-set
  - omp-list
tags:
  - domain/shell/prompt
  - pattern/cli
  - integration/brew-formula
links:
  website: https://ohmyposh.dev
  repo: https://github.com/JanDeDobbeleer/oh-my-posh
  manual: https://ohmyposh.dev/docs
  themes: https://ohmyposh.dev/docs/themes
  brew: https://formulae.brew.sh/formula/oh-my-posh
covers:
  - omp-next / omp-set / omp-list theme cycler
  - vendored stock theme list (shell/oh-my-posh/)
  - block direction knobs (newline, alignment, invert_powerline)
related:
  - "[[03-powerlevel10k|Powerlevel10k]]"
  - "[[01-iterm2|iTerm2]]"
---

## Summary
The active zsh prompt. A theme is a `*.omp.json`/`*.omp.yaml` file describing prompt *blocks*; oh-my-posh renders them. [[03-powerlevel10k|Powerlevel10k]] is the guarded fallback for any machine without oh-my-posh installed.

**One install ships the engine; the `omp-*` helpers (house functions in `shell/.zshrc`) cycle the vendored themes:**

| Command | Does | Needs |
|---|---|---|
| `omp-list` | list vendored themes, current marked | — |
| `omp-next` | cycle to the next theme (alphabetical), reload now + persist | — |
| `omp-set <name>` | jump to one by basename (extension optional, json **or** yaml) | the name must exist in `shell/oh-my-posh/` |

The choice persists in `~/.cache/oh-my-posh-theme` (a bare filename). The `.zshrc` prompt block reads that file on every new shell, defaulting to `catppuccin_macchiato.omp.json` when it's unset or names a missing file. Drop any `*.omp.json`/`*.omp.yaml` into `shell/oh-my-posh/` and it joins the rotation automatically — the cycler globs the folder, it isn't a hardcoded list.

## Setup

1. Install (one-off, user runs it): `brew install oh-my-posh` — already in the [[../INDEX|Brewfile]]; p10k stays as the fallback.
2. Themes are vendored in `shell/oh-my-posh/` (tracked, so they survive `brew upgrade` — the brew copies live at a version-stamped Cellar path).
3. Functions already live in `shell/.zshrc` (the `_omp_apply` / `omp-next` / `omp-set` / `omp-list` block).
4. New shell or `source ~/.zshrc`, then `omp-list`.

## Use

```sh
omp-list                       # all vendored themes, current marked
omp-next                       # rotate to the next one (sticks across shells)
omp-set tonybaloney            # jump straight to a theme
omp-set devious-diamonds       # bare name resolves to .omp.yaml automatically
cat ~/.cache/oh-my-posh-theme  # which theme is persisted right now

# Add a new theme to the rotation (copy from the brew set, then it auto-joins):
cp "$(brew --prefix oh-my-posh)/themes/<name>.omp.json" shell/oh-my-posh/
```

## Vendored themes (27)

Stock oh-my-posh themes copied from the brew install into `shell/oh-my-posh/`. All `.omp.json` except `devious-diamonds` (`.omp.yaml`). `atomicBit` is locally tweaked (blank line before its input row — see below); the rest are pristine.

```
1_shell           amro            atomicBit*      avit
catppuccin_macchiato (default)    clean-detailed  cobalt2
craver            darkblood       devious-diamonds (yaml)
di4am0nd          emodipt-extend  honukai         huvix
illusi0n          marcduiker      material        mojada
montys            negligible      night-owl       onehalf.minimal
peru              sim-web         tonybaloney     uew            wopian
```

## Customizing a theme — direction knobs

The three properties that move/flip prompt content (the bits that are easy to forget):

| Want | Knob | Where |
|---|---|---|
| Block **down** a line / **up** onto the previous line | `"newline": true` on the block (+ block order in `blocks[]` = top→bottom) | block level |
| Block to the left/right screen edge | `"alignment": "left"` \| `"right"` | block level |
| Powerline separator points the other way (needed when a block moves to the right edge) | `"invert_powerline": true` | segment level |
| Blank line between two rows | prepend `\n` to the lower block's leading template | segment template |

Worked example (this repo): `atomicBit.omp.json` — its bottom block's leading text was `"╰─"`; changing it to `"\n╰─"` drops the `╰─[git]` **input row down one line** with a gap above. oh-my-posh renders `\n` in a template as a real line break. There is **no** way to pin a row to the *bottom of the terminal window* — that's a [[02-tmux|tmux]] status-line job, not a prompt feature.

Verify a theme renders without polluting the live shell:
```sh
env -i HOME="$HOME" PATH="$PATH" oh-my-posh print primary \
  --config "$PWD/shell/oh-my-posh/atomicBit.omp.json" --shell zsh | cat -A
```
(The clean `env -i` matters — a normal shell's oh-my-posh init leaks `$POSH_THEME` and overrides `--config`.)

## Why installed
Trialling oh-my-posh against [[03-powerlevel10k|p10k]]: themes are plain JSON/YAML (diff-able, vendorable, portable) instead of p10k's generated `~/.p10k.zsh`, and the theme library is huge. The `omp-*` cycler exists to A/B themes without hand-editing the `.zshrc` config string each time.

## Biggest win
`omp-next` makes theme selection a live, persistent, zero-friction loop — rotate, keep typing, the prompt reloads in place and the choice survives new shells. Vendoring the JSON means the same rotation reproduces on the other Mac via git, no re-download.

## Future use
Prune the rotation to the keepers once a favourite lands; write the keeper's palette to track the [[01-iterm2|iTerm2]] theme instead of hardcoded hex; if p10k gets retired, drop the fallback block + `shell/.p10k.zsh` + the Brewfile line.

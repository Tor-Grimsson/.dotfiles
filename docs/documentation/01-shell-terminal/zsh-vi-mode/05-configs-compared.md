---
title: Real configs compared
type: guide
status: active
updated: 2026-07-09
description: Eight real-world zsh-vi-mode configurations pulled from GitHub, tabulated option-by-option against ours — escape key, cursor, fzf re-binding method, init mode, and the extras people add — with a verdict on what's worth adopting.
tags:
  - domain/shell
related:
  - "[[INDEX|zsh vi-mode — complete guide]]"
  - "[[04-configuration|Configuration reference]]"
  - "[[09-troubleshooting-faq|Troubleshooting & FAQ]]"
---

# Real configs compared

Pulled from GitHub code search (2026-07-09), reading the actual `.zshrc`/plugin files of eight people who run zsh-vi-mode daily, then lining their choices up against ours. The point: sanity-check our config against what works in the wild, and flag anything worth stealing.

## The sample

| # | Repo | File | Notable for |
| --- | --- | --- | --- |
| 1 | `wookayin/dotfiles` | `zsh/zshrc` | `ZVM_INIT_MODE=sourcing` (eager init) |
| 2 | `seblyng/dotfiles` | `zsh/vim.zsh` | DIY cursor + surgical fzf rebind |
| 3 | `linkarzu/dotfiles-latest` | `zshrc/zshrc-macos.sh` | macOS+brew, closest to ours; lazy-keybinding widgets |
| 4 | `SeniorMars/dotfiles` | `.config/zsh/.zshrc` | reverts to the ZLE readkey engine |
| 5 | `radleylewis/zsh` | `bindings.zsh` | disables highlight, sets 3 cursors |
| 6 | `XXiaoA/dotfiles` | `zsh/.zshrc` | `s-prefix` surround style |
| 7 | `maxhu08/dotfiles` | `zsh/.zshrc` | full prompt mode-indicator |
| 8 | `PraveenGongada/dotfiles` | `zshrc/.zshrc` | escape on all four modes |

## The comparison matrix

| Choice | 1 wookayin | 2 seblyng | 3 linkarzu | 4 SeniorMars | 5 radley | 6 XXiaoA | 7 maxhu08 | 8 Praveen | **Ours** |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| **Escape key** | Esc | Esc | `kj` | `jk` | Esc | `jj` | `kj` | `jj` | Esc *(jk optional)* |
| **Cursor** | — | DIY | ZVM 3-way | off | ZVM 3-way | — | DIY | — | **ZVM 2-way** |
| **fzf re-bind** | — | widget | `_commands+=` | `_commands+=` | fn | — | — | `_commands+=` | **`after_init` fn** |
| **Init mode** | sourcing | lazy | lazy | lazy | lazy | lazy | lazy | lazy | **lazy** |
| **Line-init** | insert | — | — | — | — | — | — | — | **insert** |
| **`ZVM_TERM`** | no | no | no | no | no | no | no | no | **yes** |
| **Mode indicator** | — | cursor | cursor | — | cursor | — | prompt seg | — | p10k + cursor |

## What the sample tells us

**1. A custom escape key is the majority choice — 5 of 8.** `kj`×2, `jj`×2, `jk`×1; three keep real Esc. So rebinding Esc to a home-row roll is the norm, not an oddity. We leave it as an *opt-in* (commented `ZVM_VI_INSERT_ESCAPE_BINDKEY=jk`), because for someone **learning** vim it's more faithful to build the real Esc reflex first — but if reaching for Esc gets annoying, you're in good company enabling it. Note linkarzu/Praveen set it on **all four** modes (`ZVM_VI_ESCAPE_BINDKEY=kj` then assign the insert/visual/oppend vars to it) — the thorough way.

**2. Our fzf approach is fine; the common idiom differs cosmetically.** Three configs use `zvm_after_init_commands+=('[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh')`. We use a `zvm_after_init()` *function* with `source <(fzf --zsh)` — the same mechanism, and `fzf --zsh` is the modern generator (fzf ≥ 0.48) versus the older `~/.fzf.zsh` file. seblyng's is the most surgical: `zvm_bindkey viins '^R' fzf-history-widget` — rebind only the one widget instead of re-sourcing everything. Worth borrowing if re-sourcing ever causes a hiccup.

**3. Our cursor config matches the closest setup.** linkarzu (also macOS+brew) sets `BEAM`/`BLOCK`/`UNDERLINE` for insert/normal/oppend; we set `BEAM`/`BLOCK`. Adding `ZVM_OPPEND_MODE_CURSOR=$ZVM_CURSOR_UNDERLINE` (underline while a `d`/`c` waits for its motion) is a nice, cheap upgrade. seblyng and SeniorMars **disable** ZVM's cursor and roll their own via `zle-keymap-select` — more control, more code; no reason for us to.

**4. We're the only one setting `ZVM_TERM` — and that's correct for our stack.** None of the eight set it, and linkarzu even documents fighting cursor issues under wezterm+tmux by hacking `$TERM`. `ZVM_TERM=xterm-256color` is the README's documented fix for exactly that, so running inside tmux we're **ahead** of the sample here, not behind.

**5. Init mode: we're with the majority (lazy).** Only wookayin forces `ZVM_INIT_MODE=sourcing`. Lazy (default) is the safer choice and what 7 of 8 use.

## Worth adopting (optional)

| From | Idea | Why |
| --- | --- | --- |
| linkarzu | `ZVM_OPPEND_MODE_CURSOR=$ZVM_CURSOR_UNDERLINE` | visual feedback that an operator is waiting for its motion |
| linkarzu/Praveen | set escape on all four modes, not just insert | consistent `jk`/`kj` everywhere (if you enable it at all) |
| maxhu08 | `zvm_after_select_vi_mode` prompt segment | only if you drop p10k — p10k already shows the mode |
| seblyng | `zvm_bindkey viins '^R' fzf-history-widget` | fallback if the full fzf re-source misbehaves |

None are required; ours is sound as-is. The escape key is the one genuine decision left open — see [[01-basics|chapter 1]] for how to flip it on.

## Method note

Configs fetched via `gh api repos/<owner>/<repo>/contents/<path>` on 2026-07-09 from the first page of GitHub code-search hits for `zvm_after_init` and `ZVM_VI_INSERT_ESCAPE_BINDKEY`. Eight is a sample, not a census — but the escape-key and lazy-init patterns are consistent enough to trust.

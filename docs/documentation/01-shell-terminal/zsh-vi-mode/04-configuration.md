---
title: Configuration reference
type: guide
status: active
updated: 2026-07-09
description: The complete zsh-vi-mode configuration system — where config lives, the four hook functions and two command-arrays the plugin calls, and an option-by-option table of every ZVM_* setting with its default and what we set.
tags:
  - domain/shell
related:
  - "[[INDEX|zsh vi-mode — complete guide]]"
  - "[[03-power-and-setup|Power features & your setup]]"
  - "[[05-configs-compared|Real configs compared]]"
  - "[[09-troubleshooting-faq|Troubleshooting & FAQ]]"
---

# Configuration reference

Everything zsh-vi-mode exposes, and how its config system actually works. If you only want the summary of *our* setup, that's in [[03-power-and-setup|chapter 3]] — this is the exhaustive version.

## Where configuration lives

There is no separate config file. zsh-vi-mode is configured **entirely from `shell/.zshrc`**, in the guarded block:

```zsh
VI_MODE=true
ZVM_PLUGIN="$HB/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
if [[ "$VI_MODE" == true ]] && [[ -r "$ZVM_PLUGIN" ]]; then
  function zvm_config() { ... }      # (A) options
  source "$ZVM_PLUGIN"               # (B) load the plugin
  function zvm_after_init() { ... }  # (C) re-apply keybinds
fi
```

The ordering is the whole trick, and it's dictated by *when the plugin runs each piece*.

## The config system: why timing matters

zsh-vi-mode is unusual: it **postpones its initialization to the first command line** (not source time). That's deliberate — it sidesteps the plugin-load-order bugs that plague raw `bindkey -v` setups. The consequence is that config can't all go in one place; it's split across **hook functions the plugin calls for you** at the right moments.

| Hook | When the plugin calls it | Put here |
| --- | --- | --- |
| **`zvm_config()`** | during sourcing, before init | options that reference plugin vars (`$ZVM_CURSOR_*`, `$ZVM_MODE_*`) — cursor styles, init mode, escape key |
| **`zvm_after_init()`** | after the first-prompt init (which wipes keymaps) | re-applying **insert/main-keymap** binds — fzf, atuin, history |
| **`zvm_after_lazy_keybindings()`** | first time you enter normal mode | custom **normal/visual-mode** binds (`vicmd`, `visual`) |
| **`zvm_after_select_vi_mode()`** | every time the mode changes | updating a prompt mode-indicator |

Define a function with one of these names and the plugin auto-runs it — you never call them yourself. There are also append-only array equivalents (`zvm_after_init_commands+=(...)`, etc.) if you prefer not to define a function; both are documented and equivalent.

**The rule of thumb:** insert-mode / global keybinds → `zvm_after_init`. Normal-mode keybinds → `zvm_after_lazy_keybindings`. Everything that isn't a keybind → `zvm_config`.

## Our two functions, annotated

**`zvm_config()`** — set before the plugin finishes loading:

```zsh
function zvm_config() {
  ZVM_TERM=xterm-256color                  # cursor escapes that survive tmux
  ZVM_CURSOR_STYLE_ENABLED=true            # let the plugin drive cursor shape
  ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK # normal = block
  ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BEAM  # insert = beam
  ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT      # each prompt starts in insert
}
```

**`zvm_after_init()`** — re-apply what the init wiped:

```zsh
function zvm_after_init() {
  source <(fzf --zsh)                      # Ctrl-R / Ctrl-T / Alt-C
  bindkey '^P' atuin-search                # atuin
  bindkey '^[[A' up-line-or-beginning-search   # the history tiers…
  # …plus emacs conveniences in viins
}
```

## Every option, with defaults

**Behaviour**

| Option | Default | What it does | Ours |
| --- | --- | --- | --- |
| `ZVM_INIT_MODE` | *(lazy: first prompt)* | `sourcing` = init at source time instead | default |
| `ZVM_LAZY_KEYBINDINGS` | `true` | postpone normal/visual binds to first normal-mode entry (faster startup) | default |
| `ZVM_LINE_INIT_MODE` | `$ZVM_MODE_LAST` | mode each new prompt starts in (`_INSERT` / `_NORMAL` / `_LAST`) | `_INSERT` |
| `ZVM_KEYTIMEOUT` | `0.4` | seconds to wait for a multi-key sequence | default |
| `ZVM_ESCAPE_KEYTIMEOUT` | `0.03` | seconds to wait after Esc (NEX engine) to tell standalone-Esc from an escape sequence | default |
| `ZVM_READKEY_ENGINE` | `NEX` | `$ZVM_READKEY_ENGINE_ZLE` reverts to zsh's native engine (more compatible, less featureful) | default |

**Escape key**

| Option | Default | What it does | Ours |
| --- | --- | --- | --- |
| `ZVM_VI_ESCAPE_BINDKEY` | `^[` (Esc) | the escape key for all modes | default |
| `ZVM_VI_INSERT_ESCAPE_BINDKEY` | `$ZVM_VI_ESCAPE_BINDKEY` | escape key just for insert mode (e.g. `jk`) | default (commented option) |
| `ZVM_VI_VISUAL_ESCAPE_BINDKEY` / `..._OPPEND_...` | inherit | escape for visual / operator-pending | default |

**Cursor**

| Option | Default | What it does | Ours |
| --- | --- | --- | --- |
| `ZVM_CURSOR_STYLE_ENABLED` | `true` | let the plugin change cursor shape per mode | `true` |
| `ZVM_NORMAL_MODE_CURSOR` | block | cursor in normal mode | `$ZVM_CURSOR_BLOCK` |
| `ZVM_INSERT_MODE_CURSOR` | beam | cursor in insert mode | `$ZVM_CURSOR_BEAM` |
| `ZVM_VISUAL_MODE_CURSOR` / `..._OPPEND_...` | — | cursor in visual / operator-pending | default |
| `ZVM_TERM` | `$TERM` | term type used to emit cursor escapes | `xterm-256color` (tmux fix) |

Cursor values: `ZVM_CURSOR_BLOCK`, `_UNDERLINE`, `_BEAM`, `_BLINKING_BLOCK`, `_BLINKING_UNDERLINE`, `_BLINKING_BEAM`, `_USER_DEFAULT`.

**Highlight (surround / visual)**

| Option | Default | What it does |
| --- | --- | --- |
| `ZVM_VI_HIGHLIGHT_FOREGROUND` | — | text colour of highlighted regions (name or hex) |
| `ZVM_VI_HIGHLIGHT_BACKGROUND` | — | background colour |
| `ZVM_VI_HIGHLIGHT_EXTRASTYLE` | — | `bold`, `underline`, … |

**Surround**

| Option | Default | What it does |
| --- | --- | --- |
| `ZVM_VI_SURROUND_BINDKEY` | `classic` | `s-prefix` switches to the `S`-prefixed surround style |

## Config-entry function name

The name `zvm_config` is itself configurable via `ZVM_CONFIG_FUNC` (default `zvm_config`) — rarely needed. Set it before sourcing if you want a differently-named entry function.

## Related
- [[05-configs-compared|Real configs compared]] — how eight real dotfiles set these options, and where ours differs.
- [[09-troubleshooting-faq|Troubleshooting & FAQ]] — which of these to reach for when something feels off (escape lag, cursor, load order).

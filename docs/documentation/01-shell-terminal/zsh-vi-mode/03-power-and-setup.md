---
title: Power features & your exact setup
type: guide
status: active
updated: 2026-07-09
description: The extras beyond plain vim — surround, edit-line-in-nvim, open-under-cursor, increment, system clipboard — plus a precise record of how vi-mode is wired into your shell, how it coexists with fzf/atuin/tmux, and exactly what changed on disk (including the fact that no scripts were moved and no backups were made).
tags:
  - domain/shell
related:
  - "[[INDEX|zsh vi-mode — complete guide]]"
  - "[[02-motions-and-editing|Motions & editing]]"
  - "[[28-zsh-vi-mode|zsh-vi-mode (catalog reference)]]"
---

# Power features & your exact setup

## Beyond plain vim — zsh-vi-mode extras

These ship with the plugin and go past what raw vim gives you on the command line:

| Key | Does |
| --- | --- |
| `ysiw"` | **surround**: wrap the inner word in `"…"` (`ys` = "you surround" + a text object + the char) |
| `ys$)` | surround to end of line with `()` |
| `cs"'` | change the surrounding `"` into `'` |
| `ds"` | delete the surrounding quotes |
| `S"` (visual) | surround the visual selection with `"` |
| `vv` | open the current command line in **nvim** (`$EDITOR`); save & quit → it runs |
| `gx` | open the URL or file path under the cursor |
| `Ctrl-a` / `Ctrl-x` | increment / decrement the number under the cursor |
| `10p`, `4fa` | counts work everywhere — repeat N times |

`vv` is the sleeper hit: for a long or fiddly command, drop into nvim with the full editor, fix it, `:wq`, and it executes. The command line becomes a buffer.

## System clipboard

Yank in vi-mode integrates with the macOS clipboard, and your tmux config relays it (`set-clipboard on`, `allow-passthrough on`) — so a `yy` in a tmux pane, even over SSH, lands on *this* Mac's clipboard.

## How it's wired in your `.zshrc`

The whole thing lives in one guarded block near the end of `shell/.zshrc`:

```zsh
VI_MODE=true
ZVM_PLUGIN="$HB/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
if [[ "$VI_MODE" == true ]] && [[ -r "$ZVM_PLUGIN" ]]; then
  function zvm_config() { ... }        # cursor styles, ZVM_TERM, insert-init
  source "$ZVM_PLUGIN"
  function zvm_after_init() { ... }     # re-applies fzf / atuin / history binds
fi
```

Two gates: the `VI_MODE` flag **and** the plugin file existing. Both must hold or the block is skipped.

**`zvm_config()`** (runs during sourcing) sets:

| Option | Value | Why |
| --- | --- | --- |
| `ZVM_TERM` | `xterm-256color` | cursor-shape escapes that survive tmux |
| `ZVM_NORMAL_MODE_CURSOR` | block | block cursor = normal mode |
| `ZVM_INSERT_MODE_CURSOR` | beam | beam cursor = insert mode |
| `ZVM_LINE_INIT_MODE` | insert | every prompt starts ready to type |

**`zvm_after_init()`** (runs after the plugin re-initializes zle at the first prompt) re-applies the keybinds the plugin would otherwise wipe:

| Preserved | Keys |
| --- | --- |
| fzf | `Ctrl-R`, `Ctrl-T`, `Alt-C` |
| [[25-atuin|atuin]] | `Ctrl-P`, `Shift-Up` |
| history tiers | `Up`/`Down` prefix search, `Opt-Up`/`Down` plain |
| emacs-in-insert | `Ctrl-A/E/K`, `Alt-b/f`, `Alt-⌫` |

Why the hook is needed: zsh-vi-mode rebuilds the keymaps on first use, which clobbers any binding set earlier in `.zshrc`. Re-applying them inside `zvm_after_init` is the plugin author's documented fix.

## tmux

Already vi-mode-ready — `escape-time 10` (no Esc lag), `mode-keys vi` (copy-mode uses the same motions), clipboard passthrough. If the block/beam cursor doesn't change **inside tmux**, add one line to `tmux/.tmux.conf`:

```tmux
set -ga terminal-overrides ',*:Ss=\E[%p1%d q:Se=\E[ q'
```

## Verify it's working

- [ ] Prompt starts in insert; `Esc` → block cursor, `i` → beam.
- [ ] `Ctrl-R` (fzf), `Ctrl-P` (atuin), prefix-`Up` history all still work.
- [ ] zsh-autosuggestions grey text still appears.
- [ ] Cursor shape changes inside tmux (else add the override above).
- [ ] `VI_MODE=false` + `exec zsh` cleanly reverts.

## What changed on disk (and what did NOT)

For the record — the vi-mode work touched exactly these files, all **in-place edits**:

| File | Change |
| --- | --- |
| `shell/.zshrc` | added the guarded vi-mode block |
| `brewfile-cli` | added `brew "zsh-vi-mode"` |
| `keys/keybinds.md` | added the `#vimode` drill section |
| `docs/…/28-zsh-vi-mode.md` | catalog reference (new) |
| `docs/…/zsh-vi-mode/` | this guide folder (new) |
| both `INDEX.md`s | routing + tool count |

**No scripts were moved.** Nothing in `bin/` was renamed, relocated, or deleted. **No backup files were created** — no `.bak`, no copies stashed anywhere. This repo's backup mechanism is git history, and the agent does not run git; reverting any of the above is `git checkout <file>` (your call) or, for vi-mode specifically, the `VI_MODE=false` flag. If you remember scripts being "moved and backed up," that was a different, earlier session (the `~/.p10k.zsh` colour restore), and even that overwrote in place rather than keeping a backup copy.

Next: [[04-configuration|Configuration reference]] for the exhaustive option-by-option version of this setup.

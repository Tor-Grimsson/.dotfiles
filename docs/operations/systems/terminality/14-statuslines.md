---
title: Statuslines — all five, and where each one is configured
type: reference
status: active
updated: 2026-08-05
description: The five status bars this setup edits — Claude Code, tmux, Neovim, yazi and the zsh prompt. What each one shows, the exact file that configures it, how to change it, and how to make the change appear, because every one of them reloads differently.
tags:
  - project/dotfiles
  - domain/tooling
  - pattern/tui
related:
  - "[[operations/systems/terminality/INDEX|Terminality]]"
  - "[[operations/systems/terminality/05-tmux-and-layout|tmux & layout]]"
  - "[[documentation/01-shell-terminal/03-powerlevel10k|Powerlevel10k]]"
  - "[[documentation/01-shell-terminal/02-tmux|tmux]]"
  - "[[documentation/04-dev-languages/10-neovim-config|Neovim config]]"
  - "[[documentation/02-file-management/02-yazi|yazi]]"
  - "[[scripts/md-preview|md-preview]]"
---

## Summary
Five separate status bars are edited in this repo, each with its own config language and its own reload rule. This doc is the router: it names them, points at the one file that owns each, and records how to make an edit show up. The per-tool docs linked above stay the source for everything else.

| # | Bar | Configured in | Reload with |
|---|---|---|---|
| 1 | **Claude Code** | `claude/settings.json` → `bin/kol-statusline` | restart the session |
| 2 | **tmux** | `tmux/.tmux.conf` §6 | `prefix r` |
| 3 | **Neovim** | `nvim/lua/grim/plugins/lualine.lua` | restart nvim |
| 4 | **yazi** | `yazi/init.lua` | `prefix y` |
| 5 | **zsh prompt** | `shell/.p10k.zsh` | `exec zsh` or `p10k configure` |

**The reload column is the load-bearing one.** Nothing here hot-reloads except tmux, and yazi has no reload of its own at all — `prefix y` exists only because a restart is the only way.

## 1. Claude Code

Three hops, and the indirection is deliberate.

```
claude/settings.json  "statusLine": bash "$HOME/.dotfiles/bin/kol-statusline"
  └─ bin/kol-statusline          a LOCATOR, not a renderer
       ├─ ~/dev/projects/kol-dumpty/humpty/bin/humpty-statusline   (dev checkout)
       └─ ~/.claude/plugins/cache/humpty/…/bin/humpty-statusline   (plugin cache)
```

`statusLine` is **not a hook**, so `$CLAUDE_PLUGIN_ROOT` is unset when it runs — pointing the key straight at the plugin yields a silently blank line. And `settings.json` is symlinked from dotfiles, so one hardcoded absolute path cannot be correct on two machines. `bin/kol-statusline` is the stable target that resolves the difference; it passes stdin through untouched.

**To change what it shows**, edit `humpty-statusline` in the humpty repo — not here. This repo only owns the locator.

## 2. tmux

`tmux/.tmux.conf` § *6. Status bar*, lines 167–183.

| Setting | Effect |
|---|---|
| `status-position top` | bar at the top, not the bottom |
| `status 2` | **two rows**; `status-format[1]` is the blank second one |
| `status-left ""` | no session block — windows sit flush left |
| `status-right` | the faint clock. Delete that one line to drop it |
| `window-status-format` | ` #I:#W#F ` — index, name, flags |
| `window-status-current-style` | solid block, dark bold text — humpty-badge yellow, 256-colour 214. The literal is at `.tmux.conf:183`; read it there rather than trusting a copy here |

**Reload:** `prefix r`. This is the only bar that picks up an edit without restarting its program.

## 3. Neovim — lualine

`nvim/lua/grim/plugins/lualine.lua`.

- `options.theme = "auto"` — follows the editor colorscheme. A hand-written `my_lualine_theme` sits above it, unused, as the documented revert.
- `sections.lualine_x` carries, in order: the **socket badge** (this nvim's `--listen` socket, so you can see which instance `nvim-port` will reach), the lazy.nvim pending-updates count, encoding, fileformat, filetype.

**Reload:** restart nvim. `:source` on the plugin file does not re-run lualine's setup cleanly.

## 4. yazi

`yazi/init.lua` — a `Status:children_add(fn, order, side)` child on the right.

It shows **`md:full` / `md:mdcat` / `md:glow`**, and only while a markdown file is hovered — on any other file type it would be permanent clutter. The value is read from `~/.cache/md-preview.mode`, the same file [[scripts/md-preview|md-preview]] reads per render, so there is no second source of truth and the badge cannot disagree with what is on screen.

Two things worth copying when adding another child:

| | |
|---|---|
| **Take the idiom from yazi** | `self._current.hovered`, a bare `return ""` for nothing, `self:style()` → `style.alt`. All of it is in yazi's own embedded Lua — read it rather than inventing |
| **Separators are not decoration** | without `th.status.sep_right.open` / `.close` your segment is the one flat rectangle in a bar of slanted ones. `fg` is always the segment's *own* background; that is what makes the glyph read as its edge. Glyphs are defined at `yazi/flavors/gruvbox-dark.yazi/flavor.toml:78` |

**Reload:** `prefix y`. yazi has **no** config hot-reload — the process must restart.

## 5. zsh prompt — Powerlevel10k

Not an oh-my-zsh theme. `ZSH_THEME=""` at `shell/.zshrc:13`; the theme is sourced from Homebrew at `shell/.zshrc:435`.

| | |
|---|---|
| Config | `shell/.p10k.zsh`, symlinked to `~/.p10k.zsh` |
| Instant prompt | top of `shell/.zshrc` (lines 7–8) — reads a cache so the prompt paints before the shell finishes loading |
| Parked alternate | **starship**, config at `starship.toml`, init line commented at `shell/.zshrc:438-440`. Flip those to switch |

**Reload:** `exec zsh`. To rebuild the config interactively, `p10k configure` — it rewrites `~/.p10k.zsh`, which is the tracked file.

## Gotchas

| gotcha | fact |
|---|---|
| four of five need a restart | only tmux hot-reloads. Editing and seeing nothing is usually this, not a broken config |
| yazi's is the newest | added 2026-08-05, and shipped first without separators — see §4 |
| Claude's is not ours to style | `bin/kol-statusline` only *finds* the renderer; the content lives in humpty |
| two prompts are configured | p10k is live, starship is parked and still tracked. Do not "clean up" the unused one |
| p10k is machine-shared | `.p10k.zsh` is symlinked from the repo, so a `p10k configure` on either machine rewrites the tracked file for both |
| colour literals are not copied here | this doc locates config, it does not mirror values — the vault's own rule is that a summary is never the source |

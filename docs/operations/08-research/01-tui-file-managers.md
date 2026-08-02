---
title: TUI file managers — layout modes
type: narrative
status: active
updated: 2026-08-01
description: Survey of terminal file managers that offer more than one layout mode (list, columns, vertical/horizontal split, grid, tree), with brew install commands. Prompted by yazi's ratio being the only layout knob it has. Nothing here is installed.
tags:
  - project/dotfiles
  - domain/files
  - pattern/tui
related:
  - "[[08-research/INDEX|research]]"
  - "[[documentation/02-file-management/02-yazi|yazi]]"
  - "[[documentation/02-file-management/03-broot|broot]]"
---

# TUI file managers — layout modes

**Status: survey only, nothing installed.** Prompted 2026-08-01 by the question *"can yazi have a different layout than the 3 columns?"* — the answer being that yazi's `[mgr] ratio` is its **only** layout knob (a `0` drops a column; there is no alternate view mode). That question generalises to: which terminal file managers actually ship multiple layout modes?

## Install commands

All verified present in brew core on 2026-08-01 (`brew info --formula <name>`, versions as listed). **Not run — reference only.**

```sh
brew install vifm                # 0.14.4
brew install midnight-commander  # 4.8.33  (binary: mc)
brew install xplr                # 1.1.0
brew install ranger              # 1.9.4
brew install superfile           # 1.6.0   (binary: spf)
brew install lf                  # 42
brew install nnn                 # 5.2
```

`felix` (binary `fx`) is **not in brew core** — it needs a tap or `cargo install felix`. Single-column only, so it fails the premise anyway.

## The field

| tool | layout modes | how it switches |
|---|---|---|
| **vifm** | one pane · two panes **vertical** · two panes **horizontal** · **ls-style grid** · **tree view** · miller columns | `:vsplit` / `:split` · `:only` · `:set lsview` · `:tree` · `:set milleroptions` |
| **mc** | two-pane commander; each panel independently **full · brief · long · custom**, and the split flips **vertical ↔ horizontal** | `Alt+,` flips the split · `Alt+T` cycles listing mode |
| **xplr** | **layouts are Lua-defined** — `Horizontal`/`Vertical` splits nested arbitrarily; ships `default` · `no_help` · `no_selection` · `no_help_no_selection`, custom layouts are first-class | Lua config, switchable at runtime |
| **ranger** | two real view modes: **miller** (3-column) and **multipane** (tabs side by side) | `:set viewmode miller` / `multipane` |
| **superfile** | **N side-by-side panels**, opened and closed live, plus sidebar + preview — panel *count*, not layout shape | `n` new panel · `w` close |
| **broot** | up to **3 panels** side by side + a preview panel; still always a tree | `Ctrl+→` splits |
| **lf** · **nnn** · **yazi** | **ratios only** — the same single knob yazi already exposes | config value |

## Deduped — three unique classes, not seven

Most of the list collapses. Only three are genuinely distinct once yazi is already installed:

| keep | absorbs | why the others are redundant |
|---|---|---|
| **vifm** | **mc** · **ranger** | vifm is a strict superset: dual-pane commander with copy-between-panes (mc's whole point) **plus** split-orientation control, grid and tree, on vi keys. ranger's `miller` is yazi's layout and its `multipane` is vifm's splits. |
| **xplr** | — | the only one where layout is **programmable** (Lua `Horizontal`/`Vertical` nested arbitrarily) rather than a fixed set of modes. Nothing else offers this. |
| **superfile** | — | the only **live-variable panel count** (`n` opens another, `w` closes it) rather than a layout chosen up front. |
| ~~lf~~ · ~~nnn~~ | **yazi** | ratios-only, exactly the knob yazi already has — installing either adds nothing. |
| ~~broot~~ | *already installed* | its 3-panel split is real, but it is a tree navigator, not a browser — a different job, kept for that. |

## Verdict

**vifm** is the one worth trying if the itch returns — it is the only entry covering the whole list (list · columns · vertical *and* horizontal splits · grid · tree) with vi keybinds, which matches nvim, tmux copy-mode and zsh-vi-mode already in use here.

**mc** is the second pick and a genuinely different shape: a two-pane *commander* (copy/move between panels) rather than a browser, and the only one where flipping the split orientation is a single keystroke.

Neither displaces [[documentation/02-file-management/02-yazi|yazi]] for daily browsing — yazi's async previews and `y` cd-on-quit are the reason it won in the first place, and layout was never the complaint.

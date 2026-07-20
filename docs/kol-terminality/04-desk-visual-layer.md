---
title: The desk — the visual layer
type: plan
status: draft
updated: 2026-07-11
description: The look-and-feel of the workstation — the top bar (simple-bar/Übersicht vs SketchyBar), hiding the macOS menubar, system monitors (btop, fastfetch), terminals (Ghostty, Kitty), the one-switch colorscheme selector, starship, and custom shaders.
tags:
  - project/dotfiles
  - domain/tooling
  - pattern/tui
related:
  - "[[INDEX|kol-terminality]]"
  - "[[11-ricing-backlog|ricing 2025 backlog]]"
  - "[[documentation/09-productivity-desktop/06-sketchybar|SketchyBar]]"
  - "[[07-macos-control|macOS control]]"
---

# The desk (visual layer)

Recreate the [linkarzu reference desk](https://github.com/linkarzu/dotfiles-latest) — **not 1:1**, something that fits our purpose. Reference screenshots captured 2026-07-11 (linkarzu setup: Link wallpaper, fastfetch panel, btop, skitty-notes, top bar).

## The top bar — the live decision
- **simple-bar** (preferred look/feel) — an [Übersicht](https://github.com/felixhageloh/uebersicht) widget; [simple-bar repo](https://github.com/Jean-Tinland/simple-bar). Made of **predefined blocks**, AeroSpace-aware. Build walkthrough: [YT](https://www.youtube.com/watch?v=hybbQI6CRek) · [blog](https://linkarzu.com/posts/macos/ubersitch-simple-bar/).
- **SketchyBar** (what we have) — our overhaul was **glitching / constantly reloading** yesterday. Ruby/toml-ish feel vs simple-bar's block model.
- **The call:** not "which is better" — it's *look and feel*, and simple-bar just does it better with cleaner blocks. Evaluate replacing SketchyBar with simple-bar/Übersicht. (Fix or retire the reload-loop either way.)

## Hide the macOS menubar (best solution found)
- The [SketchyBar-post method](https://linkarzu.com/posts/2024-macos-workflow/sketchybar-macos/#hide-macos-menubar) — the best real "hide menubar" solution so far, **even if we don't use SketchyBar**. It's an osascript one-liner → also lives in [[07-macos-control|macOS control]] (menubar + dock keybinds).

## Monitors
- **btop** — [repo](https://github.com/aristocratos/btop) — resource monitor, themeable. ✅ **Adopted 2026-07-14** alongside htop: `brewfile-cli` line, [[../documentation/01-shell-terminal/29-btop|catalog doc]], kol-theme consumer.
- **fastfetch** — the hardware/software banner (the panel in the reference shot). Themeable.

## Terminals
- **Ghostty** (current) — transparency + [custom shaders](https://ghostty.org) (Sin-cy ships GLSL shaders — 3.4% of his repo).
- **Kitty** — **installed** ([cask](https://formulae.brew.sh/cask/kitty), tracked in `brewfile-gui`) — check out Kitty **plugins**. (Note: skitty-notes is Kitty-based — see [[06-notes-and-tasks|Notes & tasks]].)

## Cross-cutting
- **Colorscheme selector (the big one)** — one switch → theme all tools. **v1 shipped 2026-07-14 as `bin/kol-theme`** (ghostty · kitty sticky · tmux · nvim-now · widgets; themes: gruvbox / kol-dark / solarized-osaka) — see [[../documentation/09-productivity-desktop/08-kol-theme|kol-theme]]. Remaining surfaces (simple-bar, yazi, btop, starship) tracked in [[11-ricing-backlog#4. Colorscheme selector (the big one)|the backlog]].
- **starship** — the prompt (currently parked alternate to p10k); part of the theme-selector scope.
- **Custom shaders** — Ghostty `custom-shader` (GLSL); source Sin-cy's.

## Design sync — 2026-07-11 (live artifacts)

| Artifact | What | URL |
|---|---|---|
| **kol-dark** terminal theme | derived 100% from the KOL DS: bg `#121215` (surface-primary dark) · fg cream-300 · ANSI-7 cream-500 · bright-white cream-100 · muted `#A39A78` · cursor/accent yellow-300 · ANSI = the hue ramps · JetBrains Mono | `claude.ai/code/artifact/2fb42b10` |
| **the desk** mock | wallpaper through 8%-drop/16px-blur panes · AeroSpace gaps + rounded corners · naked menubar ( + Ghostty pill → one right capsule) · floating tmux chips · notes 52%h×16%w, empty below · shell-honest containers · **6 views** (01 display-in-context · 02 working · 03 nvim session w/ clickable buffer tabs incl. lazygit · 04 popup atlas = every real tmux bind, the `prefix ?` which-key proposal · 05 vault pipeline · 06 cockpit: agents/devices/what-populates-what) + drawer + drag seams | `claude.ai/code/artifact/67803a9b` |

- **Visual refs:** 17 images + manifest at `~/.dotfiles/_tmp/kol-terminality-refs/` (gitignored).
- **Learned:** terminal tools get no app headers — identity comes from the tool's own text; the bar is naked on the wallpaper, not islands; tmux status = floating pills.
- **Parked:** kol-dark emitters — base16 spec → ghostty / kitty / iterm2 / wezterm files, once the palette is locked.

## Open questions
- simple-bar/Übersicht **replaces** SketchyBar, or do we fix SketchyBar's reload loop and keep it?
- Ghostty stays primary, or Kitty for the skitty-notes surface (dual-terminal)?
- Colorscheme selector: adopt linkarzu's script pattern, or build our own?

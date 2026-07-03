# Session: CLI cheatsheet overhaul — cross-tool integrations, yazi.nvim, in-tool help, AeroSpace floating

**Date:** 2026-07-02
**Agent:** Grim (Claude Sonnet 5, `~/.dotfiles`)
**Summary:** Extended `01-cli-cheatsheet.md` into a much richer reference (in-doc section links, per-tool plugin inventories, real cross-tool integrations, a dedicated Telescope subsection, and a "how do I get help" line as the first thing in every section) while fixing several small config/doc gaps found along the way.

## Changes Made

### Files Modified
- `docs/00-kol-cli/01-cli-cheatsheet.md` — major rework: top table's Tool column now links to its `##` section via Obsidian block refs (`^sec-neovim` etc., needed since headings already contain nested wikilinks); new top-of-doc "Help" summary table (first thing after the H1) plus a `**Help:**` line as the literal first content in each of the 5 tool sections (`:help`/`<leader>fk` for nvim, `pfx ?` for tmux, `~` for yazi, `fzf --help`/`man fzf`, `aerospace --help`/`man aerospace`); new "Cross-tool shortcuts" section (yazi→fzf/zoxide, Neovim→yazi, tmux↔Neovim via vim-tmux-navigator, Neovim↔fzf via telescope-fzf-native — explicitly *not* the real fzf binary); `**Plugins:**` line added under all 5 sections; Neovim section restructured (vanilla Vim vs. this-config's-plugins, with a dedicated Telescope subsection exposing in-picker keys); redundant Telescope mention added to the fzf section on purpose (user preference: redundant > hard to find).
- `yazi/yazi.toml` — new `[opener].markdown` group (glow/mdcat/nano) + a `.md`/`.markdown`-scoped `[open].rules` entry ahead of the generic Text rule, so `O` offers those three for markdown only; new SVG-specific rule (`image/svg+xml` → edit+open+reveal) fixing a real gap where SVGs had no editor option despite being XML/text.
- `nvim/lua/grim/plugins/yazi.lua` — **new file**, installs `mikavilpas/yazi.nvim`, bound to `<leader>fy` (README's suggested `<leader>-` was already taken by decrement-number in this config).
- `docs/04-dev-languages/10-neovim-config.md` — fixed stale Plugin roster (was: tokyonight active/flash disabled; actually: gruvbox-material active, flash is live, which-key is the disabled one), fixed a false "which-key pops a menu" claim, added the new `<leader>fy` row + `related:` link to yazi.
- `docs/02-file-management/02-yazi.md` — added the Neovim-integration note + reciprocal `related:` link.
- `aerospace/aerospace.toml` — TextEdit and Bitwarden now `run = "layout floating"` (floating-only, no workspace — TextEdit's `move-node-to-workspace O` was explicitly removed per user correction), moved into a new "Floating-only" block.
- `docs/09-productivity-desktop/05-aerospace.md` — fixed a long-stale "Auto-assigned apps" table (only had iTerm2/Chrome/Firefox; added the 10 other apps actually in the TOML), added a floating-apps table.
- `shell/.zshrc` — added `alias cl='clear'` (verified no existing binary/alias/builtin collision first).

### Features Added/Removed
- yazi.nvim integration (Neovim ↔ yazi, `<leader>fy`) — installed and confirmed live by the user this session.
- AeroSpace always-floating apps: TextEdit, Bitwarden.
- yazi `O` (open-with) now offers glow/mdcat/nano for markdown and an editor option for SVG.

## Current State

### Working
- All TOML edits validated with `python3 -c "import tomllib"` after each change.
- yazi.nvim confirmed installed by the user (lazy-lock.json updated on their end).
- Cheatsheet is internally consistent — verified no dangling references after removing now-redundant duplicate "help" mentions (old bottom-of-section notes in Neovim/tmux/yazi) once the new top-of-section Help lines replaced them.

### Known Issues
- None outstanding from this session. User confirmed nothing else pending as of the last exchange.

## Next Steps
1. None explicitly queued. If the user likes the "Plugins:" / "Help:" pattern, it could extend to other per-tool catalog docs (currently only applied to the cheatsheet).
2. `05-aerospace.md`'s deeper doc is now in sync with the TOML — worth a periodic drift re-check like the one that caught this, same for `10-neovim-config.md`.

# Session: `00-kol-cli/` reference cards (cheatsheet + workflows + scripts)

**Date:** 2026-06-26
**Agent:** Grim (Claude Opus, `~/.dotfiles`, iMac)
**Summary:** New `docs/00-kol-cli/` folder — three printable personal reference cards for the daily-driver CLI tools, all keybindings pulled from live config (not memory). Symlinked into the kol-vault for print.

## Changes Made

### Files Added
- `docs/00-kol-cli/01-cli-cheatsheet.md` (`reference`) — one-page keymaps for **nvim / tmux / yazi / fzf / AeroSpace**, TOC table first, print-dense paired-column tables, and an nvim **verb × text-object edit grid** + worked-combos table (the define/replace/copy/delete/select matrix).
- `docs/00-kol-cli/02-workflows.md` (`guide`) — keystroke **recipes**: nvim block/column/Visual-block edits, find/replace/**filter** (`cgn`+`.`, `:g/d`, `!ip sort`), surround; yazi navigate (`Z`/`z`/`/`/`s`), move/copy (mark→`y`/`x`→`p`, tabs, bulk rename), **open-with** (`O`, `;` `open -a`).
- `docs/00-kol-cli/03-scripts.md` (`reference`) — the `bin/` scripts **grouped by job** (image/video/audio/PDF/artwork/download/files/capture/sync/helpers), one-liner + key flags each, every row linking its `12-scripts` family doc.

### Files Modified
- `docs/02-file-management/02-yazi.md` — **drift fixed**: had `f`/`/` swapped (live: `f`=filter, `/`=find, `s`/`S`=search fd/rg, `z`/`Z`=fzf/zoxide jump) and `g p` pointed at the stale `~/thatComp--iMac` → corrected to `~/dev/projects`; `updated` bumped.
- `docs/00-kol-cli/01-cli-cheatsheet.md` — same yazi `f`/`/` correction + added `o`/`O` open-with row.
- `docs/INDEX.md` — new `## Quick reference` section (3 cards; **does not touch the 78-tool count**).
- Reciprocal `related:` added to the 6 source docs (`10-neovim-config`, `11-neovim-cheatsheet`, `10-tmux-help`, `02-yazi`, `12-fzf`, `05-aerospace`) + `12-scripts/INDEX.md`.
- `docs/01-shell-terminal/{02-tmux,09-tmux-tips,10-tmux-help}.md` — prefix `Ctrl-b` → `Ctrl-a` (closes the long-pending drift from 2026-06-14; live config has been `Ctrl-a`).

## Current State

### Working
- Three cards render clean (table pipes verified). Sourced from live config: `aerospace.toml` (richer than its doc — resize mode, full auto-assign set), `tmux.conf` (**live prefix `Ctrl-a`**), `yazi/keymap.toml`.
- New `00-*` folder auto-mirrors to the kol-vault (relink denylist picks up new `NN-*`); `[[…]]` cross-links resolve there since the whole `docs/` tree is mirrored.

### Known Issues
- None outstanding. The tmux-doc prefix drift (`Ctrl-b` → `Ctrl-a`) is now fixed across all three docs + the cheatsheet.

## Next Steps
1. Iterate the cards as keymaps change; `03-scripts` grows a row as new `bin/` families land.

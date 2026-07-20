# Session: SketchyBar overhaul + AeroSpace ctrl-alt migration + log-work-playbook skill

**Date:** 2026-07-10
**Agent:** Claude (Grim)
**Summary:** Resolved the AeroSpace Alt-conflict by remapping its modifier to ctrl-alt (+ full-repo doc sweep), created the `log-work-playbook` skill and the first playbook, then overhauled SketchyBar from 4 items to a full widget fleet (7 pure-shell widgets + an apple-menu power popup) with a research-backed 6-file guide folder.

## Changes Made

### Files Modified
- `aerospace/aerospace.toml` — every main-mode `alt-*`→`ctrl-alt-*`, `alt-shift-*`→`ctrl-alt-shift-*` (77 binds; `cmd-alt-*` macros + service/resize modes untouched; TOML validated).
- Docs for the ctrl-alt sweep — `keys/keybinds.md` (`#aerospace` + tmux `#layout`, plus new tmux window-move rows N/P/F/G, M-1..M-5 de-crypted), `docs/…/05-aerospace.md`, `docs/kol-cli/01-cli-cheatsheet.md`; AGENT-CONTEXT (12) + its session log flipped to "resolved"; also fixed a **stale reinforce-skill mention** in AGENT-CONTEXT:96 (the 3 `agent-*` skills → hook, 2026-07-08).
- `shell/.zshrc` — `fzv` image regex gained `tiff?|heic|avif` (both chafa-verified on-machine).
- **SketchyBar** (`sketchybar/`) — new plugins `cpu·memory·volume·wifi·battery·weather·brew·power`; new items `apple·cpu·memory·volume·wifi·battery·weather·brew`; edited `colors.sh` (accent palette), `clock.sh` (click→Calendar), `sketchybarrc` (source all + apple on left).
- `claude/skills/log-work-playbook/SKILL.md` (new) + `02-skills.md` synced (Agent-context 8→9, count 38→39).
- Docs — new guide folder `docs/…/09-productivity-desktop/sketchybar/` (INDEX + 01-model, 02-widgets, 03-build-your-own, 04-styling, 05-roadmap); `06-sketchybar.md` synced (item table, structure, roadmap, guide cross-link); category INDEX Guides route.
- `.kol/llm-context/playbook/2026-07-09-aerospace-ctrl-alt-migration.md` (new, first playbook in this repo).

### Features Added/Removed
- **AeroSpace on ctrl-alt** — frees bare Alt for the terminal (fzf `Alt-C`, word-nav, tmux `prefix Alt-1..5`). User chose "add ctrl" to fix the OS-level shadowing.
- **`/log-work-playbook`** — append-only live work-journal skill (real timestamps, one idea/line); the mid-work sibling of `/log-work`; does NOT touch AGENT-CONTEXT.
- **SketchyBar fleet** — apple-menu power popup (lock/sleep/restart/shutdown/logout via `power.sh`), cpu/memory (colour-graded), volume (event), wifi (device auto-detect — `en1` here), battery (self-hides on the desktop iMac), weather (wttr.in), brew (hidden when 0). All pure-shell, colour-graded to Catppuccin Mocha; **live via hotload** (all items verified registered).

## Current State

### Working (validated)
- `aerospace.toml` TOML-valid, 0 stray bare-alt main-mode; full-repo sweep = 0 stale refs; scripts (raycast/sketchybar) unaffected.
- All SketchyBar plugins `bash -n` clean + `chmod +x`; data sources tested on-machine; `sketchybar --query` shows every new item live.
- `zsh -n` clean; guide folders' internal links resolve.

### Known Issues
- **AeroSpace needs `aerospace reload-config`** to load the ctrl-alt binds.
- **No SketchyBar now-playing** — macOS 15.4 killed MediaRemote; `media_change` + `nowplaying-cli` dead on this 15.7 machine (documented).
- SketchyBar still Catppuccin Mocha while the stack is Gruvbox; glyphs are Nerd Font FA (swap any tofu).
- vi-mode verify-on-boot (cursor-in-tmux, autosuggestions) still pending from last session.

## Next Steps
1. `aerospace reload-config`; confirm ctrl-alt + the freed terminal Alt-keys.
2. SketchyBar trendy roadmap (guide ch.5): hover-reveal + click-popups are pure-shell next; app-menu mirror / Dynamic Island need C helpers.
3. Recolour SketchyBar `colors.sh` to Gruvbox; install `font-sketchybar-app-font` for app icons.

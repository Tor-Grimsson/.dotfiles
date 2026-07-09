# Session: Ghostty padding + aerospace-T + Catppuccin Mocha across Ghostty & nvim

**Date:** 2026-07-09
**Agent:** Claude (Grim)
**Summary:** Small polish pass — window padding for Ghostty, routed Ghostty into aerospace workspace T, moved both Ghostty and nvim onto Catppuccin Mocha (nvim further darkened via color_overrides).

## Changes Made

### Files Modified
- `ghostty/config` — added a Window block: `window-padding-x = 10`, `window-padding-y = 8`, `window-padding-balance = true` (breathing room, opposite edges evened). Theme `Catppuccin Macchiato` → `Catppuccin Mocha`.
- `aerospace/aerospace.toml` — new `on-window-detected` rule routing Ghostty (`com.mitchellh.ghostty`) to workspace **T**, alongside iTerm2.
- `nvim/lua/grim/plugins/colorscheme.lua` — active colorscheme flipped **Gruvbox Material → Catppuccin Mocha** (Mocha was already a parked disabled spec; enabled it, added `enabled = false` to gruvbox, swapped the ACTIVE/DISABLED comments). Then darkened Mocha via `color_overrides.mocha` — neutral ramp shifted down one step: base `#1e1e2e`→`#181825`, mantle `#181825`→`#11111b`, crust `#11111b`→`#0e0e16`.
- `docs/documentation/01-shell-terminal/26-ghostty.md` — synced: added the padding row to the "what's set" table, theme references (glance table + row) → Mocha.
- `docs/documentation/09-productivity-desktop/05-aerospace.md` — synced: added Ghostty→`T` row to the app-routing table.
- `docs/documentation/04-dev-languages/10-neovim-config.md` — synced: colorscheme row now lists catppuccin/mocha (with the darkened-base note) as active, gruvbox moved to the parked list.

### Features Added/Removed
- Ghostty gains window margins.
- Ghostty auto-tiles into workspace T with the other terminals.
- Unified Catppuccin Mocha look across Ghostty + nvim (nvim a touch darker than stock).

### Diagnosis (no repo change)
- Explained why Ghostty's mouse cursor doesn't change over a "slider" the way iTerm2's does: that slider is iTerm2's native scrollbar; Ghostty deliberately draws no GUI scrollbar, so there's no region to flip the pointer. Ghostty does change the pointer over detected links (Cmd-hover) and on app OSC-22 requests.

## Current State

### Working
- Ghostty config validated shape (padding + Mocha are plain `key = value` lines).
- aerospace rule added; applies to newly-opened Ghostty windows after a config reload.
- nvim colorscheme spec flipped cleanly (only the enabled block loads).

### Known Issues
- **Ghostty** needs a reload (`Cmd+Shift+,`) or relaunch to pick up padding + Mocha.
- **aerospace** needs a config reload (service mode `Alt+Shift+;` → `Esc`, or next start) for the Ghostty→T routing.
- **nvim** — Catppuccin was a disabled spec so the plugin isn't installed yet; first launch / `:Lazy sync` clones it, then Mocha (darkened) applies. lualine is `theme = "auto"` so the statusline tracks it with no edit.

## Next Steps
1. Reload each of the three (Ghostty, aerospace, nvim) to see the changes live.
2. If Mocha still isn't dark enough in nvim, push `base` further (`#11111b` / `#0e0e16`).
3. Still open from prior sessions: relaunch rmpc for its Catppuccin theme (ideally Ghostty-outside-tmux for album art), build the cava visualiser, the Torrent guide parked in `plan.md`.

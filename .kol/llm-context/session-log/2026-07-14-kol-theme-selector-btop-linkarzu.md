# Session: kol-theme — the cross-tool colorscheme selector (+ btop, + the linkarzu look)

**Date:** 2026-07-14
**Agent:** Grim (Fable 5)
**Summary:** Third arc of the day (follows the bookmarks/kol-notes and nvim-now logs): ricing-backlog #4 went from parked to a working, user-driven selector — `bin/kol-theme` reskins ghostty, the kitty sticky, tmux, nvim-now, both Übersicht widgets, and btop from per-theme native files. Four themes shipped; the user live-switched through all of them.

## Changes Made

### The theme shelf in nvim (prelude)
- Sin-cy's 7 schemes + our gruvbox-material ported into nvim-now with the `<leader>ths` telescope switcher (live preview, persists to `lua/current-theme.lua`). Default = solarized-osaka.

### bin/kol-theme + themes/
- **Pattern:** a theme = `themes/<name>/` of native files (`ghostty.conf` · `kitty.conf` · `tmux.conf` · `nvim.lua` · `colors.json` · `btop.theme`); switching flips `~/.config/kol-theme/current` and reloads what can reload (tmux + widgets instant; ghostty/kitty/btop/nvim on next launch). linkarzu's selector pattern, files-are-the-API.
- **Themes:** `gruvbox` (pre-selector look, extracted verbatim — "change back" is real) · `kol-dark` (KOL DS palette) · `solarized-osaka` (craftzdog's official extras; Sin-cy's pick) · `linkarzu` (his `linkarzu-colors.sh` + frosted ghostty 0.88/blur-25 + transparent btop).
- **Consumers wired:** ghostty `config-file = ?current-theme.conf` (dual symlink — relative include resolution is ambiguous through the config symlink) · kitty `include` · `.tmux.conf` `source-file -q` last (gruvbox lines stay as fallback) · nvim.lua copied (not linked — `<leader>ths` writes the same file) · widgets prepend `colors.json` in `command` with a kol-dark hardcoded fallback · btop `kol-current.theme` symlink + `color_theme` re-asserted every switch (btop rewrites its conf on exit).
- bootstrap: seeds `gruvbox` on a fresh machine only.

### btop — adopted (ricing #1 closed)
- Already installed by the user; `brewfile-cli` line added, catalog doc `01-shell-terminal/29-btop.md`, wired as the 6th consumer with a `btop.theme` in all four themes.

### The linkarzu bar (structure-per-theme)
- User: "ours doesn't look like the reference." His bar = the **catppuccin/tmux plugin**; the same look (green session capsule + rounded per-window index chips) hand-rolled in pure tmux format strings inside `themes/linkarzu/tmux.conf` — no plugin, linkarzu-only. The other three themes re-assert the quiet flat bar; round-trip tested.

### Gotchas that cost time
- **PUA glyphs don't survive file writes** — the E0B6/E0B4 rounded caps silently vanished (0 bytes on disk → "not pills", bare rectangles). Font was exonerated first (CoreText probe: MesloLGS NF has them; screenshot crop showed no caps at all). Fix: inject by codepoint (`python chr(0xE0B6)`).
- **Ghostty reload ≠ repaint** — `Cmd+Shift+,` leaves existing surfaces on old colors ("themes competing?" — they weren't; `+show-config` resolved correctly). Quit + relaunch, or a new window.
- Homebrew `tree-sitter` vs `tree-sitter-cli` (earlier arc) has a sibling here: none — but the btop conf-rewrite-on-exit is why its conf is untracked.

## Current State

### Working
- `kol-theme` list/switch, all four themes user-tested live (osaka → kol-dark → gruvbox); parked on **gruvbox**.
- help-lint clean; all consumer fallbacks in place (every tool keeps a sane look if the selector never ran).

### Known Issues
- linkarzu/kol-dark nvim halves are stand-ins (tokyonight / gruvbox-material) — real ports = the parked kol-dark-emitters item.
- Not yet themed: simple-bar (localStorage seam) · yazi (needs authored flavors) · starship (parked).
- Ghostty always needs a relaunch to show a switch — inherent, documented in the doc + script output.

## Next Steps
1. nvim arc continues: live in `nnow`, friction to the playbook.
2. Selector later-shelf: simple-bar consumer · yazi flavors · a kol-dark (and/or linkarzu) nvim port.
3. The daily `nvim/` joins the selector at graduation.

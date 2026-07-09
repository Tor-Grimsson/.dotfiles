# Session: starship prompt trials + whole-stack Gruvbox theme sweep

**Date:** 2026-07-09
**Agent:** Claude (Grim)
**Summary:** Iterated the starship prompt through several community configs, then — after the user found Catppuccin Mocha "super cold" — swept the entire terminal stack (Ghostty, tmux, nvim, yazi, starship) from Mocha to warm **Gruvbox Dark**.

## Changes Made

### Prompt trials (starship)
- `starship/starship.toml` — re-pulled **ericmckevitt's** config byte-exact (my earlier hand-transcription had swapped the Nerd Font powerline glyph codepoints → ribbon rendered wrong; fixed by base64-decoding the repo file, only keeping the `creen`→`green` typo fix). Then swapped to **hendrikmi's** lean two-line layout (directory + git left, `$fill` spacer, langs/aws/docker/jobs/duration right). Its stock **Nord** palette read cold; ported to a `[palettes.catppuccin_mocha]` block, then finally to `[palettes.gruvbox]` (active).

### Ghostty → Gruvbox
- `ghostty/config` — `theme = Catppuccin Mocha` → **`Gruvbox Dark`**; `background #181825` → **`#282828`**; `split-divider-color #585b70` → **`#504945`**. (User also set `background-opacity` 0.88→0.96 themselves.)

### tmux → Gruvbox
- `tmux/.tmux.conf` — earlier this session added Mocha `mode-style`/`message-style`/`message-command-style` (were tmux-default yellow) and recolored the warm-tan status holdovers to Mocha; then swept all to Gruvbox: status/clock/inactive grey `#928374`, current-window `#ebdbb2`, pane-active border **orange `#fe8019`**, mode/message on gruvbox greys, `m`-pane-highlight `#3c3836`. Also earlier: `set -g extended-keys on` → **`set -s`** (Shift+Enter fix, server option).

### nvim → Gruvbox
- `nvim/lua/grim/plugins/colorscheme.lua` — Catppuccin `enabled = false`; **gruvbox-material** enabled (was parked) with `foreground = "original"` (classic Gruvbox palette).

### yazi → Gruvbox
- `yazi/theme.toml` — flavor `catppuccin-mocha` → **`gruvbox-dark`** (both vendored).

### Docs synced
- `26-ghostty.md`, `10-neovim-config.md` (incl. the stale `## Theme` prose that still named tokyonight/coolnight), `02-yazi.md`, `27-starship.md`, `01-shell-terminal/INDEX.md` (starship row), `03-powerlevel10k.md` (archived earlier). Flagged `06-sketchybar.md` — still Catppuccin Mocha, now out of step with the Gruvbox terminal.

## Current State

### Working (validated)
- `ghostty +show-config` no errors (theme Gruvbox Dark, bg #282828). starship renders warm (orange dir, green git, cream text). yazi gruvbox-dark active.

### Known Issues / needs reload
- Reload to go live: `Cmd+Shift+,` (Ghostty), `tmux source-file ~/.tmux.conf`, **restart nvim** (gruvbox-material was disabled → lazy installs it on launch; `:Lazy sync` if not), restart yazi, `exec zsh`/Enter (starship).
- **SketchyBar is still Catppuccin Mocha** — the one piece not swept to Gruvbox. Recolor pending.
- Catppuccin/Nord/Mocha all kept as parked alternates (nvim specs, yazi flavor, starship palettes) to flip back.

## Next Steps
1. Recolor **SketchyBar** to Gruvbox to match the rest of the stack.
2. Confirm Shift+Enter works after reloads (Ghostty native + tmux `set -s extended-keys`).
3. Decide whether to delete `shell/.p10k.zsh` (dead) and `brew uninstall powerlevel10k` now that starship is the keeper.
4. Still open from prior: cava visualiser, Torrent guide (`plan.md`).

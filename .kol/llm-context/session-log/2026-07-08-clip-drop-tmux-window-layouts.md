# Session: clip-drop tool + tmux window-vs-session layouts

**Date:** 2026-07-08
**Agent:** Claude (Grim)
**Summary:** Built `clip-drop` (clipboard image → inbox → yazi, `prefix C-p`); fixed the fzf picker bat-errors; then reworked the tmuxinator layout binds so `C-d` grafts a layout as a **window in the current session** and `C-o` spawns it as its **own session**.

## Changes Made

### Files Added
- `bin/clip-drop.sh` — dump the clipboard image to `~/_inbox/clip_<ts>.png` (`pngpaste`), then `exec yazi` on it. Capture-first-then-file: preview + `r`/`x`/`p` in yazi instead of picking a path up front. Optional `[dir]` overrides the inbox.
- `tmux/pane-layout.sh` — `yq`-reads window 0's panes + `layout:` from a tmuxinator yml, opens them as a **new window in the CURRENT session** (`new-window` + `split-window` + `send-keys` into shells + `select-layout`). No `switch-client`, so no MRU-client hijack. fzf-picks when given no name. bash-3.2-safe (no `mapfile`, index loop not `${a[@]:1}`).
- `tmux/layout-picker.sh` — the session-spawn path: `tmuxinator start --no-attach <pick>` then `switch-client -c '#{client_name}' -t <pick>`, so the switch lands on the client that pressed the key, not tmux's most-recently-used one.

### Files Modified
- `tmux/.tmux.conf` — new `bind C-p` (clip-drop popup); `bind C-d` repointed to `pane-layout.sh` (window graft); new `bind C-o` → `layout-picker.sh` (session spawn, overrides the rarely-used rotate-window default). Also fixed the `C-d` bat-error mid-session by adding `--no-preview` before the picker moved into a script.
- `tmux/bookmark-open.sh` — added `--no-preview` (same inherited-bat-preview class: it errored on URL bookmarks).
- `keys/keybinds.md` — `#tmux #popover` gains `C-p`/`C-d`/`C-o`; new `#tmux #clipdrop` recipe (C-p → r/x/p file flow); `#tmux #layout` rewritten for the window-vs-session split.
- `docs/scripts/08-system.md` + `INDEX.md` — `clip-drop` row + workflow section; family `fs-`/`ss-`/`clip-` count 4→5.
- `docs/documentation/18-tui-shell-layout/02-tmux-dashboards.md` — §4 rewritten (C-d window vs C-o session table + why), §5 verification updated.
- `docs/documentation/01-shell-terminal/02-tmux.md` — popup ASCII box + prose updated for C-p / C-d / C-o.

### Root cause fixed
- **fzf pickers inheriting the shell's global bat file-preview** (`FZF_DEFAULT_OPTS`) → `[bat error]: 'home': No such file` on non-path items. Same class as the 2026-07-08 sesh-popup fix. Fixed the layout picker and the bookmark picker with `--no-preview`.
- **tmuxinator "hijacked the wrong session's view":** `tmuxinator start` attaches via a **target-less `switch-client`** that resolves to the MRU client — from a popup that can be a different terminal. The window-graft path (`C-d`) sidesteps it entirely (no switch); the session path (`C-o`) passes `-c '#{client_name}'`.

## Current State

### Working
- `pngpaste` → `~/_inbox` capture verified live (real 1.2M PNG). yq extraction + bash-3.2 syntax clean. tmux build mechanism (new-window + splits + `select-layout main-vertical`) verified in a throwaway session — session 0 untouched. `keys tmux popover`/`layout`/`clipdrop` all render; keybinds.md cross-checked against `.tmux.conf` (C-p/C-d/C-o bound and in sync).
- One yml, three entry points: `mux <name>` (whole session), `C-d` (window in current session), `C-o` (own session).

### Known Issues
- **Not yet live-tested end-to-end by the user** — the popup keypress round-trips (`C-p` yazi-preview, `C-d` window graft, `C-o` session switch) need a reload (`Ctrl-a r`) + a real keypress. User said he'll check later.
- `pane-layout.sh` assumes window 0's panes are command strings + an optional `layout:` (the `home.yml` shape); multi-window ymls only use window 0.

## Next Steps
1. User reloads tmux (`Ctrl-a r`) and eyeballs `C-p`/`C-d`/`C-o` live.
2. Add more single-window ymls in `tmuxinator/` for more window layouts (they feed all three entry points).

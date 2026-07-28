# Session: clip-drop --note/--review evidence modes + --menu capture popup

**Date:** 2026-07-28
**Agent:** Grim (Fable 5)
**Summary:** clip-drop grew two evidence modes — `--note` (issue: image + linked .md in its own folder) and `--review` (ongoing: appends captures to the current review's .md via a `.current-review` pointer) — plus `--menu`, an fzf picker over all modes that now fronts the tmux **Prefix + Ctrl+P** popup (50%×50%).

## Changes Made

### Files Modified
- `bin/clip-drop.sh` — `--note [name]` (folder `~/_inbox/<name>/` + `<name>.md`, timestamp heading + embed per capture; unnamed → timestamp slug); `--review [name]` (named = start/switch current review — pointer `~/_inbox/.current-review`, works with empty clipboard; bare = append, clean error if none); `--menu` (fzf: file (yazi) · drop · note… · review: <current> (append, hidden when unset) · review: start new…; inline name prompts; post-capture keypress pause; Esc = nothing saved); same-second collision suffix `_2`/`_3`
- `tmux/.tmux.conf` — `Prefix + Ctrl+P` popup → `clip-drop.sh --menu`, **50%×50%** (was 75 — user corrected again; memory saved: popups default 50%)
- `keys/keybinds.md` — popover + clipdrop + shell lines updated for the menu/modes
- `ref/system.md` — `#clipboard` section: menu/note/review lines added
- `docs/scripts/08-system.md` — table row + section rewritten for modes + menu
- `docs/documentation/01-shell-terminal/02-tmux.md` — popup list + the line-63 cheat-sheet block (stale "clipboard image → yazi" caught in audit)
- `docs/kol-terminality/10-references-and-backlog.md` — stale "pngpaste → yazi / needs a catalog doc" fixed (doc exists: `08-system.md`)

### Bugs caught during build (all fixed + re-tested)
- Greedy flag parser ate a DIR positional as a NAME → path-shaped args are never names. (Test pollution in `~/_inbox` cleaned; user's clips untouched.)
- Same-second captures clobbered → suffix loop, proven ×3 in one second.
- User live-test: global `FZF_DEFAULT_OPTS` file-preview (bat) errored on menu labels (`'file (yazi)': No such file`) → menu fzf passes `--preview ''` to kill the inherited preview (same trap as the sesh bind).

## Current State

### Working
- All modes exit-checked headlessly (menu driven via a fake-fzf shim — all 5 choices route correctly); `zsh -n` + help-lint clean (80 scripts); full doc audit of every clip-drop mention done.
- Memories added this arc: keybind notation (spell out Prefix + Ctrl+…), popup size 50% default.

### Known Issues
- `Prefix + r` reload pending user (menu bind + 50% size).
- Yazi filing now happens inside a 50% popup — flagged to user; resize is his call if cramped.

## Next Steps
1. Arcs unchanged: tailscale confirmation → `06-tailscale-jellyfin.md` sync; next-reboot tmux protocol verify.

# Session: desk scoping, the ref help rebuild, and crash safety after a real loss

**Date:** 2026-07-31
**Agent:** Claude Code (Grim)
**Summary:** Chased four desk bugs to their actual causes (macOS owned ⌥⌘D, AeroSpace was rejecting Magnet's window moves, Hidden Bar was hiding the Übersicht icon, `localhost` vs `127.0.0.1`), rebuilt `ref --help` as glow markdown, added two cards and an llm popup — then a tmux crash destroyed unsaved nvim text and `swapfile` was off, so that got fixed too.

## Changes Made

### Files Modified
- `aerospace/aerospace.toml` — `cmd-alt-d` **deleted** (macOS symbolic hotkey 52 already owns ⌥⌘D; both fired, autohide flipped twice, the dock looked frozen) + a do-not-re-add comment · `ctrl-alt-cmd-left/right` → `move-node-to-monitor --focus-follows-window --wrap-around` · `gaps.outer.top`/`.right` converted to per-monitor arrays (`[{ monitor.main = N }, 10]`).
- `bin/dock-toggle` — **deleted**, it duplicated a native macOS shortcut.
- `bin/menubar-toggle`, `bin/ubersicht-toggle` — sibling comments repointed.
- `bin/ref` — `usage()` rewritten as markdown piped through the existing `show()`/glow; `show()` moved above the help so both render (it defaults to glow when `renderer` is unset); `card_usage()` now a table too; new `card_list()` as the single source of card names; `--cards` flag; the no-such-card error reads from `card_list`; `textmodes` + `llm` registered.
- `bin/ref-pick` — reads `ref --cards` instead of a hardcoded array. It had silently lost `skill`, `humpty` and `repo`.
- `nvim/lua/grim/core/keymaps.lua` — `<M-Left>`/`<M-Right>` mapped in **insert** mode.
- `nvim/lua/grim/core/options.lua` — `swapfile = true`, `undofile = true`, `updatetime = 250`.
- `shell/functions/g-nav.zsh` — new `cwd` function (`-c` copy · `-e` nvim · `-f` copy+reveal · `-p` print).
- `tmux/.tmux.conf` — `prefix C-l` → `bin/llm-pick` popup · `@resurrect-capture-pane-contents 'on'`.
- `ref/desk.md` — `magnet — snaps` · `aerospace — displays` · `magnet — clashes` · `hidden bar — menu`; ubersicht section rewritten and split into `refresh` + `seam`.
- `ref/nvim.md` — new `Markdown — md prose` section; conform row restored to `(n + v)`.
- `ref/shell.md` — `paths — copy the cwd`. `ref/tmux.md` — `pfx C-l` row.
- Docs: `09-productivity-desktop/05-aerospace.md`, `07-ubersicht.md`, `04-dev-languages/10-neovim-config.md`, `01-shell-terminal/02-tmux.md`, `operations/systems/terminality/07-macos-control.md`, `docs/scripts/INDEX.md`.

### Files Added
- `ref/textmodes.md` + `bin/ref-textmodes` — which vim you are in across nvim · zsh · tmux · yazi · broot · claude · ghostty.
- `ref/llm.md` + `bin/ref-llm` — the llm CLI, models, memory, setup.
- `bin/llm-pick` + `docs/scripts/llm-pick.md` — fzf popup over `llm` (ask · continue · chat · clipboard · model).

## Current State

### Working
- Cards 14 → **16**; all render, filters verified (`llm models`, `textmodes zsh`, `shell cwd`, `nvim markdown` …).
- `aerospace reload-config --dry-run` OK; `.tmux.conf` parses; 5 scripts pass `bash -n`.
- `swapfile`/`undofile` confirmed live via headless nvim; `undodir` = `~/.local/state/nvim/undo//`.
- ⌃⌥⌘+arrows now move the window between displays and it **sticks** — user confirmed after reload, and Magnet did **not** need disabling (AeroSpace registers the hotkey first and swallows it).

### Known Issues
- **The crash cost real notes and nothing could be recovered.** `swapfile = false`, no `undofile`, and tmux-resurrect was saving layout only — three independent reasons there was nothing on disk. All three now closed, but the lost text is gone.
- Magnet still holds **11** `ctrl-alt` chords that collide with AeroSpace (`ctrl-alt-j`/`k` vs focus down/up; `c d e f g i r t u` vs workspace switches). AeroSpace wins them, so Magnet's snap keys read as dead. Carded at `ref-desk magnet clashes`, unfixed — it's a Magnet-side keymap edit.
- Übersicht's Debug Console is icon-only and unscriptable (`Uebersicht.sdef` exposes only `refresh`/`reload`/`quit`), so it stays behind Hidden Bar's `›`.
- Raycast's hotkey store is an encrypted sqlite — it was the one surface that could never be swept from disk.

### Wrong turns worth remembering
- Claimed Magnet's duplicate `horizontal`/`vertical` command sets were the double-fire cause. They are its normal storage — **every** chord is in both. Cross-checking it is what surfaced the 11 real collisions.
- Withdrew the `move-node-to-monitor` fix on finding Magnet held the chord. Magnet holding it *was* the problem.
- Said "markdown has no keys of its own" after sweeping `nvim/lua/grim/` instead of `nvim/` — `after/ftplugin/markdown.lua` and `<leader>md` were right there.
- Said `localhost:41416` was unbrowsable. It answers 400; **`127.0.0.1:41416` answers 200** — a Host-header guard, not a dead server.
- Validated the tmux config by spawning a probe session on the live server mid-crash-investigation. Killed it, but it should have been a throwaway socket.

## Next Steps
1. Decide Magnet's fate — clear its 11 contested `ctrl-alt` chords, or drop the app now that AeroSpace covers displays and `ctrl-alt-c` centre is its last real job.
2. Pick which display shows Übersicht widgets (menu icon → widget → screen); the gutter follows automatically now.
3. `prefix r` + aerospace reload to arm `prefix C-l` and the per-monitor gaps.

# 🏁 Milestone: tmux pane reference trued · nvim-now retirement sealed

**Date:** 2026-07-28
**Agent:** Claude Code (Grim)
**Arc:** The tmux pane keybind surface — config ↔ keys card ↔ docs brought into full agreement — plus the last stragglers of the nvim-now retirement (log 40) found and deleted.
**Delivered:** Pane joining exists for the first time (`prefix < / >`); the keys card's `#pane` section is honest and complete; the nvim-now sweep is now actually zero-residue.

## What closed

- **No way to join panes** → done: stock tmux ships `join-pane` command-only, so `.tmux.conf` binds `prefix <` (pull a picked window in as a pane) and `prefix >` (send this pane into a picked window) via `choose-window`; overrides the unused stock `<`/`>` display-menus.
- **`m/M` mislabeled "mark / unmark"** → done: it's `select-pane -P` — a bg tint (spot the local pane among SSH ones), not tmux's mark. Card + `02-tmux.md` now say so; the real mark stays unbound, deliberately.
- **Card `#pane` gaps** → done: stock `!` break-out, `{ / }` swap, `q` jump-by-number added; `#layout` presets annotated (Alt-1 = 1×3 even-columns, Alt-5 = 2×2 grid — they were never missing, just unlabeled).
- **Docs drift risk** → done: `docs/documentation/01-shell-terminal/02-tmux.md` synced same turn (join/break bullet, mark clarified).
- **nvim-now stragglers** → done: `ref/nnow.md` + `bin/ref-nnow` survived the log-40 sweep on this machine; both deleted. `grep -r nnow` over `bin/ ref/ shell/ keys/ bootstrap.sh` = zero hits.
- **kol-theme nvim leg (dormant)** → parked already, unchanged — the standing graduation item in `docs/documentation/09-productivity-desktop/08-kol-theme.md` gotchas; not this arc's thread.

## The arc (brief)

- User ran `ref tmux pane`, felt the card was thin, and asked what "marking" even did — the answer exposed a mislabel and a genuine capability gap.
- One pass trued all three layers at once: config (new join binds), keys card (fixes + stock binds), catalog doc (synced).
- The layout question answered itself — `#layout` already carried `space` + `Alt-1..5`; only the 1×3/2×2 names were missing.
- The nnow.md stray surfaced as a side-effect of listing `ref/`; deleting it exposed its sibling wrapper, closing [session-log/2026-07-28-nvim-now-retired-references-swept.md](2026-07-28-nvim-now-retired-references-swept.md) for real.
- New binds live after `prefix r` (user's own routine).

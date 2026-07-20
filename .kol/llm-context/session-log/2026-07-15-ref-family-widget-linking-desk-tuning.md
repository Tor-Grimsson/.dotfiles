# Session: ref-* card family · widget linking + type scale · desk geometry · cmd-alt-b sticky

**Date:** 2026-07-15 (4th session)
**Agent:** Grim (Fable 5)
**Summary:** The `keys` pattern became a family — `bin/ref` dispatcher, eight cards (keys · tmux · files · widgets · system · nvim · nnow · nmix) and `ref-*` alias scripts; plus the new `nvim-mix` (nmix) overlay config. Desk widgets got a final 12px type scale, notes is now position-LINKED below bookmarks (constant 12px gap, any list length), aerospace geometry aligns tiles with the widget column, and bookmarks gained a `cmd-alt-b` edit sticky; both stickies float now.

## Changes Made

### ref — reference-card family (`bin/ref`, `ref/`)
- **`bin/ref`** — dispatcher: bare `ref` lists cards, `ref <card> [tag …]` prints via the keys awk/bat engine. Cards: `keys` (keys/keybinds.md) · `files` (files/folders.md) · `widgets` · `system` · `nvim` (ref/*.md).
- **`ref-keys ref-files ref-widgets ref-system ref-nvim`** — the scripts (user's naming; `ref-<TAB>` lists the family). `bin/keys`/`bin/files` kept as thin `exec` aliases — data + typed usage unchanged.
- **`ref/widgets.md`** — the desk-stack card: bar/bookmarks/notes paths, refresh-twice race, hooks, gotchas.
- **`ref/system.md`** — system-level card (user call: card = system, **theme is a section**, after an initial wrong `ref-theme` build): `#window-snapping` (⇧⌥⌘D disable aerospace / ⇧⌥⌘E Raycast re-enable — corrected from user's ctrl-alt-cmd memory), `#theme` ×3 (⇧⌥⌘T OS toggle + kol-theme selector + gotchas).
- **One card per nvim config** (user call after the single card conflated them): **`ref-nvim` = the DAILY config** (extracted fresh from `nvim/lua/grim`: tree `<leader>e*`, yazi `<leader>fy`, flash s/S, substitute `<leader>r*`, surround, sessions `<leader>w*`, gitsigns `<leader>h*`, lsp incl. `<leader>d` diagnostics — daily has NO code-action key); **`ref-nnow`** = the from-scratch build (16 sections, modes as filterable tags, LSP/Trouble/blink/Oil/harpoon); **`ref-nmix`** = the overlay — additions + `#not-grafted` (blink, Comment.nvim, `<leader>vca/lx`) + `#deviation` ledgers, so every nnow-vs-daily difference is accounted for.
- **Terseness pass over all ref cards** (user: "too much explainer text"): one-line intros, clipped descriptions, grouped keys per line; notation converted `C-x` → `ctrl-x` across the nvim trio; harpoon sections open with "per-project FILE BOOKMARKS (not tmux bookmarks)"; Oil lines spell out Enter/-/q and the :w-applies-to-disk contract.
- **Per-card `--help`** (user review: `ref-nvim --help` showed the family overview) — card-level `-h` now prints that card's name, data path, and live section list grepped from its data file (never stales); bare `ref --help` keeps the overview.
- **`ref-tmux`** (user catch: tmux had no card while nvim got one) — solved structurally: a card in `card_def()` is now **data file + optional base tag**, so `ref-tmux` = the keys data scoped to `#tmux` (11 sections; `ref-tmux popover` composes tags; `--help` lists only `#tmux` sections). No duplicate data; the next domain view = one `card_def` line + 3-line alias.
- **`bin/help-lint`** — taught the pure-alias pass rule (`exec` into another bin/ script inherits help); repo lints clean at 77.
- Origin research: `files`/`to` (2026-07-10 log) was built as folder-*navigation*; the user had wanted topic-scoped reference — this family is the correction.

### nvim-mix (`nvim-mix/`, alias `nmix`) — the best-of-both config
- User keeps the daily config, wanted nnow's features ON TOP. **`nvim-mix/` is an overlay, not a copy**: init.lua puts `~/.dotfiles/nvim` on rtp (+ its `after/`), requires `grim.core`/`grim.lsp` straight from it, and runs lazy.nvim with `{ import grim.plugins }` + `{ import mix.plugins }` and `performance.rtp.reset=false` (lazy would otherwise drop the daily dir). Daily edits flow into nmix automatically.
- Grafted: Oil (dash key; `default_file_explorer=false` — tree keeps `nvim <dir>`; no `<leader>-` float — that's decrement in daily), harpoon verbatim, nnow QoL keymaps (visual J/K, centered scroll, `<leader>s/X/fp`) — **minus `<leader>d` black-hole** (daily lsp owns it as diagnostic-float; caught during the card work).
- Wired: `nmix` alias in `.zshrc`, `~/.config/nvim-mix` symlink, bootstrap.sh block. **Verified**: headless boot BOOT OK, 45 plugins, all graft keys bound, `:NvimTree` present alongside Oil.

### Desk widgets (`ubersicht/`)
- **Type scale final: 12px/17px, headers 11px** (was 11/16/10; a 14px pass was tried and walked back); simple-bar stays **14px** (`global.fontSize`, matches ghostty/kitty).
- **Width 236 → 280** both widgets.
- **notes LINKED below bookmarks:** both anchored `top: 48`; notes' command also cats `bookmarks.txt`, render computes bookmarks' height (`bmOffset`, metrics mirror) + `GAP = 12` as margin-top — constant gap at any list length. Wrapper `pointer-events: none` (it overlays bookmarks), card re-enables. Coupling: bmOffset constants mirror bookmarks' type metrics — change together.
- The `(T)` translateX nudge: added on a misread, reverted.

### aerospace (`aerospace/aerospace.toml`)
- `outer.right` 300 → **304** (widgets 280+12 margin + 12 gap = matches inter-widget spacing); `outer.top` 42 → **48** (window tops align with widget column).
- **`cmd-alt-b`** → `bin/bookmarks-toggle` (new): kol-bookmarks sticky — nvim on `bookmarks.txt` via own `kitty/kol-bookmarks.conf` (includes kol-notes.conf; own file so each toggle pkills only its window).
- Sticky rule: title regex widened to `kol-(notes|bookmarks)`, run changed **move-to-T → `layout floating`** (user call — stickies float on the current workspace).
- `~/.dotfiles/aerospace/aerospace.toml` added to `tmux/bookmarks.txt`.

### tmux (`tmux/.tmux.conf`)
- `prefix c` → plain `new-window -c cwd` = **right end** (old bind swapped one slot left; a left-end version was built first, user meant right). Live-tested in a throwaway session.
- **Second prefix: `§`** — `set -g prefix2 §` (C-a stays primary; § parse-tested in a throwaway session; `bind § send-keys §` so `§ §` types a literal §). Every `prefix X` bind answers to either.
- Plugin audit: TPM + sessionx, harpoon, resurrect, continuum — all in ref-keys now (**sessionx `prefix O` was missing, added**).
- **Gruvbox yellow status bar** (user recalled the old-tmux yellow): window names `#d79921` (faded yellow), current window `#fabd2f`, message/rename/reload bar `bg=#d79921` dark text — applied to `themes/gruvbox/tmux.conf` AND the in-file fallback in lockstep; other themes untouched.

### Docs synced (same-turn)
`07-ubersicht` (14px, linked position) · `05-aerospace` (304/48 ×2 spots) · `22-ref` NEW + INDEX row · `19-keys`/`20-files` (alias note) · `21-help-lint` (alias rule) · `03-bookmarks` (cmd-alt-b row) · `02-tmux` (right end, § prefix2) · `keys/keybinds.md` (cmd-alt-b, sessionx, prefix c, § prefix note) · keys-add/files-add skills (engine note).

## Current State

### Working (verified)
- All 8 cards + 8 `ref-*` aliases + bare `keys`/`files` print; per-card --help live; error paths correct; help-lint clean.
- Widget linking math checks against the live layout (9 rows + 2 heads = the previously hand-tuned 340).
- tmux right-end append and the earlier left-end variant both live-tested; toml/json parse-validated.

### Pending user actions
- `aerospace reload-config` — cmd-alt-b bind + float rule + geometry (bind confirmed absent from the running instance until then).
- tmux `prefix r` (+ `prefix I` still owed for resurrect/continuum).
- Übersicht Refresh all ×2 for the bar's 14px.

### Process note
Two naming corrections this session (ref-* as the script names; ref-system with theme as section) came after builds deviated from the user's stated names — logged to memory as binding rule: build exactly what was named, ask before deviating.

## Next Steps
1. Arcs: nvim now three-way (daily · nnow · nmix — user leaning nmix as the ONTOP blend); simple-bar settings-panel tune; raindrop links layer.

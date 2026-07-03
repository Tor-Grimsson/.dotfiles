# 2026-06-14 (iMac) — yazi: full config + plugins + flavor, doc rewrite

Turned yazi from "keymap-only, stock everything" into a tracked media cockpit, and rewrote the reference doc to the lookup-first shape. Repo `yazi/` is now a whole-dir symlink (like nvim) so config + plugins + flavors all version-control.

## Done
- **Restructure** — `~/.config/yazi` was a real dir with only `keymap.toml` symlinked. Now a whole-dir symlink → `~/.dotfiles/yazi`. `bootstrap.sh` yazi block changed from per-file to `ln -sfn "$DOT/yazi" …` (matches the nvim pattern). Two untracked cruft files (`keymap.toml-…`, `keymap.toml.save` with a broken `~clc/…` path) moved to `~/_temp/yazi-cruft-bak/` (classifier blocked `rm -rf`; quarantined instead).
- **`yazi/yazi.toml`** (new) — merged over defaults: `linemode=size`, `sort_by=natural`, `dir_first`, preview `max_width/height` 1000×1400, `image_filter=lanczos3`, quality 90. Openers left at stock (edit→nvim, reveal→Finder, etc.).
- **`yazi/keymap.toml`** (extended) — kept the 3 `g`-jumps, added `g D`/`g .`/`g t` (Desktop/dotfiles/_temp), `<Enter>`→smart-enter, `T`→max-preview, `<C-y>`→Quick Look. Dropped a `P`→hide-preview binding (conflicted with default paste-overwrite).
- **`yazi/theme.toml`** + **`init.lua`** (new) — flavor = `gruvbox-dark` (matches nvim's gruvbox-material); init.lua sets up full-border (rounded).
- **Plugins** via `ya pkg add` (vendored into repo, pinned in `package.toml`): `full-border`, `smart-enter`, `toggle-pane`. Note: `max-preview` was renamed to `toggle-pane` upstream — adding `max-preview` recorded but never deployed; swapped to `toggle-pane` (invoke `plugin toggle-pane max-preview`).
- **Brewfile** — added `sevenzip` (archive preview/extract) + `resvg` (SVG preview), the only two missing yazi preview backends. Confirmed video (ffmpeg), HEIC/JXL (ImageMagick 7.1.2), PDF (poppler), JSON (jq) are already covered — **current yazi uses `ffmpeg`, not ffmpegthumbnailer**, for video.
- **Doc** `docs/02-file-management/02-yazi.md` rewritten to lookup-first: preview-deps table (with status), config-file map, setup, launch, built-in vs custom key tables, plugin table, workflows. Fixed the wrong `yy()`→`y()`.

## Handoff (user runs)
- ~~`brew install sevenzip resvg` (iMac)~~ — **done** (`7zz` + `resvg` confirmed on PATH). Still needs `brew bundle` on the MBP after this commits, to land both there.
- **Live-verify** (the one thing not checkable headlessly): launch `y`, confirm gruvbox colors + rounded borders, `T` full-screens a preview, `<Enter>` enters dirs / opens files, video files show a frame thumbnail. Reload after edits: yazi has no live reload — just relaunch.
- User owns git; commit + dot-sync carries the whole `yazi/` tree (incl. vendored plugins) to the MBP, where the bootstrap symlink + pinned `package.toml` reproduce it.

## Notes
- **Catalog 68 → 70 / 13.** sevenzip + resvg installed → got brief lookup-first stubs `02-file-management/15-sevenzip.md` + `16-resvg.md` (both cross-linked to yazi as their reason-for-existing; resvg ↔ ImageMagick). Category 02 row 13 → 15, root count 68 → 70 (frontmatter + body + category table). Brewfile and catalog agree again.
- A **gated MCP handoff** was created this session at `session-bridge/handoff-2026-06-14-1919-mcp.md` — unrelated to yazi; a dormant, init-gated breadcrumb for future MCP work (see that file's activation gate).

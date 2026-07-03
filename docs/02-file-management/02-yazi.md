---
title: Yazi
type: reference
status: active
updated: 2026-07-02
description: Blazing-fast terminal file manager (Rust, async I/O, inline image/video previews). Configured here as a media cockpit — `y` drops the shell into wherever you quit.
aliases:
  - yazi
  - y
tags:
  - domain/files
  - pattern/tui
  - integration/brew-formula
links:
  website: https://github.com/sxyazi/yazi
  repo: https://github.com/sxyazi/yazi
  manual: https://yazi-rs.github.io/
  brew: https://formulae.brew.sh/formula/yazi
covers:
  - The y() cd-on-quit wrapper
  - Preview dependencies (what each filetype needs)
  - Tracked config files, plugins, and theming (terminal-inherited)
  - Default + custom keybindings, and practical workflows
related:
  - "[[01-cli-cheatsheet|CLI cheatsheet]]"
  - "[[17-yazi-cheatsheet|Yazi cheatsheet (beginner)]]"
  - "[[03-broot|broot]]"
  - "[[01-tree|tree]]"
  - "[[13-zoxide|zoxide]]"
  - "[[../01-shell-terminal/15-mdcat|mdcat]]"
  - "[[10-neovim-config|Neovim config (IDE setup)]]"
---

## Summary
Full-screen terminal file manager: Miller-column layout (parent · current · preview), async previews that never block, Vim-style keys, first-class bulk rename and selection. The `y` shell function launches it and `cd`s the shell to wherever you quit — so yazi doubles as a visual `cd`.

This install is tuned for media work: large high-quality image/video previews, terminal-inherited colors (no yazi flavor — the iTerm `coolnight` palette paints everything), and four plugins.

## Preview dependencies
Previews are handed off to external tools. Yazi degrades gracefully — a missing tool just means that filetype shows no preview.

| Preview | Backend | Brew dep | Status |
|---|---|---|---|
| Text + syntax | built-in | — | ✓ |
| **Markdown** (rendered) | mdcat (via the `mdcat` plugin) | `mdcat` | ✓ |
| Images (PNG/JPG/GIF/WebP) | built-in (iTerm2 image protocol) | — | ✓ |
| HEIC / JPEG-XL / fonts | ImageMagick ≥ 7.1.1 | `imagemagick` | ✓ (7.1.2) |
| **Video** (frame thumbnail) | ffmpeg | `ffmpeg` | ✓ |
| PDF | poppler | `poppler` | ✓ (`pdftoppm`) |
| JSON | jq | `jq` | ✓ |
| **Archives** (browse/extract inside) | 7-Zip | `sevenzip` | **missing** |
| **SVG** | resvg | `resvg` | **missing** |

Only two gaps: `brew install sevenzip resvg` (see [Setup](#setup)). `fd` / `ripgrep` / `fzf` / `zoxide` (used for in-yazi find & jump) are all already present.

## Config files
All live in `~/.dotfiles/yazi/`, symlinked as a whole dir to `~/.config/yazi` (like nvim). Edit either path — same files.

| File | Controls |
|---|---|
| `yazi.toml` | layout, sort, preview size/quality — the **full yazi default** inlined for reference; overrides marked `# ← custom` |
| `keymap.toml` | keybindings — the **full default keymap** inlined for reference; customs marked `# ← custom` |
| `theme.toml` | **no flavor** — yazi inherits the terminal palette (coolnight). catppuccin-mocha + gruvbox-dark stay vendored as commented `[flavor]` options |
| `init.lua` | Lua startup — sets up the `full-border` plugin |
| `package.toml` | plugin/flavor manifest used by `ya pkg` (pins each to a revision) |
| `plugins/` `flavors/` | the vendored plugin & flavor repos (tracked, so a fresh machine needs no re-fetch) |

## Setup
On this machine it's already wired. For a fresh machine:

1. **Symlink** (bootstrap does this): `ln -sfn ~/.dotfiles/yazi ~/.config/yazi`
2. **Preview deps**: `brew install sevenzip resvg` (the rest ride along with the Brewfile)
3. **Plugins** are vendored in the repo, so nothing to fetch. To re-sync or update them later: `ya pkg install` (deploy from `package.toml`) or `ya pkg upgrade` (bump revisions).
4. **`y` function** is in `shell/.zshrc` — new shell or `source ~/.zshrc`.

## Launch

```sh
y                 # launch in the iMac projects dir (falls back to cwd elsewhere), cd on quit
y ~/Downloads     # launch at a path, cd on quit
yazi              # raw launch (no cd-on-quit)
```

`y` (in `shell/.zshrc`) writes yazi's exit directory to a temp file and `cd`s the shell there — navigate visually, the shell follows.

**From inside Neovim:** `<leader>fy` opens yazi in a floating window at the current file (`yazi.nvim`) — picking a file returns you to that buffer. See [Neovim config](../04-dev-languages/10-neovim-config.md).

## Keys — built-in
The stock bindings you'll use most (unchanged):

| Key | Action |
|---|---|
| `h` `j` `k` `l` | parent · down · up · enter/open |
| `H` `L` | back / forward in history |
| `gg` `G` | top / bottom |
| `K` `J` | scroll the preview up / down |
| `<Space>` | toggle selection + move down |
| `v` / `V` | visual select / unselect mode |
| `<C-a>` / `<C-r>` | select all / invert selection |
| `y` `x` `p` | yank (copy) · yank (cut) · paste |
| `d` / `D` | trash / delete permanently |
| `a` `r` | create (end with `/` for a dir) · rename |
| `.` | toggle hidden files |
| `f` | filter the current listing (type to narrow; `Esc` clears) |
| `/` `?` | find by name — jump as you type (`n` / `N` repeat) |
| `s` `S` | search the tree — by name (fd) / by content (rg) |
| `z` `Z` | jump via fzf (file/dir) / zoxide (frecent dir) |
| `<Tab>` | spot info (metadata) for the hovered file |
| `:` `q` `~` | command · quit · help |

## Keys — custom
Added in `keymap.toml`:

| Key | Action |
|---|---|
| `<Enter>` | **smart-enter** — enter a dir or open a file (one key for both) |
| `T` | **maximize the preview** (full-screen an image/video); press again to restore |
| `<C-y>` | **Quick Look** the hovered/selected file(s) (macOS `qlmanage`) |
| `M` | render the markdown file **full-screen with mdcat** (`-p` pager + inline iTerm2 images) — a bigger read than the preview pane; `q` returns to yazi |
| `g h` | → `~` |
| `g p` | → `~/dev/projects` |
| `g d` | → `~/Downloads` |
| `g D` | → `~/Desktop` |
| `g .` | → `~/.dotfiles` |
| `g t` | → `~/_temp` |

## Plugins
Installed with `ya pkg add`, vendored under `plugins/` + `flavors/`, pinned in `package.toml` — except `mdcat`, which is hand-written and so carries no `package.toml` entry.

| Plugin | Does | Trigger |
|---|---|---|
| `smart-enter` | Enter dir / open file with one key | `<Enter>` |
| `toggle-pane` | maximize/hide a pane (respects the `ratio`) | `T` (max-preview); `:plugin toggle-pane <mode>` for others |
| `full-border` | rounded borders around the panes | automatic (`init.lua`) |
| `mdcat` | renders `.md` as styled markdown in the preview (clean headings, no `##` markers; frontmatter shown) | automatic (previewer matched by `*.{md,markdown}` — yazi tags `.md` as `text/plain`, so it's wired by extension, not mime) |

> **Maintenance:** `plugins/mdcat.yazi/main.lua` is **hand-written** (not a `ya pkg` dep — no `package.toml` entry, no upgrade churn). It runs `mdcat --ansi --local --columns <pane-width>`: `--ansi` forces formatting when stdout is a pipe (no TTY), `--local` skips remote image fetches so the preview never stalls. A 2-column left/right margin is added by insetting the render area (`job.area:pad(ui.Pad.x(2))`) — mdcat has no margin flag of its own; tune the `pad` local at the top of `peek`. It was picked over **glow** (which keeps the `##` heading markers and strips frontmatter) after an A/B. The `glow` **binary stays installed** — it's used by scripts + Quick Actions — but is no longer wired into yazi.
| `catppuccin-mocha`, `gruvbox-dark` (flavors) | vendored but **inactive** — colors come from the terminal (coolnight). Activate one by uncommenting its `[flavor]` block | `theme.toml` |

## Workflows
- **Move files between two dirs** — `<Space>` to mark several (or `y`/`x` to copy/cut), navigate to the target with `h`/`l`, `p` to drop. Tabs (`t` new tab, `1`–`9` switch) let you keep source and target open at once.
- **Bulk rename** — select files, `r`. Yazi opens the names in `$EDITOR` (nvim); edit the list, save, quit — every change applies at once.
- **Review media fast** — hover a video or image, `T` to full-screen the preview, `j`/`k` to step through the folder, `T` again to restore. `<C-y>` for a full Quick Look.
- **Find then act** — `s` (search by name, fd) / `S` (by content, rg), or `/` (jump to a name in this dir), to land on a file, then operate on it.
- **Browse → cd** — launch with `y`, walk the tree, `q` — the shell is now in that directory.

## Why installed
The interactive file manager for day-to-day terminal work — browse, preview, move, bulk-rename without leaving the shell or reaching for Finder. The async core stays instant on large or network dirs where other TUI managers stall. Pairs with [zoxide](13-zoxide.md) (`z` to jump near, `y` to browse there).

## Biggest win
Async, non-blocking previews **plus** cd-on-quit: you navigate visually and the shell follows, so yazi is a fast visual `cd` as much as a file manager. Inline image/video/PDF previews remove most reasons to open Finder.

## Future use
Per-filetype openers (e.g. route `.psd` through an [img-from-psd](../12-scripts/img-from-psd.md) action); a `git` plugin for status flags in the list; more `ya pkg` plugins (chmod, mount, archive browsing) as the need shows up. Add them via `ya pkg add` — they vendor into the repo automatically.

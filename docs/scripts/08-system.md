---
title: System & clipboard scripts
type: reference
status: active
updated: 2026-07-29
description: fs-* filesystem + ss-*/clip-* clipboard helpers.
aliases:
  - system
tags:
  - project/dotfiles
  - domain/scripts/system
related:
  - "[[ss-save|ss-save path cheat sheet]]"
  - "[[fs-reveal|fs-reveal]]"
  - "[[02-yazi|yazi]]"
---

# System & clipboard (`fs-` / `ss-` / `clip-`)

| Script | Does | Usage |
|--------|------|-------|
| `fs-rm-folder-smart.sh` | **Flatten** nested folders: move files out, delete emptied folders (clash-safe) | `fs-rm-folder-smart.sh [-w] [-d N] [-n]` — run `--help` |
| `fs-shoot.sh` | **Shoot** files/folders into a destination folder (created if missing, clash-safe) | `fs-shoot.sh [-n] <dest> <files…>` — run `--help` |
| `ss-save.sh` | Save clipboard image → file via `pngpaste` (you pick the path up front) | `ss-save.sh [name] [dir]` — run `--help`; full path rules in [[ss-save|ss-save.md]] |
| `clip-drop.sh` | Clipboard image → `~/_inbox` (a bare word = a folder INSIDE it, never a path); `--note`/`--review` add a linked `.md`; **repo flags** (`--kol-ds-ui` `--humpty` `--kol-website` `--dotfiles`) file it into that repo's `lobby/`; `--yazi` opens yazi; `--menu` = fzf picker | `clip-drop.sh [word] [--note \| --review] [--yazi]` · `clip-drop.sh --humpty overload` — run `--help` (examples-first); bound to `prefix C-p` |
| `fs-reveal.sh` | Open Finder at PATH; `-f` = new **floating** window on the current AeroSpace workspace | `fs-reveal.sh [-f] [path]` — run `--help`; the `-f` bypass in [[fs-reveal|fs-reveal.md]] |

> `fs-rm-folder-smart.sh` renamed from `rm-fold-smart.sh` (fold → folder). Older `rm-folder*` variants were relocated to `~/_temp/bin_bak/` (out of the repo) on 2026-06-05.

### `fs-rm-folder-smart.sh` flags
Run it **inside** the folder you want flattened. `--help` documents all of it.

| Flag | Effect |
|---|---|
| (none) | Flatten fully; each file moves up one level, emptied folders removed |
| `-w`, `--working-dir` | Pull every file to the current dir (full collapse), not just up one level |
| `-d N`, `--depth N` | Only unpack folders up to N levels deep — `-d 1` = immediate subfolders only |
| `-n`, `--dry-run` | Print the MOVE/RMDIR actions, change nothing |

Clashes auto-resolve (`file.ext` → `file-bak1.ext`). Depth-first + rmdir-only, so it never deletes a folder
that still holds un-flattened deeper content (fixed a `rm -rf` data-loss bug present in the old version, 2026-06-05).

### `fs-shoot.sh`
Move anything into a destination folder — created if missing, never overwrites: clashes auto-resolve
(`file.ext` → `file-bak1.ext`, folders → `folder-bak1`). Skips missing sources and anything already in the
destination; refuses to move the destination into itself. `-n` previews. Workhorse behind the "Shoot to …"
Finder Quick Actions — see [[10-quick-actions|Quick Actions]] for stamping those out.

### `clip-drop.sh` — capture first, file later
`ss-save`'s inverse. `ss-save` makes you name the file **and** pick the folder before you can see the image;
`clip-drop` flips it: dump the clipboard image to `~/_inbox/clip_<timestamp>.png` and print the path. With
`--yazi` it then `exec`s yazi on the file so you **preview it, then decide**. The `prefix C-p` tmux popup runs
`--menu` — a small fzf picker over all the modes (file/drop/note/review; top item is the yazi flow, so
Enter-Enter = capture-and-file; Esc = nothing saved; the review line shows the current review's name). Bare
`clip-drop.sh` just saves. If you don't feel like filing it, it just sits in `~/_inbox` as an unfiled pile.

Filing it, entirely in yazi (no path typed): `r` rename → `x` cut → navigate to the destination → `p` paste.
Needs `pngpaste` (`yazi` only with `--yazi`); errors out if the clipboard holds no image. (⌘⇧3/4 *screenshots* land in `~/Screenshots` via `macos/defaults.sh` — the `~/_inbox` flow is clipboard-only.) Image preview inside
the popup relies on tmux `allow-passthrough on` (the same thing the `prefix C-y` [[02-yazi|yazi]] popup depends on).

Optional arg overrides the inbox: `clip-drop.sh ~/Pictures/staging`.

**`_inbox` is the home (rebuilt 2026-07-30).** A bare word is a **folder name inside `~/_inbox`**, never a path — before this, `clip-drop.sh review` created `./review` in whatever directory the shell happened to be in, which is how a `review/` folder appeared inside kol-ds-ui. Path-shaped words are stripped to their last segment; `--dir PATH` is the deliberate override.

| you type | you get |
|---|---|
| `clip-drop.sh` | `~/_inbox/clip_<ts>.png` |
| `clip-drop.sh bingo` | `~/_inbox/bingo/clip_<ts>.png` — same word twice = same folder |
| `clip-drop.sh bingo --note` | …plus `bingo.md` with a timestamped embed |
| `clip-drop.sh --humpty overload` | `humpty/lobby/overload.md` + `_assets/` |

**Repo flags** — one per lobby registered in `files/folders.md`'s `## lobby` section: `--kol-ds-ui` · `--humpty` · `--kol-website` · `--dotfiles`. The flag name is the folder holding the lobby, so registering a new lobby (one row) creates its flag with no code change. The `.md` sits at the lobby root, images in `<lobby>/_assets/`, repeat captures append. `--lobby` bare lists the registry; `--lobby WORD` is the generic form underneath. `--menu` (tmux `prefix C-p`) grows one `lobby: <repo> …` item per registered path.

When the screenshot is **evidence** (an issue, a review), the modes pair it with a markdown doc in its own folder:
`--note [name]` = one-off issue — saves into `~/_inbox/<name>/` and creates/appends `<name>.md` there (title + image
embed under a timestamp heading; name defaults to the timestamp slug — rename in yazi). `--review [name]` = ongoing
session — with a name it starts (or switches to) that review folder and remembers it as **current** (the pointer is
`~/_inbox/.current-review`, so it survives reboots; switching works even with an empty clipboard); bare `--review`
appends the capture to the current review's `.md`, so the review reads top-to-bottom as it happened. Same-second
captures get a `_2`/`_3` suffix instead of clobbering. `--yazi` combines with either mode. `--desc "text"`
(menu: an optional `description (Enter = skip)` prompt) writes a one-line annotation under that capture's embed —
longer bodies belong in the editor, the .md is sitting right there.

### `fs-reveal.sh`
`reveal` in the shell. Plain mode is macOS `open`; `-f` opens a **new floating** Finder window on the
**current** AeroSpace workspace, bypassing the blanket Finder→W rule per-window — it lets the rule fire,
then overrides that one window by its `window-id`. Full mechanism: [[fs-reveal|fs-reveal.md]].

Finder selection Quick Actions (`finder-select-alternate.sh`) moved to their own family doc: [[09-finder|Finder]].

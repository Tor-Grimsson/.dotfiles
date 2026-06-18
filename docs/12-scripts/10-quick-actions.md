---
title: Quick Action generator
type: reference
status: active
updated: 2026-06-17
description: qa-make.sh — stamp a Finder Quick Action from a one-line shell command. The recipe behind Open in glow / Select Every Other, automated. Presets + worked examples.
tags:
  - project/dotfiles
  - domain/scripts/quick-actions
related:
  - "[[08-system|System & clipboard]]"
  - "[[09-finder|Finder selection]]"
  - "[[img-from-psd|PSD → image Quick Action]]"
  - "[[img-canvas|Fixed-aspect canvas Quick Action]]"
  - "[[img-convert|Any image → JPG/PNG Quick Action]]"
  - "[[02-mpv|Open in mpv (player)]]"
---

# Quick Actions (`qa-`)

| Script | Does | Usage |
|--------|------|-------|
| `qa-make.sh` | Generate a Finder Quick Action that runs a shell command on the selection | `qa-make.sh [-t types] [-f] "<Name>" '<command>'` — run `--help` |

The recipe behind *Open in glow* / *Select Every Other*, automated. One terminal line →
a tracked `.workflow` in `macos/services/` + symlink in `~/Library/Services` → the action
appears under Finder right-click → **Quick Actions** / **Services**. No Automator clicking.

## How it works

- A Quick Action bundle is just two plists: `Info.plist` (service registration — Finder
  context, accepted file types) and `document.wflow` (one *Run Shell Script* action).
  `qa-make.sh` stamps both from the same template the hand-made actions use,
  `plutil -lint`s them, symlinks, and `pbs -flush`es the Services registry.
- Selected files/folders arrive as `"$@"` in `/bin/bash`. **Single-quote the command**
  so `$HOME` and `"$@"` survive until run time.
- Automator runs with a **bare PATH** (no brew). If the command calls a brew tool
  (`magick`, `ffmpeg`, …) — directly or via a repo script — prepend
  `export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH";` (both prefixes = works on
  either machine; the absent one is ignored). `$(brew --prefix)` does **not** help
  here — `brew` itself isn't on the bare PATH to resolve it.
- `-t public.image` (comma-separable UTIs) restricts which selections offer the action.
  Default `public.item` = any file or folder.
- Bundles land in the repo → sync to the other machine; `bootstrap.sh` links every
  `*.workflow` in `macos/services/` (glob loop, 2026-06-05 — no per-file lines needed).

## Installed presets

| Quick Action | Command | Hotkey |
|---|---|---|
| Shoot to _trash | each selected item → a `_trash/` folder **next to it** (`fs-shoot.sh`) | — |
| Open in mpv | play the selected video(s) in mpv in a new terminal window (`mpv-open.sh`) | — |

*Shoot to _trash* is the fake-trash: culling a folder shoots rejects into a local
`_trash/` you can review and delete later — the real Trash stays out of it.

*Open in mpv* hands each selected video to `bin/mpv-open.sh` (the mpv twin of
`glow-open.sh`), which opens a new iTerm/Terminal window and plays it. Engine +
behaviour are documented with the player — [[02-mpv|mpv § Finder Quick Action]].
One thing worth noting *here*: it needs **no** `export PATH` shim — `mpv-open.sh`
opens a **login shell** (mpv already on PATH), unlike the bare-PATH `magick`/`ffmpeg`
recipes below.

## Making your own

```sh
# fixed destination: collect into one global staging folder
qa-make.sh "Shoot to Staging" '"$HOME/bin/fs-shoot.sh" "$HOME/_staging" "$@"'

# per-file destination: a folder next to each selected item
qa-make.sh "Shoot to _keep" 'for f in "$@"; do "$HOME/bin/fs-shoot.sh" "$(dirname "$f")/_keep" "$f"; done'

# play the selected video(s) in mpv — new terminal window per file (engine = mpv-open.sh)
# (no PATH shim: mpv-open.sh opens a login shell, which already has mpv on PATH)
qa-make.sh -t public.movie,public.audiovisual-content,org.webmproject.webm,org.matroska.mkv \
  "Open in mpv" 'for f in "$@"; do "$HOME/bin/mpv-open.sh" "$f"; done'

# images only, through the web-export pipeline
# (export PATH so magick resolves under Automator's bare PATH — both brew prefixes = cross-machine)
qa-make.sh -t public.image "Web export" \
  'export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"; "$HOME/bin/img-web.sh" "$@"'

# PSDs → 2000px JPG (see [[img-from-psd]] for a resolution-prompt variant)
qa-make.sh -t public.image "Convert PSD → JPG (2000px)" \
  'export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"; "$HOME/.dotfiles/bin/img-from-psd.sh" -r 2000x "$@"'

# PSDs → JPG at original resolution (no -r = full size)
qa-make.sh -t public.image "Convert PSD → JPG (original size)" \
  'export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"; "$HOME/.dotfiles/bin/img-from-psd.sh" "$@"'

# any image → 2000px JPG (fixed format; see [[img-convert]] for the cheat sheet)
qa-make.sh -t public.image "Convert image → JPG (2000px)" \
  'export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"; "$HOME/.dotfiles/bin/img-convert.sh" "$@"'

# …or prompt for JPG/PNG at run time — img-convert's -P mode (see [[img-convert]]).
# Add com.adobe.pdf so the action also fires on PDFs (→ first page @300dpi, fit 2000px).
qa-make.sh -t public.image,com.adobe.pdf "Convert image (pick format)" \
  'export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"; "$HOME/.dotfiles/bin/img-convert.sh" -P "$@"'

# any image → fixed social aspect, cover-crop (fixed preset)
qa-make.sh -t public.image "Canvas 4:5" \
  'export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"; "$HOME/.dotfiles/bin/img-canvas.sh" -a 4:5 "$@"'

# …or prompt for aspect + scale at run time — img-canvas's -P mode (see [[img-canvas]])
qa-make.sh -t public.image "Canvas (pick aspect)" \
  'export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"; "$HOME/.dotfiles/bin/img-canvas.sh" -P "$@"'
```

Moves go through [[08-system|fs-shoot.sh]] — clash-safe, creates the destination,
never overwrites.

## Hotkeys

Optional. System Settings → Keyboard → Keyboard Shortcuts → Services → General, or —
to make it bootstrap-able — add a `defaults write pbs NSServicesStatus` line to
`macos/defaults.sh` §Services. `qa-make.sh` prints the exact line on creation.

## Removing

Delete `macos/services/<Name>.workflow` and the `~/Library/Services/<Name>.workflow`
symlink, then `/System/Library/CoreServices/pbs -flush`.

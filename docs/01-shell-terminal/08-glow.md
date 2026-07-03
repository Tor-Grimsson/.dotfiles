---
title: glow
type: reference
status: active
updated: 2026-06-05
description: Terminal markdown renderer — open any .md as styled, readable text, instantly.
aliases:
  - glow
tags:
  - domain/shell
  - pattern/cli
  - integration/brew-formula
  - provider/charm
links:
  website: https://github.com/charmbracelet/glow
  repo: https://github.com/charmbracelet/glow
  manual: https://github.com/charmbracelet/glow#readme
  brew: https://formulae.brew.sh/formula/glow
covers:
  - file render + pager
  - TUI markdown browser
related:
  - "[[07-fastfetch|fastfetch]]"
  - "[[15-mdcat|mdcat]]"
---

## Summary
A terminal **markdown renderer** from Charm (the bubbletea/lipgloss people). A single self-contained Go binary — no runtime, no dependencies. Reads a `.md` and prints it as styled text: headings, bold/italic, tables, blockquotes, lists/task-lists, and code blocks with real syntax highlighting (chroma), word-wrapped to the terminal and themed auto light/dark.

## Why installed
Quick, zero-friction reading of the repo's own docs (`TOOLING.md`, `docs/`) without opening an editor or a browser. The dotfiles are markdown-heavy; `glow` is the instant reader for them.

## Most common use case
`glow file.md` — render and read a single doc in place.

## Biggest win
**Speed + zero setup.** ~30–40 ms cold (measured): start, render, exit — no daemon, no index, no perceptible "opening." Static binary, so it just works on any machine after `brew install`.

## How to use
```sh
glow file.md          # render a file to the terminal
glow -p file.md       # pager mode — scroll, q to quit (best for long docs)
glow                  # TUI: browse all markdown under the current dir
glow ~/.dotfiles/docs # browse a whole tree
glow -w 100 file.md   # fix wrap width (default = terminal width)
glow https://…/README.md   # render remote markdown / a repo README
```

## Config

Config file: `~/Library/Preferences/glow/glow.yml` (macOS path). Run `glow config` to create/edit it in `$EDITOR`. Keys mirror the flags:

```yaml
style: "auto"   # auto | dark | light | notty | path/to/custom-theme.json
width: 100      # word-wrap column (0 = off)
pager: true     # always page → `glow file.md` becomes scrollable (q to quit)
```

`pager: true` is the best default — every `glow file.md` opens as a clean scrollable reader, no `-p` needed. To version-control it, drop `glow.yml` in the repo and symlink it to that path via `bootstrap.sh`.

## Open a .md from Finder

Finder can't pipe a file into a terminal program, so you wrap it. **Implemented** as a Quick Action:

- Right-click a `.md` → **"Open in glow"** → new iTerm (or Terminal) window rendering the file with `glow -p`. Quitting glow (`q`) leaves the window open at a prompt.
- Engine: `bin/glow-open.sh` (works standalone too: `glow-open.sh file.md`; `glow-open.sh --help` documents it).
- Quick Action: `macos/services/Open in glow.workflow`, symlinked into `~/Library/Services` by `bootstrap.sh`; it calls `$HOME/bin/glow-open.sh`.

Alternatives not used: a `.app` wrapper as the double-click default for `.md` (more invasive), or a plain `g() { glow -p "$@"; }` shell function (not Finder).

## MBP keyboard-shortcut status — STILL INCOMPLETE (2026-06-05)

What the MBP reconcile got right, what it missed, and what remains open:

**Done and verified:**
- glow installed (brew bundle), `glow.yml` linked, workflow symlinked into `~/Library/Services` + pbs-registered.
- `bin/glow-open.sh` verified working standalone (opens an iTerm window rendering the file).
- A ⌃⇧G bind for "Open in glow" already existed in this machine's `pbs.plist` (`NSServicesStatus`) from an earlier setup and reattached by name when the workflow was relinked.

**What the agent got wrong during verification:**
- First claimed "no shortcut bound" — it read the workflow's *registration* (`pbs -dump_pboard`, whose `NSKeyEquivalent` is the workflow's built-in key, always empty) instead of the user-assignment store (`defaults read pbs NSServicesStatus`). Wrong store.
- Then claimed the reattached binds meant "done" — without ever testing that pressing the key actually dispatches the workflow. It doesn't (yet).

**Still incomplete:** ⌃⇧G in Finder does not fire the Quick Action. Script and workflow are healthy, so the break is in keypress → service dispatch. Untested candidate fixes, in order:
1. Log out / back in (pbs key-equivalents commonly need a session restart to take).
2. Right-click → Quick Actions → "Open in glow" once, to surface the first-run permission dialog.
3. If both fail: check for a ⌃⇧G conflict and re-assign the bind in System Settings → Keyboard → Shortcuts → Services.

Update this section when the chain works end-to-end.

## Future use
Pipe rendered docs (`glow doc.md | less -R`), set a default style/width via `~/.config/glow/glow.yml`. Note: terminals can't show images, so embedded `![]()` images render as nothing — text-only. (yazi's `.md` previewer is now [mdcat](15-mdcat.md), not glow — glow stays for scripts + the "Open in glow" Quick Action.)

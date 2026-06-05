---
title: Transmission (CLI)
type: reference
status: active
updated: 2026-06-05
description: Lightweight BitTorrent client as command-line utilities — a headless daemon plus a remote control tool.
aliases:
  - transmission-cli
  - transmission-daemon
  - transmission-remote
tags:
  - domain/media/torrent
  - pattern/cli
  - integration/brew-formula
links:
  website: https://transmissionbt.com/
  repo: https://github.com/transmission/transmission
  manual: https://github.com/transmission/transmission/tree/main/docs
  brew: https://formulae.brew.sh/formula/transmission-cli
covers:
  - Headless torrent downloading via the daemon
  - Controlling the daemon with transmission-remote
  - Adding torrents and magnet links
  - Inspecting torrent file contents
  - Live download dashboard via watch
related:
  - "[[01-ffmpeg|FFmpeg]]"
---

## Summary
Transmission is a lightweight, low-overhead BitTorrent client. This formula installs only the command-line utilities: `transmission-daemon` (a headless background service), `transmission-remote` (the tool that controls it), `transmission-cli` itself, plus helpers for creating and inspecting `.torrent` files. There is no GUI here — the desktop `Transmission.app` is a separate cask.

## Why installed
It provides torrent transfer without a GUI app sitting in the dock — the daemon runs in the background and is driven entirely from the terminal, which fits a scripted, headless workflow and is easy to manage over SSH. It is the standard, no-frills way to fetch large open media and dataset distributions.

## Most common use case
Starting the daemon, then adding a magnet link or `.torrent` and letting it download in the background, all via `transmission-remote`.

## Biggest win
Headless, remote-controllable, and frugal. The daemon plus `transmission-remote` model means downloads keep running independent of any window, can be queried or steered from a script, and barely touch CPU or memory — exactly what a GUI client can't offer cleanly.

## How to use
```sh
# Start the background daemon
transmission-daemon

# Add a magnet link
transmission-remote -a "magnet:?xt=urn:btih:..."

# Add a local .torrent file
transmission-remote -a path/to/file.torrent

# List current torrents and their status
transmission-remote -l

# Live dashboard — re-renders the list every second, fullscreen (q/Ctrl-C to quit)
watch -n 1 transmission-remote -l

# Pause / start torrent number 3
transmission-remote -t 3 --stop
transmission-remote -t 3 --start

# Inspect what a .torrent contains (without downloading)
transmission-show file.torrent

# Stop the daemon
transmission-remote --exit
```

## Future use
Worth adopting: a versioned `settings.json` (the daemon's config, see the project docs) to pin download directories, speed limits, and a watched folder, plus the daemon's web interface for occasional browser-based management when the terminal isn't handy.

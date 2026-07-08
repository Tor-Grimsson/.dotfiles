---
title: mpv
type: reference
status: active
updated: 2026-06-17
description: Minimal, scriptable, high-quality media player driven from the command line and config files.
aliases:
  - mpv
tags:
  - domain/media/player
  - pattern/cli
  - integration/brew-formula
links:
  website: https://mpv.io
  repo: https://github.com/mpv-player/mpv
  manual: https://mpv.io/manual/stable/
  brew: https://formulae.brew.sh/formula/mpv
covers:
  - Playing local and network media
  - Keyboard-driven playback control
  - Config and scripting via mpv.conf and Lua
  - Streaming URLs through yt-dlp
related:
  - "[[01-ffmpeg|FFmpeg]]"
  - "[[06-edge-tts|edge-tts]]"
  - "[[10-quick-actions|Open in mpv Quick Action]]"
  - "[[08-terminal-music|Terminal music (mpd + rmpc)]]"
---

## Summary
mpv is a lean media player descended from MPlayer/mplayer2, built around the same FFmpeg decoding stack and a high-quality GPU video output. It has almost no chrome — playback is controlled by keyboard, command line, config files, and Lua scripts rather than menus. It plays effectively anything FFmpeg can decode, including direct streaming URLs.

## Why installed
It is the player that does exactly what you tell it and nothing else — no library, no telemetry, no transcoding nags. Paired with `yt-dlp` (a dependency it already pulls in), it streams web video straight from a URL, which makes it the natural front end for quickly checking a file or watching a stream without launching a heavyweight app.

## Most common use case
Playing a local file or a streaming URL straight from the terminal — `mpv <file-or-url>` and done.

## Biggest win
Configurability with zero bloat. Every key, filter, and default lives in plain-text config and Lua scripts, so playback behavior is reproducible and version-controllable — a perfect fit for a dotfiles-managed setup, unlike GUI players whose state hides in opaque preference panes.

## How to use
```sh
# Play a local file
mpv movie.mkv

# Stream a web video by URL (uses yt-dlp under the hood)
mpv "https://www.youtube.com/watch?v=..."

# Play at 1.5x speed, start 90 seconds in
mpv --speed=1.5 --start=90 lecture.mp4

# Loop a file forever (good for reference clips)
mpv --loop-file=inf clip.mp4

# Audio-only playback (no video window)
mpv --no-video album.flac
```
Key in-player bindings: `Space` pause, `←/→` seek 5s, `↑/↓` seek 1min, `[` / `]` change speed, `9` / `0` volume, `f` fullscreen, `q` quit. Persistent settings go in `~/.config/mpv/mpv.conf`.

## Finder Quick Action
Right-click a video in Finder → **Open in mpv** opens a new iTerm (or Terminal) window and plays it with `mpv` (mpv pops its own video window; `q` quits and leaves the terminal at a prompt). Engine: `bin/mpv-open.sh` (the mpv twin of `glow-open.sh`; works standalone too — `mpv-open.sh clip.webm`). Workflow `macos/services/Open in mpv.workflow`, symlinked into `~/Library/Services` by `bootstrap.sh`, scoped to video UTIs (incl. webm/mkv). Full write-up + the `qa-make.sh` line: [[10-quick-actions|Quick Actions]].

## Future use
Worth adopting: a versioned `~/.config/mpv/` (mpv.conf + input.conf + Lua scripts) checked into the dotfiles for reproducible playback profiles, and `--vf` filtergraphs for on-the-fly preview of crops/scales before committing them to an FFmpeg transcode.

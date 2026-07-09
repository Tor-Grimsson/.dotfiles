---
title: Terminal music — mpd + rmpc
type: reference
status: active
updated: 2026-07-09
description: Play the local music library from the terminal — mpd (Music Player Daemon) indexes and plays, rmpc is the TUI client. Library on a dedicated SSD; mount-guarded launchd agent so mpd only runs while that drive is attached.
aliases:
  - mpd
  - rmpc
  - terminal-music
tags:
  - domain/media
  - pattern/tui
  - integration/brew-formula
links:
  mpd: https://www.musicpd.org/
  rmpc: https://mierak.github.io/rmpc/
covers:
  - mpd.conf pointed at the SSD music library, state kept local
  - The mount-guarded launchd agent (runs only while the drive is mounted)
  - rmpc client + first library scan
related:
  - "[[02-mpv|mpv]]"
  - "[[01-console-map|Google console map]]"
---

# Terminal music — mpd + rmpc

**mpd** (Music Player Daemon) indexes a music folder and does the playback; **rmpc** is the TUI client that drives it (library, queue, search, album art). Daemon + client — they go together. Library lives on a **dedicated SSD** (`kol-ssd-4000`, moved off Jellyfin's 8TB to kill the I/O contention), so mpd runs as a **mount-guarded** launchd agent: up only while that drive is attached, down otherwise (no stale-DB errors).

## Dependencies

| Piece | Does | Needs |
|---|---|---|
| `mpd` | indexes + plays the library, serves on `127.0.0.1:6600` | `brew install mpd`; the `osx` (CoreAudio) output; the drive mounted |
| `rmpc` | the TUI client you actually look at | `brew install rmpc`; mpd running |
| `mpc` *(optional)* | one-shot CLI control (`mpc update`, `mpc play`) | `brew install mpc` — rmpc doesn't need it |

## Files

| File | Role |
|---|---|
| `mpd/mpd.conf` → `~/.config/mpd/mpd.conf` | mpd config (symlinked) — `music_directory`, output, port |
| `rmpc/config.ron` → `~/.config/rmpc/config.ron` | rmpc config (symlinked; keybinds, tabs/layout inc. album-art pane, `theme: "catppuccin"`) |
| `rmpc/themes/` → `~/.config/rmpc/themes/` | theme dir (whole-dir symlink) — holds `catppuccin.ron` |
| `~/.config/mpd/{database,state,sticker.sql,log,playlists/}` | mpd state — **local, untracked** (survives the drive unmounting) |
| `macos/launchd/com.kolkrabbi.mpd.plist` → `~/Library/LaunchAgents/` | the mount-guarded agent (copied, not symlinked) |

## Setup (once per machine)

`bootstrap.sh` does all of this on a fresh machine; to wire it by hand:

```sh
# 1. configs (symlinks) — bootstrap does these; already linked on the iMac
ln -sf ~/.dotfiles/mpd/mpd.conf   ~/.config/mpd/mpd.conf
ln -sf  ~/.dotfiles/rmpc/config.ron ~/.config/rmpc/config.ron
ln -sfn ~/.dotfiles/rmpc/themes    ~/.config/rmpc/themes
mkdir -p ~/.config/mpd/playlists

# 2. load the mount-guarded agent (starts mpd now, since the drive is mounted)
cp ~/.dotfiles/macos/launchd/com.kolkrabbi.mpd.plist ~/Library/LaunchAgents/
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.kolkrabbi.mpd.plist

# 3. first library scan, then browse
rmpc          # press Ctrl-u to scan the library (fast — it's an SSD now), then browse
```

## Commands

| Command | Does |
|---|---|
| `rmpc` | open the client |
| `rmpc` → `Ctrl-u` | rescan the library (needed after adding music — macOS mpd has no filesystem watch) |
| `mpc update` *(if installed)* | rescan from the CLI |
| `launchctl print gui/$(id -u)/com.kolkrabbi.mpd` | agent status (running only while drive mounted) |
| `launchctl kickstart -k gui/$(id -u)/com.kolkrabbi.mpd` | restart mpd (e.g. after a config edit) |
| `tail -f ~/.config/mpd/log` | mpd's log — first stop when something's off |

## Playing — rmpc keys

| Key | Does |
|---|---|
| `p` | play / pause toggle |
| `s` | **stop** |
| `Enter` | play the selected track |
| `>` / `<` | next / previous track |
| `f` / `b` | seek forward / back |
| `.` / `,` | volume up / down |
| `z` `x` `c` `v` | toggle repeat / random / consume / single |
| `1`–`7` | jump to tab (Queue · Directories · Artists · Album Artists · Albums · Playlists · Search) |
| `Ctrl-u` / `Ctrl-U` | update library / full rescan |
| `?` · `:` · `q` | help · command mode · quit |

Also in `keys rmpc` (`keys rmpc transport` / `keys rmpc nav`).

## The mount-guard (why the launchd agent, not `brew services`)

The library is on a removable SSD (`/Volumes/kol-ssd-4000/Music`). The agent's `KeepAlive → PathState` watches `music_directory`: launchd **starts mpd when the drive mounts and stops it when it unmounts** — no manual start, no errors from mpd pointing at a vanished path. On a machine where that drive never mounts (the MBP), the agent simply never runs. `brew services` has no such guard, so it's not used here.

## Notes

- **`auto_update` is off — and can't be on.** macOS mpd (brew) is compiled without inotify/kqueue, so filesystem-watch doesn't work on any drive; it just logs `inotify: auto_update was disabled` and ignores the setting. Rescan after adding music with `Ctrl-u` in rmpc (or `mpc update`). The initial scan happens on first start / on demand regardless.
- **State stays local.** `db_file`/`state_file`/`log`/`playlists` live in `~/.config/mpd/`, never on the library drive — so they persist across unmounts.
- **Moved off Jellyfin's drive.** The library used to sit on the 8TB drive Jellyfin serves; mpd scanning it while Jellyfin read the same spinning disk caused heavy lag. It now lives on a dedicated SSD (`kol-ssd-4000`), so mpd and Jellyfin no longer contend for one head.
- **Theming.** rmpc uses **Catppuccin Macchiato** — `rmpc/themes/catppuccin.ron`, set via `theme: "catppuccin"` in `config.ron`. Ported from the [official theme](https://rmpc.mierak.dev/themes/catppuccin/) onto the version-exact `0.11.0` default (`rmpc theme`) — **colour values only, structure untouched**, so it can't hit an "unknown field" crash the way the dev-docs theme would. Bootstrap another with `rmpc theme > ~/.dotfiles/rmpc/themes/x.ron`, then `theme: "x"`.
- **Album art needs a graphics-capable terminal.** The Queue tab already has an `AlbumArt` pane (`config.ron`), but rmpc paints it via a terminal image protocol (kitty/iTerm/sixel). **iTerm2 inside tmux mangles the escapes → no art + a pegged-CPU render loop that stutters audio.** It renders in a terminal that speaks the kitty protocol (Ghostty/kitty), ideally with rmpc run *outside* tmux.

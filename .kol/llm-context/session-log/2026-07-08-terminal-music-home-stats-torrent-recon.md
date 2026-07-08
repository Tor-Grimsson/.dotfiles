# Session: terminal music (mpd+rmpc) live, home/stats layout split, music→SSD, torrent recon

**Date:** 2026-07-08
**Agent:** Claude (Grim)
**Summary:** Stood up the mpd+rmpc terminal-music stack and got it running; split the tmuxinator `home` into a music `home` + a `stats` cockpit (with a pane-size directive); moved the music library off Jellyfin's 8TB onto a dedicated SSD to kill scan lag; logged rmpc transport controls; and mapped the scattered torrent stack (agreed to build a consolidated guide next).

## Changes Made

### Terminal music (mpd + rmpc)
- Built `mpd/mpd.conf`, `rmpc/config.ron` (captured from `rmpc config`), `macos/launchd/com.kolkrabbi.mpd.plist` (mount-guarded via `KeepAlive→PathState`), bootstrap wiring, doc `06-media-av/08-terminal-music.md`. (Detailed in the prior build; this session activated + tuned it.)
- **Activated:** user loaded the launchd agent; diagnosed the empty-library ("0 songs") as the un-run initial scan, kicked `update` over the MPD socket. rmpc connects on `127.0.0.1:6600`.
- **Transport controls logged** (the gap that bit us): new `## #rmpc #transport` + `## #rmpc #nav` in `keys/keybinds.md` (`s` stop, `p` pause, `> / <` next/prev, `f/b` seek, `./,` vol, `Ctrl-u` update) + a keys table in the terminal-music doc. Corrected earlier bad advice: rmpc's update key is **`Ctrl-u`**, not `U`.

### home → music, stats → monitors
- Rewrote `tmuxinator/home.yml` → `fastfetch` (thin top banner) + `rmpc` (`main-horizontal`). New `tmuxinator/stats.yml` → `command -v mactop && mactop || htop` + `fastfetch` + `yazi` (mactop on Apple-Silicon, htop on Intel — auto-picks).
- `tmux/pane-layout.sh` gained an optional `# main-pane-height/width:` yml-comment directive (tmuxinator + yq ignore it) to size the main pane on the `C-d`/`C-o` paths. `home` banner set to **8 rows** so rmpc dominates.
- Deleted `tmuxinator/test.yml` (tmuxinator's default scaffold sample, unused).
- Docs synced: `18-tui-shell-layout/{02-tmux-dashboards,01-fastfetch-home,INDEX}.md` + `keys` `#tmux #layout`.

### Music library → dedicated SSD
- Moved the library off Jellyfin's external 8TB (spinning USB — mpd + Jellyfin both seeking one head = heavy lag) onto **`/Volumes/kol-ssd-4000/Music`**. Repointed `mpd/mpd.conf` (music_directory), the plist mount-guard (`PathState`), and the doc — no `BISKUP_8TB` left anywhere.
- **`auto_update` stays `no`.** Briefly flipped it to `yes` (SSD, no thrash), but the mpd log corrected me: **macOS mpd (brew) is compiled without inotify** → `auto_update` is a no-op regardless of drive (logs `inotify: auto_update was disabled`). Reverted to `no` in config + doc; rescan is manual (`Ctrl-u`).
- **Activated + verified:** user reloaded the agent (first `bootstrap` EIO'd racing the async `bootout` → re-ran `bootstrap` alone, clean). mpd came up on the SSD and scanned **11,080 songs / 942 albums / 463 artists**; rmpc live and playing.

### Torrent-stack recon
- Mapped the scattered stack: `06-media-av/05-transmission-cli.md`, `scripts/07-torrent.md` (tor-search/tor-jackett), the `torrent` tmuxinator dashboard, Jackett (run via `tor-jackett`, key in vault). **OrbStack is installed + running**; **Prowlarr is not** (no install, no container, no doc).
- Confirmed: `transmission-daemon` is headless (no app needed); it just has to be running for `transmission-remote`/the dashboard. It's not auto-started — that operational gap isn't documented.

## Current State

### Working
- **Terminal music is fully live** — mpd on the SSD (`:6600`), 11,080 songs indexed, rmpc connected + playing. `home`/`stats` layouts build correctly (banner 8-row / player big, verified in throwaway sessions). `keys rmpc` + `keys tmux layout` render. Lag gone (SSD, off Jellyfin's drive).

### Known issues
- macOS mpd has no filesystem-watch → new music needs a manual `Ctrl-u` rescan (documented).

## Next Steps
1. **Build the consolidated "Torrent stack" guide** (agreed) — pipeline (tor-search/Jackett → magnet → Transmission daemon → the `torrent` cockpit), the daemon must-run/auto-start gap, and a **Prowlarr-on-OrbStack** chapter. Parked in `plan.md`.
2. Optionally stand up Prowlarr in an OrbStack container as the Jackett successor.

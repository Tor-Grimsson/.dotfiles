# Session: rmpc Catppuccin theme + audio-glitch root-cause

**Date:** 2026-07-09
**Agent:** Claude (Grim)
**Summary:** Chased a "library won't update / audio glitches" report on the mpd+rmpc stack — the update mechanism was fine, the glitch was iTerm2 pegging a core (not mpd) — then built a version-safe Catppuccin Macchiato theme for rmpc.

## Changes Made

### Files Modified
- `rmpc/themes/catppuccin.ron` — **NEW** (307 lines). Catppuccin Macchiato, **ported from the official dev-docs theme onto the version-exact `rmpc theme` (0.11.0) default** — colour values only, structure untouched, so it can't hit an "unknown field" crash the dev theme would. Palette: base `#24273a`, text `#cad3f5`, header `#1e2030`; accents mauve `#c6a0f6` / lavender `#b7bdf8` / blue `#8aadf4`, artist yellow `#eed49f`.
- `rmpc/config.ron:7` — `theme: None` → `theme: "catppuccin"` (config uses `implicit_some`, so bare string is valid).
- `bootstrap.sh` — rmpc block gained `ln -sfn "$DOT/rmpc/themes" "$HOME/.config/rmpc/themes"` (whole-dir symlink, like fastfetch/tmuxinator).
- `docs/documentation/06-media-av/08-terminal-music.md` — Files table (+themes row, config.ron role reworded), Setup block (+themes symlink line), Notes (Theming rewritten to Catppuccin; new "album art needs a graphics terminal" note), `updated:` 2026-07-08→09.

### Diagnosis (no repo change, but the actual point of the session)
- **Library update works** — triggered `update` over the mpd socket, watched `updating_db: 1`, songs **11080 → 11786 (+706)**; the new `_konsulat-all/**/*.flac` landed. rmpc's Update = `Ctrl-u`, Rescan = `Ctrl-Shift-U`; the library tab just doesn't auto-refresh, and the scan runs in the background.
- **"Only 192 kbps"** was a red herring — rmpc was paused on an old MP3 (`Kraftwerk – Europe Endless.mp3`, 192k) in the queue, not a FLAC. FLAC reports ~900–1400 kbps.
- **Audio glitch root cause = iTerm2 at ~70% CPU** starving CoreAudio's realtime thread. mpd idled at 0.2%, no underruns logged, rmpc 0.0%, tmux 1.3%. Almost certainly rmpc's album-art image escapes mangled by tmux → iTerm spins on the garbage (also why **no** album art renders). Fix = restart iTerm (mpd is a daemon, tmux session survives) → move to a lighter terminal.
- **Album art was already laid out** — `config.ron` Queue tab already has a `Pane(AlbumArt)` (35% left col over Lyrics). Never a layout gap; purely the terminal/tmux image-protocol problem.

### Cleanup
- Killed a runaway `lsof +D /Volumes/kol-ssd-4000` I'd spawned (walking the 4TB drive at ~28% CPU, hammering the same SSD mpd reads) — was making the stutter worse.

## Current State

### Working
- Catppuccin Macchiato theme live on disk, **validated**: `rmpc status` parsed config + theme with no error (0.11.0 would have errored on a bad field). Symlink `~/.config/rmpc/themes` → repo resolves.
- Library current at 11,786 songs incl. the new FLAC batch.

### Known Issues
- The **running** rmpc is still on the old default theme — needs a quit (`q`) + relaunch (or terminal restart) to load Catppuccin.
- **Album art still won't render** in iTerm2-inside-tmux (image escapes mangled) — needs a kitty-protocol terminal (Ghostty/kitty), ideally rmpc run outside tmux. Repo already has a `ghostty/config` + bootstrap block, so Ghostty is half-wired.
- **Visualiser not built** — needs a `type "fifo"` output in `mpd.conf` + a cava pane in the layout. Not started.

## Next Steps
1. Relaunch rmpc to see Catppuccin; ideally do it in **Ghostty outside tmux** so album art renders too.
2. Build the **cava visualiser** — add a FIFO output to `mpd.conf` and a cava pane to the Queue layout.
3. Consider whether to keep chasing album-art-in-tmux (`allow-passthrough on`) or just run rmpc outside tmux.

# mpv config notes

Config lives in `~/.dotfiles/mpv/` (symlinked to `~/.config/mpv/`):
`mpv.conf` (settings) + `input.conf` (keybinds).

## Custom keybinds — `input.conf`

| Key | Action |
| --- | --- |
| `i` | Jump to the **first frame** (`seek 0 absolute frames`) |
| `o` | Jump to the **last frame** / 100% (`seek 100 absolute-percent`) |

These sit on top of mpv's built-in keys (e.g. `space` pause, `←/→` seek, `,`/`.` frame step,
`f` fullscreen, `q` quit).

## Settings — `mpv.conf`

**On-screen / terminal readout**
- `osd-msg1` — replaces the default seek/pause overlay with `FPS | Frame: current / total`.
- `term-status-msg` — terminal line shows `FPS | Time`.

**Quality & performance**
- `profile=high-quality` — mpv's HQ scaling preset.
- `hwdec=auto-safe` — hardware decode when safe, else software.
- `vo=gpu` — GPU video output.

**Window**
- `fs=yes` — start fullscreen.
- `keep-open=yes` — don't close on end of file (holds last frame).

**Playback**
- `save-position-on-quit=yes` — resume where you left off (writes to `watch_later/`, not in git).

**Audio & subtitles**
- `volume-max=200` — allow boosting to 200%.
- `alang=eng,en,jpn,ja` — preferred audio track languages, in order.
- `slang=eng,en` — preferred subtitle languages.
- `sub-auto=all` — auto-load matching external subtitle files.

## Edit configs

```sh
nano ~/.config/mpv/mpv.conf
nano ~/.config/mpv/input.conf
```

Edits land in the dotfiles repo via the symlink. After changing keybinds, restart mpv to reload.

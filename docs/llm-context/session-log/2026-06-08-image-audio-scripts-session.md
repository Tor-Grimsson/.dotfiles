# 2026-06-08 — image + audio scripts (session summary, iMac)

Session capstone: 4 new `bin/` scripts (2 image, 2 audio), a new dep (`yq`), a copy-ready example album folder, and retirement of the stale Brewfile mirror. Per-topic detail in the sibling logs (`-img-from-psd`, `-img-canvas`, `-au-mp3-au-tag`); this is the at-a-glance.

## Scripts added
- `img-from-psd.sh` — PSD(s) → JPG/PNG, optional resize; + Finder Quick Action presets.
- `img-canvas.sh` — fit any image into a fixed social aspect: 7 presets (short side 1080) / raw `WxH` / `-a orig`; `-s 1|2|orig`; modes cover (default) / fit / stretch; `-g` gravity; `-P` GUI pick-dialog for a one-liner Quick Action.
- `au-mp3.sh` — recursive WAV/AIF/AIFF → MP3 (CBR `-b` 128/160/192/320, default 320), parallel, **keeps the lossless source**.
- `au-tag.sh` — sidecar-`.md` YAML frontmatter (via `yq`) → ID3/Vorbis tags + embedded front cover into mp3/flac (ffmpeg `-c copy`); titles from `tracklist[]` or filename; cover auto-detect (folder then `_assets/`); lean downscaled embed (`-s`, default 1000px, source untouched).

## Repo / deps
- New dep **`yq`** (mikefarah) added to `Brewfile` after `jq`; user installed. `bootstrap.sh` unchanged — `brew bundle` covers it.
- **Deleted `Brewfile-mirror.txt`** (stale; ARCHITECTURE §2 had already retired it) and removed the obsolete `feedback_brewfile_mirror` memory (file + MEMORY.md line).
- Example folder `docs/12-scripts/_files/au-tag-example/`: `album.md` (real au-tag frontmatter, no `cover:` to demo auto-detect) + `_assets/cover.jpg` (user's actual release art, 1500²).

## Docs
- `03-image.md` & `01-audio.md`: table rows + per-script sections. Companion deep-dives `img-from-psd.md`, `img-canvas.md`, `au-tag.md`. `10-quick-actions.md`: PSD/canvas examples + bare-PATH note. INDEX counts: img 7 → 9, au 1 → 3.

## State
- All scripts verified by real runs (ffprobe / `magick identify`): exact dimensions/bitrates, sRGB, tags + embedded cover, lean-embed sizing, `_assets/` auto-detect.
- Quick Actions use a both-brew-prefixes PATH export (cross-arch; a deliberate, flagged bend of ARCHITECTURE §1 because Automator's bare PATH defeats §1's escape hatches).
- No open issues. User moved the leftover root cover JPG out themselves.

## Next
- Nothing required. Optional: stamp the documented Quick Actions live with `qa-make.sh` (commands in the companion docs). User owns git; nothing committed.

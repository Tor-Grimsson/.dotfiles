# Session: Claude statusline, img-export tooling (-c/-e + img-from-video.sh), AeroSpace doc fixes, tmux F/G real bugfix

**Date:** 2026-07-03
**Agent:** Grim (Claude Sonnet 5, `~/.dotfiles`)
**Summary:** Built a repo-owned Claude Code statusline (badge + model + cwd + context% + token usage + 5h/7d rate-limit reset), gave `img-convert.sh`/`img-canvas.sh` real PNG compression (`-c` quantize) and guaranteed-exact-dimensions (`-e`) flags, added a new `img-from-video.sh` script, fixed two real bugs found via user reports (AeroSpace service-mode key mislabeled in docs, and a real tmux `swap-window`-vs-`move-window` bug that scrambled window order), and closed out several documentation gaps (nvim command-line history, cheatsheet Scripts section).

## Changes Made

### Files Modified
- `tmux/.tmux.conf` — `prefix c` (new window) now chains `swap-window -t -1` so a window pinned to the last slot via `prefix G` stays there through subsequent window creation. **Later found `F`/`G` themselves had a real bug**: they used `swap-window -t "{start}"/"{end}"`, which is a 2-window trade — fine for adjacent `N`/`P`, but for `F`/`G` (which can jump across several windows) it scrambled the relative order of everything in between. Fixed by switching to tmux's separate `move-window -b/-a -t "{start}"/"{end}"` command, which does a true relocate (shifts intervening windows back by one, preserves their order) — verified on an isolated `tmux -L` socket in both directions before touching the real config.
- `claude/hooks/statusline.sh` — **new file**. Combines the ponytail mode badge (mirrored, not sourced, from the plugin's own script) with model name, cwd, context-window %, token usage, and 5h/7d plan rate-limit quota + reset time. Found and fixed a real bug in the reset-time formatting: it fed a raw ISO8601 timestamp straight into bash arithmetic / `date -r`, which need epoch seconds — fixed via `jq`'s `fromdateiso8601`. Verified with real and edge-case (missing fields, malformed timestamp) stdin payloads.
- `claude/settings.json` — `statusLine.command` repointed from the ponytail plugin's own script to the new repo-owned one.
- `bin/img-convert.sh` — new `-c COLORS` flag (PNG palette quantization, no dithering — dithering was found to error-diffuse past the requested count, which can blow past PNG's 256-entry palette cap and silently kill the size win); new `-e` flag (forces the literal `WxH` from `-r`, cropping overflow / padding shortfall via `-gravity center -extent`, fixing a real user-hit case where plain fit-resize landed 1px short of a requested target); unconditional `-strip`. Both new flags cross-verified against the user's real 1854×2316 PNG.
- `bin/img-canvas.sh` — same `-c` quantization flag added, mirroring `img-convert.sh`'s mechanism, for consistency across the `img-` family.
- `docs/09-productivity-desktop/05-aerospace.md` + `docs/00-kol-cli/01-cli-cheatsheet.md` — fixed a real docs bug: service-mode's float/tile toggle is the bare key `f`, but both docs showed capitalized `F`, implying Shift. User hit this directly — `Shift+F` collides with the *main-mode* `Alt+Shift+F` (throw window to workspace **F**), which relocates the active window rather than toggling float, and reads as "the other window got killed" since the remaining one expands to fill the screen. Also fixed the same case-mislabel on `R`/`r`. Added an explanatory note in both docs. Also converted the cheatsheet's Service-mode line from dense prose to a table, matching the rest of the document's convention (user's ask, after noting the inconsistency).
- `docs/00-kol-cli/01-cli-cheatsheet.md` — new §6 "Scripts" additions: `img-canvas.sh` row, `-e` flag on `img-convert.sh`/`img-from-video.sh`, an `-e` + `/export-specs` example pair (real numbers — `1080x1350` for 4:5@1x — pulled from `claude/skills/export-specs/SKILL.md`, not the arbitrary `1600x2000` used earlier in the conversation), and a `-c` vs `-q` explainer + a measured quantization-floor table (256→8 colors, sizes, visible-loss verdicts) from real testing. Also added Neovim command-line history (`↑`/`Ctrl-p`, **`q:`** command-line window) to the Find/filter/replace table, and established a "bold the key itself" convention for emphasizing high-value bindings in dense tables (applied to `q:`).
- `docs/04-dev-languages/11-neovim-cheatsheet.md` — added the same command-line-history explanation (beginner-phrased) after the Save & quit section — this was a genuine gap, not documented anywhere before.
- `docs/12-scripts/img-convert.md` — new §4 (PNG compression: why `-q` barely moves PNG, the real `-c` lever, measured 70-90% size cuts, why no dithering); `-e` explanation added to §3 (why plain fit-resize can land 1px short, and how `-e` fixes it — same cover+crop mechanism as `img-canvas.sh`, exposed as a flag instead of a separate tool); verification entries for both.
- `docs/12-scripts/img-canvas.md` — new §4 (PNG quantization via `-c`, with the measured quality-floor table); renumbered §4/§5 → §5/§6 accordingly; reciprocal link to `img-convert.md`.
- `docs/12-scripts/img-from-psd.md` — reciprocal link to the new `img-from-video.md`.
- `docs/12-scripts/03-image.md` + `docs/00-kol-cli/03-scripts.md` + `docs/12-scripts/INDEX.md` — catalog entries updated/added for `-c`/`-e` on existing scripts and the new `img-from-video.sh` (INDEX img family count 10→11 — `03-scripts.md` was found to be missing `img-from-video.sh` entirely, a real pre-existing gap, now closed).
- `docs/01-shell-terminal/09-tmux-tips.md` — updated the `N`/`P`/`F`/`G` explanation to describe the `swap-window` (adjacent, `N`/`P`) vs `move-window -b/-a` (`F`/`G`, preserves in-between order) distinction.

### Files Added
- `bin/img-from-video.sh` — grabs a single frame from a video (ffmpeg decode, since ImageMagick's own video delegate is broken/unreliable on this machine — confirmed via a direct error) as JPG/PNG. `-t` is dual-mode: a bare integer is a 1-based **frame number** (exact, ffmpeg `select` filter, decodes from start — user explicitly wanted this over "seconds"), `HH:MM:SS`/decimal is a **timestamp** (fast keyframe-seek). Also gained `-e` (same exact-dimensions mechanism as `img-convert.sh`). Bug found and fixed during testing: an out-of-range frame/timestamp produced a cryptic ImageMagick "file not found" instead of a clear message — now checks the ffmpeg output before proceeding.
- `docs/12-scripts/img-from-video.md` — companion deep-dive, same shape as `img-from-psd.md`.

## Current State

### Working
- Statusline is live (confirmed via manual reload) and verified end-to-end with real and synthetic stdin payloads.
- `img-convert.sh -c` / `-e`, `img-canvas.sh -c`, and `img-from-video.sh` (both `-t` modes and `-e`) are all verified against real files from the user's Downloads folder, not just synthetic tests.
- tmux `F`/`G` re-verified correct on an isolated socket after the `move-window` fix; user has not yet reloaded/confirmed live.

### Known Issues
- **Outstanding, not yet actioned:** a proposal to update `docs/04-dev-languages/13-ponytail.md`'s stale "statusline badge" description (it still describes the plugin's own script, not the new repo-owned `claude/hooks/statusline.sh`) was made and never confirmed by the user — conversation moved on to AeroSpace before a yes/no. Pick this up next time `claude/` docs come up.
- AeroSpace's native-tab "empty space" issue (macOS API limitation, not fixable in AeroSpace) — a `defaults write AppleWindowTabbingMode` fix was offered but not added to `macos/defaults.sh`. Only worth doing if the user actually wants it disabled.
- `claude/hooks/statusline.sh` has no session cost ($) figure — the installed Claude Code version's stdin schema doesn't expose one (replaced by `context_window` token counts). Not a bug, just a schema constraint.

## Next Steps
1. User reloads tmux (`prefix r`) and statusline (new Claude Code session) to confirm both fixes are live as tested.
2. Decide on the `13-ponytail.md` doc update (see Known Issues).
3. If image-export work continues, the `-c`/`-e` pattern is now consistent across `img-convert.sh` and `img-canvas.sh` — extending it to any future `img-`/`vid-` script should follow the same shape.

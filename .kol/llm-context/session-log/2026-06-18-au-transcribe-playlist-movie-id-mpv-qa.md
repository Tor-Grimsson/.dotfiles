# Session: au-transcribe-playlist + movie-ID, and the "Open in mpv" Quick Action

**Date:** 2026-06-18
**Agent:** Claude (Grim)
**Summary:** New `au-transcribe-playlist.sh` (playlist/collection → sequential transcripts), a `-M` movie-identifier and `-c` cookie auth added to `au-transcribe.sh` (+ a TikTok audio-format fix), plus an "Open in mpv" Finder Quick Action and its catalog docs.

## Changes Made

### Files Created
- `bin/mpv-open.sh` — mpv twin of `glow-open.sh`: opens a new iTerm/Terminal window and plays a file with `mpv` (login-shell PATH). Engine for the Quick Action; works standalone.
- `macos/services/Open in mpv.workflow` — stamped via `qa-make.sh`, scoped to video UTIs (`public.movie`, `public.audiovisual-content`, `org.webmproject.webm`, `org.matroska.mkv`), symlinked into `~/Library/Services`, `pbs`-flushed.
- `bin/au-transcribe-playlist.sh` — expands a playlist/profile/collection URL (`yt-dlp --flat-playlist --print url`) and loops `au-transcribe.sh` over each entry **sequentially**. Flags `-m -l -o -n(limit) -c(cookies) -M(movie-id) -k`; forwards them to the per-entry call. bash-3.2-safe (no `mapfile`; `${arr[@]+…}` guards). Resolves its sibling transcriber via `dirname`, PATH fallback.

### Files Modified
- `bin/au-transcribe.sh` — three additions:
  - `-M` **movie-ID**: when set, adds `--write-comments` to the fetch, then feeds caption + top-30 comments (ranked by like_count via jq) + the whisper transcript to the `llm` CLI; writes a `movie:` frontmatter field + a `## Movie ID` section. Parser strips any markdown heading the model wraps the title in. Best-effort, answers `UNKNOWN` when unsure. Needs `llm` (uv tool); model override `$AU_LLM_MODEL`. Degrades gracefully if `llm` absent or errors.
  - `-c BROWSER` **cookie auth**: passes `--cookies-from-browser` to the fetch for login-gated URLs.
  - **format-selector fix**: `-f 'bestaudio/best'` → `-f 'bestaudio/download/best'`. TikTok mislabels some video-only formats as carrying `aac`; `best` was grabbing the high-bitrate `bytevc1` stream which came down **video-only**, so ffmpeg got no audio and ~50% of clips skipped. `download` is TikTok's muxed source format (reliable audio). YouTube still hits `bestaudio` first — no regression.
- `bin/au-transcribe-playlist.sh` — 0-entry error now hints "try `brew upgrade yt-dlp`" / cookies (the confusing TikTok-collection failure mode).
- `docs/12-scripts/10-quick-actions.md` — *Open in mpv* preset row + note + `qa-make.sh` recipe + `[[02-mpv]]` related (updated 2026-06-17).
- `docs/12-scripts/INDEX.md` — wired-Quick-Actions line += *Open in mpv*.
- `docs/06-media-av/02-mpv.md` — new "Finder Quick Action" section + reciprocal `related` to `[[10-quick-actions]]`.

## Current State

### Working
- **Verified end-to-end on the real `plexit` collection** (`@kolkrabbi_/collection/plexit-…`): expand → fetch (+comments, firefox cookies) → whisper → `llm` movie-ID → markdown note. 8-clip sample after the selector fix = **8/8, 0 skips**; movie-ID ~63% identified (Uncut Gems, Under the Silver Lake, TRON: Legacy, …), honest `UNKNOWN` on non-movies (Dharmann skits).
- **Full 894-clip run launched in the background** (`-c firefox -M`, `nohup`, sleep-guarded by `caffeinate`), writing to `~/Desktop/plexit/` (runtime output, **outside the repo**). ~1% skip rate. ETA ~7–9 h. A background watcher will ping on the `done —` summary.
- "Open in mpv" Quick Action live + catalog docs landed.

### Known Issues / gotchas discovered
- **TikTok collections need both a current yt-dlp AND browser cookies.** The shipped `tiktok:collection` extractor returned "Downloading 0 items" on `2026.03.17`; `brew upgrade yt-dlp` → `2026.06.09` still returned 0 — it needs `--cookies-from-browser firefox` (user's logged-in browser) to populate the list. Profile (`tiktok:user`) worked without cookies. (Chrome cookie extraction failed on this box; **firefox works**, 1695 cookies.)
- **No resume in `au-transcribe-playlist.sh`** — a mid-run death re-transcribes from clip 1 and makes `-2` duplicate `.md`s (au-transcribe dedups filenames, doesn't skip done URLs). Risk on the 894 run.
- **Cost split** (user asked): whisper is local/free; `-M` is the only spend — ~894 Anthropic **API** calls on haiku (~$2), billed to `llm`'s keystore, **separate** from the Claude Code subscription. `ANTHROPIC_API_KEY` is **not** env-exported here (AGENT-CONTEXT's old "~/.secrets has the key on the iMac" note is stale — `llm` auths from its own keystore), so Claude Code bills the subscription normally.

## Next Steps
1. **Catalog the au- additions** (deferred): `au-transcribe-playlist.sh` + the `-M`/`-c` flags + the still-uncataloged `au-transcribe-ss.sh` (au- family 4→6). Needs companion docs in `12-scripts/` + rows/`related` in `06-media-av`, and a note that `-M`/`-d` depend on the `llm` CLI (uv tool, not the Brewfile).
2. **Optional: add resume/skip-existing** to `au-transcribe-playlist.sh` before any future large run.
3. **Optional accuracy bump**: relaunch with `AU_LLM_MODEL=anthropic/claude-sonnet-4-6` to convert some of the ~37% `UNKNOWN`.
4. **Unrelated, flagged not fixed:** `claude/skills/init-agent-context/SKILL.md` lines 28/50 reference a non-existent `src/_framework/` subpath (the `kol-docs-framework` package is flat); the `cp` command is correct, only the prose is wrong.

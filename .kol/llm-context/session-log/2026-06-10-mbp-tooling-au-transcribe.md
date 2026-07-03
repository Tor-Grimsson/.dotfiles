# Session: MBP tooling — machine detection, dust/yt-dlp, fe, au-transcribe.sh (whisper wired)

**Date:** 2026-06-10
**Agent:** Claude Code (Grim), MBP
**Summary:** Added machine self-detection to the boot protocol, tracked dust + yt-dlp, added an fzf→nvim `fe` function, and built `au-transcribe.sh` (URL/file → markdown transcript) — which finally wires up whisper-cpp, verified on a real TikTok. Plus a tmux Shift+Enter passthrough fix.

## Changes Made
- **Boot protocol** — `uname -m` machine detection prepended to `.claude/skills/init-agent/SKILL.md` (+`Bash` in allowed-tools) and `LLM_RULES.md`. Boot now names iMac/MBP and never asks.
- **Brewfile** — `+ brew "dust"` (modern `du`), `+ brew "yt-dlp"` (downloader, was installed but untracked). User ran `brew bundle`; both **verified present** on the MBP.
- **Catalog** — new `02-file-management/14-dust.md` + `06-media-av/07-yt-dlp.md`; reciprocal `related:` (tree↔dust, whisper↔yt-dlp); root INDEX 66→68, cat 02 12→13, cat 06 6→7; 06 index intro/date.
- **shell/.zshrc** — `fe` function: `fd` → fzf (bat preview) → open the pick in nvim; optional arg prefilters.
- **bin/au-transcribe.sh** (NEW, au- 3→4) — URL (yt-dlp) or local media → `<slug>.md`: yt-dlp metadata/caption as frontmatter + `whisper-cli` transcript body; ffmpeg 16 kHz mono wav; auto model download to `~/.cache/whisper` (default `base`); `## Caption` omitted when identical to the title. Companion playbook `12-scripts/au-transcribe.md` + real example `_files/au-transcribe-example.md`. Cross-refs in yt-dlp / whisper-cpp / `02-video`. **whisper-cpp now wired** (closes the 'unwired' flag).
- **tmux/.tmux.conf** — `set -g extended-keys on` + `set -as terminal-features 'xterm*:extkeys'` so Shift+Enter passes through tmux to Claude Code (it was being flattened to a plain Enter → submit).

## Current State
- dust + yt-dlp present on the MBP (verified `command -v`). au-transcribe runs now (ffmpeg/whisper-cli/jq/yt-dlp all present); `ggml-base.bin` cached. Proven end-to-end on a real TikTok.
- Catalog counts/links consistent for every touched category. `zsh -n` and isolated-socket `tmux` parse both clean.

## Next Steps
1. Reload tmux to activate Shift+Enter: `prefix r` (or `tmux source-file ~/.tmux.conf`); run Claude Code's `/terminal-setup` in iTerm2 if Shift+Enter still submits.
2. On the next commit + dot-sync, the **iMac** gets all the repo content; it will need its own `brew bundle` to install dust/yt-dlp there (not verifiable from the MBP — check on the iMac).
3. Optional: pull the `large-v3` whisper model (`-m large-v3`) for hard non-English source audio.

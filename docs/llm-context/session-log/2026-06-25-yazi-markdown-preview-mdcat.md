# Session: yazi Markdown preview → mdcat (glow evaluated, then superseded)

**Date:** 2026-06-25
**Agent:** Grim (Claude Opus, `~/.dotfiles`, iMac)
**Summary:** Gave yazi a real rendered-Markdown preview. Wired glow first (patched its stale plugin for the yazi 26 API, fenced frontmatter, custom style), then A/B'd it against **mdcat** — mdcat won (clean headings, no `##` markers, frontmatter shown, inline iTerm2 images), so mdcat is now the `.md` previewer via a hand-written plugin. The **glow binary stays installed** (scripts + Quick Actions use it) but is no longer wired into yazi. New Brewfile dep: **mdcat**.

## Changes Made

### Files Modified
- `yazi/yazi.toml` — `[preview] wrap = "yes"` (text/code previews wrap instead of truncating); new previewer rule `{ url = "*.{md,markdown}", run = "mdcat" }` (matched by extension — yazi tags `.md` as `text/plain`, so mime won't catch it).
- `yazi/keymap.toml` — new `M` key: `shell 'mdcat -p "$@"' --block` → full-screen mdcat (pager + inline iTerm2 images), `q` returns.
- `Brewfile` — `+ brew "mdcat"`; glow comment retargeted to "scripts + Quick Actions".
- `docs/02-file-management/02-yazi.md` — preview-deps row (mdcat), plugins table row (mdcat), config-files, custom-keys (`M`), maintenance note (mdcat plugin internals + glow-kept rationale), plugin count 3→4, `updated: 2026-06-25`.

### Features Added/Removed
- **Added:** `yazi/plugins/mdcat.yazi/main.lua` — hand-written previewer. Runs `mdcat --ansi --local --columns <pane-width>`: `--ansi` forces formatting through the pipe (no TTY), `--local` skips remote image fetches so the preview never stalls. 2-col left/right margin via `job.area:pad(ui.Pad.x(2))` (tune the `pad` local; mdcat has no margin flag). Correct yazi 26 API (`ya.preview_widget`, `ui.Text.parse`, `ya.emit`, scrolling via skip/limit).
- **Removed (dead once glow stopped being the previewer):** `yazi/plugins/glow.yazi/` and `yazi/glow-style.json`, plus the `Reledia/glow` entry in `package.toml`. Glow **binary** untouched. All in git history if the glow previewer is ever wanted back.

## Current State

### Working
- yazi renders `.md` through mdcat in the preview pane (verified live by the user — "bjutiful").
- `M` opens the current `.md` full-screen in mdcat.
- glow binary still present for scripts/Quick Actions.

### Findings / gotchas
- The vendored `Reledia/glow` plugin (rev `bd3eaa5`) predated yazi 26's API renames — three crashes in sequence (`:args`→`:arg`, `ya.mgr_emit`→`ya.emit`, `ya.preview_widgets(job,{w})`→`ya.preview_widget(job,w)`). Confirmed the correct names by grepping yazi's own binary, not guessing. This is why a hand-written mdcat plugin (no `ya pkg` upgrade churn) was preferred.
- mdcat as a previewer needs `--ansi` (it downgrades formatting when stdout is a pipe) and `--local` (don't fetch remote images mid-preview).
- mdcat renders YAML frontmatter as a rule + text (doesn't strip it like glow does) — no awk-fence workaround needed.
- The Bash sandbox aliases `cat`→`bat`; heredoc `cat > file` hangs. Use the Write tool or `printf` for temp files.
- **Catalog count unchanged** — mdcat is a yazi preview backend documented inside `02-yazi.md` (same treatment as glow), not a standalone catalog entry.

## Next Steps
1. **Both machines:** `brew bundle` to install `mdcat` (per the no-provisioning rule — user runs it). Until then the `.md` previewer + `M` key error.
2. **MBP:** still carries the open iTerm `MesloLGS NF` → `MesloLGS Nerd Font` font swap from 2026-06-24 (unrelated to this session).

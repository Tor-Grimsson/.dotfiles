# Session: bootstrap-cli split + install resilience + reply-format overhaul

**Date:** 2026-07-05
**Agent:** Claude (Opus 4.8, 1M)
**Summary:** Split the installer into a standalone CLI-only `bootstrap-cli.sh` (which `bootstrap.sh` now sources), made both installers skip-and-log instead of abort-on-first-failure, documented the repo itself under a new `docs/21-dotfiles/` category, and overhauled the reply-format rules in `CLAUDE.md` (git-status folded, tables-first, and a fenced header-card opener) with its mirror docs synced.

## Changes Made

### Files Modified
- `bootstrap-cli.sh` — **new.** CLI toolchain + `$HOME`/`~/.config` symlinks only; safe to run standalone on a foreign/SSH box (no `defaults`, no GUI, no launchd, no Quick Actions). Installs brew (`brewfile-cli`) **plus** the pipx/uv CLIs the dotfiles depend on: `pipx install edge-tts`, `uv tool install llm --with llm-anthropic`, `uv tool install pdf2image`. Symlinks shell/git/bin/tmux(+TPM)/claude+packages/nvim/yazi/broot/glow/mpv.
- `bootstrap.sh` — refactored to `source "$DOT/bootstrap-cli.sh"` first, then only the GUI/macOS remainder (gui brewfile, VS Code, iTerm, Terminal, aerospace, gcalcli, Quick Actions, launchd, MCP, plugins, `defaults.sh`). No duplication; mirrors the `brewfile-cli`/`brewfile-gui` split.
- **Resilience (both scripts)** — dropped `set -e`; added `FAILED[]` + `note_fail()` + `summarize()`. Every install step (brew/pipx/uv/TPM/claude) records failures instead of aborting; brew failures are parsed **by formula name** from captured output; an end-of-run summary lists what didn't install (`⚠`/`✓` glyphs via `printf`, bash-3.2-safe).
- `docs/21-dotfiles/` — **new category** (Systems): `INDEX.md`, `01-repo-model.md` (symlink source-of-truth model, two machines, tracked-vs-runtime), `02-provisioning.md` (CLI-vs-GUI split, foreign-box quickstart, plugin hydration).
- `docs/INDEX.md` — Systems row **21** added; date bumped.
- `claude/CLAUDE.md` — **Report shape** rewritten: (1) git/provisioning status is not a talking point (footer token `git: untouched` at most, never prose); (2) tables/checkboxes first for parallel facts; (3) **fenced header-card opener** — date + 2-blank/2-rule/2-blank breather + title, all in ONE ``` fence, title as the last line inside it; (4) **footer is ONE line always ending in `say "show noise" to expand`** (the expand handle, mandatory — kept getting dropped), and session-log + AGENT-CONTEXT writes fold to a **`llm/context: N`** token (N = files touched) — never a prose "Session log created at …" restatement line.
- `docs/16-claude-agents/07-output-formats.md` — **new.** Reply skeleton (fenced header card) + named-layout gallery (one-liner / build-report / findings / recommendation / staged) + a "whitespace & separators" section explaining why the header must be fenced.
- `docs/16-claude-agents/05-working-rules.md` + `06-claude.md` — synced to the new Report-shape rules (row/section rewrites, change-log entry, reciprocal `related:` → 07, dates); `INDEX.md` row 07 added.
- Memory `feedback_sync_doc_on_source_edit` (+ MEMORY.md pointer) — editing a tracked file with a catalog doc means syncing that doc same-change.

### Features Added/Removed
- **Added:** `bootstrap-cli.sh` (foreign-box installer), install-failure resilience across both installers, `docs/21-dotfiles/` repo self-documentation, `07-output-formats.md`, the fenced header-card reply opener.

## Current State

### Working
- Both scripts `bash -n` clean; failure-summary parser + glyph render verified via simulation.
- `workmux` confirmed already installed (`brew install raine/workmux/workmux`), so `brew bundle` reports it up-to-date — no summary entry.
- The fenced header-card opener is confirmed rendering correctly in the user's terminal (breather above **and** below the rule lines) after a live back-and-forth.

### Known Issues
- **`uv tool install pdf2image` unverified** — pdf2image is a library and may have no CLI entry point; the command is guarded with `|| note_fail` so it can't abort, but it may not install usefully. The repo documents it as uv-tool-managed; if wrong, the real form is `uv pip install` into a venv.
- **Claude Code `curl | bash` install lives in `bootstrap-cli.sh`** (treated as a CLI tool). Flagged to the user; move to `bootstrap.sh` if auto-installing claude on a foreign box is unwanted.
- Nothing run/committed — the user provisions + owns git.

## Next Steps
1. Real run of `bootstrap-cli.sh` on the remote/SSH box; confirm the skip-and-log summary behaves (e.g. an unreachable tap is reported, symlinks + pipx/uv still run).
2. Resolve the `pdf2image` install form.
3. Live the fenced header-card format for a bit; adjust the gallery in `07-output-formats.md` if new layouts recur (e.g. an error/blocked-state card).

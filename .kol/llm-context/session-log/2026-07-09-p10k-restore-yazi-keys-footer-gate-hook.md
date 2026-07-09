# Session: p10k restore + yazi keys section + footer-gate Stop hook

**Date:** 2026-07-09
**Agent:** Claude (Grim)
**Summary:** Restored Powerlevel10k as the active prompt (starship parked as a one-line flip), added a full `#yazi` block to the `keys` reference, and upgraded the report-shape reinforcement from a soft reminder to a hard **Stop-hook gate**.

## Changes Made

### Prompt: Powerlevel10k restored (starship parked)
- `shell/.zshrc` — p10k **instant-prompt** block re-added at the very top; bottom prompt block now sources `$HB/share/powerlevel10k/powerlevel10k.zsh-theme` + `~/.p10k.zsh`; the starship `eval` line is **left in place but commented** (one-line flip to switch back). `ZSH_THEME=""` comment updated. `zsh -n` clean.
- `brewfile-cli` — `powerlevel10k` added back (active); `starship` line reframed as the parked alternate (kept installed).
- No bootstrap change — `bootstrap-cli.sh:90` already symlinks `.p10k.zsh`; `~/.p10k.zsh` + `~/.config/starship.toml` symlinks both live. p10k was always sourced from brew (omz custom has no p10k theme), so this reconstructs the pre-switch wiring exactly.

### `keys` reference: yazi section
- `keys/keybinds.md` — new `#yazi` block (9 subtopics: `#ops #select #nav #copy #find #sort #view #tabs #shell`) covering the whole `[mgr]` explorer, pulled verbatim from `yazi/keymap.toml` (customs incl. gD/g./gt/gp, C-y Quick Look, M mdcat, T preview-max). Honest notes: **duplicate** = `y` then `p` in same dir (no native cmd); **move** = cut `x` then `p`. Verified `keys yazi` + `keys yazi ops` + `keys yazi copy` all filter correctly.

### Reinforcement: soft reminder → hard Stop gate
- **NEW `claude/hooks/footer-gate.sh`** (Stop hook) — reads the last assistant message from the transcript and **blocks** (forces re-emit) when the trailing ~8 lines break the footer rule: content after the footer, a trailing offer, or a bare status/recap line ("X untouched", "created/updated at", "session log written") outside the footer. Loop-safe (`stop_hook_active`), fail-open, exempts one-liners + the footer line itself.
- `claude/settings.json` — wired the `Stop` → footer-gate hook (JSON re-validated).
- `claude/hooks/reinforce-full.txt` + `reinforce-compact.txt` — rewritten to lead with a loud "END AT THE FOOTER / fold-or-delete" rule in the user's words.
- `claude/hooks/agent-reinforce.sh` — compact-reground cadence tightened **5 → 3** turns.
- `docs/operations/02-claude-agents/04-hooks-and-tools.md` — synced (footer-gate added to hooks list + settings table, cadence 5→3, `updated` 2026-07-09).

### Docs synced (prompt swap)
- `01-shell-terminal/03-powerlevel10k.md` — `archived → active`, callout + "why" reversed.
- `01-shell-terminal/27-starship.md` — reframed parked alternate (kept `status: active`; `archived` would misread it as dead), callout + activation row note it's commented.
- `01-shell-terminal/INDEX.md` — rows swapped: p10k active, starship alternate.

## Current State

### Working (validated)
- `zsh -n` clean on `.zshrc`; p10k theme present at `$(brew --prefix)/share/powerlevel10k/…`; `~/.p10k.zsh` symlink live.
- `keys yazi` + 2 subtopic filters render.
- footer-gate: 6/6 synthetic transcripts correct (clean pass, after-footer block, trailing-offer block, screenshot status-line block, one-liner exempt, loop-guard pass); no false-positive on `git: untouched` inside the footer.
- `settings.json` valid, `Stop` hook present.

### Known Issues / needs reload
- **p10k goes live on `exec zsh`** (first shell rebuilds the instant-prompt cache — one-time).
- **footer-gate goes live on the next Claude Code restart** — hooks load at session start, so this session still ran the old wiring.
- MBP: `brew bundle` needed if p10k isn't already installed there (it's back in `brewfile-cli`).

## Next Steps
1. Reload to verify: `exec zsh` (p10k prompt) + restart Claude Code (footer-gate active).
2. Still open from prior sessions: **SketchyBar** still Catppuccin Mocha (not swept to Gruvbox); decide whether to delete dead `shell/.p10k.zsh`… (no longer dead — it IS the config now); cava visualiser, Torrent guide (`plan.md`).

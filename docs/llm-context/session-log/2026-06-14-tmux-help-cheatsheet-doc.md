# 2026-06-14 (iMac) — tmux help & cheat-sheet doc + vi-mode "staleness" cleared up

Started as three tmux questions; ended with a new practical cheat-sheet doc. The "tmux docs are stale, they mention vi mode" report was a false alarm — the docs' "vi" references are all **copy-mode-vi** (`mode-keys vi`, live in `tmux/.tmux.conf:81`), not the reverted *shell* vi-mode (`bindkey -v`, killed 2026-06-12). Two different things; nothing to revert. The real gap was discoverability: the docs never led with tmux's own help commands.

## Done
- **New guide `docs/01-shell-terminal/10-tmux-help.md`** — a quick-reference card that **leads with the built-in help commands** (`prefix ?`, `prefix :`, `man tmux`, `tmux list-keys`/`lsk`, `tmux list-commands`/`lscm`, the mistyped-command usage-line trick, plus `tmux lsk | grep …` to find a binding). Then tight key tables (sessions / windows / panes / copy mode) and five practical workflows (persistent SSH session, edit+run splits, grab-old-output via copy-mode search, `synchronize-panes`, reload). Tuned to this repo's `~/.tmux.conf`; defers the full copy-mode walkthrough to `09-tmux-tips.md` so the two don't duplicate.
- **Routing:** added to the category INDEX `## Guides` line (above the tips entry).
- **Reciprocal `related:`** links added in `02-tmux.md` and `09-tmux-tips.md` (sibling cross-refs in both files, per convention).

### Files Modified
- `docs/01-shell-terminal/10-tmux-help.md` — **new** (the cheat sheet).
- `docs/01-shell-terminal/INDEX.md` — Guides line += tmux-help.
- `docs/01-shell-terminal/02-tmux.md` — `related:` += `[[10-tmux-help]]`.
- `docs/01-shell-terminal/09-tmux-tips.md` — `related:` += `[[10-tmux-help]]`.

## Not a problem (clarified, no change)
- The tmux docs' "vi" mentions = **copy-mode-vi** (scrollback navigation), still set and correct. Not the reverted shell vi-mode. No staleness.
- tmux has **90 commands / 275 default bindings**; the docs cover ~the keys actually used. That curation is deliberate — the full set is one `prefix ?` / `man tmux` away.

## Catalog math
- tmux-help is a **guide, not a tool** → routed via the INDEX Guides line; catalog count **unchanged at 68 / 13**. Category 01 now 8 tools + 2 guides.

## Next / open
- Nothing pending from this work. (User owns git — commit + dot-sync carries the new doc to the MBP.)

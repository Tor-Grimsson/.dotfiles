# 2026-06-14 (iMac) — tmux pane-layout section in the tips doc

Added a prominent **Pane layouts** section to `09-tmux-tips.md` covering `select-layout` / `prefix space` and the five presets. Corrected two errors in the source the user pasted: `even-horizontal`/`even-vertical` were swapped (horizontal = equal width side-by-side, vertical = equal height stacked), and `main-pane-height` was mislabelled as "set a default layout" — it only sizes the main pane the `main-*` layouts use.

## Done
- **New `## Pane layouts` section** in `docs/01-shell-terminal/09-tmux-tips.md` — intro (names describe spread direction, not split lines), a 5-row layout table (even-horizontal / even-vertical / main-horizontal / main-vertical / tiled), `prefix space` + `select-layout` key/shell snippets, and a "sizing the main pane" note (`main-pane-width`/`-height`, set-then-select, `set -wg …` in `~/.tmux.conf`).
- Reworded the existing Pane-tricks `prefix space` line to point at the new section instead of the inline `(even-horizontal, tiled, …)`.
- Bumped frontmatter `updated:` 2026-06-10 → 2026-06-14.

## Catalog math
- Edit to an existing **guide** — no new file, no INDEX/`related` change. Catalog unchanged at **68 / 13**.

## Next / open
- Nothing pending. (User owns git — commit + dot-sync carries it to the MBP.)

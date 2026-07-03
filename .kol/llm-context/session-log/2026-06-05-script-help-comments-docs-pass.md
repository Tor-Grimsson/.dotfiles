# 2026-06-05 — `--help` + comments + docs across every bin script

Universal pass: every script in `bin/` now answers `--help`/`-h` with a proper `usage()` block, carries earnest inline `#` comments, and has a detailed write-up in its family doc. Done via 6 parallel family agents (vid/img/pdf/art/audio+batch/system-misc) against a shared spec anchored on `fs-rm-folder-smart.sh` as the gold standard; finder + consistency pass done directly.

## Scope
- 32 scripts: `au-` (1), `vid-` (10), `img-` (7), `pdf-` (7), `art-` (1 + `art-export.yml` config), `batch-` (2), `tor-search`, `ss-save`, `glow-open`, `finder-select-alternate`, plus `scripts/transmission_scan.sh`.
- Convention: `usage()` heredoc (purpose / USAGE / ARGUMENTS / EXAMPLES / NOTES) + `case "${1:-}" in -h|--help) usage; exit 0 ;; esac`. Positional args preserved — only `-h/--help` intercepted. Added missing shebangs to the two `batch-` one-liners + `pdf-from-images.sh`.
- Verified: `bash -n` passes on all; `--help` renders rc=0 on all; file-moving scripts sandbox-tested (batch pair, img writers) — no data loss.
- Docs: every `12-scripts/*.md` rewritten with per-script reports, `updated: 2026-06-05`; INDEX gained the universal-`--help` convention note.

## Doc errors corrected (the old docs were wrong)
- `img-web-aspect.sh` ⇄ `img-web-thumb.sh` labels were swapped — `-aspect` preserves ratio (width-only), `-thumb` crops to fixed 2:1.
- `vid-h265.sh` is a 10-bit 80M **master**, not a "base transcode".
- `vid-h265-pad.sh` **crops** a 1888×1062 inset then rescales — it does NOT pad/letterbox.
- `pdf-expand.sh` **splits** a PDF into per-page PDFs (poppler `pdfseparate`) — not "expand".
- `pdf-to-png.sh` uses **Ghostscript**, not poppler.
- `batch-create-folder-move-folder.sh`: the `[ -f ]` guard **excludes** dirs (old doc claimed it "operates on folders" — inverted).

## Latent bugs found AND FIXED (same session)
1. **Output collision** — `vid-h265.sh`/`-10b`/`-pad` all wrote `<name>_h265_hw.mov` (silent overwrite). Now distinct: `_h265_80m.mov` / `_h265_200m.mov` / `_h265_1080.mov` (and `-8b` keeps `_h265_8bit.mov`).
2. **`vid-prores.sh`** — added `shopt -s nullglob`.
3. **`vid-h265-8b.sh` / `-10b.sh`** — added `-tag:v hvc1` (now `hvc1`, not generic `hev1`).
4. **`art-process.sh`** — error echo now says `art-process.sh` (was `artwork-process.sh`).
5. **`ss-save.sh`** — removed the leading blank line; `#!/bin/zsh` is now line 1.
All re-verified: `bash -n`/`zsh -n` pass; `02-video.md` updated to the new output names.

## Also
- **`bin/_bak/` moved out of the repo** → `~/_temp/bin_bak/` (12 superseded scripts). Convention updated: superseded scripts go to `~/_temp/` (machine-local), no longer carried in `bin/`. Doc refs updated in `12-scripts/INDEX.md` + `08-system.md`.

## Doc-quality verification (post-pass)
- Read `05-artwork.md` + `01-audio.md` in full (both solid); mechanical sweep of all 10 script docs: frontmatter consistent, wikilinks resolve, no placeholders/TODOs.
- Fixed staleness the `_bak` move created: 5 family docs said "quarantined" (implied in-repo `bin/_bak/`) → now "superseded, now in `~/_temp/bin_bak/`" (`01-audio`, `02-video`, `03-image`, `04-pdf`, `05-artwork`). INDEX's remaining "quarantine" mention is the intentional relocation note.

## Next steps
- `finder-select-alternate.sh` got `--help`; the two Quick Actions remain ⇧⌥⌃A / ⇧⌥⌃S.
- Working tree uncommitted, as always.

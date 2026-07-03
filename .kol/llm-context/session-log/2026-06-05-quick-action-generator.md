# 2026-06-05 — Quick Action generator + fs-shoot (iMac)

Self-serve Finder Quick Actions: `qa-make.sh` stamps a tracked `.workflow` from one terminal line (same template as the hand-made glow/TextEdit/Select-Every-Other actions), and `fs-shoot.sh` is the clash-safe file mover behind "shoot to folder" actions. First preset live: **Shoot to _trash** (each item → a `_trash/` next to it — the fake-trash).

- `bin/fs-shoot.sh` — move files/folders to a dest, creates it, never overwrites (`-bak1` convention), `-n` dry-run. Sandbox-tested (clash, folders, self/missing guards).
- `bin/qa-make.sh` — generates Info.plist + document.wflow into `macos/services/`, plutil-lints, symlinks to `~/Library/Services`, `pbs -flush`, prints the optional hotkey `defaults write pbs` line. `-t` UTI filter (default `public.item`), `-f` overwrite.
- `macos/services/Shoot to _trash.workflow` — created via qa-make (dogfood); embedded command verified end-to-end by executing it on test files.
- `bootstrap.sh` — services block now glob-loops all `*.workflow` (was 4 hardcoded `ln` lines); new actions auto-link on the MBP.
- Docs: new `12-scripts/10-quick-actions.md` (recipe, presets, worked examples, hotkey/removal); `fs-shoot` row + section in `08-system.md`; INDEX `qa-` row + counts.

## Next steps
- Hotkey for Shoot to _trash if wanted: qa-make printed the `defaults write pbs` line → goes in `macos/defaults.sh` §Services.
- MBP picks everything up on next pull + `bootstrap.sh` run (blocked on the existing `~/.claude` reconcile item, as before).

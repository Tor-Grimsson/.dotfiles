---
name: feedback-bash-weight-discipline
description: Bash habits must stay light — no full builds for routine edits, no process-storm loops, no node_modules-wide scans; his machine visibly chokes
metadata:
  type: feedback
---

Heavy shell habits peg his machine (system bar spins out). The offenders: `turbo run build --force` after routine code edits (violates his standing build rule — build ONLY on dependency/config changes), per-file esbuild spawn loops across whole src trees, recursive grep/find over node_modules, repeated installs.

**Why:** 2026-07-28: "these bash commands almost break everything, they are fucking intense" — after a day of ~8 full builds and 150-process parse loops.

**How to apply:** Parse-check only files actually edited, in one spawn if possible. Build only when deps/lockfile/vite config changed — never after CSS/class/JSX tweaks (HMR covers those). Grep node_modules with exact paths, never `-r` over the tree. One install per wave.

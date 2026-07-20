---
title: help-lint — the --help convention lint
type: reference
status: active
updated: 2026-07-11
audience: internal
aliases:
  - help-lint
tags:
  - project/dotfiles
  - domain/scripts
related:
  - "[[INDEX|Scripts]]"
  - "[[operations/03-kol-docs-system-setup/01-kol-appliant-tool-standard|kol-appliant standard]]"
---

# help-lint

Flags any `bin/` script that doesn't service the `--help` convention (the house rule: every script answers `--help`). The enforcement arm of the [[operations/03-kol-docs-system-setup/01-kol-appliant-tool-standard|kol-appliant standard]].

## Usage

| Command | Does |
|---|---|
| `help-lint` | scan `~/.dotfiles/bin` (default) |
| `help-lint DIR` | scan another directory |
| `help-lint -h` / `--help` | its own help |

## How it works

- **Static** — no scripts are executed (safe). A script passes if it contains a `--help` handler, is a Python argparse script (auto `--help`), or is a pure alias (`exec` into another `bin/` script — help passes through; added 2026-07-15 for the `ref-*` family).
- **Skips binaries** (compiled tools like `tor-jackett`, detected via `grep -I`), plus `_*` / `*.md` / `*.txt` / itself.
- **Exits non-zero** if any script is missing `--help` — usable as a commit or CI gate.

## Sources

- Built 2026-07-11 (Phase 3 of the kol-terminality initiative). First offenders it caught: `keys`, `files`, `vid-h264-web.sh`, `vid-reframe.sh` — all fixed the same day; `bin/` scan is clean (64 pass).

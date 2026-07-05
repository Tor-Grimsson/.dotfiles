---
title: How this repo works
type: index
status: active
updated: 2026-07-05
description: The dotfiles repo explaining itself — the two-machine symlink model, and how bootstrap-cli.sh / bootstrap.sh + brewfile-cli / brewfile-gui provision a machine (CLI-only for a foreign/SSH box, full for a daily driver).
tags:
  - project/dotfiles
  - domain/tooling
related:
  - "[[INDEX|tooling catalog]]"
  - "[[TOOLING|tooling audit & sync]]"
---

# How this repo works

The catalog documents 85 *tools*; this section documents the **repo itself** — how a bare machine becomes this setup, and why it's split the way it is. This is repo infrastructure (scripts + package manifests + a symlink model), not an installed tool, so it doesn't add to the tool count.

## Docs

| # | Doc | What it covers |
|---|-----|----------------|
| 01 | [Repo model](01-repo-model.md) | Two machines, one repo: the symlink source-of-truth model, cross-arch (Intel iMac `/usr/local` / Apple-Silicon MBP `/opt/homebrew`), and what's tracked vs. left as runtime state. |
| 02 | [Provisioning](02-provisioning.md) | `bootstrap-cli.sh` vs `bootstrap.sh`, `brewfile-cli` vs `brewfile-gui` — the CLI-vs-GUI split, the foreign-box / SSH quickstart, and what each script installs. |

## See also

- [Tooling catalog](../INDEX.md) — the per-tool reference this sits beside.
- [ARCHITECTURE.md](../../.kol/llm-context/ARCHITECTURE.md) — the same load-bearing decisions in agent-terse form.
- [TOOLING.md](../../TOOLING.md) — the drift audit, cross-arch notes, and open items.

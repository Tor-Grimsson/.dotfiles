---
title: Dev Languages & Tooling
type: index
status: active
updated: 2026-06-23
description: Language runtimes, package managers, editors, the container engine, the terminal LLM client, and the GitHub CLI that make up the local development environment.
tags:
  - domain/dev
---

The runtimes, package managers, editors, and container tooling this machine develops against — JavaScript (Node, pnpm), Python (uv, pipx), the editors (VS Code, Neovim), the JSON Swiss-army knife (jq), the Docker/Linux engine (OrbStack), the terminal LLM client (llm), and the GitHub CLI (gh).

| Tool | Description |
| --- | --- |
| [Node.js](01-node.md) | Cross-platform JavaScript runtime that runs JS outside the browser and ships npm. |
| [VS Code](02-visual-studio-code.md) | Microsoft's extensible GUI code editor with integrated terminal, Git, and debugging. |
| [Neovim](03-neovim.md) | Modal terminal editor (Vim fork) with Lua config, built-in LSP, and Tree-sitter. |
| [uv](04-uv.md) | Fast Rust-based Python project, dependency, and version manager. |
| [pnpm](05-pnpm.md) | Disk-efficient JavaScript package manager backed by a hard-linked global store. |
| [pipx](06-pipx.md) | Installs and runs Python CLI apps in isolated virtual environments. |
| [jq](07-jq.md) | Command-line JSON processor for filtering and transforming JSON. |
| [OrbStack](08-orbstack.md) | Lightweight Docker Desktop replacement that also runs Linux VMs. |
| [llm](09-llm.md) | Simon Willison's terminal LLM client; wired to Claude via the llm-anthropic plugin (uv-installed). |
| [gh (GitHub CLI)](12-gh.md) | GitHub from the terminal — PRs, issues, releases, CI runs, and the full GitHub API (`gh api`). |
| [ponytail](13-ponytail.md) | Claude Code plugin that forces the laziest working solution — an over-engineering reviewer with six /ponytail-* skills. |

## Guides
- [Neovim cheatsheet (beginner)](11-neovim-cheatsheet.md) — zero-assumptions reference for writing and navigating text in [Neovim](03-neovim.md): modes, movement, editing, search/replace, panic button.
- [Neovim config (IDE setup)](10-neovim-config.md) — the lazy.nvim plugin system, structure, and keybindings for the [Neovim](03-neovim.md) setup.
- [Git worktrees (parallel-agent workflow)](14-git-worktrees.md) — run two coding agents on one repo without clashing: a worktree per agent, own branch + directory, with the install/port frictions and merge-back steps.

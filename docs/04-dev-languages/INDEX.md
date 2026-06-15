---
title: Dev Languages & Tooling
type: index
status: active
updated: 2026-06-15
description: Language runtimes, package managers, editors, the container engine, the terminal LLM client, and the GitHub CLI that make up the local development environment.
tags:
  - domain/dev
---

The runtimes, package managers, editors, and container tooling this machine develops against — JavaScript (Node, pnpm), Python (uv, pipx), the editors (VS Code, Neovim), the JSON Swiss-army knife (jq), the Docker/Linux engine (OrbStack), the terminal LLM client (llm), and the GitHub CLI (gh).

| Tool | Description |
| --- | --- |
| [[01-node\|Node.js]] | Cross-platform JavaScript runtime that runs JS outside the browser and ships npm. |
| [[02-visual-studio-code\|VS Code]] | Microsoft's extensible GUI code editor with integrated terminal, Git, and debugging. |
| [[03-neovim\|Neovim]] | Modal terminal editor (Vim fork) with Lua config, built-in LSP, and Tree-sitter. |
| [[04-uv\|uv]] | Fast Rust-based Python project, dependency, and version manager. |
| [[05-pnpm\|pnpm]] | Disk-efficient JavaScript package manager backed by a hard-linked global store. |
| [[06-pipx\|pipx]] | Installs and runs Python CLI apps in isolated virtual environments. |
| [[07-jq\|jq]] | Command-line JSON processor for filtering and transforming JSON. |
| [[08-orbstack\|OrbStack]] | Lightweight Docker Desktop replacement that also runs Linux VMs. |
| [[09-llm\|llm]] | Simon Willison's terminal LLM client; wired to Claude via the llm-anthropic plugin (uv-installed). |
| [[12-gh\|gh (GitHub CLI)]] | GitHub from the terminal — PRs, issues, releases, CI runs, and the full GitHub API (`gh api`). |

## Guides
- [[11-neovim-cheatsheet\|Neovim cheatsheet (beginner)]] — zero-assumptions reference for writing and navigating text in [[03-neovim\|Neovim]]: modes, movement, editing, search/replace, panic button.
- [[10-neovim-config\|Neovim config (IDE setup)]] — the lazy.nvim plugin system, structure, and keybindings for the [[03-neovim\|Neovim]] setup.

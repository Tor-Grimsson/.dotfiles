---
title: The version-manager landscape
type: reference
status: active
updated: 2026-07-05
description: Per-language version managers (Node, Python, Ruby, Rust, Go) and the universal ones (asdf, mise), each with its main alternatives and the pick used here.
aliases:
  - language-managers
tags:
  - domain/dev
  - pattern/version-management
related:
  - "[[01-concept|the concept]]"
  - "[[04-uv|uv]]"
  - "[[01-node|Node.js]]"
---

# The version-manager landscape

Two families: **per-language** managers (one runtime, done well) and **universal** managers (one tool for all runtimes, via a single `.tool-versions` file). Pick per-language when you mostly touch one or two runtimes; pick universal when you juggle many and want one command and one pin file for all of them.

## Per-language managers

| Runtime | Manager (recommended) | Alternatives | Pin file | Notes |
|---|---|---|---|---|
| **Node** | **fnm** — Rust, fast, `--use-on-cd` auto-switch | `nvm` (the original, a slow shell script), `n`, `volta` (also pins per-project via `package.json`) | `.nvmrc` / `.node-version` | The pick here — see [[02-fnm-setup\|the playbook]]. |
| **Python** | **uv** — Rust, also does deps + venvs | `pyenv` (version-only, the classic), `conda`/`miniconda` (data-science, ships its own Python) | `.python-version` | uv is already installed here — [[04-uv\|uv doc]]. It manages *interpreters* too, so no separate pyenv needed. |
| **Ruby** | **rbenv** — small, shim-based | `rvm` (heavier, manages gemsets too), `chruby` (minimal, no shims), `frum`/`mise` | `.ruby-version` | This is the *"sounds like Rust but simpler"* one you were thinking of — **Ruby**. Not installed here; rbenv is the standard if you ever need it. |
| **Rust** | **rustup** — the official toolchain manager | (none needed — rustup *is* the answer) | `rust-toolchain.toml` | Rust is unusual: the language ships its own version manager. `rustup` installs/switches stable/beta/nightly and reads the repo's `rust-toolchain.toml`. No third-party tool required. |
| **Go** | Go's **built-in toolchain lines** (`go 1.22` in `go.mod` auto-downloads) | `g`, `gvm` | `go.mod` (`go` + `toolchain` directives) | Like Rust, mostly self-managing now — the `go.mod` file names the version and the toolchain fetches it. |

**On "the other one, super simple, sounds like Rust":** that's **Ruby** (manager: rbenv). Ruby's whole ethos is developer-friendliness/simplicity, and the name rhymes with Rust — easy to mix up. Rust's own manager is **rustup**, which is separate and official.

## Universal managers (one tool, all runtimes)

| Tool | What it is | Pin file | Notes |
|---|---|---|---|
| **mise** (formerly `rtx`) | Rust, fast, `asdf`-compatible, active | `.tool-versions` or `mise.toml` | The modern universal pick. Reads `.nvmrc`/`.python-version` too, so it can *replace* the per-language managers entirely. |
| **asdf** | The original universal manager, plugin-based (a plugin per language) | `.tool-versions` | Battle-tested but shell-script slow; mise is the faster drop-in. |
| **proto** | From the Moon monorepo people; newer | `.prototools` | Less common; mention for completeness. |

A universal manager's appeal: **one** install, **one** pin-file format (`.tool-versions` lists every runtime a repo needs), **one** mental model. The trade-off is a layer of indirection and, for asdf, per-plugin quirks.

## What's chosen here, and why not universal

This setup uses **per-language, best-of-breed**: **fnm** for Node, **uv** for Python. Rationale — the machine only really develops against Node and Python, both have an excellent dedicated Rust-based manager, and uv does far more than version-switching (deps, venvs, lockfiles). A universal manager would add a layer without earning it *yet*. If Ruby/Go/more runtimes enter the picture, revisit **mise** as the consolidation play (it reads the same `.nvmrc`/`.python-version` pins, so migrating is low-cost).

## How they relate to package managers (don't confuse the two)

A **version manager** picks the *runtime* (which `node`). A **package manager** installs a project's *dependencies* (pnpm, npm, pip, cargo, gem). Different jobs, different layer — see the layers picture in [[operations/01-dotfiles/INDEX|the dotfiles model]] and the per-tool docs for [[05-pnpm|pnpm]] and [[04-uv|uv]]. uv blurs the line by doing both for Python; fnm is strictly a runtime switcher and leaves dependencies to pnpm/npm.

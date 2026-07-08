---
title: Version Management
type: index
status: active
updated: 2026-07-05
description: Pinning a project's language runtime per-repo so a global upgrade can't silently break it — the concept, the per-language and universal managers, the shell-rc wiring they hook into, and the fnm setup used here.
tags:
  - domain/dev
  - pattern/version-management
related:
  - "[[documentation/04-dev-languages/INDEX|Dev & Languages]]"
  - "[[documentation/01-shell-terminal/INDEX|Shell & Terminal]]"
---

# Version Management

Why this earns its own category: **runtime version management is cross-language and cross-platform.** The same problem recurs for Node, Python, Ruby, Rust, and every other runtime, on both machines — a project needs a *specific* version of its language runtime, and the globally-installed version drifts out from under it (a `brew upgrade`, a new machine, a coworker on a different version). The fix has the same shape everywhere: pin the version **per project**, in a small file the repo carries, and let a *version manager* switch to it automatically when you enter the directory.

**What triggered this folder:** Homebrew silently upgraded Node to v26 and broke the `kol-monorepo` Sanity studio (the old bundled toolchain couldn't run under Node 26). Nothing pinned the version, so the repo rode whatever Homebrew last installed. Full worked example in [[01-concept|the concept doc]].

## Docs

| # | Doc | What it covers |
|---|-----|----------------|
| 01 | [[01-concept\|The concept]] | The drift problem, per-project pinning, the `.nvmrc` / `.tool-versions` model, and the real kol-monorepo Node-26 breakage. |
| 02 | [[02-fnm-setup\|fnm setup (playbook)]] | The scoped, step-by-step setup for **fnm** (the Node manager chosen here) + pinning kol-monorepo to Node 22. |
| 03 | [[03-language-managers\|The manager landscape]] | Per-language managers (Node / Python / Ruby / Rust) and universal ones (asdf / mise), each with its alternatives. |
| 04 | [[04-shell-rc-files\|Shell rc files]] | How `.zshrc` / `.bashrc` work, the shebang (`#!/bin/bash`) vs rc-file distinction, and where version managers hook in. |

## The mental model in one picture

```
your machine
 └ a version MANAGER (fnm, pyenv, rustup, asdf…)   ← installs many versions side by side
     └ reads a PIN FILE in each repo (.nvmrc, .tool-versions, rust-toolchain.toml)
         └ auto-switches the active runtime when you cd in
             └ so `node` / `python` / `ruby` means the version THIS repo needs,
               not whatever Homebrew last upgraded to globally
```

The manager is **global** (install once per machine — belongs in the Brewfile + shell rc). The pin file is **per-repo** (lives in the project, travels with it). See [[operations/01-dotfiles/INDEX|the dotfiles model]] for that global-vs-per-repo split applied across the whole setup.

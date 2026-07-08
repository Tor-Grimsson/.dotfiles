---
title: Shell rc files (and how they differ from a shebang)
type: guide
status: active
updated: 2026-07-05
description: What .zshrc / .bashrc are, login vs interactive shells, what "source" means, why a #!/bin/bash shebang is a different mechanism, and where a version manager hooks in.
aliases:
  - shell-rc-files
tags:
  - domain/shell
  - pattern/version-management
related:
  - "[[02-fnm-setup|fnm setup]]"
  - "[[documentation/01-shell-terminal/INDEX|Shell & Terminal]]"
---

# Shell rc files (and how they differ from a shebang)

You asked two things that sound related but aren't the same mechanism: **rc files** (`.bashrc`, `.zshrc`) and the **`#!/bin/bash`** you put at the top of scripts. Both involve bash; they do different jobs.

## What an rc file is

When you open a terminal, the shell (here **zsh**) starts up and, before handing you a prompt, **reads a config file and runs every line in it** — setting your PATH, defining aliases, loading the prompt theme, etc. That config file is the **rc file**. `rc` = "run commands" (an old Unix convention; you'll see it in `.vimrc`, `.npmrc`, etc.). For zsh it's `~/.zshrc`; for bash it's `~/.bashrc`.

"Running every line in it" is called **sourcing** — the lines execute *in your current shell*, so the aliases and PATH changes stick around for the whole session. (Contrast with running a script, below, which runs in a *separate* shell and can't change yours.)

## Login vs interactive — two rc files, two moments

There are two startup files because there are two kinds of shell session:

| File (zsh / bash) | Runs when | Put here |
|---|---|---|
| `.zprofile` / `.bash_profile` | **Login** shells — once, at the start of a session (SSH in, first terminal login) | One-time environment setup: `PATH` exports that shouldn't repeat, `brew shellenv` |
| `.zshrc` / `.bashrc` | **Interactive** shells — every new terminal tab/window/pane | Aliases, prompt, completions, anything you want in *every* shell — including version-manager hooks |

In practice most day-to-day config goes in `.zshrc`/`.bashrc` because you want it in every shell. This repo's [[01-repo-model|dotfiles]] track both: `shell/.zshrc` (interactive) and `shell/.zprofile` (login, which runs `brew shellenv` arch-correctly for both Macs).

## The shebang is a *different* thing

The `#!/bin/bash` (or `#!/usr/bin/env bash`) at the top of a script is a **shebang**. It is **not** an rc file and isn't sourced. It's a one-line instruction to the operating system: *"when someone runs this file, execute it with this interpreter."* So:

- **`#!/bin/bash` in a script** → "run this file's commands using bash," in a *brand-new* bash process that exits when the script finishes. Changes it makes to PATH or aliases vanish when it ends — they never touch your terminal's shell.
- **`.bashrc` / `.zshrc`** → "config the shell reads *into itself* every time it starts." Changes persist for that whole interactive session.

Quick way to hold the distinction: the shebang answers *"what program runs this file?"*; the rc file answers *"what does my shell load about itself on startup?"* A script with `#!/bin/bash` can even choose to `source ~/.bashrc` itself if it wants your aliases — that's the two mechanisms meeting, but they start out separate.

> One consequence worth knowing: because a script runs in its own shell, a script **cannot change your current directory or set an env var in your terminal** — those die with the script's process. That's why tools like the `y()` yazi wrapper and the `g-nav` helpers in this repo's `.zshrc` are shell **functions**, not scripts — a function runs *in* your shell, so its `cd` actually moves you. Same reason version-manager hooks (below) go in the rc file, not a script.

## Where a version manager hooks in

A version manager needs to run **in every interactive shell** (so `node` points at the right version the moment you open a terminal and `cd` around). So its install step appends **one line to your rc file**. For fnm that line is:

```sh
eval "$(fnm env --use-on-cd)"
```

`eval "$(fnm env …)"` means: run `fnm env`, which *prints* the shell commands that set up PATH and the auto-switch hook, and `eval` executes that printed output in the current shell. `--use-on-cd` adds the hook that re-checks the pinned version every time you change directory. It sits in `shell/.zshrc` after the `PATH` block, alongside the existing `conda` hook that works the same way. Full placement in [[02-fnm-setup|the fnm playbook]].

No hardcoded paths in that line — `fnm` is found via PATH — so it satisfies the repo's cross-arch rule ([[01-repo-model|no hardcoded brew prefixes]]) and works on both the Intel and Apple-Silicon machines from the one shared `.zshrc`.

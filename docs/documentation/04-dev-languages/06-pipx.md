---
title: pipx
type: reference
status: active
updated: 2026-06-04
description: Installs and runs Python CLI applications in isolated virtual environments, keeping each tool's dependencies separate.
aliases:
  - pipx
tags:
  - domain/dev/python
  - pattern/cli
  - integration/brew-formula
links:
  website: https://pipx.pypa.io
  repo: https://github.com/pypa/pipx
  manual: https://pipx.pypa.io/stable/docs/
  brew: https://formulae.brew.sh/formula/pipx
covers:
  - Installing Python CLI tools globally without dependency clashes
  - Running one-off tools and upgrading installed ones
related:
  - "[[04-uv|uv]]"
---

## Summary
pipx installs Python applications that ship a command-line entry point, each into its own isolated virtual environment, then exposes the command on `PATH`. This avoids the dependency conflicts that come from installing CLI tools into a shared global Python.

## Why installed
It is how Python-based command-line tools get onto the machine cleanly. Tools like formatters, linters, or generators each get a private environment, so upgrading one never breaks another and none of them pollute the system Python's site-packages.

## Most common use case
Installing a Python CLI tool globally for everyday use — `pipx install <tool>` — then calling that command from anywhere without activating a virtual environment.

## Biggest win
Isolation per tool. Every app gets its own venv, so version conflicts between tools simply can't happen, and removing a tool (`pipx uninstall`) cleanly deletes its environment with no leftovers.

## How to use
```sh
# Install a CLI tool into its own isolated env
pipx install black

# Run a tool once without installing it permanently
pipx run cowsay "hello"

# List, upgrade, and remove
pipx list
pipx upgrade black
pipx upgrade-all
pipx uninstall black

# Ensure pipx's bin dir is on PATH (run once)
pipx ensurepath
```

## Future use
Consolidate toward `uv tool` / `uvx`, which covers the same isolated-CLI use case from the same binary already managing Python versions and projects — worth migrating to so there's one tool instead of two for Python CLIs.









;lmkdfs.jnsd.n,sdfmn,fsd.mndsf

---
title: pnpm
type: reference
status: active
updated: 2026-06-04
description: Fast, disk-space-efficient JavaScript package manager that hard-links a global store instead of duplicating node_modules.
aliases:
  - pnpm
tags:
  - domain/dev/javascript
  - pattern/cli
  - integration/brew-formula
links:
  website: https://pnpm.io/
  repo: https://github.com/pnpm/pnpm
  manual: https://pnpm.io/motivation
  brew: https://formulae.brew.sh/formula/pnpm
covers:
  - Installing dependencies and running package scripts
  - The content-addressable store and why it saves disk space
related:
  - "[[01-node|Node.js]]"
---

## Summary
pnpm is a drop-in alternative to npm and Yarn for managing JavaScript dependencies. Its defining trait is a single content-addressable global store: packages are downloaded once and hard-linked into each project's `node_modules`, so disk usage and install time drop sharply across many projects.

## Why installed
It is the preferred package manager for JavaScript projects in this setup. With many repos sharing the same dependencies, the global store means those packages live on disk exactly once instead of being copied into every `node_modules`, and its strict resolution catches phantom-dependency bugs npm allows.

## Most common use case
Installing a project's dependencies and running its scripts: `pnpm install` after cloning, then `pnpm dev` / `pnpm build` to drive the project's defined tasks.

## Biggest win
The hard-linked store: installs are fast because shared packages aren't re-downloaded or re-copied, and disk usage stays flat as the number of projects grows. Its non-flat `node_modules` layout also enforces that code can only import packages it actually declared.

## How to use
```sh
# Install all dependencies from package.json / pnpm-lock.yaml
pnpm install

# Add / remove a dependency
pnpm add react
pnpm add -D vite          # dev dependency
pnpm remove react

# Run package scripts
pnpm dev
pnpm build
pnpm run <script>

# Run a binary without a permanent install
pnpm dlx create-vite@latest my-app
```

## Future use
Adopt pnpm workspaces (`pnpm-workspace.yaml`) for multi-package monorepos, and use `--filter` to run scripts against a subset of packages — turning the disk-saving installer into the backbone of a structured monorepo.

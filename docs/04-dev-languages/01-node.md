---
title: Node.js
type: reference
status: active
updated: 2026-06-04
description: Open-source, cross-platform JavaScript runtime that runs JS outside the browser and ships the npm package manager.
aliases:
  - node
  - npm
tags:
  - domain/dev/javascript
  - pattern/cli
  - integration/brew-formula
links:
  website: https://nodejs.org/
  repo: https://github.com/nodejs/node
  manual: https://nodejs.org/docs/latest/api/
  brew: https://formulae.brew.sh/formula/node
covers:
  - What the runtime provides and why it anchors the JS toolchain
  - Running scripts, the bundled npm, and npx one-offs
related:
  - "[[02-pnpm|pnpm]]"
---

## Summary
Node.js is a JavaScript runtime built on V8 that executes JS outside the browser. It provides the event loop, the standard library (filesystem, network, streams, crypto), and ships with `npm` and `npx`. Almost every modern web and CLI JavaScript tool assumes a Node install is present.

## Why installed
It is the foundation the rest of the JavaScript category sits on. `pnpm` explicitly requires a Node install to function, and any local build tooling (Vite, bundlers, linters) runs on this runtime. Installing it via brew keeps the binary on `PATH` and updatable alongside everything else.

## Most common use case
Running project tooling and scripts: `node script.js` for one-offs, and acting as the engine behind `vite`, `eslint`, and other dev servers invoked through package scripts.

## Biggest win
It is the universal substrate — install it once and the entire npm ecosystem (over two million packages) becomes available. `npx` in particular lets you run a package without a global install, which keeps the machine clean.

## How to use
```sh
# Check versions
node --version
npm --version

# Run a script / a REPL
node app.js
node                      # interactive REPL

# Run a package binary without installing it globally
npx create-vite@latest my-app

# Project init + dependency install (npm; pnpm is preferred here)
npm init -y
npm install express
```

## Future use
Pin and switch Node versions per project — either via `corepack`/a version file or by layering a manager like `fnm`/`nvm` on top — so older projects build against the runtime they expect instead of the single brew-linked version.

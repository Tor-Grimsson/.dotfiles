---
title: Shell Functions
type: reference
status: active
updated: 2026-06-24
description: Custom one-liner shell functions in `.zshrc` that fill gaps where no installed tool exists.
aliases:
  - shell-functions
tags:
  - domain/shell
  - pattern/alias
---

## Summary
Small utility functions defined in `shell/.zshrc`. Not Brewfile tools — just zsh functions that fill a specific gap.

| Function | Does | Needs |
|---|---|---|
| `killport <port>` | kill whatever process is bound to a port | `lsof` (macOS built-in) |

## Functions

### `killport`
```sh
killport 5174      # kill whatever is on port 5174
killport 3000
```
Looks up the PID via `lsof -ti:<port>` and sends `kill -9`. Equivalent to:
```sh
kill -9 $(lsof -ti:5174)
```

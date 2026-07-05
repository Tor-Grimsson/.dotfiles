---
title: Obsidian vault-config source
type: reference
status: active
updated: 2026-07-05 (2)
description: The single .obsidian config source repos symlink or copy into docs/.obsidian, its two shapes, and the four-choice picker.
tags:
  - framework/conventions
  - provider/obsidian
aliases:
  - obsidian
related:
  - "[[01-structure|structure]]"
---

# Obsidian vault-config source

The vault config lives once at **`~/.dotfiles/claude/packages/scaffold/02-scaffold-docs/obsidian-shapes/`** and repos symlink (or copy) it into their `docs/.obsidian/`. Edit the source → every symlinked repo inherits it.

## Shapes

| Shape | Seeded from | For |
|---|---|---|
| `01-vault-shape/.obsidian/` | kol-monorepo | Rich general vault — plugins, snippets, themes, hotkeys, folder-notes, dataview. |
| `02-kol-vault-shape/.obsidian/` | kol-vault | The actual dedicated Obsidian vault — 30 enabled plugins (`dataview`, `templater-obsidian`, `quickadd`, …). The richest shape. |
| `03-kol-ds-shape/.obsidian/` | kol-design-system | Minimal — core plugins only. Lightweight doc trees. |

Each shape is an openable mini-vault (a `.obsidian/` + a dummy note) — open it in Obsidian to test plugins; changes flow to linked repos.

## The picker (ask on setup)

Present six options (AskUserQuestion — symlink or copy, times 3 shapes):

1. **Symlink `01-vault-shape`** — `ln -s ~/.dotfiles/claude/packages/scaffold/02-scaffold-docs/obsidian-shapes/01-vault-shape/.obsidian docs/.obsidian`. Shared, no drift.
2. **Symlink `02-kol-vault-shape`** — same, the rich kol-vault set.
3. **Symlink `03-kol-ds-shape`** — same, minimal.
4. **Copy `01-vault-shape`** — `cp -R`, repo owns it, drifts independently.
5. **Copy `02-kol-vault-shape`** — `cp -R`, the rich kol-vault set.
6. **Copy `03-kol-ds-shape`** — `cp -R`, minimal.

Symlink = one source of truth (but the repo shares `workspace.json` churn). Copy = independent, per-repo editable, drifts from source.

## Always excluded

`workspace.json`, `workspaces.json`, `workspace-mobile.json` — per-vault local UI state. Never seeded; **gitignore them in every target repo.**

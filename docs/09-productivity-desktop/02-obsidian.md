---
title: Obsidian
type: reference
status: active
updated: 2026-07-05
description: Local-first knowledge base built on a folder of plain Markdown files, plus the shared vault-config source repos symlink from.
aliases:
  - obsidian
tags:
  - domain/productivity
  - pattern/gui
  - integration/brew-cask
links:
  website: https://obsidian.md/
  manual: https://help.obsidian.md/
  brew: https://formulae.brew.sh/cask/obsidian
covers:
  - Vaults over a local Markdown folder
  - Wikilinks, backlinks, graph view
  - Plugins and first-run setup
  - Shared vault-config source symlinked into repos
related:
  - "[[01-raycast|Raycast]]"
---

## Summary
Obsidian is a knowledge base that operates directly on a local folder of plain-text Markdown files. Notes link to each other with `[[wikilinks]]`, and the app builds backlinks and a graph from those connections. Because the data is just files on disk, it stays portable and tool-agnostic.

## Why installed
This is where the docs live. The kol-docs framework — frontmatter contracts, wikilinks, the closed tag taxonomy — is authored and read in Obsidian, so the app is the editing and navigation surface for these very reference docs.

## Most common use case
Open the vault, edit or create a Markdown note, and follow `[[wikilinks]]` between related docs. The graph and backlink panels surface how a given doc connects to its siblings.

## Biggest win
Local plain-text storage with no lock-in. The vault is a normal directory that version-controls cleanly in this dotfiles repo, works with any external editor, and survives the app itself — while still getting linking, search, and graph features on top.

## How to use
- On first run, open the folder containing these docs as a Vault.
- Create notes as `.md` files; link with `[[NN-tool|display name]]` per the doc spec.
- Use the backlinks pane and graph view to navigate related docs.
- Add community plugins via Settings → Community plugins only if a real need arises (keep the vault portable).

## Vault-config source
Repos symlink their `docs/.obsidian/` from a shared config source at `claude/packages/scaffold/02-scaffold-docs/obsidian-shapes/` — full setup, shapes, and the picker documented in [[20-kol-docs-system-setup/INDEX|kol-docs system setup]].

## Future use
Templates and the Dataview plugin could query the doc frontmatter (`type`, `status`, `tags`) to auto-generate the per-category INDEX tables instead of maintaining them by hand.

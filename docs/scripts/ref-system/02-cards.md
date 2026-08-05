---
title: ref — authoring cards
type: reference
status: active
updated: 2026-07-29
description: How card data files are written — ONE dialect since 2026-07-29 (md tables, glow-rendered, NO per-row spacers, natural filter-word titles, backticked key tokens), plus the to() path contract and the json→md port flow.
tags:
  - project/dotfiles
  - domain/shell
  - pattern/docs
related:
  - "[[01-system|01 — system]]"
  - "[[03-glow|03 — glow]]"
---

## Summary
Cards are hand-kept markdown, one file per card, **one dialect for all of them** (since 2026-07-29 — the earlier bat/glow split is gone): md tables, glow-rendered, no per-row spacer rows, single-word section titles, `[e]` blocks (one command per line, never `&&`), `doc:` folds. The maintainer skill `ref-admin` teaches the same rules (it replaced keys-add + files-add when the keys card dissolved into topical cards; renamed from `ref-add` 2026-08-02).

## The dialect

| rule | why |
|---|---|
| `## ` titles are natural words — `## tmux — popovers`, `## kol — apps` — no hashtags | the filter matches case-insensitive **substrings of the title**, so plain words filter exactly like tags did; every old tag word must survive in the title |
| two-column tables under each title (`keys \| does`, `path \| what`, `thing \| fact`) | the whole point — box-drawn, scannable |
| **NO spacer row between every data row** — a blank `\|  \|  \|` is a **category break** inside a table that has genuine groups, nothing else | user ruling 2026-07-31: *"I proposed line breaks for categories/sections within a table, as breathers"*. Applied per-row it doubles a card's length and turns a lookup into a scroll. 385 of them were stripped across 13 cards that day |
| backtick angle tokens — `` `<leader>` `` `` `<CR>` `` `` `<host>` `` | glow parses bare `<…>` as HTML and SWALLOWS it |
| literal `\|` in a cell escaped as `\\|` | table syntax |
| command SEQUENCES (e.g. `keys git new`) are fenced ```sh blocks, not tables | copy-paste beats grid for run-in-order chains |
| **cells cap at 46 characters** — over that, evict the depth to the `doc:` fold | a wrapped cell reads as a phantom row, and a sentence in a cell is a doc wearing a table costume. **`ref --lint` enforces this**; 32 rows were shortened across 9 cards on 2026-08-01 |
| **a group inside a table is `\| **## name** \| what it is \|`**, bolded, preceded by one blank spacer row | how seven tools live in ONE table instead of seven scattered `## sections` (user ruling 2026-08-01 — *"just put all the trial explorer in the same table and use space and ## inside with name of plugin"*). `ref-explorer trial` and `ref-yazi yazi` are the model |
| the bold is load-bearing, not decoration | `glow-style.json`'s `strong` carries fg `214` (2026-08-02) — a category marker reads as a distinct color, not just plain text with hashes. `bin/ref` `show()` renders through this JSON now, not the builtin `-s dark` |
| categories are optional, not default | group only when a card genuinely holds multiple tools/topics sharing one table — a single-tool card stays a plain table, no invented categories |
| duplication across sections is deliberate | a thing living in several contexts is listed in each |
| **this dialect governs `notes/*.md` too** (2026-08-05) | `bin/notes` is a second **engine**, not a second format — `ref --lint` reads `notes/` alongside `ref/`. Exempting it was tried and reversed: prose goes in the paragraphs around the table, cells stay glance-length regardless. See [[01-system\|01 — system]] |
| **a key with two owners lives on both cards** (2026-08-05) | `prefix y` restarts *yazi* from *tmux*, so it is carded in `ref-tmux reload` and `ref-yazi reload`. The **reasoning** stays in one place and the other card points at it — user ruling: *"things have to live where they are referenced, even if they have 2 homes"* |

## The lint — the law as a machine check

Every rule above was already written down, and every one of them regrew anyway: the 385 per-row spacers came back because *this doc* taught them, and `repo-map.sh --card` kept re-emitting them from a generator nobody re-read. **A rule a human has to remember is a rule that decays.** So the dialect is now checkable:

```sh
ref --lint
```

| It fails on | Because |
|---|---|
| a per-row spacer (a blank row **not** followed by `\| ## name \|`) | the 2026-07-31 ruling, now enforced instead of described |
| a cell over **46 characters** | depth belongs in the `doc:` fold, not the grid |
| a `doc:` target that doesn't exist on disk | a dead pointer renders perfectly — nothing else catches it |
| a card file with no `## section` | nothing in it is filterable |

Exit code is **1** on any violation, so it gates a skill's verify step or a pre-commit hook. It is **python3, not awk** — macOS `awk`'s `length()` counts *bytes*, and these cards are full of `·`, `→` and `…`, which inflated a 42-character cell to 49 and produced false failures on the first run.

**Generators must satisfy the lint too.** `ref/repo.md` is written by `repo-map.sh --card`; on 2026-08-01 that generator was still emitting per-row spacers and cutting cells at 120 characters mid-word. It now truncates at a word boundary to 46 with a trailing `…`. A generated card that violates the dialect re-breaks every card it writes, every run.

## The `to()` contract (files card only)
`to()` in `.zshrc` extracts the **first cell** of rows starting `| ~` — so in `folders.md` the path always leads the row, and paths contain no spaces. Breaking this breaks the jump command, silently.

## Port flow — theme JSON → readable md
When the theme changes ([[04-theme|04]]), re-port its values into the doc tables:

1. Source of truth: `~/.dotfiles/ref/glow-style.json`.
2. Translate each block (`document`, `heading`, `table`, `code_block`, …) into an `element → value` row in [[04-theme|04 — theme]].
3. Note anything vendored-but-unused so drift is visible.
The JSON is the machine end, the md is the human end — edit the JSON, then sync the md in the same change.

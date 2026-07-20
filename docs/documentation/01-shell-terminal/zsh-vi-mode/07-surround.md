---
title: Surround — the full grammar
type: guide
status: active
updated: 2026-07-09
description: The complete surround feature in zsh-vi-mode — add, change, delete, and visually apply surrounding pairs (quotes, brackets, tags) around text objects, with the full operator grammar and a worked table.
tags:
  - domain/shell
related:
  - "[[INDEX|zsh vi-mode — complete guide]]"
  - "[[06-visual-mode|Visual mode]]"
  - "[[02-motions-and-editing|Motions & editing]]"
---

# Surround — the full grammar

Surround is the feature that earns vi-mode its keep on a shell prompt: wrapping an argument in quotes, swapping `'` for `"`, or stripping brackets — all without hunting for the two ends by hand. zsh-vi-mode ships tpope-style surround built in.

## The three verbs

| Verb | Mnemonic | Does |
| --- | --- | --- |
| **`ys`** | *you surround* | **add** surrounds around a text object |
| **`cs`** | *change surround* | **replace** one surrounding pair with another |
| **`ds`** | *delete surround* | **remove** a surrounding pair |

## Add — `ys` + object + pair

`ys` takes a **text object** (what to wrap) then the **pair character** (what to wrap it in):

| Keys | Result |
| --- | --- |
| `ysiw"` | wrap the inner **word** in `"…"` |
| `ysiw(` | wrap the word in `( … )` — open bracket adds spaces |
| `ysiw)` | wrap the word in `(…)` — close bracket, no spaces |
| `ys$"` | wrap from cursor to **end of line** in quotes |
| `yss)` | wrap the **whole line** in `()` (`ss` = the line as the object) |
| `yst<tag>` | wrap in an HTML/XML tag |

The pair character rule (from vim-surround): the **opening** bracket adds inner spaces, the **closing** bracket doesn't. `ysiw{` → `{ word }`; `ysiw}` → `{word}`.

## Change — `cs` + old + new

| Keys | Turns | Into |
| --- | --- | --- |
| `cs"'` | `"word"` | `'word'` |
| `cs'(` | `'word'` | `( word )` |
| `cs)]` | `(word)` | `[word]` |
| `cs"t` | `"word"` | a tag prompt → `<em>word</em>` |

Cursor just needs to be *inside* the pair; surround finds the delimiters.

## Delete — `ds` + pair

| Keys | Turns | Into |
| --- | --- | --- |
| `ds"` | `"word"` | `word` |
| `ds(` | `(word)` | `word` |
| `ds{` | `{ word }` | `word` |

## From visual mode — `S`

Highlight a range ([[06-visual-mode|chapter 6]]) then `S` + pair:

| Keys | Result |
| --- | --- |
| `viw` `S"` | select word, wrap in quotes |
| `V` `S)` | select whole line, wrap in `(…)` |
| `v$` `S'` | select to EOL, wrap in `'…'` |

## Practical shell moments

| Situation | Keys |
| --- | --- |
| Forgot to quote a path with spaces | `ysiW"` (WORD, so it grabs the whole spaced token if joined) or `V S"` for the whole arg |
| `'single'` needs to be `"double"` (for `$var` expansion) | `cs'"` |
| Strip the parens from `$(cmd)` | move inside, `ds(` (then `ds$` if the `$` remains) |
| Wrap the last argument in braces | `ysiw}` |

## Binding style

The surround keybinding style is set by `ZVM_VI_SURROUND_BINDKEY` (default `classic`, the `ys`/`cs`/`ds` shown here). The alternative `s-prefix` moves them under an `s` prefix — some configs (e.g. `XXiaoA/dotfiles`) use it, but `classic` matches vim-surround muscle memory, so we stay on the default. See [[04-configuration|configuration reference]].

Next: [[08-search-and-history|Search & history in normal mode]].

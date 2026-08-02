---
title: emoji-fzf
type: reference
status: active
updated: 2026-08-01
description: Fuzzy emoji picker for the shell — pipes the full emoji list through fzf and returns the chosen character, wrapped here by the `emo` function which copies it to the clipboard.
aliases:
  - emoji-fzf
  - emo
tags:
  - domain/shell
  - pattern/cli
  - integration/uv-tool
links:
  website: https://github.com/noahp/emoji-fzf
  repo: https://github.com/noahp/emoji-fzf
  manual: https://github.com/noahp/emoji-fzf#usage
covers:
  - Fuzzy-searching emoji from the terminal
  - Clipboard handoff via the `emo` wrapper
related:
  - "[[30-emojify|emojify]]"
  - "[[04-dev-languages/04-uv|uv]]"
---

## Summary

emoji-fzf prints the emoji list in a format [[02-file-management/09-fzf|fzf]] can filter, then converts the chosen line back to the character. It is a **picker** — the counterpart to [[30-emojify|emojify]], which renders shortcodes you already know.

## Why installed

Installed 2026-08-01 to get emoji into the shell pipeline. Raycast and macOS `⌃⌘Space` already cover picking into a GUI app; this covers picking into a pipe.

## Most common use case

`emo`, pick, paste — the character lands on the clipboard without leaving the terminal or reaching for a system panel.

## Biggest win

**It composes.** Because both halves are plain stdin/stdout, the picker drops into any pipeline — clipboard, a commit message, a script argument — rather than only typing into a focused text field.

## How to use

**Not a brew formula.** Installed with [[04-dev-languages/04-uv|uv]], matching the direction set in that doc (`uv tool install` for standalone CLIs; pipx keeps what's already in it):

```sh
uv tool install emoji-fzf
```

The wrapper lives in `shell/.zshrc`:

```sh
emo        # fzf-pick an emoji, copy it to the clipboard, echo what was copied
```

| Piece | Does |
| --- | --- |
| `emoji-fzf preview --prepend` | emit the list with **the glyph as field 1** — without `--prepend` you get names only, no emoji to look at |
| `--with-nth=1,2` | display **glyph + name** only; each raw line carries ~20 keywords after that |
| `--nth=2..` | still search the whole keyword soup, just don't show it |
| `awk '{print $1}'` | take the glyph |
| `emo` | the above joined, result to `pbcopy` |

`emo` exits with the install hint if the binary is missing, so the function is safe to ship before the tool is installed on a second machine.

> **`--no-preview` is load-bearing.** `FZF_DEFAULT_OPTS` (`shell/.zshrc:244`) carries a file preview — `bat --color=always {}`. Every line piped in here is an emoji *name*, not a path, so without the flag fzf shells out to bat on `grinning_face` and the preview pane fills with `[bat error]`. Any new fzf wrapper over non-path input needs the same flag.

> **Don't pair `--prepend` with `emoji-fzf get`.** `get` expands the *name* on the line into a glyph; with `--prepend` the glyph is already field 1, so the pair returns it twice (`😀😀`). Use `awk '{print $1}'` instead — one or the other, never both.

## Future use

An `--append` style variant that types the emoji into the current command line rather than the clipboard, bound in `zvm_after_init` alongside the other insert-mode keys.

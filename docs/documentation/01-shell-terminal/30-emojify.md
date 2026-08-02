---
title: emojify
type: reference
status: active
updated: 2026-08-01
description: A text filter that converts :shortcodes: into emoji as text streams through it — the opposite direction from a picker, and useful in pipes and git hooks.
aliases:
  - emojify
tags:
  - domain/shell
  - pattern/cli
  - integration/brew-formula
links:
  website: https://github.com/mrowa44/emojify
  repo: https://github.com/mrowa44/emojify
  manual: https://github.com/mrowa44/emojify#usage
  brew: https://formulae.brew.sh/formula/emojify
covers:
  - Converting :shortcode: text to emoji in a pipe
  - Emoji in commit messages and script output
related:
  - "[[31-emoji-fzf|emoji-fzf]]"
---

## Summary

emojify reads text and replaces every `:shortcode:` with the emoji it names. It is a **filter, not a picker** — you already know the name and want it rendered, rather than browsing for one.

## Why installed

Installed 2026-08-01 alongside [[31-emoji-fzf|emoji-fzf]], which does the opposite job. The two are complementary: emoji-fzf finds a character you can't name, emojify renders names you already know.

## Most common use case

Emoji in script output and commit messages without pasting the raw character into a source file — the file stays ASCII, the terminal shows the emoji.

## Biggest win

**Source files stay ASCII.** A shell script carrying `:rocket:` is diff-friendly, grep-friendly, and safe in any encoding; the emoji only exists at display time.

## How to use

```sh
emojify "shipped :rocket: and tested :white_check_mark:"
echo "deploy done :tada:" | emojify
emojify --list                       # every supported shortcode
emojify --list rocket                # filter the list
```

### How people actually use it

| Pattern | Command |
| --- | --- |
| **Script status lines** — the `.sh` stays ASCII | `echo ":white_check_mark: build passed" \| emojify` |
| **Log/output decoration** — pipe anything through | `make test 2>&1 \| emojify` |
| **Commit messages** — write the code, render on read | `git log --format=%s \| emojify` |
| **Find the name first** | `emojify --list check` then use what it prints |
| **Shell prompt / MOTD** | `emojify ":coffee: $(date +%H:%M)"` in `.zshrc` |
| **Markdown to terminal** | `cat NOTES.md \| emojify \| glow -` |

The pattern in all of them is the same: **the file on disk holds `:rocket:`, the terminal shows the emoji.** That is the entire point — a shortcode greps, diffs and sorts; a raw emoji does none of those well.

### Armed: `emo -n`

Nobody can type 2562 shortcodes from memory, which is what makes emojify feel unusable on its own. `emo -n` (`shell/.zshrc`) fixes that — it fuzzy-picks from **emojify's own list**, showing the rendered glyph next to each name, and copies the colon-wrapped shortcode:

```sh
emo -n          # pick 🚀 → clipboard holds ":rocket:"  → paste into the file
emo             # pick 🚀 → clipboard holds "🚀"        → paste anywhere final
```

> **The two tools do not share a vocabulary.** emojify ships **2562** GitHub-style shortcodes; [[31-emoji-fzf|emoji-fzf]] ships **4440** Unicode/CLDR names. `:astronaut:` and `:grinning_face:` exist only in emoji-fzf, so picking one there and pasting it into a file leaves literal text after emojify runs. This is why `emo -n` sources from `emojify --list` and not from emoji-fzf — it is the only way the round trip is guaranteed.

| Flag | Does |
| --- | --- |
| `-l`, `--list [pattern]` | list shortcodes, optionally filtered |
| `-h`, `--help` | usage |

> **Not a picker.** `emojify` has no interactive mode — it never shows you a menu. If you don't know the shortcode, use [[31-emoji-fzf|emoji-fzf]] (`emo`), Raycast's emoji search, or macOS `⌃⌘Space`.

## Future use

A git `prepare-commit-msg` hook piping the message through emojify, so commit subjects can be written in shortcodes.

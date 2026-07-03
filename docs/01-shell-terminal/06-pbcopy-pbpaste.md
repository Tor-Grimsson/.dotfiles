---
title: pbcopy & pbpaste
type: reference
status: active
updated: 2026-06-09
description: The macOS clipboard from the shell — pbcopy reads stdin onto the clipboard, pbpaste writes it back out. Recipes pairing them with fzf, pngpaste, jq/yq, git, glow, and the speak function.
aliases:
  - pbcopy
  - pbpaste
  - clipboard
tags:
  - domain/shell
  - pattern/cli
links:
  manual: https://ss64.com/mac/pbcopy.html
covers:
  - The clipboard-as-a-pipe model (pbcopy ← stdin, pbpaste → stdout)
  - Exact-string copying (the echo newline trap)
  - fzf → clipboard (pipe, ctrl-y keybind, absolute paths, file contents)
  - jq / yq / git / glow / gh round-trips
  - Images via pngpaste (the text-only limit)
related:
  - "[[04-pngpaste|pngpaste]]"
  - "[[06-edge-tts|edge-tts]]"
---

## Summary
The macOS clipboard as a pipe endpoint. `pbcopy` reads **stdin** and puts it on the clipboard; `pbpaste` writes the clipboard to **stdout**. Everything below is composition — there are no other moving parts.

Both are **macOS built-ins** (`/usr/bin`), text-only. For images, use [pngpaste](../07-pdf-images/04-pngpaste.md) (`pbpaste` for pixels).

| Command | Does | Note |
|---|---|---|
| `pbcopy` | stdin → clipboard | text only; ignores arguments — you must **pipe** into it |
| `pbpaste` | clipboard → stdout | text only |
| [pngpaste](../07-pdf-images/04-pngpaste.md) | clipboard image → file/stdout | brew; the image counterpart `pbpaste` can't do |
| `copypath` | copy a file/dir **path** to the clipboard | oh-my-zsh plugin (loaded) — `copypath [file]`, no arg = cwd |
| `copyfile` | copy a file's **contents** to the clipboard | oh-my-zsh plugin (loaded) — `copyfile <file>` |
| `speak` | clipboard → spoken aloud | your function — `pbpaste` → sanitizer → [edge-playback](../06-media-av/06-edge-tts.md) |

## Core idioms

```sh
echo "hello" | pbcopy          # clipboard now holds "hello\n"  ← note the newline
printf '%s' "$x" | pbcopy      # exact string, NO trailing newline (paths, tokens, ids)
cat file.txt | pbcopy          # whole file onto the clipboard
pbpaste                        # print clipboard to terminal
pbpaste > out.txt              # clipboard → file
pbpaste | tr a-z A-Z | pbcopy  # transform the clipboard IN PLACE (the round-trip idiom)
```

The newline trap is the one that bites: `echo` appends `\n`. Use `printf '%s'` (or `echo -n`) whenever the exact bytes matter — pasting a path or token with a stray newline breaks things silently.

## With fzf

`fzf` prints the selection to stdout, so it pipes straight into `pbcopy`:

```sh
fzf | pbcopy                                   # pick a line, copy it (kills nothing extra)
fzf | tr -d '\n' | pbcopy                      # drop fzf's trailing newline
fd --type f | fzf | tr -d '\n' | pbcopy        # find a file, copy its (relative) path
rg -n PATTERN | fzf | pbcopy                    # grep → pick a match → copy "file:line:text"
fzf | xargs bat | pbcopy                        # copy the CONTENTS of the picked file
```

**Copy without leaving fzf — bind a key.** This is the right move for an interactive `fzf` (a bare `fzf` only prints on Enter):

```sh
fzf --bind 'ctrl-y:execute-silent(echo -n {} | pbcopy)'        # Ctrl-Y copies highlighted line
fzf --bind 'ctrl-y:execute-silent(echo -n "$PWD/"{} | pbcopy)' # ...as an ABSOLUTE path
```

`{}` is the current line, `execute-silent` runs without flashing the screen, and fzf stays open.

**Make it permanent.** Your `FZF_DEFAULT_OPTS` already lives in `shell/.zshrc` — add the bind to that same block so every `fzf` (and `Ctrl-T`, `fzf-tab`) gets Ctrl-Y copy:

```sh
export FZF_DEFAULT_OPTS="
    --height 60%
    --layout=reverse
    --border
    --bind 'ctrl-y:execute-silent(echo -n {} | pbcopy)'
    --preview '[ -d {} ] && eza -T --level=2 --color=always {} || bat --color=always --style=numbers {}'
  "
```

Note: fzf shows paths **relative** to where it launched (your default command is `fd --strip-cwd-prefix`). For an absolute path, prepend `$PWD/` as above, or `realpath` the pick after the fact.

## With your other tools

```sh
# JSON / YAML
pbpaste | jq .                                  # pretty-print clipboard JSON to the terminal
pbpaste | jq -r '.token' | pbcopy               # extract one field, put it back on the clipboard
pbpaste | yq -P                                 # pretty-print clipboard YAML
yq --front-matter=extract '.title' note.md | pbcopy   # copy a .md frontmatter field

# git
git rev-parse HEAD | tr -d '\n' | pbcopy        # copy the commit sha (no newline)
git branch --show-current | pbcopy              # copy current branch name
gh pr view --json url -q .url | pbcopy          # copy the PR url

# markdown / text
pbpaste | glow -                                # render clipboard markdown, styled, in the terminal
speak                                            # read the clipboard aloud (pbpaste → sanitizer → voice)

# paths
pwd | tr -d '\n' | pbcopy                        # copy current dir (or: copypath)
realpath ./some/file | tr -d '\n' | pbcopy       # copy an absolute path
```

## Images — the text-only limit

`pbcopy`/`pbpaste` only move **text**. For images on the clipboard, [pngpaste](../07-pdf-images/04-pngpaste.md) is the counterpart:

```sh
pngpaste shot.png                                # clipboard image → file
pngpaste - | img-convert.sh ...                  # clipboard image → stdout → a script
```

Screenshot straight to the clipboard with **⌘⌃⇧4** (region) or **⌘⌃⇧3** (full), then `pngpaste` it into a file or pipe.

## Gotchas

| Trap | Fix |
|---|---|
| `echo` adds a trailing `\n` | `printf '%s'` or `echo -n` for exact strings |
| `pbcopy "text"` does nothing | it reads **stdin**, not args — always pipe |
| copying an image fails | `pbcopy` is text-only — use [pngpaste](../07-pdf-images/04-pngpaste.md) |
| over SSH it "doesn't copy" | it targets the **remote** Mac's clipboard, not your local one |
| UTF-8 mangled under a C locale | `export LANG=en_US.UTF-8` (already set in your shell) |

## Why it matters
The clipboard is the universal hand-off: text from Claude Code, a browser, a man page, or an `fzf` pick all flow through the same two commands. Pairing `pbpaste`/`pbcopy` with the tools already in this setup — `fzf`, `jq`, `git`, `glow`, [speak](../06-media-av/06-edge-tts.md), [pngpaste](../07-pdf-images/04-pngpaste.md) — turns the clipboard into a scriptable junction instead of a manual ⌘C/⌘V step.

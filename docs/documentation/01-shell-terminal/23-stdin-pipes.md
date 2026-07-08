---
title: stdin, stdout & pipes
type: guide
status: active
updated: 2026-07-04
audience: internal
description: What the standard input/output/error streams actually are, how redirection and pipes work, and the `-` convention CLI tools use to mean "read from stdin instead of a file."
aliases:
  - stdin
  - stdout
  - pipes
  - standard-streams
tags:
  - domain/shell
  - pattern/tui
related:
  - "[[01-cli-cheatsheet|CLI cheatsheet]]"
  - "[[12-fzf|fzf]]"
  - "[[06-pbcopy-pbpaste|pbcopy & pbpaste]]"
---

# stdin, stdout & pipes

## Purpose

Every command-line program is handed three data streams the moment it starts, before it even reads its arguments. Almost every "how do these two commands connect" question — `|`, `>`, `--file=-`, `xargs` — is really just a question about these three streams. Once they click, a lot of shell syntax that looks like memorized incantation turns out to be one idea reused everywhere.

## The three streams

| Stream | Number (fd) | Default source/destination | In plain terms |
|---|---|---|---|
| **stdin** (standard input) | `0` | your keyboard | "where this program reads its input from" |
| **stdout** (standard output) | `1` | your terminal screen | "where this program writes its normal output" |
| **stderr** (standard error) | `2` | your terminal screen | "where this program writes error/status messages" |

Nothing here is a file on disk. They're just three open **file descriptors** every process inherits from the shell that launched it — the process doesn't know or care whether fd 0 is your keyboard, a file, or another program's output. That indifference is the entire trick: the shell decides what's actually on the other end, the program just reads fd 0 / writes fd 1 and 2.

stdout and stderr are separate streams so that a program's real output and its error chatter don't get mixed together — `grep pattern file.txt > results.txt` still shows you a "permission denied" on screen even though the matches went to the file.

## Redirection — pointing a stream at a file

```sh
command > file.txt     # stdout → file.txt (overwrite)
command >> file.txt    # stdout → file.txt (append)
command < file.txt     # file.txt → stdin
command 2> errors.txt  # stderr → errors.txt
command &> all.txt     # both stdout and stderr → all.txt
command 2>/dev/null    # throw errors away entirely
```

`/dev/null` is the "nowhere" file — anything written there vanishes. `command 2>&1` means "send stderr to wherever stdout is currently going" (note: no `$` before the `1` — that's a stream number, not a variable).

## Pipes — wiring one program's stdout to another's stdin

```sh
command1 | command2
```

This is the one that matters most day-to-day: it connects `command1`'s **stdout** directly to `command2`'s **stdin**, with no temp file in between. Chain as many as you want:

```sh
rg --line-number "TODO" . | fzf | xargs bat
#  ^ search               ^ filter interactively ^ open the picked result
```

Each stage only knows "read stdin, write stdout" — it has no idea what's upstream or downstream. That's why these tools compose so freely: `rg`, `fzf`, `jq`, `sort`, `grep`, `xargs` all speak the same two streams.

## The `-` convention

Once a tool supports reading from stdin, it needs a way to say "use stdin here" in a place that normally expects a filename. The near-universal convention is a bare `-`:

```sh
brew bundle --file=-        # read the Brewfile from stdin, not a file on disk
curl -s URL | tar xz -C dir -f -   # tar: read the archive from stdin
jq . -                       # jq: read JSON from stdin (also jq's default with no file arg)
```

`-` isn't a real filename — every tool that accepts it has a special check: "if the filename argument is literally `-`, read/write the stream instead." Not every tool supports this (check `--help`), but it's common enough to always try first before writing a temp file.

## Use cases

**Filter a config file before installing it, without editing the file:**
```sh
grep -v -E '"(handbrake|clamav)"' brewfile-cli | brew bundle --file=-
```
Nothing on disk changes — `grep` reads the real file, drops the matching lines, and the filtered result flows straight into `brew bundle` as if it were the file.

**Clipboard in, command out (or the reverse):**
```sh
pbpaste | jq .              # pretty-print JSON that's on the clipboard
echo "hello" | pbcopy       # send a string straight to the clipboard
```

**Search, then act only on what matched:**
```sh
fd -e md | xargs wc -l                    # line-count every markdown file
rg -l "TODO" . | fzf | xargs -o code      # fuzzy-pick a file containing TODO, open it
```
`xargs` is the bridge for tools that *don't* read stdin themselves (like `code` or `rm`) — it takes lines from stdin and turns each one into an argument on a new command line.

**Pipe a command's output straight into a pager or editor, no temp file:**
```sh
git log --oneline | glow -              # render as if it were a markdown file
curl -s https://example.com/data.json | jq '.items[]'
```

**Redirect errors away from a script's normal output:**
```sh
./bin/some-script.sh > output.log 2>&1 &   # log everything, run in the background
```

## Why this matters here

Half this repo's CLI stack is built from small single-purpose tools designed to be piped together — `fd`/`rg` → `fzf` → `bat`/`xargs`, `jq`/`yq` on JSON/YAML, `pbcopy`/`pbpaste` at either end. None of that composability exists without stdin/stdout being the shared interface every tool agrees to speak.

## Future use
Nothing tracked yet — this is background knowledge, not a tool with its own config or install step.

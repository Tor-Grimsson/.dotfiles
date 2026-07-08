---
title: llm
type: reference
status: active
updated: 2026-07-05
verified: 2026-06-09
description: Simon Willison's CLI for talking to LLMs from the terminal. Wired to Claude via the llm-anthropic plugin; defaults to Haiku 4.5 for cheap casual queries.
aliases:
  - llm
tags:
  - domain/ai/llm
  - pattern/cli
  - integration/uv
  - provider/anthropic
links:
  website: https://llm.datasette.io
  repo: https://github.com/simonw/llm
  manual: https://llm.datasette.io/en/stable/
  pypi: https://pypi.org/project/llm/
  plugin: https://github.com/simonw/llm-anthropic
covers:
  - install via uv + the llm-anthropic plugin
  - one-shot vs `llm chat`
  - piping, `-c` continue, `-m` model override
  - Claude model aliases (dots) + setting the default
related:
  - "[[04-uv|uv]]"
  - "[[06-pipx|pipx]]"
  - "[[13-ponytail|ponytail]]"
---

## Summary
Ask an LLM a question from the terminal — one-shot or interactive. Multi-provider via plugins; here it's pointed at **Claude** through `llm-anthropic`, defaulting to **Haiku 4.5** (cheapest, fastest) for casual queries.

| Command | Does | Needs |
|---|---|---|
| `llm "..."` | one question → one answer, prints and exits | key + `llm-anthropic` |
| `llm chat` / `llmc` | interactive back-and-forth REPL, stays open until `exit`/Ctrl-D | key + `llm-anthropic` |
| `llm -c "..."` / `cllm "..."` | continue the previous conversation (shell alias for `-c`) | a prior exchange (logged to SQLite) |
| `cat file \| llm "..."` | pipe file/command output in as context for that one prompt | — |

Picked over `ata`/`trf`: those only speak OpenAI-compatible providers, so reaching Claude through them means the OpenAI-compat shim. `llm` + `llm-anthropic` talks to the **native** Anthropic API instead.

## Setup
1. Install: `uv tool install llm` (see [[04-uv|uv]])
2. Add Claude support: `llm install llm-anthropic` — this is **llm's own** plugin installer (injects into llm's venv), not `uv install`.
3. Key: `llm keys set anthropic` → paste the Anthropic API key (from the vault). It's stored in llm's config dir, **not** the repo — run `llm keys path` to see where.
4. Default to the cheap model: `llm models default claude-haiku-4.5`
5. Test: `llm "say hi in three words"`

## Use

```sh
llm "explain tmux in one sentence"            # one-shot, default model (Haiku 4.5)
llm chat                                       # interactive session; exit / Ctrl-D to leave
llmc                                        # same thing — shell alias for `llm chat`
llm -c "and how do I detach?"                  # continue the previous answer
cllm "and how do I detach?"                    # same thing — shell alias for `llm -c`
cat error.log | llm "what's wrong here?"       # pipe stdin in — no flag needed, just works
llm "summarize this" < notes.md                # file as input
llm -m claude-sonnet-4.6 "harder question"     # one-off model override
llm -s "you are a terse sysadmin" "..."        # set a system prompt
llm logs -n 3                                  # show the last 3 logged exchanges
```

**Piping vs `-c` — two different things.** Piping (`cat x | llm "..."`) feeds *content* into one prompt. `-c`/`cllm` (or `--cid <id>` for a specific past thread) continues *conversation memory* across separate one-shot calls — every `llm`/`llm chat` exchange is logged to a local SQLite DB (`llm logs path`) regardless, so `-c` always has something to continue. Verified 2026-07-05: `echo "the secret word is banana47" | llm "..."` then a separate `llm -c "..."` call both landed under the same `conversation:` ID in `llm logs list`.

## Models — `llm-anthropic` aliases use **dots**, not hyphens

| Alias | Model | $ /1M (in/out) | For |
|---|---|---|---|
| `claude-haiku-4.5` | Haiku 4.5 | $1 / $5 | casual default — cheap + fast |
| `claude-sonnet-4.6` | Sonnet 4.6 | $3 / $15 | more capable |
| `claude-opus-4.8` | Opus 4.8 | $5 / $25 | heavy reasoning |

`llm models` lists everything; `llm models default <alias>` sets the default. The full IDs (`anthropic/claude-haiku-4-5-20251001`) also work. New Claude models arrive via plugin updates: `llm install -U llm-anthropic`.

## Why installed
A lightweight terminal client for quick LLM questions without opening a browser or burning Claude Code context. The `ata`/`trf` tool is lighter but OpenAI-shaped — native Claude there needs the compat shim, so `llm` won that call.

## Biggest win
`cat <thing> | llm "..."` — pipe any file, log, or man page straight into Claude from the shell, and every exchange is logged to SQLite for free (`-c` to continue, `llm logs` to review).

## Reproduce on the other machine
`brew bundle` already installs [[04-uv|uv]]. Then re-run the four setup steps — the plugin, key, and default model live in llm's own config dir (not the repo), so they don't sync:

```sh
uv tool install llm
llm install llm-anthropic
llm keys set anthropic            # key from the vault
llm models default claude-haiku-4.5
```

## Future use
Templates (`llm -t`) if a casual query hardens into a repeated prompt; embeddings (`llm embed`) if local semantic search becomes useful; exporting the Anthropic key to `~/.secrets` so other tools share one source instead of llm's private keystore.

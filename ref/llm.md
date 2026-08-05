# llm — Claude from the shell · ~/.local/bin/llm (uv tool, not brew)

Filter: `ref-llm <word …>` · Simon Willison's CLI on the native Anthropic
via `llm-anthropic`. Default is Haiku 4.5. Every exchange logs to SQLite.

## llm — ask

| command          | does                                     |
|------------------|------------------------------------------|
| llm "question"   | one-shot — prints and exits              |
| llmc             | interactive REPL (alias for llm chat)    |
| cllm "follow-up" | continue the last one (alias for llm -c) |
| pfx C-l          | the popup — pick a mode, type, read      |

[e] pipe in · `cat error.log | llm "what's wrong here?"`
[e] file in · `llm "summarize this" < notes.md`
[e] system  · `llm -s "you are a terse sysadmin" "..."`
[e] one-off · `llm -m claude-sonnet-4.6 "harder question"`

## llm-pick — the popup

the tmux prefix is `C-a`, so `pfx C-l` floats the menu over the pane

| mode      | does                                    |
|-----------|-----------------------------------------|
| ask       | one-shot question, default model        |
| continue  | keep going from the last exchange       |
| chat      | the interactive REPL                    |
| clipboard | pipe the clipboard in, then ask         |
| model     | one-off model override, then ask        |

| fact    | value                                       |
|---------|---------------------------------------------|
| close   | esc at the menu · q leaves the pager        |
| chat    | needs `exit` or Ctrl-D, not esc             |
| answers | paged in less, so they survive the popup    |
| script  | `bin/llm-pick` — `llm-pick --help`          |

[e] menu   · `llm-pick`
[e] no fzf · every mode is a plain `llm` flag — see the ask section

## llm — models

aliases use DOTS, not hyphens — the one thing people get wrong

| alias             | $ in/out per 1M | for                  |
|-------------------|-----------------|----------------------|
| claude-haiku-4.5  | 1 / 5           | the default — casual |
| claude-sonnet-4.6 | 3 / 15          | more capable         |
| claude-opus-4.8   | 5 / 25          | heavy reasoning      |

[e] list all    · `llm models`
[e] set default · `llm models default claude-haiku-4.5`
[e] new models  · `llm install -U llm-anthropic`

## llm — memory

| fact       | value                                         |
|------------|-----------------------------------------------|
| pipe vs -c | pipe feeds CONTENT · -c continues a THREAD    |
| logged     | every exchange, always — SQLite, no flag      |
| where      | `llm logs path`                               |
| review     | `llm logs -n 3`                               |
| a thread   | `llm --cid <id> "..."` resumes a specific one |

## llm — setup

key + plugin live in llm's own config dir, NOT the repo — they don't sync

| step | command                             |
|------|-------------------------------------|
| 1    | uv tool install llm                 |
| 2    | llm install llm-anthropic           |
| 3    | llm keys set anthropic              |
| 4    | llm models default claude-haiku-4.5 |

never export ANTHROPIC_API_KEY on a machine running Claude Code — it bills
the API instead of the subscription

----
doc: docs/documentation/04-dev-languages/09-llm.md

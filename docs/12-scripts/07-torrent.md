---
title: Torrent scripts
type: reference
status: active
updated: 2026-06-05
description: tor-* — Jackett torrent indexer + CLI search, feeding Transmission.
tags:
  - project/dotfiles
  - domain/scripts/torrent
---

# Torrent (`tor-`)

| Script | Does | Usage |
|--------|------|-------|
| `tor-jackett` | Symlink → the local Jackett binary (`~/.local/share/jackett/jackett`). Torrent indexer proxy. Gitignored (machine-local) | `tor-jackett` |
| `tor-search` | Search Jackett, pick a result, send its magnet to Transmission | `tor-search <search term>` — run `--help`/`-h` |

## How the chain works

```
tor-search "query"
   │ GET /api/v2.0/indexers/all/results?apikey=…&Query=…
   ▼
Jackett (daemon, http://127.0.0.1:9117)        ← start with `tor-jackett`
   │ queries every configured indexer, aggregates JSON
   ▼
tor-search renders a numbered table: [id] indexer | size MB | seeders | title
   │ you type a result id
   ▼
transmission-remote -a "<magnet>"               ← download starts in the daemon
```

- Jackett is a **proxy**: one local API in front of many torrent-site indexers. Indexers are configured in its web UI (`http://127.0.0.1:9117`).
- `tor-search` is interactive — after the table it prompts `Enter ID to download (or 'q' to quit)` and ships the chosen magnet to Transmission.
- Requires `jq` (brewfile) and a running `transmission-daemon` for the handoff.

## API key

`tor-search` resolves the key in this order:

1. `JACKETT_API_KEY` env var, if exported.
2. Bitwarden: `bw get password Jackett` (folder `kol-tokens`) — needs an unlocked session, so in practice: `bwu` once per shell, then `tor-search` just works. See [Bitwarden CLI](../05-network-security/03-bitwarden-cli.md).

The key itself comes from the Jackett dashboard (top-right "API Key").

## Examples

```sh
# multi-word query — no quotes needed, args are joined
tor-search dune part two

# the result table
🔍 Searching Jackett for: dune part two...
[0] 1337x      | 2480MB | S:312 | Dune.Part.Two.2024.1080p…
[1] TPB        | 4200MB | S:198 | Dune Part Two 2160p…
Enter ID to download (or 'q' to quit): 0
🚀 Sending to Transmission...

# watch it download (live dashboard, see 06-media-av/05-transmission-cli)
watch -n 1 transmission-remote -l

# typical failures
tor-search foo
❌ No results …          # Jackett not running → start `tor-jackett`, retry
Error: no API key …      # locked vault → run `bwu` first
```

## Streamlining (speculative — see .kol/llm-context/plan.md)

Target flow: *anywhere in the UI → hotkey → terminal drops down → type query → results.* The friction points and their fixes, in impact order:

1. **Kill the cold start instead of waiting for it.** Run Jackett + `transmission-daemon` as **launchd user agents** (`KeepAlive=true`) so both are always up — then there is no "run up Jackett and stash the query", searches are instant at all times. Two small plists in `~/Library/LaunchAgents`, loaded once. This is the single biggest win.
2. **Hotkey terminal: iTerm2 Hotkey Window.** Built-in, zero code: dedicated profile → "A hotkey opens a dedicated window with this profile" → system-wide key (e.g. ⌥⌘T) slides a terminal over any app. Type `tor-search …` there. (Alternatives: Shortcuts.app / Automator with a global shortcut, Raycast script command — all heavier than the native iTerm feature.)
3. **Self-healing fallback in `tor-search`.** If the API doesn't answer, the script starts `tor-jackett` itself, polls `127.0.0.1:9117` until ready (this is the "stash the query" behavior), then fires. Only worth it if launchd (1) is rejected.
4. **Niceties, later:** `fzf` picker instead of the numbered prompt; loop mode (back to query prompt after sending instead of exiting); sort by seeders / `--top N`.

With (1) + (2) the whole flow is: hotkey → `tor-search query` → pick → done. (3) and (4) are polish.

## Watch downloads live

See [Transmission (CLI)](../06-media-av/05-transmission-cli.md) — `watch -n 1 transmission-remote -l` renders a self-refreshing download dashboard in the terminal.

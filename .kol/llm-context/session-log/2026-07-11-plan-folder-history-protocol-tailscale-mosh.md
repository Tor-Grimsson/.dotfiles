# Session: llm-plan folder + HISTORY.md protocol restructure; tailscale/mosh remote-access docs

**Date:** 2026-07-11
**Agent:** Grim (Opus 4.8)
**Summary:** Restructured the agent-context protocol — speculative plans moved out of `llm-context/` into a peer `.kol/llm-plan/` folder (one `NN-slug.md` per plan), `history.md` → `HISTORY.md` (uppercase = system file) — and propagated it through the boot file, the scaffold template, three skills, and the ops doc. Then documented the iPad-built tailscale/mosh keyless-remote-access setup into the vault and added `tailscale` to `brewfile-cli`. Closes the whole ssh/mosh/remote-crash arc from this session.

## Changes Made

### Protocol restructure (unified across kol-system repos)
- **New peer folder `.kol/llm-plan/`** — `01-parking-lot.md` (backlog, was `plan.md`) + `02-docs-restructure.md` (was `docs-restructure-plan.md`) + `README.md` (the "one plan per `NN-` file" convention). Old `plan.md` / `docs-restructure-plan.md` removed.
- **`history.md` → `HISTORY.md`** — case-only rename; uppercase joins `ARCHITECTURE`/`AGENT-CONTEXT` in the naming law.
- **Repointed cross-refs:** `llm-context/{README,ARCHITECTURE,AGENT-CONTEXT}`, root `LLM_RULES.md` (tree + naming law + 🔔 protocol-update notification), `docs/scripts/07-torrent.md`.
- **Scaffold template** (`claude/packages/scaffold/03-scaffold-llm-context/`): `LLM_RULES.md` + `HISTORY.md` rename + new `.kol/llm-plan/` so future scaffolds emit the new shape.
- **Skills:** `scaffold-llm-context`, `kol-docs-overview`, `kol-migrate-structure` repointed. Resolved a canon conflict — `kol-docs-overview` called `plan` a *dated* folder → corrected to `NN-`. `kol-docs-{fm,md}` checked, left clean (their "plan" is the doc archetype, not the file).
- **Docs (yours):** `docs/operations/02-claude-agents/01-agent-context-protocol.md`.

### Tailscale / mosh remote access
- `brewfile-cli` += `brew "tailscale"` (the daemon build; **mosh already present**).
- New **`docs/operations/04-remote-machine/03-tailscale-remote-access.md`** — normalized from the iPad notes: daemon-not-GUI, keyless accept-mode SSH ACL, mosh transport, sleep-prevention. + INDEX row + reciprocal `01-ssh-toolkit` cross-links.
- **Not imported:** the iPad `02-workflows.md` — it's a mislabeled subset of the existing `docs/kol-cli/02-nvim-workflows.md` (nvim/yazi), not a remote-keybinds sibling.

### Crash diagnosis (the arc, put to bed)
- The 04:30 tmux drop was **mosh transport**, not `keys`/vi-mode/content. Mosh survives network blips by design → a drop means the server/client process paused or died (**Mac sleep** at 4:30am is the prime suspect).
- **Shift+Enter doesn't line-break over mosh** — mosh 1.4.0 carries no extended-key (Kitty/CSI-u) protocol, so the sequence collapses to a plain CR. Ghostty (native) → tmux (`extended-keys on`) works locally; mosh is the weak hop. **Use ssh for Claude Code sessions.**

## Current State
### Verified
- New `.kol/` layout on disk (`llm-context/{…,HISTORY.md}` + `llm-plan/{README,01,02}`); final grep clean of stale `plan.md`/`history.md` refs; boot path (ARCHITECTURE→AGENT-CONTEXT→session-log) intact.
- Tailscale doc + INDEX + cross-links conform to kol-docs; `brewfile-cli` line added.

### Needs the user
- `brew bundle --file=~/.dotfiles/brewfile-cli` to install tailscale where it isn't already (both Macs already have the daemon per the setup).

## Next Steps (real-world, documented in the doc)
- Sleep-prevention on both Macs (`pmset` or `caffeinate` in tmux) — a sleeping host drops SSH/mosh.
- Record `yrs-imac`'s login user + save a `mosh yrs-imac` Blink alias while it's physically accessible.

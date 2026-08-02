---
title: Lobby — the cross-repo ticket system
type: index
status: active
updated: 2026-08-01
description: The lobby pattern — a repo-root intake queue addressed to that repo's agent, four connected repos, one ledger law, the return receipt that tells the filing repo when its ticket closed, and the skills and scripts that write into and read out of it.
tags:
  - project/dotfiles
  - domain/tooling
  - pattern/workflow
related:
  - "[[operations/systems/INDEX|systems/]]"
  - "[[01-registry|the four lobbies]]"
  - "[[02-lifecycle|the ticket protocol]]"
  - "[[03-tooling|skills + scripts]]"
  - "[[04-conventions|entry + ledger shape]]"
  - "[[05-lookup|at a glance]]"
  - "[[operations/systems/repo-map/INDEX|repo map]]"
---

# Lobby

**The problem it solves:** you find something in repo A that is repo B's to fix. Telling the user is lossy, and by the time B's agent is running the context is gone. A lobby is B's inbox — A writes a ticket with its evidence, and B's agent finds it on arrival.

A **lobby** is a `lobby/` folder at a repo's root, holding work addressed to *that repo's agent*. It sits deliberately **outside `docs/`**: it is a work queue, not published documentation, so it does not ride the docs-framework conventions.

## The shape

```
<repo>/lobby/
├── INDEX.md      THE LEDGER — every entry, its state, its date.
│                 The truth. Never a raw `ls`.
├── inbox/        live entries — one .md per ticket, sent TO this repo
├── done/         closed, each carrying its ## ✅ RESOLUTION section
├── archive/      ⚪ parked (not-now) · ⚫ retired (not-ever) · ownership notes
├── outbox/       receipts for tickets this repo FILED elsewhere —
│                 what came back, and what stays here
└── _assets/      screenshots and evidence
```

`inbox/` keeps the queue a folder rather than a filename convention, so `INDEX.md` can be the one ledger without competing with entries for the root.

`outbox/` is that queue reflected. A ticket used to travel one way and never come back: `agent-init-docs-index` was filed **from a kol-ds-ui session**, closed in dotfiles on 2026-08-01, and its resolution ends *"the per-repo half stays open by design"* — a job only kol-ds-ui can do, which kol-ds-ui has no record of owning. The receipt closes that loop, and `ag-init` reads it at boot. Protocol: [[02-lifecycle|02-lifecycle]] § The return receipt.

## How the estate wires

```
     ANY repo, any session
              │
              │  /lobby-dotfiles · /lobby-humpty
              │  /lobby-web      · /lobby-ds
              │  clip-drop.sh --<flag> NAME
              ▼
   ┌──────────┴───────────┬──────────────┬────────────────┐
   ▼                      ▼              ▼                ▼
~/.dotfiles          kol-dumpty/      kol-website      kol-ds-ui
  /lobby              humpty/lobby      /lobby           /lobby
   │                      │              │                │
tooling ·             agent            content ·      component
scripts ·             behaviour:       UI issues      specs · UI
configs ·             muzzle, gates,                  issues
ref cards             output discipline
   │                      │              │                │
   └──────────────────────┴──────────────┴────────────────┘
                          │
                    /lobby-list · bin/lobby · prefix Ctrl+K
                    the agent of THAT repo reads its own queue
                          │
                          │  it closes the ticket, and in the SAME turn
                          │  writes the receipt back —
                          ▼
              <filing repo>/lobby/outbox/<slug>.md
                 ✅ RETURNED · 🟢 closed there
                 📌 Remainder here: <what this repo still owes>
                          │
                          ▼
                  /ag-init, next session in the filing repo
```

## Where to complain

| the finding is about | file it to |
|---|---|
| a script, a config, a ref card, the shell, the desk | **dotfiles** |
| the agent's own behaviour — muzzling, word-soup, gates, ignoring a law | **humpty** |
| the public site's content or UI | **kol-website** |
| a component, token, or design-system behaviour | **kol-ds-ui** |

Misfiled beats unfiled — a reader flags the wrong-repo entry and names the right one. But a ticket in the wrong lobby is read by an agent who cannot act on it, so aim first.

## The three laws

1. **The ledger is the truth.** A file's state lives in its `INDEX.md` row, not in your reading of its content. A raw `ls` of `inbox/` is not an audit.
2. **The ticket closes the same turn the work does — at both ends.** Finishing an entry's substance obligates the bookkeeping in the same pass — resolution section, file move, ledger row, **and the receipt returned to the repo that filed it**. Work closed with the ticket left open is the failure this system exists to prevent; work closed with the *filer* never told is the one it kept committing anyway.
3. **Open · closed · stale · parked is the user's call.** The agent reports what the ledger says and executes only moves the ledger's own rules already authorise. It never promotes an entry to "open issue", never declares one stale, never reopens anything.

Full protocol in [[02-lifecycle|02-lifecycle]]. The four lobbies and what belongs in each: [[01-registry|01-registry]]. Every write and read path: [[03-tooling|03-tooling]]. One-screen cheatsheet: [[05-lookup|05-lookup]].

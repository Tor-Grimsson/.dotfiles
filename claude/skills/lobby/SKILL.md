---
name: lobby
description: The lobby router — an interactive dialog that asks what you want (file a ticket · read the queue · audit a ledger) and delegates to the right lobby-* skill. Use on a bare /lobby, or when the user mentions the lobby without saying which side. If they already named the action ("file that to humpty", "show me the queue"), skip the router and use the specific skill.
---

# lobby — the router

A bare `/lobby` is ambiguous: it might mean *file something*, *show me what's queued*, or *this queue looks wrong*. Ask, then delegate. Never guess — guessing wrong writes a ticket nobody asked for, or reports a queue when the user wanted to file.

**If the message already names the action, do not run the router.** "file that to humpty" → `/lobby-humpty` directly. "what's in the lobby" → `/lobby-list` directly. The router is for the bare invocation only.

## Step 1 — what do you want

Ask with **AskUserQuestion**, one question, these options:

| option | means | delegate to |
|---|---|---|
| **File a ticket** | something in this conversation belongs to another repo | step 2 |
| **Read the queue** | show what's waiting for *this* repo's agent — **and what came back** from tickets it filed elsewhere | `/lobby-list` |
| **Audit a ledger** | the queue or its receipts look out of sync with reality | `/lobby-hygiene` |
| **All queues** | what's waiting across all four lobbies | step 3 |

## Step 2 — which lobby

Only if they chose *File a ticket*. Ask with **AskUserQuestion**, and put your own best guess first, labelled `(Recommended)` — you have the conversation, so you usually know:

| option | for | delegate to |
|---|---|---|
| **dotfiles** | scripts · configs · ref cards · shell · desk | `/lobby-dotfiles` |
| **humpty** | the agent's own behaviour — muzzle, gates, output | `/lobby-humpty` |
| **kol-website** | site content · UI | `/lobby-web` |
| **kol-ds-ui** | components · tokens · design-system behaviour | `/lobby-ds` |

Then **hand off completely** — the chosen skill owns the entry shape, the ledger row, the history line **and the `outbox/` receipt in this repo**. Do not write a half-entry here.

Two specialised writers the router does not offer, because they need an artefact in hand rather than a conversation: `/lobby-icon` (an SVG to promote) and `/lobby-ds` reached directly with a component (it emits a spec, not a note).

## Step 3 — all queues

Read every registered lobby's ledger and report one table across all four:

```
lobby        queue  🔵  🟡  🟠  🔴   out  📌   oldest
dotfiles         1   1   0   0   0     0   0   2026-07-31
humpty           7   0   7   0   0     1   0   2026-07-29
kol-website      1   1   0   0   0     0   0   2026-07-30
kol-ds-ui        2   0   1   0   1     1   1   2026-07-03
```

`out` = receipts in `outbox/` (tickets this repo filed elsewhere); **📌 = closed over there and still owed here** — the column to read first, because it is work this repo owns and has no other record of.

Registry: `~/.dotfiles/files/folders.md` § `lobby` — read it, never hardcode the list. Ledger filename is `INDEX.md` **or** `LEDGER.md` (humpty uses the latter); check both. Live entries are in `lobby/inbox/` — `done/` and `archive/` are not queue, and `outbox/` is not queue either: it is what this repo sent.

`bin/lobby` (`prefix Ctrl+K`) does this same sweep in an fzf popup — mention it once if the user is browsing rather than acting.

## The laws that bind every branch

- **The ledger is the truth, never a raw `ls`.** A file's state lives in its ledger row. For a ticket filed elsewhere, that means the **destination's** ledger — an `outbox/` receipt is a dated copy, not a second truth.
- **Open · closed · stale · parked is the USER's call.** Report what the ledger says. Never promote an entry to "open issue", never declare one stale, never reopen anything.
- **A ticket travels both ways.** Filing writes a receipt in this repo; closing returns it. Neither half is optional bookkeeping.
- **Do not start the work.** A lobby is an inbox.

Protocol: `~/.dotfiles/docs/operations/systems/lobby/` · card: `ref-lobby`.

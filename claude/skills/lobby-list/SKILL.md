---
name: lobby-list
description: READ side of the lobby pattern — check the current repo's root for a lobby/ folder; if it exists, read every entry as instructions and queued work addressed to the agent of THIS repo, then report the queue. Use on arriving in a repo, before starting work, or on /lobby. (Write side: /lobby-ds stages a component spec.)
---

# lobby — read the queue addressed to this repo

Pairs with `/lobby-ds` (which **writes** a component spec into a design-system lobby). This is the **read** side: an agent arriving in a repo checks whether anyone left it instructions.

## What a lobby is

A **repo-root `lobby/`** folder — deliberately *not* under `docs/`, because it's a work queue, not published documentation. It holds issues, specs, ported notes and screenshots staged from elsewhere (often by `clip-drop.sh --<repo>`). Entries address *the agent of this repo*.

## Steps

1. **Look:** is there a `lobby/` at the repo root? No → say "no lobby here" and stop.
2. **Read the LEDGER first** — `lobby/INDEX.md`, or `lobby/LEDGER.md` (humpty uses that name; check both). **The ledger is the truth, never a raw `ls`.** A file's state lives in its ledger row, not in your reading of its content.
3. **Then read the live entries** — `lobby/inbox/*.md`. (`done/` = closed, `archive/` = parked/notes; don't report those as queue.) A lobby that predates the split may still have loose `.md` at the root — read those too and say so.
4. **Read `_assets/`** references — screenshots in a lobby entry are evidence, not decoration; look at them.
5. **Read `lobby/outbox/`** — receipts for tickets **this** repo filed elsewhere. Two classes matter: a receipt whose `Remainder here:` is not `none` (📌 — closed over there, still owed **here**) and one still 🔵 🟡 🟠 (filed, no news — so don't re-file it). A 🟢 with `Remainder here: none` is history; stay silent on it.
6. **Report the queue** as a table: emoji · entry · what it asks · staged · state **exactly as the ledger says it**. Never the words "open issue" for anything the user hasn't called open. Then report the outbox as its own short table — destination · last known · remainder — or one line saying nothing is owed.
   **A lobby is a portal, not a tracker** (2026-08-01). `live` means outstanding **agent** work, never *unconfirmed*. If a row's work is verifiably shipped, or its entry already carries a resolution, or its only remainder is a **user decision**, it is **not** queue — say so plainly and name `/lobby-hygiene` to file it. Reporting four finished rows as a queue is the failure that wrote this line.
7. **Do not start the work.** A lobby is an inbox; the user picks what gets built.
8. Flag **misfiled** entries — an issue about another repo belongs in that repo's lobby (say which).
9. Flag **ledger drift** — a file in `inbox/` with no row, or a row pointing at a missing file. Report it; `/lobby-hygiene` repairs it.
10. Flag **receipt drift** — an `outbox/` stub whose destination ledger has moved on, or a stub with no `Remainder here:` answer. Same repairer.

## The states you'll see

🔵 `filed` · 🟡 `read` · 🟠 `addressed` · 🟢 `closed` · ⚪ `parked` · 🔴 `needs-ruling` (a flag, not a state) · 📌 `remainder` (a flag too — closed at its destination, still owed here; `outbox/` only).
`read` and `addressed` are **never** `closed`. humpty uses its own words (`researched`, `verified`, `retired`) under the same emoji.

## The four registered lobbies

Registry: `~/.dotfiles/files/folders.md` § `lobby` — read it rather than trusting this table.

| repo | holds | writer |
|---|---|---|
| `~/.dotfiles/lobby/` | tooling · scripts · configs · ref cards · desk | `/lobby-dotfiles` |
| `kol-dumpty/humpty/lobby/` | agent behaviour — muzzle, output discipline, gates | `/lobby-humpty` |
| `kol-website/lobby/` | site content · UI | `/lobby-web` |
| `kol-ds-ui/lobby/` | component specs · tokens · DS behaviour | `/lobby-ds` |

⚠ `kol-dumpty/lobby/` (family level) and `kol-dumpty/jabberwocky/lobby/` are **not registered** — the first isn't inside a repo at all. Treat anything there as misfiled and name the repo it belongs in.

`bin/lobby` (`prefix Ctrl+K`) sweeps all four at once. Spec: `~/.dotfiles/docs/operations/systems/lobby/` · card: `ref-lobby`.

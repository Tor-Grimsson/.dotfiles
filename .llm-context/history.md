---
_template:
  version: 1
  path: .llm-context/history.md
  sync: skip
---

# dotfiles — history & decisions

The *why* behind the structure. For rules as enforced, see `ARCHITECTURE.md`. For current state, see `AGENT-CONTEXT.md`.

---

## origin

The repo started on the Intel iMac and was later cloned to an Apple-Silicon MBP. The two drifted: packages installed ad-hoc on each never made it back into the `Brewfile`, and the MBP grew a separate Claude config living in iCloud Workbox. A 2026-06-04 session audited the drift and pulled the moving parts back under git as the single source of truth.

---

## alternatives surveyed and rejected

### Per-host Brewfiles (core + Brewfile.mbp + Brewfile.imac)
- Considered because the machines have intentional leans (iMac = media/server, MBP = recon/mobile).
- **Rejected:** user chose a single unified Brewfile — simpler, one file, accept that each machine gets the other's stack.

### iCloud as the config sync mechanism
- The MBP already ran `~/.claude` out of iCloud Workbox (auto-sync, no commits).
- **Rejected as the source of truth:** no versioning/rollback/review, and two sync systems (iCloud + git) over the same files guarantees drift. Git/dotfiles wins; iCloud is demoted to media + Obsidian vaults.

### Symlinking skills straight from kol-system
- kol-system is the canonical skill source.
- **Rejected:** kol-system may not exist on every machine. Skills (and the kol-docs `_framework`) are **copied/bundled** into the repo so it's self-contained; re-sync via `init-agent-context-sync`.

---

## core principles

- **One source of truth per concern.** Kill parallel systems (iCloud vs git, Brewfile vs reality, brew-p10k vs omz-p10k).
- **Portable over clever.** No hardcoded brew prefixes; bundle the framework rather than depend on an external repo.
- **The user owns side-effects.** The agent prepares files; the user runs git and all provisioning.

---

## architectural decisions

### Why a unified (not per-host) Brewfile
User's explicit call. Trade-off accepted: the iMac gains the recon stack, the MBP gains the media/torrent stack. Pruning happens via `brew autoremove` + manual leaf review, not by splitting the file.

### Why `~/.claude` moved into the repo
To stop Claude config (CLAUDE.md, skills, hooks, settings) drifting between machines and to get the kol-docs/agent-context skills onto both. Symlink-back keeps `~/.claude` working while git holds the truth.

### Why the per-tool `docs/` catalog
`TOOLING.md` is the audit (drift + decisions); `docs/` is the durable catalog — one `reference` doc per tool with verified links and a why/use/win/how/future write-up, so the rationale for every install survives.

---

## what's *not* in this document

- Current state, open items, gotchas → `AGENT-CONTEXT.md`
- Rules as invariants → `ARCHITECTURE.md`
- Session-by-session log → `session-log/`
- Speculative future work → `plan.md`

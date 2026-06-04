---
_template:
  version: 1
  path: .llm-context/ARCHITECTURE.md
  sync: skip
---

# dotfiles — Architecture

Load-bearing decisions. Each was chosen deliberately and has downstream consequences. Don't revisit without explicit reason. For the narrative *why*, see `history.md`.

---

## §1 — Two machines, one repo, no hardcoded brew prefixes

`~/.dotfiles` is shared by an **Intel iMac** (`/usr/local`) and an **Apple-Silicon MBP** (`/opt/homebrew`).

**Consequence:** never hardcode a brew prefix in any tracked file — use the bare command name (PATH) or `$(brew --prefix)`. Two such bugs were fixed on 2026-06-04 (`claude/settings.json` node path, `scripts/transmission_scan.sh` clamscan path).

**Do not revisit** unless the repo stops being cross-arch.

---

## §2 — Unified Brewfile, and `Brewfile` ≡ `Brewfile-mirror.txt`

One Brewfile, identical on both machines (chosen over a per-host split). `Brewfile-mirror.txt` is a **byte-identical** mirror the user maintains.

**Consequence:** every edit to `Brewfile` requires the same edit to `Brewfile-mirror.txt` in the same pass.

**Do not revisit** unless a per-host split is deliberately adopted.

---

## §3 — `~/.claude` is repo-backed via symlink; git is the source of truth

`claude/` holds `CLAUDE.md`, `settings.json`, `skills/`, `hooks/`, `commands/`, `agents/`, `output-styles/`. `bootstrap.sh` symlinks each into `~/.claude/`. Editing `~/.claude/<x>` edits the repo.

**Consequence:** dotfiles (git) is the single source of truth for portable LLM context — **not** iCloud. iCloud is for media + Obsidian vaults only.

**Do not revisit** unless abandoning git-as-source-of-truth.

---

## §4 — Skills are sourced from kol-system and bundled self-contained

Canonical skill source is `~/dev/projects/kol-system/claude/skills/` + `~/dev/projects/kol-system/_framework/`. Curated copies live in `claude/skills/`. The kol-docs skill **bundles** `_framework/` so it has no external dependency.

**Consequence:** the repo is portable to a machine without kol-system. Re-sync skills/framework from kol-system via the `init-agent-context-sync` skill.

**Do not revisit** unless skills move to a package manager.

---

## §N — Non-goals (do not reopen without explicit ask)

- iCloud as a config-sync mechanism (it's for media + vaults).
- Auto-installing `macfuse` or Mac App Store apps via the bundle (kext/perms pain).
- The agent running `git` or provisioning commands (`brew`, `bootstrap.sh`).
- Tracking `~/.claude` runtime state (history, sessions, projects, caches) in the repo.

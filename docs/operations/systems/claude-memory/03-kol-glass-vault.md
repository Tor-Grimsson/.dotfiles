---
title: The kol-glass vault — lens, git policy, sync
type: reference
status: active
updated: 2026-07-28
description: The aggregator vault's role in the memory system — current state and drift (4 broken links, not yet a git repo, contradictory ignore rules), the new memory/ lens beside repos/, the verdict that the vault SHOULD be a git repo (tracking scaffold, never links), and the sync-script spec.
tags:
  - project/dotfiles
  - domain/tooling
related:
  - "[[INDEX|kol-claude-memory]]"
  - "[[01-memory-system|the memory system]]"
  - "[[02-repo-contract|dependencies & repo contract]]"
---

# The kol-glass vault

`~/dev/projects/kol-glass` — the aggregator lens: one Obsidian vault symlinking every repo's `docs/` so all documentation is searchable in one place. It owns nothing; every file is a source-repo file seen through a link. The memory system extends the same pattern with a second lens.

## Current state (audited 2026-07-28)

- [x] 34 `repos/` links + `INDEX.md` + rules authored (2026-07-10)
- [ ] **4 links broken** — `kol-distress` · `kol-docs` · `kol-noter` · `kol-radar` (their `kol-apps/` sources moved)
- [ ] **2 repos with fresh `docs/` not folded in** — `kol-chess` · `_kol-quick`
- [ ] **Not a git repo** — has a `.gitignore` but no `.git`; the ignore rules also contradict the INDEX (INDEX says all links are untracked machinery, the file ignores only 4 by name)
- [ ] No `memory/` lens yet

## Target shape

```
kol-glass/
├── INDEX.md            tracked — the vault's own content
├── .gitignore          tracked — ignores ALL links + .obsidian + boot file
├── sync.sh             tracked — regenerates every link, both lenses
├── LLM_RULES.md        untracked (symlink to the dotfiles scaffold package)
├── .obsidian/          untracked (machine-local Obsidian state)
├── repos/              untracked — the docs lens, one link per repo docs/
└── memory/             untracked — the memory lens
    ├── _global   ──▶ ~/.dotfiles/claude/memory
    └── <repo>    ──▶ <repo>/.kol/llm-memory
```

## Git verdict: yes — track the scaffold, never the links

The vault **should be a git repo**. What's worth versioning is the *machinery that rebuilds it* — `INDEX.md`, the ignore rules, `sync.sh` — which is also exactly the shareable artifact ([[04-sharing|04]]). The links themselves are machine-local output: derivable in seconds, different per machine, meaningless off-machine. Tracking them would version absolute paths that git can't follow anyway.

| Tracked | Untracked (regenerated) |
|---|---|
| `INDEX.md` · `.gitignore` · `sync.sh` | `repos/*` · `memory/*` · `.obsidian/` · `LLM_RULES.md` |

Initialising the repo and any commits are the user's own step — the agent prepares content only.

## sync.sh spec

One idempotent script, plain filesystem ops, no arguments needed:

1. **Scan** the project roots (`~/dev/projects/*`, one level of nesting for app-collection dirs, plus `~/.dotfiles`) for repos carrying `docs/` and/or `.kol/llm-memory/`.
2. **Link** each hit into the matching lens (`ln -sfn`), name = repo dir name; `_global` always points at the dotfiles global tier.
3. **Prune** dangling links in both lenses.
4. **Write-path pass** — for each repo, derive its `~/.claude/projects/<key>` from the absolute path (`/`→`-`) and ensure `<key>/memory` is a link to the repo tier; a real dir found there gets its files merged into the repo tier first (see failure modes in [[02-repo-contract|02]]).
5. **Report** — print added / pruned / merged / untouched counts; never touch anything outside the two lenses and the `<key>/memory` paths.

Roots and the dotfiles location sit in two variables at the top of the script — the portability seam ([[04-sharing|04]]).

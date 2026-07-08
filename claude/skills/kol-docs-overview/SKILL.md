---
name: kol-docs-overview
description: Orientation explainer for the WHOLE kol repo structure in one read — the .kol/ machinery (llm-context agent state, docs-framework spec, the symlinked LLM_RULES boot file) AND the docs/ vault (documentation subject + operations machinery + .obsidian), why it's shaped this way, what's seeded from dotfiles, and which skill owns what. Not action-based — to actually do the work use scaffold-llm-context (.kol/llm-context + boot), scaffold-docs-system (docs/ + docs-framework), kol-migrate-structure (legacy → .kol), kol-docs-md/-fm (one doc). Use when asked "explain the structure/docs system", "why is .kol/ or docs/ shaped this way", "what's kol-docs", or orienting to an unfamiliar kol repo.
---

# kol-docs-overview

The **front door** to a kol repo's structure. One read to understand *why* both `.kol/` and `docs/` look the way they do — and **which skill owns which piece** — before reaching for a doer. If you're about to author, scaffold, migrate, or move files, stop and use the owner skill (map at the bottom); this skill only explains.

## The structure at a glance

```
<repo>/
  LLM_RULES.md          ← boot pointer. A SYMLINK to one generic dotfiles file. Gitignored.
  .kol/                 ← machinery, hidden at root, outside the Obsidian vault
    llm-context/        ← agent state (this repo's facts)
    docs-framework/     ← the kol-docs spec this repo's docs conform to
  docs/                 ← the Obsidian vault — 100% human-readable
    documentation/      ← the repo's SUBJECT (numbered sections 00-… NN)
    operations/         ← repo MACHINERY (build/CI/release) — a sibling, not a numbered section
    .obsidian/          ← vault config (seeded from dotfiles, gitignored)
```

## The three layers (the split that governs everything)

| Layer | Home | Holds | Owner skill |
|---|---|---|---|
| **Agent state** | `.kol/llm-context/` | Architecture, context, logs — this repo's facts. Outside the vault. | `scaffold-llm-context` |
| **Doc spec** | `.kol/docs-framework/` | The kol-docs framework packages the `docs/` conform to. | `scaffold-docs-system` |
| **Subject** | `docs/documentation/` | What the repo *is about* — numbered sections `00-… NN`. | `scaffold-docs-system` |
| **Machinery** | `docs/<sibling>/` (e.g. `operations/`) | Repo/CI/tooling process — a sibling, never a numbered section. | `scaffold-docs-system` |

The dividing question for any content: *agent-only?* → `.kol/`. *the repo's subject?* → `documentation/`. *the machinery around the repo?* → its own sibling folder.

## `.kol/llm-context/` — the agent state

Everything project-specific an agent needs, none of it in the boot file:

- `ARCHITECTURE.md` — load-bearing decisions + invariants (numbered §1, §2…). · `AGENT-CONTEXT.md` — what the repo is, current state, gotchas, contracts.
- `history.md` — the *why* (decisions, alternatives). · `plan.md` — speculative work.
- `session-log/` — concluded sessions (point-in-time; never rewritten). · `session-bridge/` — in-flight handoffs.

## `LLM_RULES.md` — the boot pointer (a symlink)

`LLM_RULES.md` at the repo root is **a symlink to one generic file** in dotfiles (`~/.dotfiles/claude/packages/scaffold/03-scaffold-llm-context/LLM_RULES.md`), **gitignored** (it points at a machine-local path). It is deliberately **identical across every repo** — the startup protocol + where-things-live map + house rules — because repo-specific facts live in `.kol/llm-context/`, never here. So: never hand-author a per-repo `LLM_RULES.md`; that's the single most common mistake. It's owned by `scaffold-llm-context`.

## The Obsidian layer

`docs/.obsidian/` is vault *config*, not doc content — a real local directory whose files are **symlinked or copied per-file** (never as a whole directory) from `~/.dotfiles/claude/packages/scaffold/02-scaffold-docs/obsidian-shapes/`, so the render/graph/backlinks experience is consistent across repos. Per-file matters: per-vault runtime state (`workspace.json` etc.) is never seeded, so each vault stays independent. `scaffold-docs-system` owns the wiring (shape picker, symlink-vs-copy). Gitignore it wholesale.

**What's shared from dotfiles vs per-repo:** the boot file (symlinked, identical), the `.obsidian` config (seeded, shared shape), and the `docs-framework` packages (copied, shared spec) all come *from* dotfiles. Everything under `.kol/llm-context/` and `docs/documentation/` is per-repo and authored locally.

## Link form (render-target rule)

Inside the vault → **wikilinks**; outside it (root `README.md`, GitHub-facing files) and *pointing out of* the vault (into `.kol/`) → **markdown links** (wikilinks render dead there). Section links target folders-with-`INDEX`, so use `[[NN-section/INDEX|display]]`. Heading anchors use the **literal heading text**, never a GitHub kebab-slug (Obsidian doesn't resolve those). Full rule: `scaffold-docs-system`'s render-target section.

## The numbering law

`NN-slug.md` — two-digit, kebab-case, catalog (display-priority) or sequential (reading-order) per folder. **Not** `X.Y.Z-slug.md` — a dotted scheme was never the spec. Dated folders (`plan`/`log`) use `YYYY-MM-DD-`. `INDEX.md` is the only prefix-exempt filename. Numbering is contiguous, no gaps; removing a section means renumbering the rest and repointing refs.

## The doc contract (one line)

Every doc's frontmatter: `title` / `type` (1 of 9 archetypes: index, reference, guide, playbook, plan, decisions, audit, narrative, log) / `status` (`draft`→`active`→`canonical`→`superseded`→`archived`) / `updated` / `tags` (closed taxonomy, list-form). Body shape follows from the archetype.

**Known gap:** the canon names only the layers above. Neither-fish-nor-fowl content — dead/superseded subject (an `archive/` sibling), or a PII registry that shouldn't sit in numbered sections — has no blessed slot. Treat as pragmatic per-repo exceptions; name the real reason, don't invent siblings freely.

## Who owns what — go here to do something

| Need | Skill |
|---|---|
| Stand up `.kol/llm-context/` + the `LLM_RULES` boot symlink (fresh repo) | [[scaffold-llm-context]] |
| Stand up the `docs/` vault + `.kol/docs-framework/` (fresh repo) | [[scaffold-docs-system]] |
| Convert a **legacy** repo (old `docs/llm-context`, `_framework`, hand-authored boot file) → `.kol/` | [[kol-migrate-structure]] |
| Author or normalise one doc | [[kol-docs-md]] |
| Just fix one file's frontmatter | [[kol-docs-fm]] |

Neither scaffolder depends on the other — run either first; each only `mkdir -p`s its own `.kol/` subpath. `kol-migrate-structure` is the orchestrator for the legacy conversion: it relocates old content, then **delegates** the boot file and framework to the two scaffolders rather than reimplementing them (reimplementation is how the boot-file-symlink-vs-copy contradiction crept in). Canon packages live in `claude/packages/kol-docs/kol-docs-{fm,md,lib}/`.

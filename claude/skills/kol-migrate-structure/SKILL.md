---
name: kol-migrate-structure
description: Converge a LEGACY repo onto the .kol/ convention — detect an old agent-context/doc layout (docs/llm-context, .claude/llm-context, .llm-context, docs/_framework, a hand-authored LLM_RULES.md, loose plan/history/rfc), relocate that content into .kol/, then hand the canonical wiring to scaffold-llm-context (boot symlink + .kol/llm-context) and scaffold-docs-system (canon docs-framework + docs/ vault). Use when agent-init reports a legacy layout, or the user says "migrate structure", "converge to .kol", "/kol-migrate-structure", or asks to modernize a repo's docs/context layout.
allowed-tools: Bash, Read, Edit, Write, Glob, Grep, AskUserQuestion, Skill
---

# kol-migrate-structure

Converge a **legacy** repo onto the `.kol/` convention. This skill is the **orchestrator for the legacy → `.kol/` conversion only**: it relocates existing content, then hands the canonical wiring to the two owners below. It does **not** author `LLM_RULES.md` and does **not** define the doc framework — reimplementing those is exactly the drift this skill exists to avoid.

**Ownership — never reimplement these here, delegate:**

| Concern | Owner | The rule |
|---|---|---|
| `LLM_RULES.md` + `.kol/llm-context/` | `scaffold-llm-context` | `LLM_RULES.md` is a **symlink** to the one generic dotfiles boot file, **gitignored**. Every project-specific fact lives in `.kol/llm-context/` (ARCHITECTURE/AGENT-CONTEXT), never in the boot file. |
| `.kol/docs-framework/` + the `docs/` vault | `scaffold-docs-system` | The framework is the canon `kol-docs-{fm,md,lib}` packages. `docs/` = `documentation/` (subject) + `operations/` (machinery sibling) + `.obsidian/`. |

Target layout:

```
<repo>/
  LLM_RULES.md          ← SYMLINK → ~/.dotfiles/.../03-scaffold-llm-context/LLM_RULES.md (gitignored, generic)
  .kol/
    llm-context/        ← ARCHITECTURE · AGENT-CONTEXT · plan · history · session-log/ · session-bridge/
    docs-framework/     ← canon kol-docs-{fm,md,lib} packages (+ INDEX)
  docs/                 ← documentation/ (numbered sections) + operations/ (sibling) + .obsidian/
```

Rationale: `docs/` stays 100% human content; agent state + doc spec are machinery under `.kol/`; the boot pointer is a single shared file so every repo boots identically.

## 1. Detect

Identify what exists: `docs/llm-context/` · `.claude/llm-context/` · `.llm-context/` · `docs/_framework/` · a hand-authored (non-symlink) root `LLM_RULES.md` · loose planning docs (`docs/plan.md`, `docs/history.md`, `docs/rfc/`, `docs/backlog/`, `docs/migration/`). If everything is already under `.kol/`, the boot file is already the symlink, and the framework is the canon packages, say so and stop.

Show the user the planned moves as a short table and confirm before touching anything.

## 2. Relocate legacy content

Plain `mv`/`rm` — the user owns git.

- **Legacy context dir** (`docs/llm-context` / `.claude/llm-context` / `.llm-context`) → `.kol/llm-context/` (merge if several exist; newest wins on collisions — flag them, don't silently overwrite).
- **Planning/working docs** (`plan.md`, `history.md`, `backlog/`, `migration/`) → `.kol/llm-context/`.
- **Old `docs/_framework/`** → **delete** (superseded by the canon packages installed in step 4 — do NOT move it into `.kol/docs-framework/`, that just carries a stale spec forward). If it had repo-specific edits, surface them before removing.
- **Legacy RFCs / audits / research** (`docs/rfc/`, loose audit docs) → leave in place for step 4 to fold into `docs/documentation/NN-research/` with conformant frontmatter.

## 3. Boot file → hand to `scaffold-llm-context`

`LLM_RULES.md` is **not authored here**. Apply `scaffold-llm-context`'s rule: any hand-authored boot file is replaced with the symlink, then gitignored.

```sh
rm -f LLM_RULES.md
ln -s ~/.dotfiles/claude/packages/scaffold/03-scaffold-llm-context/LLM_RULES.md ./LLM_RULES.md
# gitignore (idempotent, scaffold-llm-context block):
grep -qxF '# Agent boot symlink (scaffold-llm-context)' .gitignore 2>/dev/null || \
  printf '\n# Agent boot symlink (scaffold-llm-context)\nLLM_RULES.md\n' >> .gitignore
```

The generic boot file already carries the startup protocol, the where-things-live map, and the house rules — repo facts stay in `.kol/llm-context/`. If `.kol/llm-context/` is missing entirely (not just legacy-located), run `/scaffold-llm-context` for the full scaffold + placeholder fill.

## 4. Framework + docs → hand to `scaffold-docs-system`

Install the canon framework and stand up the `docs/` vault by **running `/scaffold-docs-system`** (or applying its workflow). At minimum:

```sh
mkdir -p .kol/docs-framework
cp -R ~/.dotfiles/claude/packages/kol-docs/{kol-docs-fm,kol-docs-md,kol-docs-lib} .kol/docs-framework/
# + write .kol/docs-framework/INDEX.md routing the three tiers (fm ⊂ md ⊂ lib)
```

Then, per `scaffold-docs-system`: numbered `docs/documentation/` sections, a `docs/operations/` sibling for repo machinery, `.obsidian/` (shape picker + gitignore), an `INDEX.md` in every folder, and the render-target link rules. Fold the legacy RFCs/audits from step 2 into `docs/documentation/NN-research/`.

## 5. Repoint references

Grep the repo for every live mention of the old paths and fix them:

- `docs/llm-context` → `.kol/llm-context` · `docs/_framework` → `.kol/docs-framework` — in docs, code comments, scripts, READMEs, config. (`LLM_RULES.md` is no longer a path to repoint — it's a symlink.)
- **Cross-vault links:** wikilinks from `docs/` into `.kol/` **cannot resolve** — convert to relative markdown links `[text](../.kol/llm-context/plan.md)`, or drop from `related:` (that field is vault-internal). Section links target folders-with-`INDEX`, so use `[[NN-section/INDEX|display]]`.
- **Leave historical session-log bodies untouched** — point-in-time records.
- Verify: final grep for the old paths returns only session-log history; every `docs/` wikilink resolves to a file; run any repo validators.

## 6. Report

List what moved/was deleted, what was delegated to each scaffolder, what was repointed, and any collisions left for the user. **No git, no session log unless asked.**

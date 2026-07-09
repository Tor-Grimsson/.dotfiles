---
name: kol-migrate-structure
description: Converge a LEGACY repo onto the .kol/ convention — detect an old agent-context/doc layout (docs/llm-context, .claude/llm-context, .llm-context, docs/_framework, a hand-authored LLM_RULES.md, loose plan/history/rfc), relocate that content into .kol/, then hand the canonical wiring to scaffold-llm-context (boot symlink + .kol/llm-context) and scaffold-docs-system (canon docs-framework + docs/ vault). Also repairs a PARTIALLY-converged repo — no legacy present, but a delegated artifact (e.g. docs/.obsidian, an INDEX.md, the LLM_RULES.md boot symlink) is missing or the wrong type. Use when agent-init reports a legacy layout, or the user says "migrate structure", "converge to .kol", "/kol-migrate-structure", asks to modernize a repo's docs/context layout, or reports a missing/broken .kol or docs/ artifact.
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

Detection is **two questions, not one**: (a) is any *legacy* layout present? and (b) is every *converged* artifact present **and the right type**? A repo can have zero legacy signals yet still be missing an artifact an owner scaffolder was supposed to produce — that is **partial convergence**, not "done." **Anything this skill delegates (steps 3–4), it must still verify landed here** — delegating creation never removes the obligation to check. "No legacy found" is not "converged."

**(a) Legacy signals** — any present ⇒ migrate (steps 2–5): `docs/llm-context/` · `.claude/llm-context/` · `.llm-context/` · `docs/_framework/` · a hand-authored (non-symlink) root `LLM_RULES.md` · loose planning docs (`docs/plan.md`, `docs/history.md`, `docs/rfc/`, `docs/backlog/`, `docs/migration/`).

**(b) Convergence checklist (Definition of Done)** — a converged repo has **all** of these, each checked **by type**. Use `test -L` for symlink-typed artifacts, not `test -e`: a real file/dir where a symlink belongs is drift that `-e` silently passes (this is exactly the class of miss — e.g. an absent `docs/.obsidian` — that a legacy-only scan never catches).

| Artifact | Required state | Check |
|---|---|---|
| `.kol/llm-context/` | dir + `ARCHITECTURE.md` + `AGENT-CONTEXT.md` | `test -f` each |
| `.kol/docs-framework/` | `kol-docs-{fm,md,lib}/` + `INDEX.md` | `test -d` / `-f` |
| `LLM_RULES.md` | **symlink** → dotfiles boot **and** gitignored | `test -L` + grep `.gitignore` |
| `docs/documentation/` | numbered sections, each with `INDEX.md` | `test -f */INDEX.md` |
| `docs/operations/` | sibling dir present | `test -d` |
| `docs/INDEX.md` | present | `test -f` |
| `docs/.obsidian/` | **real dir**, non-empty (per-file symlinks *or* a copied shape inside), **and** gitignored | `test -d` + non-empty + grep `.gitignore` — **not** `test -L`; a whole-dir symlink is wrong per `scaffold-docs-system` |

The two shared-machinery artifacts are the ones a legacy-only scan misses, so the skill **must** stat them by type — a repo that has the symlinked `LLM_RULES.md` **and** a wired `docs/.obsidian/` is converged on this axis; one that has neither (or a real file / absent dir) is **not**, and the two states must never read the same. Run this probe at repo root; it prints each artifact's actual type:

```sh
# LLM_RULES.md — symlink (converged) vs real file (deliberate? ask) vs absent
if   [ -L LLM_RULES.md ]; then echo "LLM_RULES.md: SYMLINK -> $(readlink LLM_RULES.md)  [converged]"
elif [ -f LLM_RULES.md ]; then echo "LLM_RULES.md: REAL FILE  [NOT converged — deliberate? flag, don't auto-convert]"
else                           echo "LLM_RULES.md: ABSENT  [NOT converged]"; fi

# docs/.obsidian — wired dir (converged; note symlink vs copy mode) vs absent/empty
if [ -d docs/.obsidian ] && [ -n "$(ls -A docs/.obsidian 2>/dev/null)" ]; then
  if find docs/.obsidian -maxdepth 1 -mindepth 1 -type l | grep -q .; then
    echo "docs/.obsidian: DIR, per-file SYMLINKS  [converged, symlink mode]"
  else
    echo "docs/.obsidian: DIR, copied config  [converged, copy mode]"; fi
else echo "docs/.obsidian: ABSENT or EMPTY  [NOT converged]"; fi
```

**Three outcomes** (the stop condition is the *whole* checklist passing, never just "no legacy"):

- **All (b) pass, no (a):** fully converged — say so and **stop**.
- **Any (a) present:** legacy — run steps 2–5.
- **No (a), but a (b) artifact is missing or wrong-type:** *partial convergence* — do **not** stop and do **not** run a full migration. Re-invoke only the **owning** scaffolder for the gap: `scaffold-docs-system` for a missing/empty `docs/.obsidian/`, a missing `INDEX.md`, or a missing section; `scaffold-llm-context` for a missing boot symlink or `.kol/llm-context` file. If an artifact exists but is the **deliberate** wrong type (e.g. a real `LLM_RULES.md` a repo chose on purpose), flag the contradiction and let the user decide — don't silently convert it.

Show the user the planned moves/repairs as a short table and confirm before touching anything.

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

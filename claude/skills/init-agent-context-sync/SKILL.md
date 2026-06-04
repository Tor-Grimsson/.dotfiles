---
name: init-agent-context-sync
description: Bring a previously init-agent-context'd repository up to date with the latest templates and framework. Compares versions, surfaces drift, applies updates per each file's sync policy.
disable-model-invocation: true
allowed-tools: Bash, Read, Edit, Write, Glob, Grep, AskUserQuestion
---

# init-agent-context-sync

Brings a repo that was scaffolded by `/init-agent-context` up to date with the current state of:
- Templates at `~/.dotfiles/claude/packages/init-agent-context-templates/`
- Framework at `~/.dotfiles/claude/packages/kol-docs-framework/`

Run this inside a target repo when you want to pull in template/framework improvements (skill fixes, new conventions, framework updates, etc.) without re-scaffolding.

This is the companion to `/init-agent-context`. It uses the same templates + framework as the sources of truth.

---

## How drift is tracked

Each template Markdown file (and each framework file) carries a `_template:` block in its frontmatter:

```yaml
---
_template:
  version: 1            # bumped manually when the file materially changes
  path: docs/llm-context/AGENT-CONTEXT.md   # path relative to repo root
  sync: skip            # policy: replace | notify-only | skip
---
```

The scaffolded copy in the target repo inherits this block. Sync compares the source `_template.version` against the target file's `_template.version`. Drift triggers the policy.

### Sync policies

- **`replace`** — overwrite the target file with the source content. For files that should match exactly: skill SKILL.md files, protocol READMEs (e.g. `session-bridge/README.md`), framework files.
- **`notify-only`** — show the diff but don't change anything. The user decides whether to merge by hand. For files that are scaffold-seeded but expected to grow with project-specific content: `LLM_RULES.md`, `llm-context/README.md`.
- **`skip`** — never touch. Project-owned after scaffold: `AGENT-CONTEXT.md`, `ARCHITECTURE.md`, `history.md`, `plan.md` / `backlog.md`.

### Why `_template:` is namespaced

The underscore prefix marks the block as **tool-managed**. The sync skill reads/writes only inside `_template:`. Everything else in the frontmatter (`tags`, `title`, `status`, `related`, etc.) is human/Obsidian territory and never touched. Clean conflict boundary.

---

## Steps

1. **Confirm target.** Run `pwd`. Confirm with the user: "Syncing into `<pwd>` — is that right?" If wrong, stop.

2. **Sanity check.** Confirm the target repo has been init-agent-context'd:
   - `LLM_RULES.md` exists at root, AND
   - `docs/llm-context/` exists.

   If not, stop and tell the user to run `/init-agent-context` first.

3. **Enumerate source files.** Run two finds:
   - `find ~/.dotfiles/claude/packages/init-agent-context-templates -type f -name '*.md'` for template files.
   - `find ~/.dotfiles/claude/packages/kol-docs-framework -type f -name '*.md'` for framework files. Framework files target `docs/_framework/` in the consumer repo.

4. **For each source file, compute the diff state.** Build a report with one row per file:
   - **Status:** `missing` (target file doesn't exist), `out-of-date` (target version < source version), `current` (versions match), `customized` (target content differs but version matches — user edited a `replace`/`notify-only` file).
   - **Source version, target version, policy.**

   Read frontmatter via Read or a small Bash one-liner. Don't trust path inference — read `_template.path` from the source's frontmatter for the canonical relative path. For framework files (no `_template.path`), derive the target path as `docs/_framework/<relative path from src/>`.

5. **Surface the report to the user.** Print a table:

   ```
   File                                          src  tgt  policy        action
   --------------------------------------------- ---  ---  ------------  -------------------
   .claude/skills/log-work/SKILL.md              2    1    replace       will replace
   docs/llm-context/session-bridge/README.md     1    -    replace       will create (missing)
   docs/_framework/01-conventions.md             2    1    replace       will replace
   LLM_RULES.md                                  1    1    notify-only   in sync
   docs/llm-context/AGENT-CONTEXT.md             1    1    skip          (untracked — project-owned)
   ```

6. **Confirm via `AskUserQuestion`** before applying anything. Options:
   - **Yes — apply all `replace` actions.** Bulk-applies all changes the policy allows.
   - **One-by-one.** Walks each file, asks per change.
   - **Cancel.** No writes.

7. **Apply changes per policy.**
   - `replace` (out-of-date or missing): copy the source file content into the target, preserving the `_template:` block from the source (with the new version number).
   - `notify-only` (out-of-date): print the diff to the user; do **not** write. The user merges by hand.
   - `skip`: never touched.
   - `customized` (target differs but version matches and policy is `replace`): warn the user, ask whether to overwrite. Manual customization detected.

8. **Report final state.** Say:
   ```
   Sync complete.
   Replaced: <N> files
   Created:  <N> files
   Notified: <N> files (manual merge needed — see diffs above)
   Skipped:  <N> files (skip policy)
   ```

---

## When to bump a source's `_template.version`

Bump the version in the source file (templates or framework) whenever its content materially changes. The version is the signal to all already-scaffolded repos that they're behind. **Don't bump for typo fixes.** Do bump for:

- New steps added to a skill's procedure.
- Order changes that affect behavior.
- New sections in README/protocol docs that downstream repos should adopt.
- Removed or renamed sections.
- Framework changes that affect how docs should be authored.

The version is per-file, not global. Each file evolves on its own clock.

---

## Notes

- This skill **does not handle renames.** If a source file moves or is renamed (e.g. `plan.md` → `backlog.md`), the sync skill will see the old file as orphaned in the target and the new file as missing. Renames must be applied manually for now.
- This skill **does not modify files outside the template + framework set.** Project-specific docs (anything in `docs/client/`, `session-log/`, `session-bridge/handoff-*.md`, etc.) are never touched.
- The sync compares **versions, not content hashes**. A source author who edits a file without bumping its version will produce silent drift. This is by design — the version is the only contract; content-level diffs would force constant 3-way merges.
- For non-Markdown source files (like `.gitkeep`, `_assets/*.png`), versioning is overkill. If you ever need to version a binary or non-YAML-friendly file, introduce a manifest at `~/.dotfiles/claude/packages/init-agent-context-templates/.template-manifest.json` keyed by path.

# Session: fnm wiring + version-management docs category + Obsidian per-file symlink canon fix

**Date:** 2026-07-05
**Agent:** Claude (Grim)
**Summary:** Wired fnm (Node version manager) into the dotfiles and authored a new `docs/23-version-management/` category to document the concept cross-language; earlier in the same session, corrected the Obsidian vault-config canon (per-file symlink, not whole-directory) across the kol-docs skills/packages, removed a dead npm line from `.zshrc`, and duplicated `agent-init` → `ag-init`. Cross-repo session — the kol-monorepo consumer side (`.nvmrc`, pnpm-overrides move, a broken docs import) is logged separately in that repo's context.

## Changes Made

### fnm / version management (this repo's half of a cross-repo task)
- `docs/23-version-management/` — **new category** (registered under *Guides* in `docs/INDEX.md`, not the tool count): `INDEX.md` + `01-concept.md` (the drift problem + per-project pinning, worked through the kol-monorepo Node-26 breakage), `02-fnm-setup.md` (playbook — each step tagged done/file-edit/provisioning), `03-language-managers.md` (per-language: Node fnm / Python uv / Ruby rbenv / Rust rustup / Go, + universal asdf/mise, with alternatives), `04-shell-rc-files.md` (rc files vs `#!/bin/bash` shebang, where a manager hooks in).
- `brewfile-cli` — added `brew "fnm"` under Dev & languages; node comment reworded ("global fallback; per-project versions come from fnm").
- `shell/.zshrc` — added the fnm hook after the PATH block, guarded, beside the conda hook: `command -v fnm >/dev/null && eval "$(fnm env --use-on-cd)"`. No hardcoded brew prefix (§1-safe).
- **Design decision:** fnm is now an installed tool, but its reference lives *inside* the version-management guide rather than a separate `04-dev-languages` tool doc (deliberate, noted in the playbook) — so the tool count is unchanged.

### Obsidian vault-config canon — per-file symlink correction (earlier this session)
Root issue: the canon documented a *whole-directory* `.obsidian` symlink, which would make `workspace.json` (per-vault runtime state) one shared file across every consuming repo — contradicting the "per-vault local, gitignore per repo" rule. Corrected to **per-file symlink** (real local `docs/.obsidian/` dir, each file individually symlinked from the chosen shape; the exclusion list stays unseeded):
- `claude/skills/scaffold-docs-system/SKILL.md` — layout diagram, workflow step 4, full picker section rewritten with the per-file loop + 9-item exclusion list.
- `claude/skills/kol-docs-overview/SKILL.md` — Obsidian-layer paragraph.
- `claude/packages/kol-docs/kol-docs-lib/02-obsidian.md` (the canon file behind the bug) — picker rewritten, new "per-file not whole-directory" section, exclusion list expanded 3→9, stale "two shapes/four-choice" description fixed to three/six, `updated:` → `2026-07-05 (3)`.
- `claude/packages/scaffold/02-scaffold-docs/obsidian-shapes/INDEX.md` — intro + "how repos consume" line.
- `docs/20-kol-docs-system-setup/INDEX.md` — same clarification, links to the canon for the full list.
- `claude/packages/kol-docs/kol-docs-lib/_example-repo/docs/INDEX.md` — one-line wording fix.
- (Consumer wiring — kol-monorepo's own `docs/.obsidian` rebuilt as per-file symlinks to `02-kol-vault-shape` — logged in kol-monorepo's context, not here.)

### Misc dotfiles fixes (earlier this session)
- `shell/.zshrc` — **removed a dead line** `export PATH="$(npm config get prefix)/bin:$PATH"`. It ran `npm` on every shell init regardless of project, surfacing pnpm-only `.npmrc` warnings (`link-workspace-packages`, `public-hoist-pattern`) as Powerlevel10k "console output during init" noise whenever a pane opened in a pnpm repo. `npm config get prefix` resolved to `/usr/local` (already on PATH via Homebrew) — the line did nothing useful.
- `claude/skills/ag-init/SKILL.md` — **new skill**, a byte-copy of `agent-init` with `name:` changed to `ag-init` (user wanted a shorter alias). Original `agent-init` untouched. (`~/.claude/skills` is a symlink into this repo, so it's tracked here.)

## Current State

### Working
- fnm installed (`1.39.0`), Node 22.23.1 installed via fnm, `.zshrc` hook live — verified end-to-end: `node -v` → `v22.23.1` inside kol-monorepo, and `pnpm dev` boots all three apps including the previously-crashing Sanity studio (3333).
- Version-management docs category complete and registered; all internal wikilinks resolve.
- Obsidian canon now consistently describes per-file symlinking across all 6 touched files (grep-verified: the only remaining whole-dir `ln -s` mentions are the docs explicitly citing it as the anti-pattern).

### Known Issues
- None introduced. Sanity flagged a v4 major landing 2026-07-15 (needs Node 20+; we're on 22, already clear) — informational.

## Next Steps
1. **User: commit both repos** (dotfiles + kol-monorepo, separate commits) — all changes uncommitted, user owns git.
2. **User: on the MBP, `brew bundle`** to install fnm from the new `brewfile-cli` line; the `.zshrc` hook is already symlinked, then `fnm install 22` per repo.
3. Deferred (its own project, not now): if DS docs move to *published npm packages* / an external source, revisit the build-time `?raw` import model → externalized fetch (bucket/registry). Trigger condition noted in the kol-monorepo docs-import discussion.

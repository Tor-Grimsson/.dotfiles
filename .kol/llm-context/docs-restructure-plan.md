---
_template:
  version: 1
  path: .kol/llm-context/docs-restructure-plan.md
  sync: skip
---

# docs/ restructure — DONE (phase 1: folders + refs), 2026-07-08

Converged `docs/` onto the kol-docs content/operations split. Folder moves + link/ref repointing only. **Next steps (`.obsidian` seeding, kol-vault sync scripts) deliberately NOT done — to be handled together.**

## What was done

**Structure** — 25 flat `NN-` sections → three homes:

| Home | Sections |
|---|---|
| `documentation/` (content) | 01-shell-terminal … 11-cloud-sync (unchanged #), 12-terminal-browsers (was 13), 13-documents (was 17), 14-supabase, 15-cloudflare, 16-version-management (was 23) |
| `operations/` (machinery) | 01-dotfiles (was 21), 02-claude-agents (was 16), 03-kol-docs-system-setup (was 20), 04-remote-machine (was 22), 05-cdn-r2b2 (was 18), 06-kol-dash (was 24) |
| siblings | `kol-cli/` (was 00-kol-cli), `scripts/` (was 12-scripts), `explorations/` (was 19-kol-tui-plugin) |

**References repointed**
- Internal wikilinks: file-targets → bare filename, INDEX-targets → new full path, all `../` relatives normalised (207 files processed; every link verified resolving).
- External path strings: `bin/{bucket-tree,img-canvas,img-convert,img-from-psd,img-from-video}.sh`, `bootstrap.sh`, `bootstrap-cli.sh`, `claude/skills/{export-specs,kol-bucket-b2,kol-bucket-r2,kol-cdn-overview}/SKILL.md`, plus a live pointer in `plan.md`.
- INDEX layer: root `docs/INDEX.md` rewritten as top-level router; new `documentation/INDEX.md`, `operations/INDEX.md`, `kol-cli/INDEX.md`.
- Incidental: fixed a pre-existing dead link `[[02-pnpm]]` → `[[05-pnpm]]` in `04-dev-languages/01-node.md`.

**Not touched (correct):** session logs (73, historical), `LLM_RULES.md` (no refs; real file here — origin repo), out-of-vault `[[SKILL]]`/`[[TOOLING]]`/skill-name links (pre-existing convention).

## Next (together, not planned here)
- `.obsidian/` vault-config seeding.
- kol-vault sync scripts (`sync-dotfiles-docs-rs.sh` / `relink-dotfiles-docs-sm.sh`, in the *kol-vault* repo) — repoint + the keep-one-mirror question.
- git (user owns it).

---
name: init-agent-context
description: Scaffold the LLM agent-context protocol into the current repo (LLM_RULES.md, ARCHITECTURE/AGENT-CONTEXT/history/plan, init-agent and log-work skills, .kol/docs-framework/)
disable-model-invocation: true
allowed-tools: Bash, Read, Edit, Write, Glob, Grep, AskUserQuestion
---

# init-agent-context

Scaffold the Kolkrabbi-style LLM agent context protocol into the current working directory. Produces `LLM_RULES.md`, `.kol/llm-context/{ARCHITECTURE,AGENT-CONTEXT,README,history,plan}.md`, `.kol/docs-framework/` (kol-docs framework — frontmatter spec, archetypes, tag taxonomy), and `.claude/skills/{init-agent,log-work}/SKILL.md` — all wired up with `/init-agent` and `/log-work` ready to use.

Templates live in `~/.dotfiles/claude/packages/init-agent-context-templates/`. The docs framework lives at `~/.dotfiles/claude/packages/kol-docs-framework/` and is copied at scaffold time so it stays in sync with the canonical source.

---

## Steps

1. **Confirm target.** Run `pwd` to get the current working directory. Confirm with the user: "Scaffolding into `<pwd>` — is that right?" If wrong, stop and ask them to `cd` first.

2. **Sanity check.** Check if any of these already exist in the target:
   - `LLM_RULES.md`
   - `.kol/llm-context/`
   - `.kol/docs-framework/`
   - `.claude/skills/init-agent/`

   If any exist, stop and ask the user if they want to overwrite. Do not overwrite without confirmation — agent context is often hand-tuned.

3. **Verify framework source available.** Run `ls ~/.dotfiles/claude/packages/kol-docs-framework/` — if missing, stop and tell the user the kol-system repo isn't where the skill expects it. The framework lives inside the `kol-docs` package at `src/_framework/`.

4. **Collect project metadata.** Use `AskUserQuestion` to gather:
   - `PROJECT_NAME` — short name (e.g. `vcap`, `video-modulo`, `my-tool`)
   - `PROJECT_TAGLINE` — one line (e.g. `Console-driven skinless tab recording`)
   - `PROJECT_DESCRIPTION` — paragraph describing what the project does
   - `TECH_STACK` — short summary (e.g. `React 19 + Vite 7 + Tailwind 4 + Yarn`, or `Plain JS — no build step`, or `Rust CLI + cargo`)

   You can collect all four in one `AskUserQuestion` call with multiple questions, or one at a time. Derive these:
   - `REPO_ABS_PATH` = output of `pwd`
   - `TODAY_ISO` = output of `date +%Y-%m-%d`

5. **Copy templates.** Run:
   ```sh
   cp -R ~/.dotfiles/claude/packages/init-agent-context-templates/. .
   ```
   The trailing `/.` preserves hidden directories (`.claude/`). `-R` is recursive.

6. **Copy framework.** Run:
   ```sh
   mkdir -p .kol/docs-framework && cp -R ~/.dotfiles/claude/packages/kol-docs-framework/. .kol/docs-framework/
   ```
   This lands the framework spec in `.kol/docs-framework/` of the target repo (flattened — `src/_framework/INDEX.md` → `.kol/docs-framework/INDEX.md`, etc.). Obsidian wikilinks like `[[../_framework/INDEX|the kol-docs framework]]` resolve against this.

7. **Find-replace placeholders** across all copied files. Use Grep to list files containing `{{`, then Edit each one to substitute:
   - `{{PROJECT_NAME}}` → collected value
   - `{{PROJECT_TAGLINE}}` → collected value
   - `{{PROJECT_DESCRIPTION}}` → collected value
   - `{{TECH_STACK}}` → collected value
   - `{{REPO_ABS_PATH}}` → `pwd` output
   - `{{TODAY_ISO}}` → today's date

   Use `Edit` with `replace_all: true` for each placeholder/file pair to handle multiple occurrences.

8. **Verify no placeholders remain.** Run `grep -rn '{{' . --exclude-dir=node_modules --exclude-dir=.git` and confirm clean. If any remain, list them to the user.

9. **Gitignore agent-context & local-only docs.** Append a block to `.gitignore` so `LLM_RULES.md`, `/docs/`, and `.claude/` are ignored. These are agent-facing artifacts — they do not belong in the deployable repo. Creates `.gitignore` if missing. Idempotent via sentinel comment:

   ```sh
   if ! grep -qxF '# Agent context & local-only docs (init-scaffold / init-agent-context)' .gitignore 2>/dev/null; then
     [ -s .gitignore ] && printf '\n' >> .gitignore
     cat >> .gitignore <<'EOF'
   # Agent context & local-only docs (init-scaffold / init-agent-context)
   LLM_RULES.md
   /docs/
   .claude/
   EOF
   fi
   ```

10. **Report result.** Say:
    ```
    Scaffolded into <pwd>.

    Created:
    - LLM_RULES.md
    - .kol/llm-context/{README,ARCHITECTURE,AGENT-CONTEXT,history,plan}.md
    - .kol/llm-context/session-log/ (empty)
    - .kol/docs-framework/ (kol-docs framework, copied from ~/.dotfiles/claude/packages/kol-docs-framework)
    - .claude/skills/init-agent/SKILL.md
    - .claude/skills/log-work/SKILL.md

    Next:
    1. Fill in real content in ARCHITECTURE.md (numbered §1, §2, ... decisions) and history.md.
    2. Flesh out AGENT-CONTEXT.md with current state when you have something to report.
    3. Delete plan.md if you have no speculative work yet.
    4. Run /init-agent to verify the wiring works.
    ```

---

## Notes

- **Templates are kept in sync manually** with the reference copy. If the reference evolves, update `~/.dotfiles/claude/packages/init-agent-context-templates/` to match.
- **Framework lives in the shared packages dir** at `~/.dotfiles/claude/packages/kol-docs-framework/` (copied from the canonical kol-system source). Don't bake framework content into templates; copy from packages at scaffold time so updates propagate via `/init-agent-context-sync` cleanly.
- **Template versioning.** Each Markdown template file carries a `_template:` block in its frontmatter (`version`, `path`, `sync` policy). When you materially change a template, bump its `version`. Already-scaffolded repos can pull in the change by running `/init-agent-context-sync` from inside the target repo.
- **`disable-model-invocation: true`** means this only runs on explicit `/init-agent-context` — the model won't auto-invoke it.
- **Don't scaffold into an existing project with its own agent context** — the sanity check in step 2 catches this.

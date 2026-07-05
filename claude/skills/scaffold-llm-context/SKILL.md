---
name: scaffold-llm-context
description: Scaffold the LLM agent-context protocol into the current repo (.kol/llm-context/{ARCHITECTURE,AGENT-CONTEXT,history,plan} + session-bridge, and a symlinked generic LLM_RULES.md). Docs system (.kol/docs-framework/ + docs/) is a separate concern — see /scaffold-docs-system. Skills are global (~/.claude), not scaffolded per-repo.
disable-model-invocation: true
allowed-tools: Bash, Read, Edit, Write, Glob, Grep, AskUserQuestion
---

# scaffold-llm-context

Scaffold the Kolkrabbi-style LLM agent context protocol into the current working directory. Produces `.kol/llm-context/{ARCHITECTURE,AGENT-CONTEXT,README,history,plan}.md` + `session-bridge/`, and a **symlinked** `LLM_RULES.md` → the one generic boot file at `~/.dotfiles/claude/packages/scaffold/03-scaffold-llm-context/LLM_RULES.md`. The `/init-agent` and `/log-work` skills are **global** (`~/.claude/skills`, dotfiles-backed) — never scaffolded per-repo. All project-specific content lives in `.kol/llm-context/`; `LLM_RULES.md` stays generic.

Templates live in `~/.dotfiles/claude/packages/scaffold/03-scaffold-llm-context/`. The docs system (`.kol/docs-framework/`, the `docs/` tree) is **not** this skill's job — run `/scaffold-docs-system` separately, in either order. Neither depends on the other: each only ever `mkdir -p`s its own `.kol/` subpath.

---

## Steps

1. **Confirm target.** Run `pwd` to get the current working directory. Confirm with the user: "Scaffolding into `<pwd>` — is that right?" If wrong, stop and ask them to `cd` first.

2. **Sanity check.** Check if any of these already exist in the target:
   - `LLM_RULES.md`
   - `.kol/llm-context/`

   If any exist, stop and ask the user if they want to overwrite. Do not overwrite without confirmation — agent context is often hand-tuned.

3. **Collect project metadata.** Use `AskUserQuestion` to gather:
   - `PROJECT_NAME` — short name (e.g. `vcap`, `video-modulo`, `my-tool`)
   - `PROJECT_TAGLINE` — one line (e.g. `Console-driven skinless tab recording`)
   - `PROJECT_DESCRIPTION` — paragraph describing what the project does
   - `TECH_STACK` — short summary (e.g. `React 19 + Vite 7 + Tailwind 4 + Yarn`, or `Plain JS — no build step`, or `Rust CLI + cargo`)

   You can collect all four in one `AskUserQuestion` call with multiple questions, or one at a time. Derive these:
   - `REPO_ABS_PATH` = output of `pwd`
   - `TODAY_ISO` = output of `date +%Y-%m-%d`

4. **Copy templates + symlink the boot file.** The templates are `.kol/` only — no per-repo `.claude/`, no per-repo `LLM_RULES.md`:
   ```sh
   cp -R ~/.dotfiles/claude/packages/scaffold/03-scaffold-llm-context/. .
   ln -s ~/.dotfiles/claude/packages/scaffold/03-scaffold-llm-context/LLM_RULES.md ./LLM_RULES.md
   ```
   `LLM_RULES.md` is a **symlink** to the one generic boot file — never a per-repo copy. All project-specific content lives in `.kol/llm-context/` (`ARCHITECTURE.md` carries the project's load-bearing rules).

5. **Find-replace placeholders** across all copied files. Use Grep to list files containing `{{`, then Edit each one to substitute:
   - `{{PROJECT_NAME}}` → collected value
   - `{{PROJECT_TAGLINE}}` → collected value
   - `{{PROJECT_DESCRIPTION}}` → collected value
   - `{{TECH_STACK}}` → collected value
   - `{{REPO_ABS_PATH}}` → `pwd` output
   - `{{TODAY_ISO}}` → today's date

   Use `Edit` with `replace_all: true` for each placeholder/file pair to handle multiple occurrences.

6. **Verify no placeholders remain.** Run `grep -rn '{{' . --exclude-dir=node_modules --exclude-dir=.git` and confirm clean. If any remain, list them to the user.

7. **Gitignore the boot symlink.** `LLM_RULES.md` points into `~/.dotfiles` (machine-local) — it must never be committed. Append idempotently:

   ```sh
   if ! grep -qxF '# Agent boot symlink (scaffold-llm-context)' .gitignore 2>/dev/null; then
     [ -s .gitignore ] && printf '\n' >> .gitignore
     cat >> .gitignore <<'EOF'
   # Agent boot symlink (scaffold-llm-context)
   LLM_RULES.md
   EOF
   fi
   ```
   Whether `.kol/` and `docs/` are tracked or ignored is the **repo's choice** — leave those to the project.

8. **Report result.** Say:
   ```
   Scaffolded into <pwd>.

   Created:
   - LLM_RULES.md → symlink to ~/.dotfiles/claude/packages/scaffold/03-scaffold-llm-context/LLM_RULES.md (generic boot)
   - .kol/llm-context/{README,ARCHITECTURE,AGENT-CONTEXT,history,plan}.md + session-bridge/
   - .kol/llm-context/session-log/ (empty)

   Skills (/init-agent, /log-work) are global — nothing added under .claude/.
   Docs system not included — run /scaffold-docs-system separately if this repo needs one.

   Next:
   1. Fill in real content in ARCHITECTURE.md (numbered §1, §2, ... decisions) and history.md.
   2. Flesh out AGENT-CONTEXT.md with current state when you have something to report.
   3. Delete plan.md if you have no speculative work yet.
   4. Run /init-agent to verify the wiring works.
   ```

---

## Notes

- **Templates are kept in sync manually** with the reference copy. If the reference evolves, update `~/.dotfiles/claude/packages/scaffold/03-scaffold-llm-context/` to match — there's no automated sync skill; re-scaffold or hand-edit the target repo instead.
- **Template versioning.** Each Markdown template file carries a `_template:` block in its frontmatter (`version`, `path`, `sync` policy). When you materially change a template, bump its `version` — already-scaffolded repos pick it up by hand (talk through the change and edit directly; no automated sync tool).
- **`disable-model-invocation: true`** means this only runs on explicit `/scaffold-llm-context` — the model won't auto-invoke it.
- **Don't scaffold into an existing project with its own agent context** — the sanity check in step 2 catches this.

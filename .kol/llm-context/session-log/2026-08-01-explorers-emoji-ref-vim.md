# Session: Seven explorers, the emoji pair, and ref-textmodes becomes ref-vim

**Date:** 2026-08-01
**Agent:** Claude Code (Grim)
**Summary:** broot got the `b` launcher it never had, Claude Code's vim mode was turned on from the official docs after two sessions of wrong assertions, seven TUI file managers were installed/themed/documented, and the emoji picker + filter pair was wired with the vocabulary trap found and documented.

## Changes Made

### Files Modified
- `shell/.zshrc` — dead `source …/org.dystroy.broot/launcher/bash/br` line **deleted** (the file never existed); new `b()` broot launcher next to `y()`; `MC_SKIN` + `NNN_COLORS` exports; the `emo` picker function with its `-n` mode
- `claude/settings.json:102` — `"editorMode": "vim"` added, JSON validated
- `ref/textmodes.md` → **`ref/vim.md`**, `bin/ref-textmodes` → **`bin/ref-vim`**; `bin/ref` card_list/card_def/help row; pointers in `ref/shell.md` and `docs/…/10-neovim-config.md`
- `ref/vim.md` — claude section rebuilt from the official docs into 6 sections; zsh section expanded 2 tables → 8 sections
- `ref/explorer.md` — `b` replaces `br`; new `vifm — panes and tree` and `explorers — on trial` sections
- `ref/system.md` — new `emoji — pick and render` section
- `brewfile-cli` — 7 file managers + `emojify`; `emoji-fzf` logged under uv-tool-managed
- `bootstrap.sh` — loop symlinking `vifm lf xplr` into `~/.config`
- `vifm/{vifmrc,colors/kol.vifm}` · `lf/lfrc` · `xplr/init.lua` — new tracked configs
- `docs/documentation/02-file-management/{18-vifm … 24-nnn}.md` — 7 new reference docs
- `docs/documentation/01-shell-terminal/{30-emojify,31-emoji-fzf}.md` — 2 new reference docs
- 3 INDEXes: both category INDEXes + `docs/documentation/INDEX.md` (counts 24→26, 15→22)
- `claude/memory/feedback_examples_are_copy_pasteable.md` — new, indexed in `MEMORY.md`

### Features Added/Removed
- **Added:** `b` (broot cd-on-quit), `emo` / `emo -n` (emoji picker, glyph or shortcode), `:t1`/`:t2` (bounded vifm tree), vim mode in Claude Code.
- **Removed:** the phantom broot `source` line; the `/r` and `/j` skill aliases (`rosa`, `yana`, `ref/skill.md`) — user's call, *"they shouldnt exist"*.

## Current State

### Working
- `type b` resolves to the repo function; `ref-vim` renders all 19 sections; `ref-system emoji` and both new `ref-explorer` sections render.
- All 9 new docs pass a frontmatter check (title/type/status/updated/description/tags).
- Seven managers on PATH, mouse on in all seven, every theme driven by ANSI 0-15 so `kol-theme` retints them with no per-app file.
- `emo` → glyph, `emo -n` → `:shortcode:`; round trip verified (`:rocket:` → 🚀).

### Known Issues
- **The two emoji tools do not share a vocabulary.** emojify ships 2562 GitHub shortcodes, emoji-fzf 4440 Unicode/CLDR names; `:astronaut:` renders in neither direction because it exists only in the latter. `emo -n` therefore sources from `emojify --list`. Verified: `echo ":rocket: :smile: :astronaut:" | emojify` → `🚀 😄 :astronaut:`.
- **`themes/gruvbox/` is off-palette** since the `#ffaf00` repoint earlier today, and its header still claims *"the .tmux.conf originals, verbatim"*.
- **`vifm :tree` has no lazy expansion.** Unbounded in `$HOME` it stats the whole tree including `.git` (`set dotfiles` is on). `:t2` exists for this reason.
- **`xplr/init.lua` pins `version = "1.1.0"`** — xplr refuses to start on a mismatch, so a brew bump breaks it until the line is edited.

## Next Steps
1. Live-test the seven managers and cut the ones that don't earn a slot — the survey's verdict is vifm, but that is a paper verdict.

**Two corrections recorded this session.** First: **Claude Code has vim mode.** `ref-textmodes` carried *"/vim NOT a command"* as if it proved no vim mode existed — it proved only that the slash command doesn't. The route is `/config` → Editor mode, or `"editorMode": "vim"`; the section was rebuilt from `code.claude.com/docs/en/interactive-mode` rather than memory, which is the third time this claim has been touched and the first time it was fetched. Second: **examples were written with `$` prompt prefixes** in a walkthrough the user had explicitly asked for, forcing him to ask what `$` meant — *"funny to give examples to someone learning adding stuff he should know to retract?"* Filed as global memory `feedback_examples_are_copy_pasteable`.

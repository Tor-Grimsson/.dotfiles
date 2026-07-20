# Playbook — nvim-now: the from-scratch build

> **Live work journal.** Append-only, newest at the bottom, real timestamps. One idea per line, no prose.
> Milestone logs: `session-log/`. Study doc: `docs/kol-terminality/12-nvim-from-scratch.md`.

**Goal:** Build the `now` set from the map triage (`claude.ai/code/artifact/f13381d8`) as a real config at `nvim-now/`, parallel to the daily `nvim/` via `NVIM_APPNAME` — graduate to `~/.config/nvim` only when it's the editor actually reached for.

**Standing rules (non-negotiable):**
- Every session ends on a working editor — never mid-plugin.
- Build order = the map's dependency board; user's triage gates every plugin.
- Mason/lspconfig come from Sin-cy's repo (video's version broke), not the video.
- Daily `nvim/` untouched until graduation.

---
## Entries

[21:00 GMT · 2026-07-14] · setup · playbook created
  what → initialised the live playbook   why → multi-session arc, journal beats re-reading logs

[21:00] · phase-1/scaffold · nvim-now/{init,lua/config/{options,keymaps,lazy},lua/plugins/init}.lua
  what → foundation built: options + keymaps + lazy bootstrap, plugins/ auto-import seeded empty
  why → phases 1–3 need no triage; Sin-cy baseline, `ours` markers keep grim habits (2-space, jk, nh, +/-)
  note → skipped from reference: vim._core.ui2 + :restart + lsp-restart (nightly), <leader>f (LSP phase), guicursor="" (keep default feel)

[21:00] · phase-1/wiring · bootstrap.sh · shell/.zshrc
  what → ~/.config/nvim-now symlink (live + bootstrap block) · alias nnow='NVIM_APPNAME=nvim-now nvim'
  note → ★ bootstrap gap found+fixed: ~/.config/nvim was hand-linked, never in bootstrap — MBP parity; both links in the new block

[21:01] · phase-1/verify
  verify → Lazy! sync ✓ (exit 0) · headless assert leader/tabstop/jk/undofile ✓ CONFIG OK · plugins import resolves ✓
  note → BLOCKED on user triage export (map f13381d8) for phase 2

[21:05] · phase-2/triage · user call: map too big, "just do it"
  what → agent triage replaces the export   why → the daily grim config IS the revealed preference
  note → rule: now = video core ∩ daily usage + oil/harpoon/blink experiments; lists recorded in 12-nvim-from-scratch.md

[21:08] · phase-2/build · nvim-now/lua/plugins/{16 files} · config/lazy.lua +plugins.lsp import
  what → full now-set built from Sin-cy's current specs, adapted: prettier/eslint_d (not biome), stack-trimmed servers, lualine theme=auto, lazygit enabled (he parked it in snacks), telescope binds = daily's ff/fr/fs/fc/ft/fk
  note → blink-cmp not nvim-cmp (repo moved past the video); <C-i> harpoon caveat inherited

[21:11] · phase-2/verify
  verify → Lazy! sync ✓ 31 plugins · load-check ✓ colorscheme gruvbox-material, errmsg none · stylua+prettier installed ✓
  note → tree-sitter CLI absent → all parser compiles fail (expected); brewfile-cli += tree-sitter, USER runs brew install; parsers+mason finish on next launches · jsonc unsupported on main → dropped

[21:16] · phase-2/fix · brewfile-cli
  what → tree-sitter → tree-sitter-cli   why → ⤺ wrong formula: "tree-sitter" is library-only now (no bin/; neovim already depends on it) — user installed it, CLI still ENOENT
  note → correct install = brew install tree-sitter-cli (ships the binary)

[21:19] · phase-2/live · user launched nnow
  verify → 19/19 parsers compiled ✓ (site/parser count matches install list) · user: "its working" ✓
  note → no aggregate finished-banner on main-branch installs — per-language messages only (told user)

──────────── MILESTONE: phases 1+2 — working editor ──────────── [21:19]
  changed: nvim-now/ (21 files) · bootstrap.sh · shell/.zshrc · brewfile-cli · 2 docs · build ✓ · user-confirmed live
  log: session-log/2026-07-14-nvim-now-foundation-and-now-set.md
  next: live in it; friction → this playbook; graduation checklist in 12-nvim-from-scratch.md

[21:34] · phase-3/theme-shelf · plugins/colorscheme.lua · plugins/telescope.lua · lua/current-theme.lua · init.lua
  what → Sin-cy's theme switcher ported (★ later→now on user ask, "wanna see his colors"): his 7 schemes + our gruvbox-material as 8th, telescope-themes ext (<leader>ths, live preview) persisting to lua/current-theme.lua, required last in init
  why → his in-nvim selector = the small-scale colorscheme-selector pattern (ricing #4 stays open for the cross-tool version)
  verify → Lazy! sync ✓ · colorscheme = solarized-osaka ✓ (his current pick, default) · themes ext loads ✓
  note → most of his schemes run transparent — Ghostty's kol-dark bg bleeds through, authentic to his setup · tmux question answered: his tmux = backlog #9 (reverses plugin-free choice), NOT in arc scope; vim-tmux-navigator's tmux half stays unwired pending user call (C-l clear-screen tradeoff)

[21:47] · phase-4/kol-theme · bin/kol-theme · themes/{gruvbox,kol-dark,solarized-osaka}/ · 5 consumer wirings
  what → ricing #4 v1 built: theme = dir of native files (ghostty/kitty/tmux/nvim/colors.json), switch = one symlink (~/.config/kol-theme/current) + reloads; gruvbox theme = exact pre-selector look ("change back" honored)
  why → user asked for the unified cross-tool selector, approved single plan
  before → 3 looks (kol-dark chrome / gruvbox terminal / gruvbox-material nvim)   after → kol-theme solarized-osaka live everywhere
  verify → ghostty +show-config bg #001419 ✓ · tmux pane-border #268bd3 live ✓ · both widgets themed (computed rgba(0,20,25,.96)) ✓ · nvim current-theme = solarized-osaka ✓ · help-lint 70/70 clean ✓
  note → solarized-osaka terminal palette from craftzdog's official extras/ (Sin-cy's own ghostty actually runs rose-pine under transparent nvim) · deferred: simple-bar (localStorage seam) · yazi (no flavors) · btop/starship (not adopted) · ghostty include = dual symlink (relative config-file resolution ambiguous through the config symlink)

[21:53] · phase-5/btop+linkarzu · themes/linkarzu/{6 files} · btop.theme ×4 · bin/kol-theme btop block · brewfile-cli
  what → btop adopted (★ user had installed already) as 6th consumer: kol-current.theme symlink + color_theme re-asserted each switch (btop rewrites conf on exit — why conf untracked) · linkarzu theme authored from his linkarzu-colors.sh (bg #0D1116, green #37f499 / cyan #04d1f9 / purple #987afb, frosted ghostty 0.88+blur25, btop main_bg transparent)
  why → the reference-desk screenshot: the boxed panels are btop, the style = his palette + transparency
  verify → kol-theme linkarzu ✓ ghostty bg/opacity/blur resolve ✓ tmux border #37f499 live ✓ btop symlink+pointer ✓ help-lint clean ✓ gruvbox btop.theme = bundled upstream file
  note → linkarzu nvim half = tokyonight stand-in (his colors live in neobean, no shelf port) · docs: 29-btop new + INDEX row, 08-kol-theme rows, ricing #1 adopted / #4 updated, 04-desk btop line

[21:57] · phase-5/bar-structure · themes/linkarzu/tmux.conf · quiet-bar resets ×3
  what → user: "ours doesn't look like the reference bar" — his bar = catppuccin/tmux PLUGIN; hand-rolled the same look plugin-free in the linkarzu theme (green session pill + rounded window index chips, E0B6/E0B4 caps) — structure-per-theme, only linkarzu restyles the bar
  why → theme files source last → they may carry layout; other 3 themes re-assert the quiet bar so switch-back resets
  verify → round-trip ✓ gruvbox → status-left '' · linkarzu → pill format live · user visual pending
  note → glyph dependency: MesloLGS NF powerline-extra (present) · window names stay ours (his "zsh" = auto-rename, cosmetic)

[22:02] · phase-5/fix · themes/linkarzu/tmux.conf
  what → ⤺ "not pills" — square chips: the E0B6/E0B4 rounded-cap glyphs (PUA codepoints) never survived the file Write; 0 glyph bytes on disk
  why → root cause was the file content, not the font — CoreText probe confirmed MesloLGS NF HAS E0B4/E0B6 (screenshot crop showed no caps rendered at all)
  after → caps injected byte-level via python chr(0xE0B6/0xE0B4), 3L+3R
  verify → glyph bytes present in live tmux status-left ✓ · user visual pending

[22:09] · phase-5/live-switching · user drove the shelf
  what → ghostty "still gruvbox" = stale surfaces (reload doesn't repaint existing windows; quit+relaunch does — told user, confirmed "fixed it partly") · then user test-drove: solarized-osaka → kol-dark → gruvbox, each verified live on tmux (border #268bd3 / #FFCF33 / #fe8019), quiet-bar reset held on every switch-back
  note → the selector's daily loop is real now; landed parked on gruvbox

[08:17 GMT · 2026-07-15] · phase-6/simple-bar-consumer · themes/*/colors.json +simplebar block · bin/kol-theme jq-merge
  what → the bar joins the selector (was the last visible hold-out): 15 color* slots per theme, jq --argjson merged into .themes of ~/.simplebarrc
  why → user: "does it not share color theme?" — approved single plan
  note → write THROUGH the symlink (cat > not mv — mv would replace the repo link with a file); layout keys + lightTheme names untouched; panel write-backs beaten by re-patch-per-switch (btop-conf trick)
  verify → gruvbox re-applied ✓ accent #fe8019 in repo file · symlink intact ✓ · widgets/layout sections intact ✓

──────────── MILESTONE: kol-theme arc — selector + 4 themes, user-driven ──────────── [22:09]
  changed: bin/kol-theme · themes/ ×4×6 files · 5 consumer wirings · 2 widgets themed · btop adopted · 8 docs · build ✓ · user switched themes live
  log: session-log/2026-07-14-kol-theme-selector-btop-linkarzu.md
  next: nvim arc continues (live in nnow); selector later-shelf: simple-bar · yazi · starship · kol-dark/linkarzu nvim ports

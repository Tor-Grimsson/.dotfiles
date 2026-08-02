---
title: macOS ricing 2025 — backlog & references
type: reference
status: active
updated: 2026-07-11
description: Captured wishlist of tools/scripts/ideas to evaluate for ~/.dotfiles, mostly from linkarzu's dotfiles-latest + 2025 ricing writeups. Reading/discussion doc — nothing adopted yet.
tags:
  - project/dotfiles
  - domain/tooling
related:
  - "[[INDEX|kol-terminality]]"
  - "[[12-nvim-from-scratch|nvim from scratch]]"
---

# macOS ricing 2025 — backlog & references

Braindump captured 2026-07-10 to discuss after rest. Nothing here is adopted — it's a **to-evaluate** list with links. Primary source is **linkarzu** (dotfiles + blog); several items complement our existing SketchyBar / AeroSpace / Neovim setup.

## Source of truth
- **Dotfiles repo:** https://github.com/linkarzu/dotfiles-latest — the whole rig; his organizational layout is the model (see §8).
- **Ricing writeup 2025:** https://linkarzu.com/posts/macos/macos-ricing-2025/
- **SketchyBar / menubar post:** https://linkarzu.com/posts/2024-macos-workflow/sketchybar-macos/

## At a glance

| # | Item | What | Link | Fits our setup? |
|---|------|------|------|-----------------|
| 1 | **btop** | Resource monitor (htop++), themeable | [terminaltrove](https://terminaltrove.com/btop/) · [repo](https://github.com/aristocratos/btop) | New tool — brew `btop` |
| 2 | **simple-bar** | Übersicht bar, **AeroSpace**-aware | [repo](https://github.com/Jean-Tinland/simple-bar) · [site](https://www.jeantinland.com/toolbox/simple-bar/) | Alternative to our SketchyBar |
| 3 | **skitty-notes** | Markdown sticky-notes = Neovim in Kitty | [post](https://linkarzu.com/posts/neovim/skitty-notes/) · [yt](https://www.youtube.com/watch?v=M0B_24d0MWw) | Neovim workflow add |
| 4 | **Colorscheme selector** | One switch → theme all tools | [ricing post](https://linkarzu.com/posts/macos/macos-ricing-2025/) | Cross-cuts starship/nvim/tmux/kitty/btop/sketchybar |
| 5 | **tmux arrow pane indicator** | Vertical arrows marking pane direction | in [dotfiles-latest](https://github.com/linkarzu/dotfiles-latest) tmux config | Our tmux config |
| 6 | **osascript menubar hide** | Native menubar auto-hide, one line | [post §hide-menubar](https://linkarzu.com/posts/2024-macos-workflow/sketchybar-macos/#hide-macos-menubar) | Pairs with our SketchyBar |
| 7 | **osascript (learn)** | AppleScript from the shell — automation | see §7 | General macOS tooling |
| 8 | **Dotfiles layout system** | How his repo is *organized* (obsidian/nvim-md/bars/tasks) | [dotfiles-latest](https://github.com/linkarzu/dotfiles-latest) | Structural model |
| 9 | **tmux plugins (TPM)** | Curated plugin set + fzf window-jump | [video](https://youtu.be/u56ViYVJlfw) | **Reverses** our plugin-free tmux |

---

## 1. btop
Resource monitor — CPU / mem / disk / net / processes, mouse-driven, **themeable** (linkarzu ships `btop/themes/btop-theme.theme` and drives it from his colorscheme selector, §4). Install: `brew "btop"`. We already have `dust` (du) but no live monitor in the catalog.
- ✅ **ADOPTED 2026-07-14** — installed, `brewfile-cli` line, cataloged at [[../documentation/01-shell-terminal/29-btop|29-btop]], wired as a kol-theme consumer (`themes/<name>/btop.theme` in all four themes). htop stays for quick kills.

## 2. simple-bar
Übersicht status-bar widget by Jean Tinland — **explicitly supports AeroSpace** (and yabai), which is our WM. Shows spaces + apps per space, click-to-jump, plus weather/battery/mic/wifi/media widgets. Needs **Übersicht** running.
- **Tension:** we just did a full **SketchyBar overhaul** (AGENT-CONTEXT session 13 — 7 pure-shell widgets, AeroSpace-wired). simple-bar is a *competing* bar, not additive. This is an "evaluate vs. what we built" call, not an add.

## 3. skitty-notes
linkarzu's markdown **sticky-notes app** — really his Neovim config (`neobean`) launched inside a dedicated **Kitty** window, git-synced to a private repo with an auto-push script. Vim motions + markdown + pasted images. Config is gated behind a `neovim_mode` flag (grep his repo).
- **Note:** we run Ghostty, not Kitty — the Kitty dependency matters here.

## 4. Colorscheme selector (the big one)
Custom bash scripts giving **single-location theme switching** across: starship · btop · ghostty/kitty · tmux · SketchyBar · Neovim. This is the centerpiece of the ricing post — change one value, everything reskins.
- **User's list:** starship, nvim, tmux, kitty. **His list also covers** btop + sketchybar.
- ✅ **v1 BUILT 2026-07-14** — `bin/kol-theme` + `themes/{gruvbox,kol-dark,solarized-osaka,linkarzu}/` covering ghostty · kitty sticky · tmux · nvim-now · the Übersicht widgets · **btop** (same-day follow-up; the `linkarzu` theme carries his palette + frosted-ghostty transparency). Full reference: [[../documentation/09-productivity-desktop/08-kol-theme|kol-theme]]. **Still out:** yazi (needs flavors), starship (parked) — they join as adopted. **simple-bar joined 2026-07-15** (jq-merge of the `.themes` slots, written through the symlink).

## 5. tmux vertical arrow pane indicator
A pane-border / status touch showing **arrow glyphs** indicating pane direction/active pane in his tmux config. Cosmetic + orientation aid.
- **To find:** the exact option in his `tmux.conf` (likely `pane-border-format` / a border-status setting).

## 6. osascript — hide the macOS menubar
From the SketchyBar post — auto-hide the native menubar so a custom bar owns the top. Captured from the screenshot:

```sh
# turn menubar auto-hide ON (native bar hides)
osascript -e 'tell application "System Events" to set autohide menu bar of dock preferences to true'

# turn it OFF again
osascript -e 'tell application "System Events" to set autohide menu bar of dock preferences to false'
```

Equivalent GUI path (macOS Sonoma+): **System Settings → Control Center → Automatically hide and show the menu bar → Always**.
- **Fits:** direct complement to our SketchyBar — hide Apple's bar, show ours. Source: https://linkarzu.com/posts/2024-macos-workflow/sketchybar-macos/#hide-macos-menubar

## 7. osascript — learn more
`osascript` runs **AppleScript (or JXA/JavaScript)** from the shell — the CLI door into macOS app automation and system prefs (as in §6). Worth a real primer.
- `man osascript` — the CLI (`-e` inline, `-l JavaScript` for JXA, script files).
- AppleScript Language Guide (Apple): https://developer.apple.com/library/archive/documentation/AppleScript/Conceptual/AppleScriptLangGuide/introduction/ASLR_intro.html
- Common shapes: `tell application "System Events" to …` (UI/prefs), `tell application "Finder" to …`, `display notification`, `do shell script`.
- **To discuss:** whether a few osascript one-liners deserve a `bin/` helper or a catalog doc (we already stamp Finder Quick Actions via `bin/qa-make.sh` — osascript is the same automation surface).

## 8. Dotfiles layout system (organizational, not visual)
The part the user flagged as *"beautiful… organizationally"* — how linkarzu **structures** his dotfiles-latest repo and workflow, not the pixels. Threads to mine:
- **Obsidian → Neovim** note workflow: https://linkarzu.com/posts/neovim/obsidian-to-neovim/
- **Neovim markdown setup 2025:** https://linkarzu.com/posts/neovim/markdown-setup-2025/
- **Markdown tasks in Neovim** (Telescope list of completed/pending): https://linkarzu.com/posts/neovim/neovim-tasks/
- Repo top-level split by tool (`btop/`, `starship-config/`, `fastfetch/`, `neovim/neobean/`, bars, tasks) — compare to our `docs/`-catalog + `bin/`-by-domain convention.
- **To discuss:** what to borrow for our own structure vs. what's Neovim-workflow-specific (we're not on his obsidian-in-nvim path).

## 9. tmux plugins (TPM) — video overview
Source: https://youtu.be/u56ViYVJlfw — a `~/.tmux.conf` plugin overview. **Directly conflicts with our decision:** our tmux is deliberately **plugin-free** (session 2026-06-10 kept native detach/reattach; TPM/resurrect/continuum were parked as "the documented future option"). This video is that option resurfacing — adopting it is a real reversal, not an add.

His plugin set (from the screenshot):

| Plugin | Purpose |
|--------|---------|
| `tmux-plugins/tpm` | plugin manager (init line **must be last** in tmux.conf) |
| `tmux-plugins/tmux-sensible` | sane default settings |
| `tmux-plugins/tmux-resurrect` | save/restore sessions (`prefix Ctrl-s` / `prefix Ctrl-r`) |
| `tmux-plugins/tmux-continuum` | auto continuous save + `@continuum-restore 'on'` (restore on start) |
| `tmux-plugins/tmux-yank` | copy to system clipboard, cross-platform |
| `christoomey/vim-tmux-navigator` | seamless nvim⇄tmux pane nav (`Ctrl-h/j/k/l`) |
| `tmux-plugins/tmux-prefix-highlight` | show in status bar when prefix is pressed |
| `sainnhe/tmux-fzf` | fuzzy finder for sessions/windows/panes |

Plus a **plugin-free** fzf window-jumper worth stealing standalone (`bind C-f display-popup` → `list-windows | fzf | select-window`) — no TPM needed for that one.
- **To discuss:** the highest-value bits for us are likely `vim-tmux-navigator` (nvim⇄pane nav) + resurrect/continuum (session persistence) + the standalone `C-f` window-jump. Whether that's worth reversing plugin-free.

---

## Reference rigs (other dotfiles to mine)

### Sin-cy/dotfiles — near-identical stack ★621
https://github.com/Sin-cy/dotfiles — macOS, 621★. **Worth an eventual dedicated markdown doc** (user flagged). Notable because its stack is *almost exactly ours*, so it's a direct "how does someone else wire the same tools" reference:

> **Primary interest = the Neovim config** (`nvim/.config/nvim`, 65% Lua). Being studied/built from scratch via a tutorial — split into its own tracker: **[`nvim-from-scratch-study.md`](nvim-from-scratch-study.md)**. The rest of the rig below is context; the nvim study lives in that doc.

| Layer | Sin-cy | Us |
|-------|--------|-----|
| WM | **AeroSpace** | AeroSpace ✓ |
| Terminal | **Ghostty** (+ Alacritty, WezTerm) | Ghostty ✓ |
| Bar | **SketchyBar** | SketchyBar ✓ |
| Prompt | Zsh + **starship** | Zsh + p10k (starship parked) |
| Editor | Neovim (65% Lua) + Zed | Neovim |
| Multiplexer | tmux | tmux ✓ |
| CLI core | fzf/fd/bat/eza/**zoxide**/**atuin** | same ✓ |
| Music | **MPD + rmpc** | rmpc ✓ |

- **Standouts to look at:** uses **GNU Stow** for symlink management (vs. our `bootstrap.sh` symlink loop) + an `install.sh`; **3.4% GLSL** = custom shaders (likely Ghostty `custom-shader` — relevant, we're on Ghostty).
- **To discuss:** it's the closest external mirror of our setup — best repo to diff our choices against (Stow vs bootstrap, starship vs p10k, shader effects). Eventual dedicated doc.

---

## Open questions to settle (after rest)
- [ ] **Bar decision:** keep our SketchyBar, or evaluate simple-bar? They don't coexist.
- [ ] **Theme selector:** adopt the one-switch-reskins-all pattern? Scope = which tools (starship/nvim/tmux/kitty/btop/sketchybar).
- [ ] **btop:** add to Brewfile + catalog?
- [ ] **Menubar hide:** wire the osascript into our setup now (pairs with SketchyBar)?
- [ ] **osascript:** primer / `bin/` helper / catalog doc — how deep?
- [ ] **Layout:** what organizational ideas from his repo are worth stealing?
- [ ] **tmux plugins:** reverse plugin-free for TPM + resurrect/continuum + vim-tmux-navigator, or cherry-pick only the standalone `C-f` window-jump?
- [ ] **Sin-cy diff:** worth a dedicated doc? Stow vs our bootstrap symlinks; steal his Ghostty GLSL shaders?

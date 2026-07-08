---
title: Fastfetch shell home
type: playbook
status: active
updated: 2026-07-08
description: The terminal "shell home" — a fastfetch greeting fronted by a chafa-rendered ANSI portrait, wired into the dotfiles as a symlinked config dir.
aliases:
  - fastfetch-home
  - shell-home
tags:
  - domain/shell
  - pattern/tui
related:
  - "[[07-fastfetch|fastfetch]]"
  - "[[21-chafa|chafa]]"
---

# Fastfetch shell home

The first thing a new terminal shows: a **portrait logo** rendered to ANSI on the left, a **fastfetch** system report on the right, a color palette bar underneath. This category (`18-tui-shell-layout`) is the home for terminal-cockpit customization — this greeting, plus the [[02-tmux-dashboards|tmux dashboard layouts]] it's a panel in ([§7](#7-where-fastfetch-shows-up)).

## 0. What this is

A [[07-fastfetch|fastfetch]] run with a custom **file-raw** logo: instead of a built-in OS logo, fastfetch prints a chafa-rendered ANSI portrait from a text file. The whole thing lives in the repo and is symlinked live.

- **Repo dir:** `~/.dotfiles/fastfetch/` — holds the config, the ANSI logo, and its source image.
- **Live symlink:** `~/.config/fastfetch` → `~/.dotfiles/fastfetch/` — a whole-dir symlink, same pattern as `nvim` and `yazi`.
- Editing files in `~/.dotfiles/fastfetch/` *is* editing the live config; nothing to copy.

## 1. The pieces

| File | What it is |
| --- | --- |
| `config.jsonc` | The fastfetch config — logo block, display separator, module list. |
| `logo.txt` | The chafa-rendered ANSI portrait (~40k of escape codes). What fastfetch prints. |
| `logo-source.jpeg` | The source image the ANSI is generated from. Kept in-repo so the logo is reproducible. |
| symlink `~/.config/fastfetch` | Points the whole dir at the repo. Per machine; created by `ln -sfn` / `bootstrap.sh`. |

## 2. How the logo works

The logo is a **static pipeline**, run once at author time — not at every launch:

```
logo-source.jpeg  ──chafa──►  logo.txt  ──fastfetch──►  printed banner
   (source image)   (ANSI art)  (escape codes)   (logo.type: file-raw)
```

[[21-chafa|chafa]] converts the JPEG into an ANSI/Unicode block-art string and writes it to `logo.txt`. fastfetch never sees the image — `logo.type: "file-raw"` tells it to dump the file's bytes verbatim as the logo, escape codes and all. So the portrait's fidelity is fixed at generation time by chafa's `--size`; fastfetch just replays it.

## 3. Regenerate / retune the logo

The exact command (paths absolute so it runs from anywhere):

```sh
chafa ~/.dotfiles/fastfetch/logo-source.jpeg --size 42x26 --align center \
  > ~/.dotfiles/fastfetch/logo.txt
```

- **`--size 42x26`** — the character grid (cols × rows). Bigger = more detail but a taller/wider banner that pushes the module column right. Tune this against your terminal's font size until the portrait sits beside the text cleanly.
- **`--align center`** — centers the art within that grid.
- **Swap the portrait:** drop a new image at `logo-source.jpeg` (or point the command at a different file), rerun the command, done. Commit the new `logo-source.jpeg` *and* the regenerated `logo.txt` together so the source stays in sync with what renders.
- For dithering, symbol sets, color modes, and the rest of chafa's flags, see [[21-chafa|chafa]].

## 4. The config

`config.jsonc` has two parts that matter.

**The `logo` block** — points fastfetch at the ANSI file and pads it off the module column:

```jsonc
"logo": {
  "type": "file-raw",                        // print the file's bytes as-is
  "source": "~/.config/fastfetch/logo.txt",  // resolves through the symlink
  "padding": { "top": 1, "left": 1, "right": 4 }
}
```

`source` uses the `~/.config` path, not the repo path — it resolves through the symlink, so it's correct on any machine. `padding.right` is the gap between portrait and text; widen it if they crowd.

**The `modules` list** — the report lines, top to bottom, exactly as ordered:

```
title · separator · os · host · kernel · uptime · packages ·
shell · display · cpu · gpu · memory · swap · battery · locale ·
break · colors
```

- **Add / remove a line:** add or delete the module's string in the array. Order in the array = order on screen.
- **`break`** inserts a blank line (the gap before the palette).
- **`colors`** is the palette bar — the row of terminal color swatches at the bottom, a quick read on the active theme.
- `display.separator` is set to two spaces — the gutter between each label and its value.

## 5. Wire it

**Symlink the dir** (per machine — the symlink itself isn't a tracked file):

```sh
ln -sfn ~/.dotfiles/fastfetch ~/.config/fastfetch
```

`-sfn` forces the link and treats an existing symlink dir as a file (won't nest inside it). A `bootstrap.sh` block does this on a fresh machine, same as `nvim`/`yazi`.

**Greet on every shell** (optional — not wired yet). Add to `.zshrc`:

```sh
fastfetch
```

Once `config.jsonc` + `logo.*` are committed, both machines get the identical home after each one runs the symlink (or `bootstrap.sh`).

## 6. Verification

- `fastfetch` renders the **portrait** on the left, the **module report** on the right, the **palette bar** underneath — no error, no missing-file warning.
- `readlink ~/.config/fastfetch` prints `…/.dotfiles/fastfetch` — the symlink resolves.
- Change `--size` and rerun the chafa command → the portrait visibly resizes on the next `fastfetch`.
- If a shell greeting was wired: open a new terminal → the home prints on its own.

## 7. Where fastfetch shows up

This greeting is a panel in the **tmux dashboard layouts** ([[02-tmux-dashboards|tmux dashboards]]): the top banner of the music `home` (fastfetch + rmpc), and the right-column banner of the `stats` cockpit (mactop/htop + fastfetch + yazi). Summon either as a window (`prefix C-d`) or a session (`prefix C-o`).

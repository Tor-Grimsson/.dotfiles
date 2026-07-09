---
title: Yazi cheatsheet (beginner)
type: guide
status: active
updated: 2026-07-09
audience: internal
description: Zero-assumptions beginner guide to actually using Yazi — navigating, previewing, opening files, sending them to other apps, copying/moving, fuzzy-finding, and feeding files to Claude (llm). Worked workflows first, then one big everything-table at the end.
aliases:
  - yazi-cheatsheet
  - yazi-beginner
  - yazi-basics
tags:
  - domain/files
  - pattern/tui
related:
  - "[[02-yazi|Yazi]]"
  - "[[12-fzf|fzf]]"
  - "[[13-zoxide|zoxide]]"
  - "[[09-bat|bat]]"
  - "[[08-eza|eza]]"
  - "[[09-llm|llm]]"
---

# Yazi cheatsheet (beginner)

Assumes you've never used a terminal file manager. Read it top to bottom once, do the workflows, then keep the [[17-yazi-cheatsheet#Everything table|big table]] open while you work. For the dry config/reference, see [[02-yazi|Yazi]].

## What Yazi is (the mental model)

Yazi is a **file manager that lives in your terminal** — like Finder, but keyboard-driven and instant. The screen has **three columns**:

```
   parent dir      current dir          preview
 ┌────────────┐ ┌──────────────┐ ┌──────────────────────┐
 │  Desktop   │ │ > photo.jpg  │ │  [the actual image    │
 │  Downloads │ │   notes.md   │ │   or text or video    │
 │ >Projects  │ │   clip.mp4   │ │   frame, rendered]    │
 │  _temp     │ │   data.json  │ │                       │
 └────────────┘ └──────────────┘ └──────────────────────┘
   where you      what you're       what the highlighted
   came from       looking at        file looks like
```

The **middle** column is where you are. The **`>`** marks the file you're hovering. The **right** column previews it live (images, video frames, PDFs, text — no opening needed). Move the highlight and the preview follows.

Unlike vim, Yazi has **no modes to fight** — one letter = one action, always. The only thing to internalize: **`q` to quit, and quitting drops your shell into whatever folder you were looking at.** That's the killer feature.

## Start & stop — the part that feels like magic

You launch Yazi with **`y`** (a shell function, not the raw `yazi` command):

```sh
y                 # opens at your projects dir (or the current folder)
y ~/Downloads     # open straight at a folder
y .               # open at the current folder
```

Walk around, then quit — and **your shell is now standing in that folder**:

| Key | Does |
|---|---|
| `q` | quit **and `cd` the shell to where you ended up** (visual `cd`) |
| `Q` | quit **without** changing the shell's directory |
| `<Esc>` | cancel whatever you're in the middle of (a filter, a selection, a prompt) |

So the everyday loop is: type `y`, browse visually, press `q`, and start typing commands — you're already in the right folder. No more `cd ../../that/long/path`.

> Raw `yazi` (no `cd`-on-quit) still works if you ever want it, but use `y`.

## Move around

| Key | Does |
|---|---|
| `j` / `k` | move highlight **down / up** |
| `l` or `<Enter>` | **enter** the folder / **open** the file (one key does both — "smart enter") |
| `h` | go **up** to the parent folder (left) |
| `H` / `L` | **back / forward** through where you've been (like a browser) |
| `gg` / `G` | jump to **top / bottom** of the list |
| `.` | show / hide **hidden** (dotfiles) |

### Instant jumps (your custom shortcuts)

Press `g` then a letter — set up in your `keymap.toml`:

| Keys | Jumps to |
|---|---|
| `g h` | Home (`~`) |
| `g p` | Projects (`~/thatComp--iMac`) |
| `g d` | Downloads |
| `g D` | Desktop |
| `g .` | Dotfiles repo (`~/.dotfiles`) |
| `g t` | `~/_temp` |

## Look without opening

The whole point of the preview pane is to **judge a file without launching anything**:

| Key | Does |
|---|---|
| (just hover) | live preview on the right — image, video frame, PDF, text, JSON |
| `T` | **full-screen the preview** (blow an image/video up to the whole window); `T` again to restore |
| `K` / `J` | scroll **inside** the preview (long text/PDF) up / down |
| `<C-y>` | **Quick Look** — the real macOS spacebar-preview popup, for the hovered/selected files |
| `<Tab>` | show file **metadata** (size, dates, dimensions) |

`T` + `j`/`k` is how you flip through a folder of photos or video clips like a contact sheet.

## Open files & send them to other apps

"Opening" means handing the file to an app. Yazi gives you several routes:

| Key / command | Opens the file… |
|---|---|
| `<Enter>` or `l` | with the **default app** (text → nvim, image → Preview, etc.) |
| `o` | same — open with the default app |
| `O` | **pick** how to open it (Yazi shows its opener list: open / edit / reveal / play) |
| `<C-y>` | **Quick Look** (just peek, don't launch an app) |

**Send to a *specific* app** (Yazi has no "Open With…" menu for arbitrary apps, so you run one shell command — `"$@"` means "the file(s) I have highlighted/selected"):

1. Press **`;`** (run a shell command, returns immediately).
2. Type, e.g.:

```sh
open -a "Preview" "$@"          # open in Preview
open -a "Adobe Photoshop 2024" "$@"
open -R "$@"                    # reveal in Finder
```

3. `Enter`. (Use **`:`** instead of `;` when you want Yazi to *wait* for the command to finish.)

To **edit in nvim** specifically, `<Enter>` on a text file already does it (`$EDITOR` is nvim), or `; nvim "$@"`.

## Select, copy, move, delete

First pick files, then act. Selection is how you operate on many at once.

| Key | Does |
|---|---|
| `<Space>` | **select / deselect** the file and move down (tap down a list to multi-select) |
| `v` / `V` | visual-select mode / visual-deselect mode |
| `<C-a>` / `<C-r>` | select **all** / **invert** the selection |
| `<Esc>` | clear the selection |
| `y` | **yank** = copy the selected (or hovered) files |
| `x` | **cut** them (move on paste) |
| `p` | **paste** here (do this after `y`/`x`) |
| `P` | paste **overwriting** if names clash |
| `d` | move to **Trash** (recoverable) |
| `D` | **delete permanently** (gone — careful) |
| `a` | **create** a file; end the name with `/` to make a **folder** |
| `r` | **rename** the hovered file |

**Bulk rename:** select several files, press `r`. Yazi opens all their names as a list **in nvim**. Edit the list like text, `:wq`, and every rename applies at once.

## Find & jump fast

| Key | Does |
|---|---|
| `/` | **filter** the current folder as you type (hides non-matches) |
| `s` | **search** files by name under here (uses `fd`/`ripgrep`) |
| `f` | jump to a name in view (type-to-jump) |
| `z` | **zoxide** — type a fragment, teleport to a folder you've visited before |
| `Z` | **fzf** — fuzzy-pick any file/folder from a live list |
| `t` | open a **new tab** · `1`…`9` switch tabs · `<Tab>` cycles |

`z` and `Z` are the big ones — see [[17-yazi-cheatsheet#How it connects to your other tools|integrations]] below.

## Worked workflows

These are the real reasons to use Yazi. Do them once each.

### 1. Visual `cd` into a project

You want a terminal sitting in a project folder buried a few levels deep.

`y` → `g p` (jump to Projects) → `j`/`k` to the project → `l` to go in, maybe `l` again into a subfolder → **`q`**. Your shell prompt is now inside that folder. Start running commands.

### 2. Clean out a messy Downloads folder

`y` → `g d` (Downloads). Now triage:
- Hover a file → glance at the **preview** (or `<C-y>` for Quick Look) to remember what it is.
- Junk? **`d`** (Trash).
- Keeper that belongs elsewhere? **`<Space>`** to select it (select several this way), navigate to the destination with `h`/`l`/the `g`-jumps, then **`p`**… wait — to *move*, you press **`x`** (cut) on the selection first, go to the target, then **`p`**.
- Done. `q`.

### 3. Review a folder of photos/videos fast

`y` to the folder → hover the first image → **`T`** (full-screen the preview) → **`j`/`k`** to flip through them at full size → **`T`** to drop back to normal. For a pixel-perfect look at one, **`<C-y>`** (Quick Look). No app launches, no waiting.

### 4. Rename a batch of files

Select the files with **`<Space>`** (or `<C-a>` for all) → **`r`** → Yazi dumps the names into **nvim** as an editable list → fix them (find-replace, numbering, whatever) → **`:wq`**. All renames land together.

### 5. Move files between two folders (two-pane style)

Open the **source** folder, press **`t`** for a second tab, navigate that tab to the **destination**. Back in the source tab (`1`/`2` to switch), select files (`<Space>`), **`x`** to cut (or `y` to copy), switch to the destination tab, **`p`** to drop them. Two folders open at once, no path typing.

### 6. Find a file when you forget where it is

- Know roughly the folder? **`z`** then a fragment of its name → you're there (zoxide remembers everywhere you've been).
- Know part of the *filename*? **`Z`** (fzf) and fuzzy-type it, or **`s`** to search names under the current folder.

### 7. Ask Claude about a file (llm)

Two ways:

**a) From inside Yazi** — hover the file, press **`;`** and pipe it to `llm`:
```sh
llm "summarize this in 5 bullets" < "$0"     # "$0" = the hovered file
cat "$@" | llm "explain what this code does" # "$@" = all selected files
```
Press **`:`** instead of `;` so Yazi waits and you see the answer.

**b) From the shell** — `y` to the folder, **`q`** to land there, then run `llm` normally:
```sh
llm "what's wrong with this config?" < broken.toml
```

(`llm` is Simon Willison's CLI, default model `claude-haiku-4.5` — see [[09-llm|llm]].)

### 8. Open one file in a specific app, reveal another in Finder

Hover the file → **`;`** → `open -a "Preview" "$@"` (or any app name). To show it in Finder instead: **`;`** → `open -R "$@"`. To just peek: **`<C-y>`**.

## How it connects to your other tools

You asked specifically about fzf, zoxide (`z`), bat, eza, and llm. Here's the honest breakdown — **two are wired *into* Yazi, the rest are partners that live in the shell**:

| Tool | Relationship to Yazi | How you feel it |
|---|---|---|
| **zoxide** ([[13-zoxide|13-zoxide]]) | **Built in** — `z` inside Yazi uses the *same* frecency database as `z` in your shell. | Press `z`, type a fragment, teleport. Visiting folders in Yazi *and* in the shell both train it. |
| **fzf** ([[12-fzf|12-fzf]]) | **Built in** — `Z` inside Yazi fuzzy-finds files/folders via fzf. | Press `Z`, fuzzy-type, jump. Same engine as your shell's `Ctrl-T`. |
| **bat** ([[09-bat|09-bat]]) | **Not** called by Yazi — Yazi has its *own* syntax-highlighted text preview. bat is your **shell's** `cat` (`alias cat='bat'`). | They're cousins, not connected: gorgeous text preview in Yazi, gorgeous `cat` in the shell. |
| **eza** ([[08-eza|08-eza]]) | **Not** called by Yazi — Yazi *is* the visual file lister. eza is the **inline** `ls` for when you don't want a full TUI (`ls`/`ll`/`lt`). | Use eza for a quick listing in place; use `y` when you want to browse and preview. |
| **llm** ([[09-llm|llm]]) | **Not** built in — but Yazi's shell command (`;`) pipes the hovered/selected file straight to it. | See [[17-yazi-cheatsheet#7. Ask Claude about a file (llm)|workflow 7]]. |
| **nvim** | Yazi's editor (`$EDITOR`) — opens text files and powers **bulk rename**. | `<Enter>` on a `.md`, or `r` on a selection. |
| **Quick Look / Finder** | macOS native, via `<C-y>` and `open -R`. | Peek without launching; reveal when you need the GUI. |

The mental split: **inside Yazi**, `z`/`Z` are your jump keys (zoxide/fzf). **Outside Yazi** (after `q`), `z`, `ls`/`ll` (eza), `cat` (bat), and `llm` are the shell tools you land next to. Yazi is the hub; `q` hands off to them.

## Everything table

The full keymap for your install — stock Yazi keys plus your customizations. (Press **`~`** inside Yazi anytime to see the live, authoritative list.)

### Move
| Key | Action |
|---|---|
| `j` / `k` | down / up |
| `l` / `<Enter>` | enter folder / open file (smart-enter) |
| `h` | up to parent |
| `H` / `L` | history back / forward |
| `gg` / `G` | top / bottom |
| `g h/p/d/D/./t` | jump: Home / Projects / Downloads / Desktop / Dotfiles / _temp |
| `z` | zoxide jump (visited folders) |
| `Z` | fzf jump (fuzzy any file/folder) |

### Look / preview
| Key | Action |
|---|---|
| (hover) | live preview (image/video/PDF/text/JSON) |
| `T` | full-screen the preview / restore |
| `K` / `J` | scroll inside the preview |
| `<C-y>` | Quick Look (macOS) |
| `<Tab>` | file metadata |
| `.` | toggle hidden files |

### Open
| Key | Action |
|---|---|
| `<Enter>` / `o` | open with default app |
| `O` | pick the opener (open/edit/reveal/play) |
| `;` `open -a "App" "$@"` | open in a specific app |
| `;` `open -R "$@"` | reveal in Finder |

### Select / edit files
| Key | Action |
|---|---|
| `<Space>` | select / deselect + move down |
| `v` / `V` | visual select / deselect |
| `<C-a>` / `<C-r>` | select all / invert |
| `<Esc>` | clear selection / cancel |
| `y` / `x` / `p` | copy / cut / paste |
| `P` | paste, overwrite on clash |
| `d` / `D` | Trash / delete permanently |
| `a` | create file (end `/` = folder) |
| `r` | rename (select many = bulk rename in nvim) |

### Find
| Key | Action |
|---|---|
| `/` | filter current folder as you type |
| `s` | search names under here (fd/rg) |
| `f` | type-to-jump in view |
| `z` / `Z` | zoxide / fzf jump |

### Tabs & shell
| Key | Action |
|---|---|
| `t` | new tab |
| `1`–`9` | switch to tab N |
| `;` | run a shell command (returns immediately) |
| `:` | run a shell command (waits for it) |

### Quit
| Key | Action |
|---|---|
| `q` | quit **and `cd`** the shell there |
| `Q` | quit, leave shell where it was |
| `~` | help (every active key) |

## When you're stuck

- **Highlight won't move / weird behavior?** → `<Esc>`. You're probably in a filter or selection.
- **Deleted something by accident?** → if you used `d` it's in the **Trash** (recover from Finder). `D` is permanent — that's why it's separate.
- **Preview is blank?** → that filetype may need a backend; check the deps table in [[02-yazi|Yazi]] (`brew install sevenzip resvg` covers the last gaps).
- **Quit but the shell didn't move?** → you pressed `Q` (no-cd). Use lowercase `q`.
- **Forgot a key?** → press **`~`** for the full help, right inside Yazi.

## Keep learning

- **`~`** — Yazi's built-in keymap help (the source of truth for your version).
- **Manual** — <https://yazi-rs.github.io/> (config, plugins, every command).
- The terse reference (config files, plugins, deps): [[02-yazi|Yazi]].

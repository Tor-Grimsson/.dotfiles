# macOS `defaults` — what this script does, and how the system works

This explains `defaults.sh`: the macOS preferences system underneath it, then every setting it writes and *why*.

---

## 1. What `defaults` actually is

Every preference you set in **System Settings** — Finder options, Dock behaviour, keyboard speed — isn't stored in some opaque blob. macOS keeps preferences in a structured key-value database, organised into **domains** (one per app/area). System Settings is just a friendly GUI that writes into that database.

You can write to it directly:

```sh
defaults write <domain> <key> -<type> <value>
defaults read   <domain> <key>          # see the current value
defaults delete <domain> <key>          # remove it (revert to the app's built-in default)
```

- **domain** — which app/area. `com.apple.finder`, `com.apple.dock`, `com.apple.screencapture`. One special domain, **`NSGlobalDomain`** (aliases: `-g`, "Apple global"), is inherited by *every* app — that's where system-wide things like keyboard repeat and text substitution live.
- **type** — `-bool`, `-int`, `-float`, `-string`. Use the right one or the app may ignore the value.

So `defaults.sh` is simply **your preferences expressed as code**: set once, replay on any Mac, version-control it, and — crucially — *comment why* each choice was made. That's the whole point of doing it in a script instead of clicking through 200 settings panes on every fresh machine.

### Why the `killall` at the very end

Apps read their preference domain **once, at launch**, and cache it. Writing a key does nothing to an already-running app. So the script ends with:

```sh
killall Finder Dock SystemUIServer
```

— which force-relaunches those three (SystemUIServer owns the menu bar + screenshot service) so they re-read the database. A few keys (keyboard repeat, anything login-level) need a **full logout/restart** to take hold; those are noted below.

---

## 2. Finder — make the file manager stop lying to you

```sh
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
```
Finder hides file extensions by default. Beyond being annoying, that's a real footgun: `invoice.pdf.app` *looks* like a PDF with extensions hidden. Always show them.

```sh
defaults write com.apple.finder AppleShowAllFiles -bool true
```
Show dotfiles (`.gitignore`, `.zshrc`, `.env`) in Finder. You live in a dotfiles repo — you need to see them.

```sh
defaults write com.apple.finder ShowPathbar   -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
```
The **path bar** (bottom strip showing where you are), the **status bar** (item count + free space), and the **full POSIX path in the window title** — so you can read/copy `/Users/you/dev/project` at a glance instead of guessing from a folder name.

```sh
defaults write com.apple.finder FXPreferredViewStyle  -string "Nlsv"
defaults write com.apple.finder FXDefaultSearchScope  -string "SCcf"
```
Two four-letter codes worth knowing:
- `FXPreferredViewStyle`: `Nlsv` = **list** view (others: `icnv` icon, `clmv` column, `glyv` gallery). List is the sane default for work.
- `FXDefaultSearchScope`: `SCcf` = search the **current folder**. The macOS default is `SCev` ("this Mac"), so typing in Finder's search box searches your *entire drive* — almost never what you want.

```sh
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder _FXSortFoldersFirst -bool true
```
Kill the "Are you sure you want to change the extension?" nag (you change extensions on purpose), and sort **folders before files** (like every other OS).

```sh
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores     -bool true
```
Finder scatters `.DS_Store` files (folder view metadata) into every directory it opens — including network shares and USB sticks, where they litter other people's machines. These two stop it on **network volumes** and **USB volumes**. (It still writes them locally; that's harmless and `.gitignore`'d.)

```sh
chflags nohidden "$HOME/Library"
```
Not a `defaults` call — Apple flips a hidden flag on `~/Library`. This unhides it so you can reach `~/Library/Application Support`, fonts, etc. without `cmd+shift+.` gymnastics.

---

## 3. Keyboard & text — fast, and out of your way

```sh
defaults write NSGlobalDomain KeyRepeat        -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
```
These control key repeat when you **hold** a key. The values are in ~15 ms ticks: `KeyRepeat 2` ≈ 30 ms between repeats, `InitialKeyRepeat 15` ≈ 225 ms before repeat kicks in. The System Settings sliders *bottom out* at "Fast"/"Short" — these go **faster than the GUI allows**. (Needs a logout to fully apply.)

```sh
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
```
By default, holding a key pops up the **accent menu** (hold `e` → é, è, ê…). Great for writing French, terrible for vim or any held-key navigation. `false` = held keys **repeat** instead.

```sh
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled      -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled  -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled   -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled    -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled  -bool false
```
The five "smart text" meddlers, all off — because they wreck code, paths, and commands:
- **Capitalization** — capitalises the start of "lines" (breaks `ssh`, variable names).
- **Spelling correction** — silently rewrites words.
- **Quote substitution** — turns `"` into `"` `"` (curly quotes), which shells and JSON reject.
- **Dash substitution** — turns `--flag` into `—flag` (em dash). Murders CLI flags.
- **Period substitution** — double-space inserts a `. ` you didn't type.

---

## 4. Screenshots

```sh
defaults write com.apple.screencapture location -string "$HOME/Screenshots"
defaults write com.apple.screencapture type     -string "png"
defaults write com.apple.screencapture disable-shadow -bool true
```
- **location** — screenshots default to the **Desktop**, which becomes a junkyard. Send them to `~/Screenshots` (the script `mkdir -p`s it first).
- **type** — keep PNG (lossless; alternatives are `jpg`, `pdf`, `tiff`).
- **disable-shadow** — a window capture (`cmd+shift+4`, then space) adds a fat soft drop-shadow, which means ~100 px of transparent margin around the image. Off = tight crops.

---

## 5. Dock

```sh
defaults write com.apple.dock autohide              -bool  true
defaults write com.apple.dock autohide-delay        -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.15
```
Auto-hide the Dock, but with **zero reveal delay** and a **fast animation** — the stock auto-hide has a deliberate pause that makes it feel sticky and slow. These three together make it snap in/out instantly.

```sh
defaults write com.apple.dock show-recents          -bool false
defaults write com.apple.dock minimize-to-application -bool true
defaults write com.apple.dock mru-spaces            -bool false
defaults write com.apple.dock tilesize              -int  48
```
- **show-recents** off — drop the auto "recent apps" section.
- **minimize-to-application** — minimised windows fold **into their app's icon** instead of piling up as separate tiles on the right.
- **mru-spaces** off — stop macOS from **reordering your Spaces** by most-recently-used; they stay where you put them (vital for muscle memory with multiple desktops).
- **tilesize** — icon size in px.

```sh
defaults write com.apple.dock appswitcher-all-displays -bool true
```
The **⌘-Tab switcher on every display**, not only the one with the menu bar. On a two-monitor desk the stock behaviour makes you look away from whatever you were working on.

---

## 5b. Rectangle — window snapping

Replaced **Magnet** on 2026-08-01. The reason is this section existing at all: Magnet has **no gap or margin setting**, and its keymap lives in an opaque plist blob (`horizontalCommands` / `verticalCommands`, JSON stuffed into a data field). Rectangle exposes every setting as a plain `defaults` key — so the geometry is tracked here instead of clicked into a GUI.

```sh
defaults write com.knollsoft.Rectangle gapSize                -float 24
defaults write com.knollsoft.Rectangle screenEdgeGapTop       -int   48
defaults write com.knollsoft.Rectangle screenEdgeGapRight     -int   304
defaults write com.knollsoft.Rectangle screenEdgeGapLeft      -int   10
defaults write com.knollsoft.Rectangle screenEdgeGapBottom    -int   10
defaults write com.knollsoft.Rectangle screenEdgeGapsOnMainScreenOnly -bool true
defaults write com.knollsoft.Rectangle applyGapsToMaximize    -int   2
```

- **gapSize** — the gutter **between** windows. Separate from the edge margins, which is the thing Raycast can't do (it has one global value for both).
- **screenEdgeGap\*** — margin per edge. `304` clears the Übersicht widget column (280 wide + 12 margin + 12 gap); `48` clears the bar strip.
- **screenEdgeGapsOnMainScreenOnly** — confines those two large values to the **iMac**. Rectangle has no true per-display setting, so main-vs-rest is as fine as it gets — which happens to be exactly the split `aerospace.toml`'s `[gaps]` uses (`[{ monitor.main = N }, 10]`).
- **applyGapsToMaximize** — without it, Maximize ignores the gaps and fills the screen edge-to-edge.

**The numbers mirror `aerospace.toml` on purpose.** AeroSpace tiles managed windows; Rectangle snaps the 11 `layout floating` apps. Same grid, two tools, so a floated Finder lines up with a tiled Ghostty.

**Division of labour:** AeroSpace owns `ctrl-alt` (workspaces + focus). Rectangle's chords must not collide with it — Magnet's did, on 11 of them, and lost all 11 silently (first registrar wins).

### Shortcuts

Also `defaults` keys, so the keymap is tracked rather than clicked:

```sh
defaults write com.knollsoft.Rectangle leftHalf -dict-add keyCode -float 123 modifierFlags -float 786432
```

`modifierFlags` are **Cocoa** masks, not the Carbon ones Magnet stored: `ctrl 262144` · `alt 524288` · `cmd 1048576` · `shift 131072`. So `786432` = ctrl+alt and `1310720` = cmd+ctrl.

| chord | action | why this band |
|---|---|---|
| `⌃⌥←` `→` `↑` `↓` | `leftHalf` `rightHalf` `topHalf` `bottomHalf` | Magnet's exact chords — AeroSpace has **no arrow bindings**, so these were never contested |
| `⌃⌥⏎` | `almostMaximize` | not `maximize` — that one ignores the gaps |
| `⌃⌥⌫` | `restore` | uncontested |
| `⌘⌃U` `I` `J` `K` | quarters | same letters as Magnet, moved off `ctrl-alt` |
| `⌘⌃D` `F` `G` | `firstThird` `secondThird` `thirdThird` | ditto |
| `⌘⌃E` `T` | `firstTwoThirds` `lastTwoThirds` | ditto |
| `⌘⌃C` | `center` | ditto |

`cmd-ctrl` was chosen because AeroSpace has **zero** bindings in it — verified, not assumed.

**One trap closed:** Rectangle's *Todo* feature ships bound to `⌃⌥N` and `⌃⌥B`, which are AeroSpace workspaces N and B. `defaults.sh` deletes both and sets `todo -bool false`.

---

## 6. Save / print dialogs

```sh
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode  -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint     -bool true
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud   -bool false
```
Always open the **expanded** Save panel (the one with the full folder tree, not the collapsed dropdown) and the expanded Print panel. And default new documents to **disk, not iCloud** — so "Save" doesn't keep trying to push into iCloud Drive.

---

## 7. Trackpad

```sh
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
```
**Tap-to-click** on. The second line (`-currentHost`) sets it for the login session too, so it's active at the login screen / for this specific Mac.

---

## 8. Services shortcuts

```sh
defaults write pbs NSServicesStatus -dict-add '"(null) - Open in TextEdit - runWorkflowAsService"' \
  '{key_equivalent = "$~^e"; enabled_services_menu = 1; presentation_modes = {ContextMenu = 1; ServicesMenu = 1;};}'
```

Keyboard shortcuts for **Services / Quick Actions** live in their own domain, `pbs` (the pasteboard/services daemon), keyed by `"<bundle> - <menu name> - <message>"` — Automator workflows use `(null)` as the bundle. The `key_equivalent` string is modifier glyphs + key: `@` cmd, `$` shift, `~` option, `^` control.

| Shortcut | Service | Source |
|---|---|---|
| ⇧⌥⌃E | Open in TextEdit (any Finder file) | `macos/services/Open in TextEdit.workflow` |
| ⇧⌥⌃A | Select Every Other (thins the Finder selection to the 1st/3rd/5th…) | `macos/services/Select Every Other.workflow` → `bin/finder-select-alternate.sh` |
| — (menu only) | Open in glow (markdown) | `macos/services/Open in glow.workflow` |

The workflows themselves are symlinked into `~/Library/Services` by `bootstrap.sh`. After changing a binding: `/System/Library/CoreServices/pbs -flush` and restart Finder.

---

## 9. Reverting and tweaking — important gotcha

`defaults write` is **one-directional**. Commenting a line out of the script and re-running does **not** undo a value you already wrote — the key is still in the database. To truly revert:

```sh
defaults delete com.apple.finder ShowPathbar   # remove the key → app falls back to its built-in default
killall Finder
```

Useful workflow for **finding** a key: change a setting in System Settings, then diff the domain before/after:

```sh
defaults read com.apple.finder > /tmp/before
# ...toggle the setting in System Settings...
defaults read com.apple.finder > /tmp/after
diff /tmp/before /tmp/after            # shows exactly which key changed
```

---

## 10. `defaults.sh` vs `macos/prefs/*.plist`

These are **two different mechanisms** for the same database — don't confuse them:

- **`defaults.sh`** — the curated, per-key, *readable* approach. Each line is one deliberate choice you can read, comment, and port. This is the one you maintain.
- **`macos/prefs/*.plist`** — a **raw dump of entire domains** (`finder`, `NSGlobalDomain`, `symbolichotkeys`, `hitoolbox`) exported from this machine. They are **not symlinked, not imported, and do nothing on their own** — a backup snapshot only. You *could* load one with `defaults import <domain> <file.plist>`, but that **overwrites the whole domain** (every key, including machine-specific cruft), so it's heavy-handed. Keep them as a reference/backup; make actual changes in `defaults.sh`.

Run the script directly any time: `~/.dotfiles/macos/defaults.sh` (idempotent — safe to re-run). `bootstrap.sh` also calls it.

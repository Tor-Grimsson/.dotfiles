# macOS defaults — what `defaults.sh` does

`defaults.sh` writes a curated baseline of macOS preferences via `defaults write`, then restarts Finder/Dock/SystemUIServer so most of it applies immediately. It's **idempotent** — safe to re-run. `bootstrap.sh` calls it automatically.

Run standalone: `~/.dotfiles/macos/defaults.sh`

## What it sets

| Group | Keys | Effect |
|---|---|---|
| **Finder** | `AppleShowAllExtensions`, `AppleShowAllFiles`, `ShowPathbar`, `ShowStatusBar`, `_FXShowPosixPathInTitle`, `FXPreferredViewStyle=Nlsv`, `FXDefaultSearchScope=SCcf`, `FXEnableExtensionChangeWarning=false`, `_FXSortFoldersFirst` | Show extensions + hidden files, path/status bars, full POSIX path in title, list view, search current folder, no extension-change nag, folders on top |
| **No .DS_Store** | `DSDontWriteNetworkStores`, `DSDontWriteUSBStores` | Stop `.DS_Store` litter on network shares + USB volumes |
| **~/Library** | `chflags nohidden ~/Library` | Unhide the user Library folder |
| **Keyboard** | `KeyRepeat=2`, `InitialKeyRepeat=15`, `ApplePressAndHoldEnabled=false` | Fast key repeat, short initial delay, repeat held keys (no accent popup) |
| **Text (dev)** | `NSAutomatic{Capitalization,SpellingCorrection,QuoteSubstitution,DashSubstitution,PeriodSubstitution}Enabled=false` | Kill autocorrect / smart quotes / smart dashes / double-space-period |
| **Screenshots** | `screencapture location=~/Screenshots`, `type=png`, `disable-shadow=true` | Save to `~/Screenshots` as shadowless PNG |
| **Dock** | `autohide`, `autohide-delay=0`, `autohide-time-modifier=0.15`, `show-recents=false`, `minimize-to-application`, `mru-spaces=false`, `tilesize=48` | Auto-hide instantly, no recents, minimize into app icon, don't reorder Spaces |
| **Save/print** | `NSNavPanelExpandedStateForSaveMode(2)`, `PMPrintingExpandedStateForPrint`, `NSDocumentSaveNewDocumentsToCloud=false` | Expanded save/print panels, default new docs to disk not iCloud |
| **Trackpad** | `AppleBluetoothMultitouch.trackpad Clicking`, `mouse.tapBehavior=1` | Tap-to-click |

## Caveats
- A few changes (key-repeat, some Finder bits) need a **logout/restart** to fully take hold.
- Want a default gone? Comment the line and re-run — `defaults write` won't un-set on its own; use `defaults delete <domain> <key>` to truly revert.
- This is the **curated, readable** mechanism. The plist dumps in `macos/prefs/` are a separate raw capture — see below.

## `macos/prefs/*.plist` — not the same thing
Those are full exported pref **domains** (`finder`, `NSGlobalDomain`, `symbolichotkeys`, `hitoolbox`), a raw snapshot of this machine. They are **not symlinked, not imported, do nothing on their own**. Activate one with `defaults import <domain> <plist>` (then restart the app) — but that overwrites the *entire* domain, so prefer editing `defaults.sh` for portable, reviewable changes. Keep `prefs/` as a backup/diff reference.

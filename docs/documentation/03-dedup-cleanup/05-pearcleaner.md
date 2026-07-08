---
title: Pearcleaner
type: reference
status: active
updated: 2026-06-04
description: Open-source macOS app uninstaller that removes apps and hunts down leftover files from already-deleted apps.
aliases:
  - Pearcleaner
tags:
  - domain/cleanup
  - pattern/gui
  - integration/brew-cask
links:
  website: https://itsalin.com/appInfo/?id=pearcleaner
  repo: https://github.com/alienator88/Pearcleaner
  manual: https://github.com/alienator88/Pearcleaner
  brew: https://formulae.brew.sh/cask/pearcleaner
covers:
  - thorough app uninstall with associated files
  - orphaned-file detection for already-removed apps
  - bundled CLI and Finder/Sentinel integration
related:
  - "[[04-appcleaner|AppCleaner]]"
---

## Summary
Pearcleaner is an open-source, native-SwiftUI macOS uninstaller. It removes an application together with its associated files, and — unlike most uninstallers — it can also scan for and clean up leftover files belonging to apps that were already deleted.

## Why installed
It is the open-source, actively developed counterpart to AppCleaner, and it covers a gap the others do not: finding orphaned support files from apps long since dragged to the Trash. It also ships a CLI binary, so uninstalls can be scripted.

## Most common use case
Dropping an app into Pearcleaner to uninstall it cleanly, or running its leftover-files scan to clear residue from apps that were removed without a proper uninstaller.

## Biggest win
Orphaned-file detection. Pearcleaner can scan the system for support files whose parent app no longer exists and clean them up — recovering space that drag-to-Trash uninstalls leave stranded indefinitely. Being native, open-source, and CLI-capable is a bonus over closed alternatives.

## How to use
- Launch Pearcleaner and drag an app onto the window to see and remove its associated files.
- Open the **Orphaned Files** view to scan for and clean leftovers from already-deleted apps.
- Enable the **Sentinel** monitor so dragging an app to the Trash triggers a cleanup prompt automatically.
- Use the bundled CLI for scripted uninstalls:

```sh
# The cask symlinks the app binary as `pearcleaner`
pearcleaner --help
```

## Future use
The bundled CLI is the unexplored lever here — uninstalls and leftover scans can be wired into maintenance scripts rather than done by hand. The orphaned-files scan is also worth running periodically as a standalone housekeeping pass, independent of any single uninstall.

---
title: AppCleaner
type: reference
status: active
updated: 2026-06-04
description: Lightweight macOS app uninstaller that removes an application along with its leftover support files.
aliases:
  - AppCleaner
tags:
  - domain/cleanup
  - pattern/gui
  - integration/brew-cask
  - provider/freemacsoft
links:
  website: https://freemacsoft.net/appcleaner/
  brew: https://formulae.brew.sh/cask/appcleaner
covers:
  - complete app uninstall with associated files
  - drag-to-remove and app-list selection
  - SmartDelete background monitoring
related:
  - "[[05-pearcleaner|Pearcleaner]]"
---

## Summary
AppCleaner is a small, free macOS utility that uninstalls applications thoroughly. Dragging an app onto its window (or picking it from a list) surfaces every related file — preferences, caches, support folders, login items — so the app and all its scattered leftovers are removed together.

## Why installed
Deleting an app to the Trash leaves support files, caches, and preference plists behind across `~/Library`. AppCleaner finds and removes those orphans in one pass, keeping the system free of dead-app cruft.

## Most common use case
Dragging an application onto the AppCleaner window, reviewing the list of associated files it finds, and removing them all in one click.

## Biggest win
SmartDelete: when enabled, AppCleaner watches for apps dragged to the Trash and automatically pops up to offer removal of their leftover files — so a normal Trash-drag uninstall becomes a complete one without launching anything manually.

## How to use
- Launch AppCleaner and drag an app from `/Applications` onto its window.
- Review the checklist of related files it discovers, then click **Remove**.
- Use the **Applications** list view to browse installed apps and select one to uninstall without dragging.
- Enable **SmartDelete** in Preferences so it auto-offers cleanup whenever you drag an app to the Trash.
- Use the **Preferences > Protect** list to shield apps you never want it to touch.

## Future use
The Applications list with sorting can double as an audit of what is installed and how much each app's footprint is. Leaving SmartDelete on makes complete uninstalls the default behavior system-wide, reducing the need to ever open the app explicitly.

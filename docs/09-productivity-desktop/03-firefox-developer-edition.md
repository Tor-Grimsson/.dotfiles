---
title: Firefox Developer Edition
type: reference
status: active
updated: 2026-06-04
description: Mozilla's developer-focused Firefox build with the latest devtools.
aliases:
  - firefox-dev
tags:
  - domain/dev/web
  - pattern/gui
  - integration/brew-cask
  - provider/mozilla
links:
  website: https://www.mozilla.org/firefox/developer/
  manual: https://firefox-source-docs.mozilla.org/devtools-user/
  brew: https://formulae.brew.sh/cask/firefox@developer-edition
covers:
  - Separate dev browser profile
  - Devtools, responsive design mode
  - First-run setup
related:
  - "[[01-raycast|Raycast]]"
---

## Summary
Firefox Developer Edition is a separate Firefox build aimed at web developers, tracking the Beta channel with developer tools enabled and surfaced by default. It runs its own profile, keeping development browsing isolated from a daily-driver browser. It ships the newest devtools features before they reach the stable release.

## Why installed
It is the dedicated web-development browser, kept apart from everyday browsing. A distinct profile means dev extensions, relaxed security flags, and test cookies never pollute the main browser, and the Beta-channel devtools expose upcoming platform behaviour early.

## Most common use case
Open it to inspect and debug a page — element inspector, network panel, and console — against a build that is closer to the web platform's leading edge than stable Firefox.

## Biggest win
A clean, isolated profile with bleeding-edge devtools. Responsive Design Mode and the multi-context devtools come configured for development out of the box, without compromising the security posture of the primary browser.

## How to use
- Launch "Firefox Developer Edition" — it manages its own profile automatically.
- Open devtools with `Cmd+Opt+I`; the inspector with `Cmd+Opt+C`.
- Toggle Responsive Design Mode with `Cmd+Opt+M` to test breakpoints.
- Keep dev-only extensions and accounts confined to this profile.

## Future use
The cask token is `firefox@developer-edition`; it could front local dev servers for live preview, and its profile could be seeded from the dotfiles repo to make the dev browser reproducible across machines.

---
title: Carbonyl
type: reference
status: active
updated: 2026-06-05
description: Chromium fork that renders the full modern web — JS, CSS, video, mouse — directly to terminal cells, run via Docker/OrbStack.
aliases:
  - carbonyl
tags:
  - domain/web
  - pattern/tui
  - integration/docker
links:
  website: https://github.com/fathyb/carbonyl
  repo: https://github.com/fathyb/carbonyl
  manual: https://github.com/fathyb/carbonyl#readme
  docker: https://hub.docker.com/r/fathyb/carbonyl
covers:
  - Docker/OrbStack delivery and the `carbonyl()` shell function
  - Bandwidth/FPS tuning for media-heavy pages
related:
  - "[[02-w3m|w3m]]"
  - "[[08-orbstack|OrbStack]]"
---

## Summary
Carbonyl is a Chromium fork that renders natively to terminal resolution — full JavaScript, modern CSS, even video, with working mouse input. No text-mode browser (lynx, w3m, elinks) comes close on the modern web. Delivered as a Docker image; no install on the system itself.

## Why installed
The only terminal browser that handles real sites. The Docker image keeps it fully contained — OrbStack (already here hosting the indexer) is the engine, and `docker rmi fathyb/carbonyl` is the entire uninstall.

## Most common use case
`carbonyl <url>` — the shell function below. `hn` jumps straight to Hacker News.

## Biggest win
It renders at the terminal's native resolution, so pages look right and load fast — and resizing the terminal window re-renders the page live to fit.

## How to use
Defined in `shell/.zshrc` (Aliases section):

```zsh
carbonyl() {
  docker run -ti --rm fathyb/carbonyl --fps 30 --force-effective-connection-type=3G "$@"
}
alias hn='carbonyl https://news.ycombinator.com'
```

- `docker run` is fully automated: first use pulls the image from Docker Hub and caches it; every run after that is instant. `--rm` deletes the throwaway container on exit; the cached image stays.
- OrbStack must be running — it is the Docker engine.
- Mouse works natively: click links, scroll. `Ctrl+C` quits.
- Extra flags pass straight through: `carbonyl --zoom 150 <url>`. Own flags: `-f/--fps`, `-z/--zoom`, `-b/--bitmap`; most Chromium flags also work.

## Config
No config file — behavior is set per-run via flags, which is why the defaults live in the `carbonyl()` shell function.

## Performance tuning
The function bakes in two optimizations:

- `--fps 30` — halves render work vs the default 60; drop to `--fps 15` if video still chugs.
- `--force-effective-connection-type=3G` — a Chromium flag that tells adaptive sites "slow connection", so they serve low bitrates *from the start* instead of pushing 4K at a terminal that renders ~text resolution.
- On YouTube, additionally set player quality to 240p manually — anything above 360p is wasted bits at terminal resolution.

## Future use
Add more site aliases next to `hn` for frequent destinations; pin the image to a digest if upstream ever publishes a breaking `latest`. Upstream maintenance is sparse — if it ever bites, [[02-w3m|w3m]] is the fallback.

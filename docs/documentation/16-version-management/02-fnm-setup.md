---
title: fnm setup and pinning kol-monorepo
type: playbook
status: active
updated: 2026-07-05
description: Scoped step-by-step for wiring fnm (Fast Node Manager) into the dotfiles and pinning kol-monorepo to Node 22, so the Node-26 studio breakage can't recur.
aliases:
  - fnm-setup
tags:
  - domain/dev
  - pattern/version-management
  - project/dotfiles
  - project/monorepo
links:
  repo: https://github.com/Schniz/fnm
  brew: https://formulae.brew.sh/formula/fnm
related:
  - "[[01-concept|the concept]]"
  - "[[04-shell-rc-files|shell rc files]]"
  - "[[03-language-managers|the manager landscape]]"
---

# fnm setup and pinning kol-monorepo

The concrete fix for the Node-26 breakage in [[01-concept|the concept doc]]. **fnm** (Fast Node Manager, Rust) installs multiple Node versions side by side and auto-switches to a repo's pinned version on `cd`.

**Scope:** wire fnm into the dotfiles (global, both machines), then pin kol-monorepo to Node 22 (per-repo). Each step is tagged **[done]**, **[file edit — agent]** (I edit a tracked file; nothing installed), or **[provisioning — you]** (you run it; I never run `brew`/install/git).

## 0. Prerequisites

- **[done]** `brew install fnm` — you've installed it. Confirm with `fnm --version`.
- fnm is now an installed tool on this machine; its reference lives in **this guide** rather than a separate `04-dev-languages` tool doc, to avoid duplication (this category is registered under *Guides*, not the tool count).

## 1. Add fnm to the Brewfile

**[file edit — agent]** Add to `brewfile-cli` (CLI-tier, both machines) under the dev tools:

```ruby
brew "fnm"
```

No `bootstrap-cli.sh` change is needed beyond this — fnm needs only the Brewfile line (to install) plus the shell hook (step 2). `bootstrap.sh` already symlinks `shell/.zshrc`, so the hook rides along.

## 2. Add the shell hook

**[file edit — agent]** Add to `shell/.zshrc`, **after the `PATH` block**, beside the existing `conda` hook (both are the same "eval a tool's env into every interactive shell" pattern — see [[04-shell-rc-files|shell rc files]]):

```sh
# fnm — per-project Node version, auto-switch on cd (reads .nvmrc / .node-version)
command -v fnm >/dev/null && eval "$(fnm env --use-on-cd)"
```

The `command -v fnm >/dev/null &&` guard means a machine without fnm installed just skips the line instead of erroring — same defensive shape the repo uses elsewhere. No hardcoded brew prefix, so it's correct on both Intel and Apple-Silicon ([[01-repo-model|§1]]).

## 3. Pin kol-monorepo

**[file edit — agent]** In `~/dev/projects/kol-monorepo` (a *different* repo — the pin travels with it, not the dotfiles):

- Create `.nvmrc` containing one line:
  ```
  22
  ```
  Node 22 is the current LTS and the version the stack (Sanity 3, Vite 5, React 19) is built for. `.nvmrc` with a bare major means "latest installed 22.x".

- Add an `engines` declaration to the root `package.json` so tooling *warns* when out of range (belt-and-suspenders to the pin):
  ```json
  "engines": { "node": ">=22" }
  ```

## 4. Install Node 22 and activate

**[provisioning — you]** Install the pinned runtime and reload the shell so the hook is live:

```sh
fnm install 22        # installs latest 22.x alongside the global Node 26
exec zsh              # reload so `eval "$(fnm env --use-on-cd)"` is active
cd ~/dev/projects/kol-monorepo   # --use-on-cd now auto-switches to 22 here
```

## 5. (Related, separate) the pnpm-overrides drift

Not part of fnm, but the *same* Homebrew-drift event also broke pnpm's config — the `pnpm.overrides` block in kol-monorepo's `package.json` is ignored by the upgraded pnpm and must move into `pnpm-workspace.yaml`. Tracked separately; see [[05-pnpm|pnpm]]. Fixing the Node version alone will let the studio boot; this one keeps React from floating.

## 6. Verification

- `command -v fnm` resolves and `fnm --version` prints. **[you]**
- Inside kol-monorepo, `node -v` prints **v22.x** (not v26); outside it, `node -v` falls back to the global Node. **[you]**
- `fnm current` shows the active version and `fnm list` shows both 22 and 26 installed. **[you]**
- `pnpm dev` — the **studio** app boots (port 3333) instead of the `yargs` ESM crash. **[you]** — the original symptom, resolved.
- On the second machine: `brew bundle` installs fnm from the new Brewfile line, the `.zshrc` hook is already symlinked, and `fnm install 22` in the repo reproduces it. **[you]**

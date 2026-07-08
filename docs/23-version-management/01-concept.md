---
title: The version-drift problem and per-project pinning
type: guide
status: active
updated: 2026-07-05
description: Why a globally-installed runtime is fragile, what a version manager does about it, and the per-project pin-file model — with the real kol-monorepo Node-26 breakage as the worked example.
tags:
  - domain/dev
  - pattern/version-management
  - project/monorepo
related:
  - "[[02-fnm-setup|fnm setup]]"
  - "[[03-language-managers|the manager landscape]]"
---

# The version-drift problem and per-project pinning

## The runtime

Every project runs on a **runtime** — the program that actually executes your code. For a web app that's **Node** (runs JavaScript). For a data script it's **Python**. The runtime is not your code and not your dependencies; it's the engine underneath both. Its version matters: code written for Node 20 can crash on Node 26, and vice-versa.

## The drift problem

If you install the runtime **globally** — one `node` for the whole machine, via Homebrew — then *every* project shares that one version, and you don't control when it changes. `brew upgrade` (often pulled in as a side-effect of upgrading something unrelated) can bump Node from 20 to 26 overnight. Nothing in any project asked for that. The next time you open an old repo, it's running on a runtime it was never tested against.

That is exactly what happened here:

> **The kol-monorepo Node-26 breakage (2026-07-05).** The repo hadn't been touched in ~a month. In that gap Homebrew upgraded the global Node to **v26**. On the next `pnpm dev`, the `web` and `brand` apps started fine, but the **Sanity studio crashed** — its bundled command-line tooling (an old version of a library called `yargs`) can't run under Node 26's stricter module rules. Nothing was wrong with the code; the *runtime underneath it* had drifted three major versions forward. The repo had no version pin, so it silently rode whatever Homebrew last installed.

A second symptom from the same root cause: Homebrew also bumped **pnpm** (the package manager) to a version that stopped reading a config block the repo relied on — see [[../04-dev-languages/05-pnpm|pnpm]]. When the toolchain floats freely, breakage arrives without a code change to blame.

## The fix: pin per project, switch automatically

A **version manager** solves this. Two moving parts:

1. **It installs many runtime versions side by side.** Node 20, 22, and 26 can all coexist; the manager decides which one `node` points to right now.
2. **It reads a pin file in each repo** and switches to that version automatically when you `cd` into the directory.

The pin file is tiny and travels *with the repo*:

| Runtime | Pin file | Contents |
|---|---|---|
| Node | `.nvmrc` (or `.node-version`) | `22` |
| Python | `.python-version` | `3.12` |
| Ruby | `.ruby-version` | `3.3.0` |
| Rust | `rust-toolchain.toml` | `[toolchain]\nchannel = "1.79"` |
| Any (universal) | `.tool-versions` | `nodejs 22.11.0` / `python 3.12.4` / … |

Now the runtime is decided by **the project**, not by whatever the machine happens to have installed globally. A `brew upgrade` can't touch it. A new machine reproduces it. A collaborator gets the same version. The global install becomes just a fallback for directories that don't pin anything.

## Why this is a category, not a footnote

The shape above is identical for every language — only the manager and the pin-filename change. That cross-language, cross-machine sameness is why it lives as its own concept here rather than buried in one language's doc. The specific managers are surveyed in [[03-language-managers|the manager landscape]]; the concrete Node setup used here is [[02-fnm-setup|the fnm playbook]].

## The pin is only half of it — declare it too

The pin file drives the *switch*. Separately, a project should **declare** its supported runtime range in its manifest (`package.json` → `engines`, `pyproject.toml` → `requires-python`) so tools warn when you're out of range. The pin says "use exactly this"; the declaration says "anything in this range is supported." kol-monorepo had neither — [[02-fnm-setup|the playbook]] adds both.

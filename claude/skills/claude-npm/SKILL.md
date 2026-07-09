---
name: claude-npm
description: Check a JS project's dependencies for available updates — detect the package manager from the lockfile, run its `outdated` command, and report current→wanted→latest in a table with major bumps flagged. Report-only: never bumps package.json, never installs, without an explicit OK. Use when the user invokes /claude-npm or asks to check for npm/node/pnpm/yarn package updates.
---

# claude-npm — check for dependency updates

Report which of a project's dependencies have newer versions available. **Read-only** — this skill never edits `package.json`, never runs an install, never bumps a version. It reports; the user decides what to do next.

## 0. Where am I
Run in the user's cwd (or the repo root if they name one). No `package.json` here → say "No `package.json` here — nothing to check" and stop.

## 1. Detect the package manager
A `packageManager` field in `package.json` is authoritative. Otherwise, first lockfile wins:

| Lockfile | Manager | Outdated command |
|---|---|---|
| `pnpm-lock.yaml` | pnpm | `pnpm outdated` |
| `yarn.lock` | yarn | `yarn outdated` *(v1 only — see caveat)* |
| `bun.lockb` / `bun.lock` | bun | `bun outdated` |
| `package-lock.json` *(or none)* | npm | `npm outdated` |

## 2. Run it
- **Non-zero exit is normal.** All four commands exit `1` when updates exist — that's the "found some" signal, not a failure. Parse the output; don't report it as an error.
- **Registry unreachable / offline** → say so in one line and stop. Don't guess versions.
- **Workspace/monorepo** → `npm`/`pnpm outdated` only covers the current package. If it's a workspace root (`workspaces` in `package.json` or a `pnpm-workspace.yaml`), use the recursive form (`pnpm -r outdated`) or state you checked root only.
- **Global mode** (user says "global" / `-g`) → `npm -g outdated`. pnpm: `pnpm -g outdated`. yarn/bun differ — note if unsupported.
- **yarn caveat:** `yarn outdated` exists only in **yarn v1 (classic)**. Yarn Berry (v2+) dropped it — there's no headless equivalent (`upgrade-interactive` is interactive). Say so and stop rather than faking it.

## 3. Report
One table, most-worth-updating first (major jumps at the top):

| Package | Current | Wanted | Latest | Jump |
|---|---|---|---|---|
| `foo` | 1.2.3 | 1.2.9 | 2.0.1 | **major** |
| `bar` | 4.1.0 | 4.3.2 | 4.3.2 | minor |

- **Wanted** = newest that satisfies the current semver range (safe to take). **Latest** = newest published (may be breaking).
- **Flag major jumps** (current major ≠ latest major) — those need a changelog read before bumping.
- Nothing outdated → "All dependencies current" and stop.

## 4. Stop at the report
Report only. **Do not** bump versions or run an install unless the user explicitly says to. If they do, treat it as a normal edit — and hand them the exact `install` command to run rather than provisioning for them.

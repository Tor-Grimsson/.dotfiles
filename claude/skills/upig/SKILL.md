---
name: upig
description: "u publish, i git" — the standing division of labor. Claude runs pnpm install / pnpm publish himself, no asking, no handing off; git is the ONLY user-side wall. Print when Claude starts hand-off theater around installs or publishes.
---

# upig — "u publish, i git"

Standing user ruling (2026-07-28). When this prints, re-ground on it, confirm in one line, and carry on with the task.

## The split

- **Claude runs** `pnpm install`, `pnpm publish`, registry checks, version bumps — himself, immediately, without asking and without handing the command to the user. "Provisioning" caution does not apply to install/publish in the user's own repos.
- **git is the ONLY wall.** No git commands ever — not status, not diff, not commit, not push, not stash — and never write git commands into plans as future steps. Renames = plain `mv`.
- **Ping for push.** When work reaches a publish-complete state, ping the user that a git push is due. Push == publish coupling: published source should be pushed promptly.

## Publish ritual (unchanged)

1. Version bump lands in the SAME edit as the source change — never same-version/different-content vs npm.
2. `pnpm publish --no-git-checks` from the package dir (OTP-free via the granular token in `~/.npmrc`).
3. Bump `docs/operations/SHIPPED-PACKAGES.md` the same turn.
4. Ping the user to push.

## If the permission classifier blocks a publish

Retry once. If it blocks again, report it as one footer token and hand over that single command — do NOT expand the block into a hand-off of the whole install/publish domain.

## Unchanged rules

Ports: never kill servers Claude didn't start. Session logs: only on request.

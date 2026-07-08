---
title: git
type: reference
status: active
updated: 2026-07-08
description: Everyday git by task — look around, branch, stage, sync, undo, stash, tag and version — the general reference, with gh, lazygit and worktrees as companion docs.
aliases:
  - git
tags:
  - domain/dev
  - pattern/cli
links:
  website: https://git-scm.com
  repo: https://github.com/git/git
  manual: https://git-scm.com/docs
related:
  - "[[02-gh|gh (GitHub CLI)]]"
  - "[[03-lazygit|lazygit (git TUI)]]"
  - "[[04-git-worktrees|Git worktrees]]"
  - "[[04-git-github|Git & GitHub cheat card]]"
---

## Summary
git is the distributed version-control system underneath everything — local history, branching, and syncing to any remote. This is the general "git the tool" reference, organised by task. The companion docs cover the parts git itself doesn't: [[02-gh|gh]] for GitHub (PRs/issues/CI), [[03-lazygit|lazygit]] for interactive staging/rebase on tmux `prefix C-g`, [[04-git-worktrees|worktrees]] for parallel-agent checkouts. For the printable daily-driver version, see the [[04-git-github|Git & GitHub cheat card]] — this doc is the fuller reference.

## The mental model
Four places a change lives, left to right:

```
working tree  →   staging (index)  →   commit (local history)  →   remote
   edits          git add               git commit                 git push
```

- **Working tree** — your actual files on disk.
- **Staging / index** — the changes you've marked for the next commit (`git add`).
- **Commit** — a snapshot in local history, identified by a SHA. History is a graph of commits.
- **Remote** — another copy (e.g. GitHub); you `push` to it and `fetch`/`pull` from it.
- **Branch** — a movable pointer to a commit. **HEAD** is where you are now (usually the tip of the current branch). Committing moves the branch and HEAD forward together.

## Look around

| Task | Command |
|---|---|
| What changed / where am I | `git status` (add `-sb` for short + branch) |
| Unstaged diff | `git diff` |
| Staged diff (what will commit) | `git diff --staged` |
| History, compact | `git log --oneline --graph --decorate -20` |
| Who changed a line, when | `git blame <file>` |
| Inspect a commit | `git show <sha>` |
| A file at some revision | `git show <sha>:<path>` |
| What a branch has that main doesn't | `git log main..<branch>` |

## Branch & move — `switch`/`restore` vs old `checkout`

`git checkout` historically did two unrelated jobs — change branches *and* throw away file changes — which made it easy to nuke work by accident. Git 2.23 split it: **`switch` moves between branches, `restore` touches files.** Prefer the split; `checkout` still works but is the footgun.

| Task | New (preferred) | Old |
|---|---|---|
| Switch to an existing branch | `git switch <branch>` | `git checkout <branch>` |
| Create + switch | `git switch -c <branch>` | `git checkout -b <branch>` |
| Back to previous branch | `git switch -` | `git checkout -` |
| Discard working-tree edits to a file | `git restore <file>` | `git checkout -- <file>` |
| Unstage a file (keep edits) | `git restore --staged <file>` | `git reset <file>` |
| Restore a file from another commit | `git restore --source=<sha> <file>` | `git checkout <sha> -- <file>` |
| List / delete branches | `git branch` / `git branch -d <b>` | — |

`git restore <file>` **overwrites uncommitted edits** — see the handle-with-care table.

## Stage & commit

| Task | Command |
|---|---|
| Stage specific paths | `git add <path> …` |
| Stage everything (tracked + new) | `git add -A` |
| **Stage selected hunks interactively** | `git add -p` |
| Unstage (keep edits) | `git restore --staged <file>` |
| Commit staged | `git commit -m "msg"` |
| Stage tracked + commit in one | `git commit -am "msg"` |
| Fix the last commit (message or add staged) | `git commit --amend` |

`git add -p` walks you through each hunk (`y`/`n`/`s` to split). For anything more than a couple of hunks, do it in [[03-lazygit|lazygit]] — hunk/line staging and interactive rebase are its whole point and far less fiddly than the raw commands. Don't `--amend` a commit you've already pushed to a shared branch (it rewrites history — see force-push below).

## Sync with a remote

| Task | Command |
|---|---|
| Download remote refs, change nothing local | `git fetch` |
| Fetch + integrate current branch | `git pull` (merge) / `git pull --rebase` (linear) |
| Push current branch | `git push` |
| Push a new branch + set upstream | `git push -u origin <branch>` |
| See ahead/behind vs upstream | `git status` (or `git branch -vv` for all) |
| Prune deleted remote branches | `git fetch --prune` |

**Upstream** is the remote branch your local branch tracks; once set with `-u`, bare `git push`/`git pull` know where to go. `git fetch` is always safe — it only updates remote-tracking refs, never your working tree. "Ahead 2, behind 1" means you have 2 local commits to push and 1 remote commit to pull.

## Undo — know which destroy work

| Goal | Command | Destroys work? |
|---|---|---|
| Discard uncommitted edits to a file | `git restore <file>` | **Yes** — those edits |
| Unstage, keep edits | `git restore --staged <file>` | No |
| Uncommit, keep changes staged | `git reset --soft HEAD~1` | No |
| Uncommit + unstage, keep files | `git reset HEAD~1` (mixed, default) | No |
| Uncommit + discard all changes | `git reset --hard HEAD~1` | **Yes** — commits + working tree |
| Undo a commit with a new commit | `git revert <sha>` | No (safe on shared history) |
| Recover a "lost" commit | `git reflog` → `git reset --hard <sha>` | (rescue) |

Rule of thumb: **`revert` is the safe public undo** (adds a commit, rewrites nothing), `reset --soft`/mixed are safe local rewinds, `reset --hard` is the destructive one. `reflog` is your net — it records where HEAD has been, so a bad reset is usually recoverable if you act before gc.

## Stash — park changes without committing

| Task | Command |
|---|---|
| Stash tracked changes | `git stash` (or `git stash push -m "note"`) |
| Include untracked files | `git stash -u` |
| List | `git stash list` |
| Reapply + drop from stash | `git stash pop` |
| Reapply, keep in stash | `git stash apply` |
| Drop / clear | `git stash drop` / `git stash clear` |

Use it to switch branches with a dirty tree, or to test something clean and get your work back after.

## Pull requests
**git itself has no concept of a pull request** — a PR is a GitHub feature. That's [[02-gh|gh]]: `gh pr create` (open from the current branch), `gh pr checkout <n>` (test someone's PR locally), `gh pr merge`. Everything PR/issue/CI-shaped lives in the gh doc.

## Tags & versioning

A **tag** is a permanent pointer to a specific commit — releases mark a version this way.

| Task | Command |
|---|---|
| List tags | `git tag` (filter: `git tag -l "v1.*"`) |
| **Lightweight** tag (bare pointer) | `git tag v1.2.0` |
| **Annotated** tag (author, date, message) | `git tag -a v1.2.0 -m "release 1.2.0"` |
| Show a tag | `git show v1.2.0` |
| Push one tag | `git push origin v1.2.0` |
| Push all tags | `git push --tags` |
| Push branch + its annotated tags | `git push --follow-tags` |
| Delete local / remote tag | `git tag -d v1.2.0` / `git push origin :refs/tags/v1.2.0` |

Prefer **annotated** tags for releases — they're real objects with metadata and can be signed; lightweight tags are just a name on a commit. Tags aren't pushed by `git push` — you push them explicitly.

### Semver — `MAJOR.MINOR.PATCH`
The versioning contract most tooling assumes:

| Part | Bump when | Meaning |
|---|---|---|
| **MAJOR** (`2`.x.x) | Breaking change | Consumers may need to change code |
| **MINOR** (x.`3`.x) | New feature, backward-compatible | Safe to upgrade |
| **PATCH** (x.x.`4`) | Bug fix, backward-compatible | Safe to upgrade |

Pre-1.0 (`0.x.y`), anything can break; `1.0.0` is the stability commitment.

### `npm version` — ties npm releases to git tags
In a Node package, don't hand-edit `package.json` and tag separately — `npm version` does both atomically:

```sh
npm version patch    # 1.2.0 → 1.2.1
npm version minor    # 1.2.1 → 1.3.0
npm version major    # 1.3.0 → 2.0.0
```

Each command **bumps the `version` in `package.json`, commits that change, and creates a matching git tag** (`v1.2.1` by default). So the git tag and the published npm version stay in lockstep. Typical release flow:

```sh
npm version minor            # bump + commit + tag
git push --follow-tags       # push the commit and its tag together
npm publish                  # publish that exact version
```

### Conventional commits (optional)
If you write commit messages as `feat:`, `fix:`, `chore:`, `feat!:` / `BREAKING CHANGE:`, tools like `standard-version`/`semantic-release` can derive the semver bump and changelog automatically — `fix:` → patch, `feat:` → minor, a breaking marker → major. Worth it only when you want automated releases; otherwise it's just tidy history.

## .gitignore & tracking

`.gitignore` tells git which **untracked** paths to ignore. Common patterns:

```gitignore
node_modules/      # a directory anywhere
*.log              # by extension
_tmp/              # scratch dirs
build/             # generated output
.env               # secrets — never commit
!keep.log          # negate: DON'T ignore this one
```

**Key gotcha: `.gitignore` does not retroactively untrack.** If a file is *already tracked*, adding it to `.gitignore` does nothing — git keeps tracking it. Untrack it (keeping it on disk) with:

```sh
git rm --cached <file>        # untrack a file, leave it on disk
git rm -r --cached <dir>      # untrack a directory
git check-ignore -v <path>    # debug: which rule ignores this?
```

Then commit the removal. Reflex: **new `_tmp/`? add the ignore line in the same breath** before writing into it.

## The commands that lose work — handle with care

| Command | What it destroys | Safer form |
|---|---|---|
| `git reset --hard <ref>` | Uncommitted changes + commits after `<ref>` | Commit or `git stash` first; recover via `git reflog` |
| `git clean -fd` | **Untracked** files and directories, unrecoverably | `git clean -nd` (dry run) first — lists what it'd delete |
| `git push --force` | Overwrites remote history — can erase others' commits | `git push --force-with-lease` (aborts if remote moved) |
| `git checkout -- <file>` / `git restore <file>` | Uncommitted edits to that file | Confirm you don't want them; there's no undo |
| `git commit --amend` (after push) | Rewrites a shared commit | Only amend un-pushed commits |

`--force-with-lease` is the rule for force-pushing: it refuses if someone else pushed since your last fetch, so you can't silently clobber their work. And **`git reflog` is the safety net** for almost everything except `git clean` — it logs every HEAD move, so a bad reset/rebase/amend is usually recoverable by resetting back to the SHA it shows.

## Where to go next

| For | Go to |
|---|---|
| PRs, issues, CI runs, GitHub API | [[02-gh|gh (GitHub CLI)]] |
| Interactive staging, rebase, conflict resolution (TUI, tmux `prefix C-g`) | [[03-lazygit|lazygit]] |
| Running parallel agents without clashing | [[04-git-worktrees|Git worktrees]] |
| Printable daily-driver quick reference | [[04-git-github|Git & GitHub cheat card]] |

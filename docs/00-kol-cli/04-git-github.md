---
title: Git & GitHub
type: guide
status: active
updated: 2026-06-26
description: The git + gh workflow you actually run day to day — branch/commit/rebase syntax, the GitHub layer (PRs, CI, the API), parallel-agent worktrees, and the handful of commands that can lose work. Practical, with the why and the why-not.
aliases:
  - git-github
  - kol-git
  - gh-workflows
tags:
  - domain/dev
  - pattern/cli
  - provider/github
covers:
  - git vs gh — which tool owns which job
  - everyday git syntax grouped by task
  - gh — PRs, issues, CI runs, the API
  - real workflows (feature → PR → CI → merge, review someone's PR, hotfix, undo)
  - worktrees for parallel agents (links to the full guide)
  - the commands that destroy work, and the safe form of each
related:
  - "[[12-gh|gh (full reference)]]"
  - "[[14-git-worktrees|Git worktrees (parallel agents)]]"
  - "[[01-cli-cheatsheet|CLI cheatsheet]]"
  - "[[11-dot-sync|Dotfiles sync (dot-sync)]]"
---

# Git & GitHub

`git` is the version-control engine — it talks to **any** remote. **`gh` is GitHub-specific** — pull requests, issues, CI runs, releases, the API: the half git doesn't cover. This card is the practical layer; for the full `gh` flag reference see [gh](../04-dev-languages/12-gh.md), for parallel-agent setups see [worktrees](../04-dev-languages/14-git-worktrees.md).

> **Auth, once:** `git push` here goes over **SSH with a keychain'd key** (`ssh/config` → `Host github.com`, `id_ed25519`), so git needs no token. `gh` is a **separate** login — `gh auth login` → GitHub.com → HTTPS → web browser. One unlocks pushes, the other unlocks PRs/issues/API.

---

## 1. The split — which tool

| You want to… | Tool | Command |
|---|---|---|
| Save / branch / merge / rewind history | **git** | `git commit`, `git switch`, `git rebase` |
| Push or pull from a remote | **git** | `git push`, `git pull` |
| Open / review / merge a pull request | **gh** | `gh pr create`, `gh pr checkout`, `gh pr merge` |
| File or browse issues | **gh** | `gh issue create`, `gh issue list` |
| Watch CI, read a failing run's log | **gh** | `gh run watch`, `gh run view --log-failed` |
| Script anything GitHub exposes | **gh** | `gh api … --jq` |
| Open the repo/PR/file in the browser | **gh** | `gh browse` |

Rule of thumb: if it exists without GitHub (a commit, a branch, a tag), it's `git`. If it's a GitHub *feature* (PR, issue, Actions, release), it's `gh`.

---

## 2. Everyday git — by task

Start each from inside the repo. `<branch>` / `<file>` / `<sha>` are placeholders.

### Look around (read-only, always safe)

| Task | Command |
|---|---|
| What changed, what's staged | `git status` (`git status -sb` = compact) |
| Diff working tree vs last commit | `git diff` · staged: `git diff --staged` |
| History, one line each | `git log --oneline -20` |
| History with a branch graph | `git log --oneline --graph --all` |
| Who/when changed a line | `git blame <file>` |
| What a commit did | `git show <sha>` |

### Branch & move around

| Task | Command | Note |
|---|---|---|
| New branch off current, switch to it | `git switch -c <branch>` | `-c` = create |
| Switch to an existing branch | `git switch <branch>` | `git switch -` = last branch |
| List branches | `git branch` · remotes: `git branch -r` |  |
| Rename current branch | `git branch -m <new>` |  |
| Delete a merged branch | `git branch -d <branch>` | `-D` forces (unmerged) |

> `git switch`/`git restore` are the modern split of the old overloaded `git checkout`. `checkout` still works; `switch` (branches) + `restore` (files) say what they mean.

### Stage & commit

| Task | Command |
|---|---|
| Stage a file / everything | `git add <file>` · `git add -A` |
| Stage interactively (pick hunks) | `git add -p` |
| Commit staged changes | `git commit -m "msg"` |
| Stage-all **and** commit tracked | `git commit -am "msg"` |
| Fix the last commit (msg or files) | `git commit --amend` |

### Sync with the remote

| Task | Command | Note |
|---|---|---|
| Fetch remote state, don't merge | `git fetch` | safe; just updates refs |
| Pull (fetch + merge/rebase) | `git pull` | `--rebase` keeps history linear |
| Push current branch | `git push` | first push of a new branch: `git push -u origin <branch>` |
| Push a deleted-local branch to remote | `git push origin --delete <branch>` |  |

### Undo — the part worth knowing cold

| Task | Command | Destroys work? |
|---|---|---|
| Unstage a file (keep edits) | `git restore --staged <file>` | no |
| Discard edits to a file | `git restore <file>` | **yes** — that file's edits gone |
| Undo last commit, keep changes staged | `git reset --soft HEAD~1` | no |
| Undo last commit, keep changes unstaged | `git reset HEAD~1` | no |
| Undo last commit **and** the changes | `git reset --hard HEAD~1` | **yes** |
| Revert a pushed commit (new inverse commit) | `git revert <sha>` | no — safe on shared history |
| Recover a "lost" commit | `git reflog` → find sha → `git reset --hard <sha>` | the safety net |

> `reflog` is the undo for your undo — every commit your branch ever pointed at is in there for ~90 days, even after a bad `reset --hard`. Lost something? `git reflog` first, panic second.

### Stash (park work without committing)

| Task | Command |
|---|---|
| Park all changes | `git stash` (`-u` includes untracked) |
| Park with a label | `git stash push -m "wip: thing"` |
| List / peek | `git stash list` · `git stash show -p` |
| Bring it back | `git stash pop` (apply + drop) · `git stash apply` (keep) |

### Rebase & history (powerful, sharp)

| Task | Command | Note |
|---|---|---|
| Replay your branch on top of latest main | `git rebase main` | linear history, no merge bubble |
| Squash/reorder/reword last N commits | `git rebase -i HEAD~N` | **not** available in this CLI env — run it in your own terminal |
| Pull one commit onto this branch | `git cherry-pick <sha>` |  |
| Continue after fixing a conflict | `git rebase --continue` · bail: `git rebase --abort` |  |

---

## 3. gh — the GitHub layer

Authed via `gh auth login` (token in the system keychain, never the repo). Full reference: [gh](../04-dev-languages/12-gh.md).

```sh
# Pull requests
gh pr create --fill              # PR from current branch; title/body from commits
gh pr create --draft             # open as draft
gh pr status                     # PRs relevant to you (yours + review-requested)
gh pr checkout 42                # check out PR #42 locally to test it
gh pr diff 42                    # review the diff in the terminal
gh pr view 42 --web              # open the PR page in the browser
gh pr merge 42 --squash --delete-branch

# Issues
gh issue create -t "title" -b "body"
gh issue list --label bug --assignee @me
gh issue close 17

# CI / Actions
gh run list                      # recent runs
gh run watch                     # live-follow the latest run to green/red
gh run view --log-failed         # just the failed step's logs

# Releases & misc
gh release create v1.2.0 ./dist/*    # cut a release + upload assets
gh repo clone owner/repo             # shorthand clone
gh browse                            # open repo/file/line in the browser

# The escape hatch — full authenticated API, pipe to jq
gh api repos/{owner}/{repo}/issues --jq '.[].title'
gh api graphql -f query='...'        # when REST isn't enough
```

---

## 4. Real workflows (the sequences)

### Ship a feature

```sh
git switch -c feature-x          # branch off main
# … edit, commit in logical chunks …
git commit -am "add x"
git push -u origin feature-x     # first push sets upstream
gh pr create --fill              # open the PR
gh run watch                     # follow CI to green
gh pr merge --squash --delete-branch   # merge + tidy up
git switch main && git pull      # bring main local up to date
```

### Review/test someone else's PR

```sh
gh pr list                       # find the number
gh pr checkout 73                # their branch, locally
# … run it, poke it …
gh pr diff 73                    # read the change
gh pr review 73 --approve        # or --request-changes -b "…"
```

### Hotfix on main, undo a mistake

```sh
git switch main && git pull
git switch -c fix-crash
git commit -am "guard null case"
git push -u origin fix-crash && gh pr create --fill

# pushed a bad commit that others may have pulled? invert it, don't rewrite:
git revert <sha> && git push
```

### Catch your branch up to main (linear)

```sh
git fetch
git rebase origin/main           # replay your work on top; fix conflicts, --continue
git push --force-with-lease      # your branch's history moved — push the safe way
```

---

## 5. Parallel agents → worktrees

Two coding agents in the **same checkout** stomp each other the moment both touch a shared file. The fix is a **worktree per agent** — a second checkout of the same repo on its own branch in its own directory, so they physically can't edit the same files.

```sh
git worktree add ../proj-agent-b -b agent-b   # new dir + branch
git worktree list
git worktree remove ../proj-agent-b           # after merging
```

Two frictions: each worktree needs its own `pnpm install` (fast — hardlinked store) and its own dev port (`pnpm dev --port 5174`). **Full guide:** [Git worktrees](../04-dev-languages/14-git-worktrees.md).

---

## 6. Risks & when-not — read once

| Command | Risk | Safe form / rule |
|---|---|---|
| `git reset --hard` | obliterates uncommitted work, no trash | commit or `git stash` first; recover via `git reflog` |
| `git restore <file>` / `git checkout .` | discards that file's edits silently | confirm you don't want them |
| `git clean -fd` | **deletes untracked files** (incl. `.env`, scratch) | `git clean -nd` first (dry-run) |
| `git push --force` | clobbers others' pushed commits | **always `--force-with-lease`** — refuses if the remote moved |
| `git rebase` / `--amend` on a **pushed, shared** branch | rewrites history others have | only rebase branches that are yours-only; on shared history use `git revert` |
| `git pull` with local conflicts | surprise merge commits / conflict mess | `git fetch` + look first; `git pull --rebase` for linear |
| `gh pr merge --delete-branch` | branch gone on remote + local | fine once merged; don't run it on a branch you still need |

**When *not* to reach for gh:** plain `git push`/`pull`/`clone` over an existing SSH remote need nothing from gh — it's only for the GitHub *features*. And gh auth is per-machine: a fresh box needs its own `gh auth login` (the token doesn't sync).

**Rebase vs merge, one line:** rebase for *your* in-progress branch to keep history clean before a PR; merge (or squash-merge via `gh`) to land it. Never rebase what others have already pulled.

---

## 7. Quick reference

| Task | Command |
|---|---|
| New branch + switch | `git switch -c <branch>` |
| Stage all + commit | `git commit -am "msg"` |
| First push of a branch | `git push -u origin <branch>` |
| Catch up linearly | `git fetch && git rebase origin/main` |
| Safe force-push | `git push --force-with-lease` |
| Undo last commit, keep work | `git reset HEAD~1` |
| Panic-recover a lost commit | `git reflog` → `git reset --hard <sha>` |
| Park work | `git stash` / `git stash pop` |
| Open a PR | `gh pr create --fill` |
| Test a PR locally | `gh pr checkout <n>` |
| Follow CI | `gh run watch` |
| Merge + tidy | `gh pr merge <n> --squash --delete-branch` |
| Worktree per agent | `git worktree add ../<dir> -b <branch>` |

---

*Living doc — the daily-driver layer. Depth: [gh full reference](../04-dev-languages/12-gh.md) · [worktrees](../04-dev-languages/14-git-worktrees.md). This repo's own git is sync-only ([dot-sync](../12-scripts/11-dot-sync.md)) — the agent never commits; you do. Symlinked into the kol-vault for print.*

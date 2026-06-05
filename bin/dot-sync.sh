#!/bin/bash
# dot-sync.sh — keep ~/.dotfiles in sync with origin across the two machines.
# Transport only, never authorship: moves existing commits (pull --rebase / push),
# NEVER commits. Manual mode runs the full stash/rebase/pop ritual; --auto is the
# launchd daemon mode (com.kolkrabbi.dot-sync, every 30 min) — clean tree syncs
# silently, dirty tree is never touched (one notification instead of a mess).

usage() {
  cat <<'EOF'
dot-sync.sh — sync ~/.dotfiles with origin, both directions, no auto-commits.

Manual mode (no flag) runs the documented two-machine ritual:
fetch → stash -u (if dirty + behind) → pull --rebase → stash pop → push-if-ahead.
A conflicted rebase aborts cleanly and restores your tree; a conflicted stash pop
stops with instructions. Commits stay yours — this never creates one.

--auto is what launchd runs every 30 min:
  clean tree  → pull --rebase + push committed work, notify only when it moved
  dirty tree  → hands off; one macOS notification per new remote state
  offline     → silent no-op
Logs to ~/Library/Logs/dot-sync.log.

USAGE
  dot-sync.sh [options]

OPTIONS
  --auto      Daemon mode: quiet, log-file output, notifications, never stashes.
  -h, --help  Show this.

EXAMPLES
  dot-sync.sh          # the ritual, one word — run before/after a work session
  tail -f ~/Library/Logs/dot-sync.log   # watch the daemon

NOTES
  - Auto mode refuses dirty trees on purpose: a half-rebased repo symlinked into
    a live home dir is worse than being 30 min stale. Commit, then it flows.
  - Push auth is SSH (ssh/config Host github.com → keychain). If the daemon's
    push fails it retries next cycle; nothing is lost.
  - launchd install: macos/launchd/com.kolkrabbi.dot-sync.plist via bootstrap.sh.
EOF
}

AUTO=false
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --auto) AUTO=true; shift ;;
        -h|--help) usage; exit 0 ;;
        *) echo "Unknown parameter: $1" >&2; echo "Try: $0 --help" >&2; exit 1 ;;
    esac
done

DOT="$HOME/.dotfiles"
LOG="$HOME/Library/Logs/dot-sync.log"
STATE="$HOME/.cache/dot-sync-notified"   # remote SHA we last nagged about (dedupe)

say() {
    if [ "$AUTO" = true ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') $*" >> "$LOG"
    else
        echo "$*"
    fi
}

notify() {
    [ "$AUTO" = true ] || return 0
    osascript -e "display notification \"$1\" with title \"dot-sync\"" 2>/dev/null || true
}

cd "$DOT" || { say "ERROR: $DOT missing"; exit 1; }

# never touch a repo mid-operation
if [ -d .git/rebase-merge ] || [ -d .git/rebase-apply ] || [ -f .git/MERGE_HEAD ]; then
    say "repo is mid-rebase/merge — resolve by hand, then rerun"
    notify "repo mid-rebase/merge — resolve by hand"
    exit 1
fi

git symbolic-ref --short -q HEAD >/dev/null \
    || { say "detached HEAD — skipping"; notify "detached HEAD — skipping"; exit 1; }
git rev-parse --abbrev-ref '@{u}' >/dev/null 2>&1 \
    || { say "no upstream configured — skipping"; exit 1; }

# offline is normal, not an error
if ! git fetch --quiet origin 2>/dev/null; then
    say "fetch failed (offline?) — skipping"
    exit 0
fi

behind=$(git rev-list --count 'HEAD..@{u}')
ahead=$(git rev-list --count '@{u}..HEAD')
dirty=$(git status --porcelain)
remote_sha=$(git rev-parse '@{u}')

# ---------- daemon mode ----------
if [ "$AUTO" = true ]; then
    if [ -n "$dirty" ]; then
        if [ "$behind" -gt 0 ]; then
            # nag once per new remote state, not every 30 min
            if [ "$(cat "$STATE" 2>/dev/null)" != "$remote_sha" ]; then
                mkdir -p "$(dirname "$STATE")"
                echo "$remote_sha" > "$STATE"
                notify "behind by $behind, local changes uncommitted — run dot-sync.sh"
            fi
            say "dirty + behind $behind — hands off, notified"
        else
            say "dirty, nothing to pull — hands off"
        fi
        exit 0
    fi

    pulled=0
    if [ "$behind" -gt 0 ]; then
        if git pull --rebase --quiet >>"$LOG" 2>&1; then
            pulled=$behind
        else
            git rebase --abort 2>/dev/null
            say "pull --rebase hit conflicts — aborted clean"
            notify "pull --rebase hit conflicts — run dot-sync.sh manually"
            exit 1
        fi
    fi

    pushed=0
    if [ "$ahead" -gt 0 ]; then
        if git push --quiet >>"$LOG" 2>&1; then
            pushed=$ahead
        else
            say "push failed — will retry next cycle"
        fi
    fi

    if [ "$pulled" -gt 0 ] || [ "$pushed" -gt 0 ]; then
        say "synced: pulled $pulled, pushed $pushed"
        notify "synced — pulled $pulled, pushed $pushed"
    else
        say "up to date"
    fi
    exit 0
fi

# ---------- manual mode: the ritual ----------
stashed=false
if [ "$behind" -gt 0 ]; then
    if [ -n "$dirty" ]; then
        say "stashing local changes (incl. untracked)"
        git stash push -u -m "dot-sync $(date '+%Y-%m-%d %H:%M')" >/dev/null
        stashed=true
    fi
    if ! git pull --rebase; then
        git rebase --abort 2>/dev/null
        [ "$stashed" = true ] && git stash pop >/dev/null
        say "pull --rebase hit conflicts — aborted, tree restored. Sync by hand."
        exit 1
    fi
    say "pulled $behind commit(s)"
    if [ "$stashed" = true ]; then
        if git stash pop; then
            say "stash popped clean — eyeball auto-merged files before committing"
        else
            say "stash pop CONFLICTED — fix the markers, then: git stash drop"
            exit 1
        fi
    fi
fi

ahead=$(git rev-list --count '@{u}..HEAD')   # recompute after rebase
if [ "$ahead" -gt 0 ]; then
    git push && say "pushed $ahead commit(s)"
fi

[ -n "$(git status --porcelain)" ] && say "local changes still uncommitted — commit when ready"
say "done: $(git status -sb | head -1)"

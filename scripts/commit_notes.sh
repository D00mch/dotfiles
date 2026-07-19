#!/bin/bash
set -euo pipefail

REPO="$HOME/work/wiki"
STATE_DIR="$HOME/.local/state/wiki-sync"
LOCK_DIR="$STATE_DIR/git-sync.lock"

log() {
    printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}

mkdir -p "$STATE_DIR"
mkdir "$LOCK_DIR" 2>/dev/null || {
    log "Another wiki Git sync is already running."
    exit 75
}
trap 'rmdir "$LOCK_DIR" 2>/dev/null || true' EXIT

cd "$REPO"

branch="$(git branch --show-current)"
[[ "$branch" == "main" ]] || {
    log "Unexpected branch: $branch"
    exit 1
}

log "Syncing $REPO"
git status --short --branch

git add -A

if git diff --cached --quiet; then
    log "No local changes to commit"
else
    message="Daily update: $(date +'%Y-%m-%d %H:%M:%S')"
    git commit -m "$message"
    log "Committed: $message"
fi

git fetch origin main
git rebase origin/main
git push origin main

log "Git sync completed successfully"

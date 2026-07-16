#!/bin/bash

set -euo pipefail

SOURCE="${WIKI_SOURCE:-$HOME/work/wiki}"
DESTINATION="${WIKI_YANDEX_DESTINATION:-$HOME/Yandex.Disk.localized/wiki}"
STATE_DIR="${WIKI_SYNC_STATE_DIR:-$HOME/.local/state/wiki-sync}"
LOCK_DIR="$STATE_DIR/yandex-mirror.lock"

log() {
    printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}

mkdir -p "$STATE_DIR"

if ! mkdir "$LOCK_DIR" 2>/dev/null; then
    log "Another Yandex wiki mirror is already running (lock: $LOCK_DIR)."
    exit 75
fi

cleanup() {
    rmdir "$LOCK_DIR" 2>/dev/null || true
}
trap cleanup EXIT HUP INT TERM

if [[ ! -d "$SOURCE/.git" ]] || ! /usr/bin/git -C "$SOURCE" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    log "Source is not a Git working tree: $SOURCE"
    exit 1
fi

if [[ ! -d "$DESTINATION" ]]; then
    log "Yandex destination does not exist: $DESTINATION"
    exit 1
fi

log "Mirroring $SOURCE to $DESTINATION"

/usr/bin/rsync -a \
    --delete \
    --delete-excluded \
    --exclude='/.git/' \
    --exclude='/.git.lock' \
    --exclude='*.rsync-part' \
    --exclude='/.rsync-partial/' \
    "$SOURCE/" "$DESTINATION/"

if [[ -e "$DESTINATION/.git" ]]; then
    log "Refusing to report success because Git metadata remains in $DESTINATION"
    exit 1
fi

log "Mirror completed successfully"

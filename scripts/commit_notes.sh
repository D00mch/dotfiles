#!/bin/bash

NOTES_DIR="$HOME/Yandex.Disk.localized/wiki/"

cd "$NOTES_DIR" || { echo "Directory not found: $NOTES_DIR"; exit 1; }

git status

git add .

MESSAGE="Daily update: $(date +'%Y-%m-%d %H:%M:%S')"

git commit -m "$MESSAGE"

echo "About to push. $MESSAGE"

git pull --rebase

git push origin main

# every hour:
# 0 * * * * "$HOME/dotfiles/scripts/commit_notes.sh" >> "$HOME/Documents/chrone.log" 2>&1

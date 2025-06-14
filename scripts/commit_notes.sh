#!/bin/bash

NOTES_DIR="$HOME/Yandex.Disk.localized/wiki/"

cd "$NOTES_DIR" || { echo "Directory not found: $NOTES_DIR"; exit 1; }

git add .

git commit -m "Daily update: $(date +'%Y-%m-%d %H:%M:%S')"

git pull --rebase

git push origin main

# 0 12 * * * /Users/m1/dotfiles/scripts/commit_notes.sh >> /Users/m1/Documents/chone.log 2>&1

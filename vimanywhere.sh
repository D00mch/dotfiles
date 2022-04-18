#!/bin/bash

VIM=/usr/local/bin/neovide
AW_PATH=$HOME/osx-vimr-anywhere
TMPFILE_DIR=/tmp/vim-anywhere
TMPFILE=$TMPFILE_DIR/last-buffer
VIM_OPTS='--nofork'

mkdir -p $TMPFILE_DIR
touch $TMPFILE

app=$(osascript \
    -e 'tell application "System Events" 
            copy (name of application processes whose frontmost is true) to stdout 
        end tell')

$VIM $VIM_OPTS $TMPFILE

LANG=en_US.UTF-8 pbcopy < $TMPFILE
osascript -e "activate application \"$app\""

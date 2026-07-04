#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

log_file=/tmp/aerospace-window-mode.log
script_name=${0##*/}
exec 2>>"$log_file"

trap 'rc=$?; if [ "$rc" -ne 0 ]; then printf "%s %s failed rc=%s args=%s\n" "$(/bin/date -u +%Y-%m-%dT%H:%M:%SZ)" "$script_name" "$rc" "$*" >> "$log_file"; fi' EXIT

if [ "$#" -ne 2 ]; then
  echo "usage: $script_name <delta-x> <delta-y>" >&2
  exit 64
fi

dx=$1
dy=$2

/usr/bin/osascript <<APPLESCRIPT
tell application "System Events"
  set _app to name of first application process whose frontmost is true
  tell process _app
    set _window to front window
    set {_x, _y} to position of _window
    set position of _window to {_x + ($dx), _y + ($dy)}
    activate
  end tell
end tell
APPLESCRIPT

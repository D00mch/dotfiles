#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

log_file=/tmp/aerospace-window-mode.log
script_name=${0##*/}
exec 2>>"$log_file"

trap 'rc=$?; if [ "$rc" -ne 0 ]; then printf "%s %s failed rc=%s args=%s\n" "$(/bin/date -u +%Y-%m-%dT%H:%M:%SZ)" "$script_name" "$rc" "$*" >> "$log_file"; fi' EXIT

if [ "$#" -ne 2 ]; then
  echo "usage: $script_name <delta-width> <delta-height>" >&2
  exit 64
fi

delta_width=$1
delta_height=$2
min_width=320
min_height=240

/usr/bin/osascript <<APPLESCRIPT
tell application "System Events"
  set _app to first application process whose frontmost is true
  set frontmost of _app to true
  tell _app
    set _window to front window
    try
      perform action "AXRaise" of _window
    end try
    set {_x, _y} to position of _window
    set {_width, _height} to size of _window
    set _new_width to _width + ($delta_width)
    set _new_height to _height + ($delta_height)
    if _new_width < $min_width then set _new_width to $min_width
    if _new_height < $min_height then set _new_height to $min_height
    set _new_x to _x - ((_new_width - _width) / 2)
    set _new_y to _y - ((_new_height - _height) / 2)
    set position of _window to {_new_x as integer, _new_y as integer}
    set size of _window to {_new_width as integer, _new_height as integer}
    try
      perform action "AXRaise" of _window
    end try
    try
      set value of attribute "AXMain" of _window to true
    end try
    try
      set value of attribute "AXFocused" of _window to true
    end try
  end tell
  set frontmost of _app to true
end tell
APPLESCRIPT

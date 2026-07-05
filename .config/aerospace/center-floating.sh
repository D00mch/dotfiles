#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

log_file=/tmp/aerospace-window-mode.log
script_name=${0##*/}
aerospace_bin=${AEROSPACE_BIN:-}
exec 2>>"$log_file"

trap 'rc=$?; if [ "$rc" -ne 0 ]; then printf "%s %s failed rc=%s args=%s\n" "$(/bin/date -u +%Y-%m-%dT%H:%M:%SZ)" "$script_name" "$rc" "$*" >> "$log_file"; fi' EXIT

if [ -z "$aerospace_bin" ]; then
  if aerospace_bin=$(command -v aerospace 2>/dev/null); then
    :
  elif [ -x /opt/homebrew/bin/aerospace ]; then
    aerospace_bin=/opt/homebrew/bin/aerospace
  fi
fi

focused_window_id=
if [ -n "$aerospace_bin" ]; then
  focused_window_id=$("$aerospace_bin" list-windows --focused --format '%{window-id}' 2>/dev/null || true)
  focused_window_id=${focused_window_id%%$'\n'*}
fi

if [ -n "$focused_window_id" ]; then
  "$aerospace_bin" layout --window-id "$focused_window_id" floating 2>/dev/null || true
  "$aerospace_bin" focus --window-id "$focused_window_id" 2>/dev/null || true
  /bin/sleep 0.05
fi

window_rect=$(/usr/bin/osascript <<'APPLESCRIPT'
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
    return (_x as integer) & " " & (_y as integer) & " " & (_width as integer) & " " & (_height as integer)
  end tell
end tell
APPLESCRIPT
)

window_rect=${window_rect//,/}
read -r window_x window_y window_width window_height <<< "$window_rect"
window_center_x=$((window_x + window_width / 2))
window_center_y=$((window_y + window_height / 2))

export CLANG_MODULE_CACHE_PATH="${CLANG_MODULE_CACHE_PATH:-/tmp/aerospace-window-mode-swift-cache}"
/bin/mkdir -p "$CLANG_MODULE_CACHE_PATH"

screen_rect=$(/usr/bin/swift - "$window_center_x" "$window_center_y" <<'SWIFT'
import CoreGraphics
import Foundation

let pointX = Double(CommandLine.arguments[1]) ?? 0
let pointY = Double(CommandLine.arguments[2]) ?? 0
let point = CGPoint(x: pointX, y: pointY)

var displayCount: UInt32 = 0
guard CGGetActiveDisplayList(0, nil, &displayCount) == .success, displayCount > 0 else {
    exit(1)
}

var displays = Array(repeating: CGDirectDisplayID(0), count: Int(displayCount))
guard CGGetActiveDisplayList(displayCount, &displays, &displayCount) == .success else {
    exit(1)
}

let frames = displays.map { CGDisplayBounds($0) }.filter { !$0.isEmpty }
let frame = frames.first { $0.contains(point) } ?? frames.first

guard let frame else {
    exit(1)
}

print("\(Int(frame.origin.x)) \(Int(frame.origin.y)) \(Int(frame.size.width)) \(Int(frame.size.height))")
SWIFT
)

read -r screen_x screen_y screen_width screen_height <<< "$screen_rect"

new_width=$((screen_width * 4 / 11))
new_height=$((screen_height * 18 / 19))
new_x=$((screen_x + (screen_width - new_width) / 2))
new_y=$((screen_y + (screen_height - new_height) / 2))

/usr/bin/osascript <<APPLESCRIPT
tell application "System Events"
  set _app to first application process whose frontmost is true
  set frontmost of _app to true
  tell _app
    set _window to front window
    try
      perform action "AXRaise" of _window
    end try
    set position of _window to {$new_x, $new_y}
    set size of _window to {$new_width, $new_height}
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

if [ -n "$focused_window_id" ]; then
  "$aerospace_bin" focus --window-id "$focused_window_id" 2>/dev/null || true
fi

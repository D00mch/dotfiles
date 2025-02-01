#!/bin/bash

# Toggle system dark mode
osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to not dark mode'

# Remember the currently focused app
FOCUSED_APP=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true')

# Click <alt+shift+d> to toggle Dark Reader in Chrome
open -a "Google Chrome"
sleep 0.1
osascript <<EOF
tell application "System Events"
    tell process "Google Chrome"
        set frontmost to true
        keystroke "d" using {option down, shift down}
    end tell
end tell
EOF

# Return focus to the originally focused app
osascript -e "tell application \"$FOCUSED_APP\" to activate"

echo "Dark mode toggled, Chrome shortcut applied, and focus returned to $FOCUSED_APP."

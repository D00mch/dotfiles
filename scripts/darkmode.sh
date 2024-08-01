#!/bin/bash

# Toggle system dark mode
osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to not dark mode'

# Open Google Chrome
open -a "Google Chrome"

# Use osascript to send alt+shift+d shortcut to Google Chrome
# Wait a moment for Chrome to focus
sleep 2
osascript <<EOF
tell application "System Events"
    tell process "Google Chrome"
        set frontmost to true
        keystroke "d" using {option down, shift down}
    end tell
end tell
EOF

echo "Dark mode toggled and Chrome shortcut applied."

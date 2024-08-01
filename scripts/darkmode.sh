#!/bin/bash

# Toggle system dark mode
osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to not dark mode'

# Open Google Chrome
open -a "Google Chrome"

# Click <alt+shift+d> to toggle Dark Reader
sleep 0.1
osascript <<EOF
tell application "System Events"
    tell process "Google Chrome"
        set frontmost to true
        keystroke "d" using {option down, shift down}
    end tell
end tell
EOF

echo "Dark mode toggled and Chrome shortcut applied."

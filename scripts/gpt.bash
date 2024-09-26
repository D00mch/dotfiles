#!/bin/bash

# alfred doesn't see exports by default
source ~/.zprofile

WIFI_NAME="asus-vr"
WIFI_PASSWORD="$WIFI_HOME"

get_current_ssid() {
    networksetup -getairportnetwork en0 | awk -F': ' '{print $2}'
}

CURRENT_SSID=$(get_current_ssid)

# Check if the Wi-Fi network has been changed
if [ "$CURRENT_SSID" != "$WIFI_NAME" ]; then
    echo "About to switch network"
    networksetup -setairportnetwork en0 "$WIFI_NAME" "$WIFI_PASSWORD"
    CURRENT_SSID=$(get_current_ssid)
fi

if [ "$CURRENT_SSID" == "$WIFI_NAME" ]; then
    echo "Successfully connected to $WIFI_NAME."
    open "https://chatgpt.com/"
else
    echo "Failed to connect to $WIFI_NAME."
fi

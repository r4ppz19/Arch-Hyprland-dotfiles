#!/bin/bash

# Note to self:
# bind this to your liking
# dependencies: grim & slup & notification-deamon (ex. swaync, dunst), libnotify

# Define the lock file
LOCKFILE="/tmp/screenshot.lock"

# Use flock to prevent multiple instances
exec 200>"$LOCKFILE"
flock -n 200 || {
    notify-send "Screenshot Already Running" "Please wait for the current screenshot process to finish." -i dialog-warning
    exit 1
}

# Ensure the screenshot directory exists
mkdir -p ~/Pictures/Screenshot

# Define the screenshot file name with timestamp
FILE=~/Pictures/Screenshot/screenshot_$(date +%Y-%m-%d_%H-%M-%S).png

# Check if required tools are installed
if ! command -v grim &>/dev/null || ! command -v slurp &>/dev/null; then
    notify-send "Screenshot Failed" "Required tools (grim or slurp) are not installed." -i dialog-error
    exit 1
fi

# Use slurp to select a region
REGION=$(slurp)

# Check if slurp was canceled (empty REGION)
if [[ -z "$REGION" ]]; then
    notify-send "Screenshot Canceled" "No region selected." -i dialog-warning
    exit 1
fi

# Introduce a short delay to ensure the slurp overlay is cleared
sleep 0.2

# Take a screenshot with grim
grim -g "$REGION" "$FILE"

# Verify that the screenshot was saved successfully
if [[ -f "$FILE" && -s "$FILE" ]]; then
    notify-send "Screenshot Taken" "Saved to $FILE\nRegion: $REGION" -i camera
    exit 0
else
    notify-send "Screenshot Failed" "Could not save the screenshot." -i dialog-error
    exit 1
fi

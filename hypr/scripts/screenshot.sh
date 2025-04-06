#!/bin/bash

# Define the lock file
LOCKFILE="/tmp/screenshot.lock"

# Check if the script is already running
if [[ -e "$LOCKFILE" ]]; then
    notify-send "Screenshot Already Running" "Please wait for the current screenshot process to finish." -i dialog-warning
    exit 1
fi

# Create the lock file
touch "$LOCKFILE"

# Ensure the lock file is removed when the script exits
trap 'rm -f "$LOCKFILE"' EXIT

# Define the screenshot file name with timestamp
FILE=~/Pictures/Screenshot/screenshot_$(date +%Y-%m-%d_%H-%M-%S).png

# Use slurp to select a region
REGION=$(slurp)

# Check if slurp was canceled (empty REGION)
if [[ -z "$REGION" ]]; then
    notify-send "Screenshot Canceled" "No region selected." -i dialog-warning
    exit 1
fi

# Take a screenshot with grim
grim -g "$REGION" "$FILE"

# Verify that the screenshot was saved successfully
if [[ -f "$FILE" && -s "$FILE" ]]; then
    notify-send "Screenshot Taken" "Saved to $FILE" -i camera
else
    notify-send "Screenshot Failed" "Could not save the screenshot." -i dialog-error
    exit 1
fi
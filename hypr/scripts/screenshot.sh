#!/bin/bash

# Define the screenshot file name with timestamp
FILE=~/Pictures/Screenshot/screenshot_$(date +%Y-%m-%d_%H-%M-%S).png

# Take a screenshot with grim and slurp
grim -g "$(slurp)" "$FILE"

# Send a notification using dunst
notify-send "Screenshot Taken" "Saved to $FILE" -i camera

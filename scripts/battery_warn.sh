#!/bin/bash

# Note to self:
# run this using systemd with timer
# see my systemd folder for reference
# dependency: libnotify

# Get battery percentage
BATTERY_PATH="/sys/class/power_supply/BAT1"
BATTERY_LEVEL=$(cat "$BATTERY_PATH/capacity")
STATUS=$(cat "$BATTERY_PATH/status")

# Only notify if discharging and below or at 20%
if [[ "$STATUS" == "Discharging" && "$BATTERY_LEVEL" -le 20 ]]; then
    notify-send -u critical "Battery Low" "Battery is at ${BATTERY_LEVEL}%. Plug in your charger!"
fi


#!/bin/bash

# Note to self:
# dependencies: brightnessctl, wireplumber, libnotify

case "$1" in
    volume-up)
        wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+
        vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{printf "%.0f%%", $2 * 100}')
        notify-send -h string:x-canonical-private-synchronous:volume \
                    "Volume" "$vol" -i audio-volume-high-symbolic
        ;;
    volume-down)
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
        vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{printf "%.0f%%", $2 * 100}')
        notify-send -h string:x-canonical-private-synchronous:volume \
                    "Volume" "$vol" -i audio-volume-low-symbolic
        ;;
    mute)
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        state=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{if ($3 == "[MUTED]") print "Muted"; else print "Unmuted"}')
        notify-send -h string:x-canonical-private-synchronous:audio \
                    "Audio" "$state" -i audio-volume-muted-symbolic
        ;;
    mic-mute)
        wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
        state=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | awk '{if ($3 == "[MUTED]") print "Muted"; else print "Unmuted"}')
        notify-send -h string:x-canonical-private-synchronous:mic \
                    "Microphone" "$state" -i microphone-off-symbolic
        ;;
    brightness-up)
        brightnessctl set 5%+
        current=$(brightnessctl get)
        max=$(brightnessctl max)
        percentage=$(awk -v c="$current" -v m="$max" 'BEGIN {printf "%.0f", (c / m) * 100}')
        notify-send -h string:x-canonical-private-synchronous:brightness \
                    "Brightness" "${percentage}%" -i display-brightness-high-symbolic
        ;;
    brightness-down)
        brightnessctl set 5%-
        current=$(brightnessctl get)
        max=$(brightnessctl max)
        percentage=$(awk -v c="$current" -v m="$max" 'BEGIN {printf "%.0f", (c / m) * 100}')
        notify-send -h string:x-canonical-private-synchronous:brightness \
                    "Brightness" "${percentage}%" -i display-brightness-low-symbolic
        ;;
esac

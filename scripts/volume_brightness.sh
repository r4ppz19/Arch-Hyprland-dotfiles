#!/bin/bash

case "$1" in
    volume-up)
        wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+
        notify-send -r 999 "Volume" "$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100) "%"}')" -i audio-volume-high
        ;;
    volume-down)
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
        notify-send -r 999 "Volume" "$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100) "%"}')" -i audio-volume-low
        ;;
    mute)
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        notify-send -r 999 "Audio" "$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{if ($3 == "[MUTED]") print "Muted"; else print "Unmuted"}')" -i audio-volume-muted
        ;;
    mic-mute)
        wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
        notify-send -r 998 "Mic" "$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | awk '{if ($3 == "[MUTED]") print "Muted"; else print "Unmuted"}')" -i microphone-sensitivity-muted
        ;;
    brightness-up)
        brightnessctl set 5%+
        current=$(brightnessctl get)
        max=$(brightnessctl max)
        percentage=$((current * 100 / max))
        notify-send -r 997 "Brightness" "${percentage}%" -i display-brightness-high
        ;;
    brightness-down)
        brightnessctl set 5%-
        current=$(brightnessctl get)
        max=$(brightnessctl max)
        percentage=$((current * 100 / max))
        notify-send -r 997 "Brightness" "${percentage}%" -i display-brightness-low
        ;;
esac
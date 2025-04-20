#!/bin/bash
# filepath: /home/r4ppz/Arch-dotfiles/hypr/scripts/record.sh

PID_FILE="/tmp/recording.pid"
VIDEO_PATH_FILE="/tmp/recording_path.txt"

# Check if recording is active
if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
    # Stop the recording by sending SIGINT to wl-screenrec
    kill -INT $(cat "$PID_FILE")
    VID=$(cat "$VIDEO_PATH_FILE")
    rm "$PID_FILE" "$VIDEO_PATH_FILE"
    notify-send "✅ Recording Stopped" "Saved to $VID" -i media-playback-stop
else
    # Start a new recording
    notify-send "🎥 Recording" "Select area to record..." -i media-record
    
    # Use slurp to pick region
    REGION=$(slurp)
    
    # Check if selection was canceled
    if [ -z "$REGION" ]; then
        notify-send "Recording Canceled" "No region selected." -i dialog-warning
        exit 1
    fi
    
    # Start recording
    VID="$HOME/Videos/screenrecord_$(date +%Y-%m-%d_%H-%M-%S).mp4"
    notify-send "🎥 Recording Started" "Saving to $VID" -i media-record
    
    # Run wl-screenrec in background and save its PID
    wl-screenrec -g "$REGION" -f "$VID" &
    echo $! > "$PID_FILE"
    echo "$VID" > "$VIDEO_PATH_FILE"
fi
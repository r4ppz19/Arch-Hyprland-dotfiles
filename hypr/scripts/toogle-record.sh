#!/bin/bash
if pgrep -x "wf-recorder" > /dev/null; then
    pkill -INT -x wf-recorder
else
    wf-recorder -f ~/Videos/recording_$(date +%s).mp4 &
fi

#!/bin/bash
# flameshot-ocr.sh

# Note to self:
# bind this to your screenshot button
# purpose: copy the text of the image you screenshot
# dependencies: flameshot-git (AUR), tesseract, wl-clipboard, libnotify

# Take screenshot and save to temp file
flameshot gui -p /tmp/flameshot-ocr.png

# Run OCR and copy to clipboard
tesseract /tmp/flameshot-ocr.png stdout | wl-copy

# Optional: notify user
notify-send "Flameshot OCR" "Text copied to clipboard!"


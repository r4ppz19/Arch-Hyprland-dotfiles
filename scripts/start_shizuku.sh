#!/bin/bash

# -----------------------
# CONFIG SECTION
# -----------------------

PHONE_IP="192.168.1.1"  # Change to your device's IP
PORT="5555"              # Default ADB port
SHIZUKU_START_SCRIPT="/sdcard/Android/data/moe.shizuku.privileged.api/start.sh"
ADB_BIN="$(which adb)"   # Absolute path to ADB

# -----------------------
# SCRIPT BEGINS
# -----------------------

echo "[*] Connecting to $PHONE_IP:$PORT..."
CONN_RESULT="$("$ADB_BIN" connect "$PHONE_IP:$PORT")"

if echo "$CONN_RESULT" | grep -q "connected to"; then
  echo "[+] Connected successfully!"
elif echo "$CONN_RESULT" | grep -q "already connected"; then
  echo "[+] Already connected."
else
  echo "[!] Connection failed: $CONN_RESULT"
  exit 1
fi

# Check authorization status
if "$ADB_BIN" devices | grep "$PHONE_IP" | grep -q "unauthorized"; then
  echo "[!] Device unauthorized. Check your device."
  exit 1
fi

# Check if Shizuku is running
echo "[*] Checking if Shizuku is running..."
if "$ADB_BIN" shell sh -c "pgrep -f 'moe.shizuku.privileged.api' || exit 1" >/dev/null 2>&1; then
  echo "[+] Shizuku is already running."
  exit 0
else
  echo "[*] Starting Shizuku..."
  "$ADB_BIN" shell sh "$SHIZUKU_START_SCRIPT" || {
    echo "[!] Failed to execute Shizuku start script."
    exit 1
  }

  # Verify Shizuku started
  sleep 2
  if "$ADB_BIN" shell sh -c "pgrep -f 'moe.shizuku.privileged.api' || exit 1" >/dev/null 2>&1; then
    echo "[+] Shizuku started successfully."
  else
    echo "[!] Shizuku may not have started. Check manually."
    exit 1
  fi
fi

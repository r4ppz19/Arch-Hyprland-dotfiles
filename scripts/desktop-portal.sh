#!/usr/bin/env bash

# Note to self:
# run this using exec-once in hyprland
# dependencies: xdg-desktop-portal-hyprland (AUR), xdg-desktop-portal

sleep 1
killall -e xdg-desktop-portal-hyprland
killall xdg-desktop-portal
/usr/lib/xdg-desktop-portal-hyprland &
sleep 2
/usr/lib/xdg-desktop-portal &

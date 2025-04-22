#!/usr/bin/env bash

# Power Menu for Rofi - Adapted for Hyprland + Hyprlock

# Directories & Theme
dir="$HOME/.config/rofi/powermenu/type-3"
theme='style-3'

# Get system info
uptime="$(uptime -p | sed -e 's/up //g')"
host="$(cat /proc/sys/kernel/hostname)"  # Alternative to `hostname`

# Icons (Nerd Fonts)
shutdown='󰐥'  # nf-md-power
reboot='󰜉'    # nf-md-restart
lock=''       # nf-fa-lock
suspend='󰤄'   # nf-md-sleep
logout='󰍃'    # nf-md-logout
yes=''        # nf-fa-check
no=''         # nf-fa-times

# Rofi Command
rofi_cmd() {
	rofi -dmenu \
		-p "Uptime: $uptime" \
		-mesg "Uptime: $uptime" \
		-theme "${dir}/${theme}.rasi"
}

# Confirmation Dialog
confirm_cmd() {
	rofi -dmenu \
		-p 'Confirmation' \
		-mesg 'Are you sure?' \
		-theme "${dir}/shared/confirm.rasi"
}

# Ask for Confirmation
confirm_exit() {
	echo -e "$yes\n$no" | confirm_cmd
}

# Show Rofi Menu
run_rofi() {
	echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | rofi_cmd
}

# Execute Commands
run_cmd() {
	selected="$(confirm_exit)"
	if [[ "$selected" == "$yes" ]]; then
		case "$1" in
			'--shutdown') systemctl poweroff ;;
			'--reboot') systemctl reboot ;;
			'--suspend')
				mpc -q pause
				amixer set Master mute
				systemctl suspend
				;;
			'--logout') loginctl terminate-user $USER ;;
		esac
	else
		exit 0
	fi
}

# Handle User Selection
chosen="$(run_rofi)"
case "$chosen" in
    "$shutdown") run_cmd --shutdown ;;
    "$reboot") run_cmd --reboot ;;
	"$lock") sleep 0.5 && swaylock ;;
    "$suspend") run_cmd --suspend ;;
    "$logout") run_cmd --logout ;;
esac

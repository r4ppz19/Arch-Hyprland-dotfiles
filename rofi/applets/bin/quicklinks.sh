#!/usr/bin/env bash

## Author  : Aditya Shakya (adi1090x)
## Github  : @adi1090x
#
## Applets : Quick Links

# Import Current Theme
source "$HOME"/.config/rofi/applets/shared/theme.bash
theme="$type/$style"

# Theme Elements
prompt='AI'
mesg="r4ppz"

if [[ ( "$theme" == *'type-1'* ) || ( "$theme" == *'type-3'* ) || ( "$theme" == *'type-5'* ) ]]; then
    list_col='1'
    list_row='6'
elif [[ ( "$theme" == *'type-2'* ) || ( "$theme" == *'type-4'* ) ]]; then
    list_col='6'
    list_row='1'
fi

if [[ ( "$theme" == *'type-1'* ) || ( "$theme" == *'type-5'* ) ]]; then
    efonts="JetBrains Mono Nerd Font 10"
else
    efonts="JetBrains Mono Nerd Font 28"
fi

# Options
layout=`cat ${theme} | grep 'USE_ICON' | cut -d'=' -f2`
if [[ "$layout" == 'NO' ]]; then
    option_1="  ChatGPT"
    option_2="󱚝  DeepSeek"
    option_3="󰚩  Qwen"
    option_4="󱚥  Gemini"
    option_5="󱚣  Kimi"
else
    option_1=" "
    option_2="󱚝 "
    option_3="󰚩 "
    option_4="󱚥"
    option_5="󱚣"
fi

# Rofi CMD
rofi_cmd() {
    rofi -theme-str "listview {columns: $list_col; lines: $list_row;}" \
        -theme-str 'textbox-prompt-colon {str: " ";}' \
        -theme-str "element-text {font: \"$efonts\";}" \
        -dmenu \
        -p "$prompt" \
        -mesg "$mesg" \
        -markup-rows \
        -theme ${theme}
}

# Pass variables to rofi dmenu
run_rofi() {
    echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5" | rofi_cmd
}

# Execute Command
run_cmd() {
    if [[ "$1" == '--opt1' ]]; then
        xdg-open 'https://chatgpt.com/'
    elif [[ "$1" == '--opt2' ]]; then
        xdg-open 'https://chat.deepseek.com/'
    elif [[ "$1" == '--opt3' ]]; then
        xdg-open 'https://chat.qwen.ai/'
    elif [[ "$1" == '--opt4' ]]; then
        xdg-open 'https://gemini.google.com/app'
    elif [[ "$1" == '--opt5' ]]; then
        xdg-open 'https://kimi.ai/'
    fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $option_1)
        run_cmd --opt1
        ;;
    $option_2)
        run_cmd --opt2
        ;;
    $option_3)
        run_cmd --opt3
        ;;
    $option_4)
        run_cmd --opt4
        ;;
    $option_5)
        run_cmd --opt5
        ;;
esac

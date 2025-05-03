# =========================================================================================
# functions
# =========================================================================================


# tgpt with different parameter
ai() {
  case "$1" in
    -p)
      shift
      tgpt -q -w --provider pollinations "$@" ;;
    -o)
      shift
      tgpt -q -w --provider ollama --model gemma3 "$@" ;;
    *)
      tgpt -q -w "$@" ;;
  esac | mdcat | less -FRX
}

cleanup() {
    # Remove orphans with confirmation
    local orphans=$(pacman -Qdtq)
    if [[ -n "$orphans" ]]; then
        echo "Orphaned packages found:"
        echo "$orphans"
        read -p "Remove these packages? [y/N] " confirm
        if [[ $confirm =~ [Yy] ]]; then
            sudo pacman -Rns $orphans
        else
            echo "Skipping orphan removal."
        fi
    else
        echo "No orphaned packages found."
    fi

    # Keep 2 latest versions of installed packages (safer than -Sc)
    sudo paccache -rk2

    # Remove all cached versions of uninstalled packages
    sudo paccache -ruk0

    # AUR cleanup (supports yay/paru, skips if helper isn't installed)
    aur_helper=$(command -v yay || command -v paru)
    if [[ -n $aur_helper ]]; then
        $aur_helper -Sc --noconfirm
    else
        echo "No AUR helper (yay/paru) found. Skipping AUR cleanup."
    fi
}

# file search
ff() {
  local file
  file=$(fd --type f --hidden . | fzf --preview 'bat --style=numbers --color=always {}' --height=50% --layout=reverse --border)
  [[ -n "$file" ]] && ${EDITOR:-nvim} "$file"
}

# grep search
gf() {
  local result
  result=$(rg --no-heading --line-number --color=always --hidden --no-ignore "$1" | \
           fzf --ansi --delimiter : \
               --preview 'bat --style=numbers --color=always {1} --highlight-line {2}' \
               --height=50% --layout=reverse --border)
  [[ -n "$result" ]] && ${EDITOR:-nvim} "$(cut -d: -f1 <<< "$result")" +$(cut -d: -f2 <<< "$result")
}


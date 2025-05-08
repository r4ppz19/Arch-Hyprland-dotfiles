# =========================================================================================
# functions
# =========================================================================================

HISTORY_IGNORE='(sudo -S*|*--password*|*\$\(*|*\"*|*"*)'
zshaddhistory() {
  emulate -L zsh
  [[ $1 != ${~HISTORY_IGNORE}[[:space:]]## ]]
}

# package management
install() {
  if command -v pacman >/dev/null 2>&1; then
    sudo pacman -S "$@"
  elif command -v yay >/dev/null 2>&1; then
    yay -S "$@"
  else
    echo "Neither pacman nor yay is available."
    return 1
  fi
}

uninstall() {
  if command -v pacman >/dev/null 2>&1; then
    sudo pacman -Rns "$@"
  elif command -v yay >/dev/null 2>&1; then
    yay -Rns "$@"
  else
    echo "Neither pacman nor yay is available."
    return 1
  fi
}

update() {
  echo "Updating system..."
  if command -v pacman >/dev/null 2>&1; then
    echo "Using pacman..."
    sudo pacman -Syu
  elif command -v yay >/dev/null 2>&1; then
    echo "Using yay..."
    yay -Syu
  else
    echo "Neither pacman nor yay is available."
    return 1
  fi
}


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
  esac | mdcat | less
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


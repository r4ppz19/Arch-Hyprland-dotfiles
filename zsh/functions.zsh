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


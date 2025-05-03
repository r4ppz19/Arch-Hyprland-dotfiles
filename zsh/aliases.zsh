# =========================================================================================
# Aliases
# =========================================================================================
# Dependencies: eza, tree, bat, less, ranger, , trash
# gh (github cli + copilot extension), ollama (model: gemma3), tgpt
#
# improvements
alias ls="eza --icons --group-directories-first --color=auto"           # Default listing with icons
alias lg="eza -l --icons --group-directories-first --color=auto --git"  # Long format with git info
alias la="eza -a --icons --group-directories-first --color=auto"        # Show all files including hidden
alias ll="eza -lh --icons --group-directories-first --color=auto"       # Long format with human-readable sizes
alias tree="eza -T --icons --group-directories-first --color=auto"      # Tree view
alias bat="bat --style=plain --paging=always"
alias less="less -RX"
alias compress='tar -czvf'
alias rm="command -v trash >/dev/null && trash -i || rm -i"
alias mv="mv -iv"
alias cp="cp -iv"
alias mkdir="mkdir -pv"
alias grep="grep -inR"

# mine
alias icat="kitty +kitten icat --place 100x100@2x2"
alias r='ranger --choosedir="$HOME/.rangerdir"; LASTDIR=$(cat "$HOME/.rangerdir"); cd "$LASTDIR"'
alias n='nnn'
alias v="nvim"
alias calculator='qalc'

# tmux
alias txd='tmux detach'
alias txls='tmux ls'
alias txa='tmux attach'

# package management
alias install='sudo pacman -S'
alias aurinstall='yay -S'
alias uninstall='sudo pacman -Rns'
alias update="sudo pacman -Syu && yay"
alias search='pacman -Ss && yay -Ss'
alias pkglist='pacman -Qqe'

# AI
alias gpt="tgpt"
alias gce='gh copilot explain'
alias gcs='gh copilot suggest'
alias gemma3="tgpt --provider ollama --model gemma3"
alias poll="tgpt --provider pollinations"

# script aliases
alias shizukuup="~/Arch-dotfiles/scripts/start_shizuku.sh"



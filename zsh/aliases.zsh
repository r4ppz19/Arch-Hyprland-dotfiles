# =========================================================================================
# Aliases
# =========================================================================================
# Dependencies: eza, tree, bat, less, ranger, , trash
# gh (github cli + copilot extension), ollama (model: gemma3), tgpt
#
# improvements
alias ls="eza --icons --group-directories-first --color=auto"           # Default listing with icons
alias la="eza -a --icons --group-directories-first --color=auto"        # Show all files including hidden
alias ll="eza -lh --icons --group-directories-first --color=auto"       # Long format with human-readable sizes
alias tree="eza -T --icons --group-directories-first --color=auto"      # Tree view
alias less="less -SRX"
alias compress='tar -czvf'
alias rm="trash -v"
alias mv="mv -iv"
alias cp="cp -iv"
alias mkdir="mkdir -pv"
alias grep="grep -inR"

# mine
alias r='ranger --choosedir="$HOME/.rangerdir"; LASTDIR=$(cat "$HOME/.rangerdir"); cd "$LASTDIR"'
alias n='nnn'
alias v="nvim"
alias calculator='qalc'

# tmux
alias txd='tmux detach'
alias txls='tmux ls'
alias txa='tmux attach'

# package management
alias search='pacman -Ss && yay -Ss'
alias pkglist='pacman -Qqe'

# AI
alias gce='gh copilot explain'
alias gcs='gh copilot suggest'
alias gemma3="tgpt --provider ollama --model gemma3"
alias poll="tgpt --provider pollinations"

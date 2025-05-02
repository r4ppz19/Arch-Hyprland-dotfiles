# =========================================================================================
# Fast TMUX Session Manager (Top of .zshrc)
# =========================================================================================

if [[ -z "$TMUX" ]] && [[ $- == *i* ]] && command -v tmux &>/dev/null; then
  # Get existing sessions
  local sessions=(${(f)"$(tmux list-sessions -F '#{session_name}' 2>/dev/null)"})
  local session_count=${#sessions}
  local choice

  # Quick-attach first session on Enter
  if (( session_count > 0 )); then
    echo "\n\033[1;34mTMUX Sessions:\033[0m"
    tmux list-sessions
    echo "\n\033[1;36mPress Enter to attach \033[1;33m${sessions[1]}\033[0m"
    echo "Or enter:"
    echo "  [number] - Attach specific session"
    echo "  n - New session"
    echo "  q - Quit"
    read "choice?Choice (${sessions[1]}/n/q): "
    
    case "$choice" in
      ""|1) tmux attach -t "${sessions[1]}" 2>/dev/null ;;
      [2-9]) 
        if (( choice <= session_count )); then
          tmux attach -t "${sessions[choice]}" 2>/dev/null
        fi ;;
      n|N)
        read "session_name?Session name (default=main): "
        tmux new-session -s "${session_name:-main}" 2>/dev/null ;;
      q|Q) : ;;  # Do nothing
      *) echo "\033[31mInvalid choice!\033[0m" ;;
    esac
  else
    echo "\n\033[1;34mNo existing TMUX sessions\033[0m"
    read "choice?Create new? [Y/n]: "
    case "$choice" in
      n|N) : ;;  # Do nothing
      *) 
        read "session_name?Session name (default=main): "
        tmux new-session -s "${session_name:-main}" 2>/dev/null ;;
    esac
  fi
fi

# =========================================================================================
# Instant Prompt (Powerlevel10k)
# =========================================================================================

# Load Powerlevel10k instant prompt (keep this!)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =========================================================================================
# Plugin Management (Antidote)
# =========================================================================================

# Completion System
autoload -Uz compinit
compinit

# Load antidote from its installation directory
source ${ZDOTDIR:-~}/.antidote/antidote.zsh

# Generate plugins file if missing, then load it
if [[ ! -f ~/Arch-dotfiles/zsh/.zsh_plugins.zsh ]]; then
  antidote bundle < ~/Arch-dotfiles/zsh/.zsh_plugins.txt > ~/Arch-dotfiles/zsh/.zsh_plugins.zsh
fi
source ~/Arch-dotfiles/zsh/.zsh_plugins.zsh


# =========================================================================================
# load configuration
# =========================================================================================

# FZF keybindings (keep this!)
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

# Load Powerlevel10k config
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# =========================================================================================
# Path Management
# =========================================================================================

typeset -U path  # Ensure unique entries in PATH
path=(
  $HOME/.local/bin
  $HOME/go/bin/
  $HOME/.cargo/bin
  ${path[@]}
)
export PATH

# =========================================================================================
# Environment Variables
# =========================================================================================
# wut variable
export OLLAMA_API_BASE=http://127.0.0.1:11434

# qt theme
export QT_QPA_PLATFORMTHEME=qt6ct   # For Qt6 apps

export EDITOR="nvim"      # Default editor
export VISUAL="nvim"      # Default visual editor
export TERMINAL="kitty"   # Default terminal emulator is Kitty
export BRAVE_PASSWORD_STORE=gnome  # Use GNOME keyring as the password store for Brave browser

# Reduce completion delay
export KEYTIMEOUT=1

# History file configuration
export HISTFILE=~/.zsh_history
export HISTSIZE=50000         # Increased from 10000 for more history retention
export SAVEHIST=50000         # Should match HISTSIZE
export HIST_IGNORE_PATTERN='*"*'  # Ignore commands with double quotes

# nnn
export NNN_PLUG='f:finder;o:fzopen;p:mocq;d:diffs;t:nmount;v:imgview'
export NNN_TMPFILE='/tmp/.lastd' 
export NNN_FCOLORS="a088429691af6ccb84d68e6d"
export NNN_COLORS="#2828283c504a"
export NNN_OPTS="ec" # opener

# fzf
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always {}' --height 50%"
export FZF_DEFAULT_OPTS='--height 50% --layout=reverse --border --margin=0 --padding=0'
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap"

# =========================================================================================
# Usefull setopt
# =========================================================================================

setopt append_history         # Append history to the file, rather than overwriting it
setopt inc_append_history     # Add commands to history immediately
setopt share_history          # Share history across all Zsh sessions
setopt hist_ignore_all_dups   # Remove all duplicate entries in history
setopt hist_ignore_space      # Ignore commands that start with a space
setopt hist_reduce_blanks     # Remove extra blanks from commands before saving
setopt hist_verify            # Verify recalled commands before running
setopt extended_history       # Save timestamps for each command in history
setopt hist_expire_dups_first # Remove duplicates first when trimming history
setopt hist_find_no_dups      # Don't display duplicates when searching history
setopt hist_save_no_dups      # Don't write duplicate entries to history file
setopt notify
setopt HIST_FCNTL_LOCK  # Safer history file locking
setopt INTERACTIVE_COMMENTS  # Allow comments in interactive shell
setopt HIST_NO_STORE     # Don't store history commands
setopt HIST_REDUCE_BLANKS # Compact whitespace in history

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
alias rm="trash -i"
alias mv="mv -iv"
alias cp="cp -iv"
alias mkdir="mkdir -pv"
alias grep="grep -inR"

# mine
alias icat="kitty +kitten icat --place 100x100@2x2"
alias r='ranger --choosedir="$HOME/.rangerdir"; LASTDIR=$(cat "$HOME/.rangerdir"); cd "$LASTDIR"'
alias n='nnn'
alias v="nvim"

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

# =========================================================================================
# Keybindings
# =========================================================================================
bindkey -e  # Explicitly set emacs mode (default but ensures no conflicts)

# Modern word jumps (Alt+←/→ and Ctrl+←/→)
bindkey '^[[1;3D' backward-word    # Alt+←
bindkey '^[[1;3C' forward-word     # Alt+→
bindkey '^[[1;5D' backward-word    # Ctrl+←
bindkey '^[[1;5C' forward-word     # Ctrl+→

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

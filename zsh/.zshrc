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

# Load antidote
source ${ZDOTDIR:-~}/.antidote/antidote.zsh

# Load plugins from the plugin list
antidote load ~/Arch-dotfiles/zsh/.zsh_plugins.txt

# Optional: static bundle for faster startup
antidote bundle < ~/Arch-dotfiles/zsh/.zsh_plugins.txt > ~/Arch-dotfiles/zsh/.zsh_plugins.zsh
source ~/Arch-dotfiles/zsh/.zsh_plugins.zsh

# =========================================================================================
# FZF Configuration
# =========================================================================================

# FZF keybindings (keep this!)
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

# =========================================================================================
# Powerlevel10k Configuration
# =========================================================================================

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
  $HOME/.npm-global/bin
  ${path[@]}
)
export PATH

# =========================================================================================
# Environment Variables
# =========================================================================================

export QT_QPA_PLATFORMTHEME=qt6ct   # For Qt6 apps
export QT_QPA_PLATFORMTHEME=qt5ct   # For Qt5 apps

export EDITOR="nvim"      # Default editor
export VISUAL="nvim"      # Default visual editor
export TERMINAL="kitty"   # Default terminal emulator is Kitty
export BRAVE_PASSWORD_STORE=gnome  # Use GNOME keyring as the password store for Brave browser

# Reduce completion delay
export KEYTIMEOUT=1

# Enable colored output for `ls` and other commands
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# History file configuration
export HISTFILE=~/.zsh_history
export HISTSIZE=50000         # Increased from 10000 for more history retention
export SAVEHIST=50000         # Should match HISTSIZE

# nnn
export NNN_PLUG='f:finder;o:fzopen;p:mocq;d:diffs;t:nmount;v:imgview'
export NNN_TMPFILE='/tmp/.lastd' 
export NNN_FCOLORS="a088429691af6ccb84d68e6d"
export NNN_COLORS="#2828283c504a"
export NNN_OPTS="ec" # opener

# =========================================================================================
# Usefull setopt
# =========================================================================================

export HIST_IGNORE_PATTERN='*"*'  # Ignore commands with double quotes

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
# =========================================================================================
# Aliases
# =========================================================================================
# Dependencies: eza, tree, bat, less, ranger, , trash
# gh (github cli + copilot extension), ollama (model: gemma3), tgpt
#
alias ls="eza --icons --group-directories-first --color=auto"           # Default listing with icons
alias lg="eza -l --icons --group-directories-first --color=auto --git"  # Long format with git info
alias la="eza -a --icons --group-directories-first --color=auto"        # Show all files including hidden
alias ll="eza -lh --icons --group-directories-first --color=auto"       # Long format with human-readable sizes
alias tree="eza -T --icons --group-directories-first --color=auto"      # Tree view
alias bat="bat --style=plain --paging=always"
alias update="sudo pacman -Syu && yay"
alias less="less -FRX"
alias r='ranger --choosedir="$HOME/.rangerdir"; LASTDIR=$(cat "$HOME/.rangerdir"); cd "$LASTDIR"'
alias rm="trash"
alias icat="kitty +kitten icat --place 100x100@2x2"
alias compress='tar -czvf'
alias n='nnn'

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

# =========================================================================================
# function
# =========================================================================================
#
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

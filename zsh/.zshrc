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
antidote load ~/.zsh_plugins.txt

# Optional: static bundle for faster startup
antidote bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.zsh
source ~/.zsh_plugins.zsh

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

typeset -U path
path=(
  $HOME/.local/bin       # Local binaries
  # $HOME/.cargo/bin       # Rust binaries
  $HOME/.npm-global/bin  # Global npm binaries
  ${path[@]}             # Preserve existing PATH entries
)
export PATH

# =========================================================================================
# Environment Variables
# =========================================================================================

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

# =========================================================================================
# History Configuration
# =========================================================================================

# Optimize Zsh history file
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

# =========================================================================================
# Aliases
# =========================================================================================

alias lg="eza -l --icons --group-directories-first --color=auto --git"  # Long format with git info
alias tree="eza -T --icons --group-directories-first --color=auto"      # Tree view
alias la="eza -a --icons --group-directories-first --color=auto"        # Show all files including hidden
alias ll="eza -lh --icons --group-directories-first --color=auto"       # Long format with human-readable sizes
alias ls="eza --icons --group-directories-first --color=auto"           # Default listing with icons
alias update="pacman -Syu && yay"

alias r="ranger"
alias gce='gh copilot explain'
alias gcs='gh copilot suggest'
alias gpt="tgpt"

# =========================================================================================
# Keybindings
# =========================================================================================

bindkey -e
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word


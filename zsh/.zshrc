# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

### Added by Zinit's installer
# Install Zinit plugin manager if not already installed.
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

# Source Zinit and set up autoloading for its completion function.
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load Powerlevel10k configuration if it exists.
# To customize the prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# =========================================================================================
# Plugins
# =========================================================================================
zinit light romkatv/powerlevel10k
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-history-substring-search
zinit light zsh-users/zsh-syntax-highlighting
zinit light mrjohannchang/zsh-interactive-cd
# zinit light marlonrichert/zsh-autocomplete
zinit light junegunn/fzf

# =========================================================================================
# Source
# =========================================================================================
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

# =========================================================================================
# Path Management
# =========================================================================================
typeset -U path
path=(
  $HOME/.local/bin       # Local binaries
  $HOME/.cargo/bin       # Rust binaries
  $HOME/.npm-global/bin  # Global npm binaries
  ${path[@]}             # Preserve existing PATH entries
)
export PATH

# =========================================================================================
# Defaults
# =========================================================================================
export EDITOR="code"      # Default editor is Visual Studio Code
export VISUAL="code"      # Default visual editor is Visual Studio Code
export TERMINAL="kitty"   # Default terminal emulator is Kitty
export BRAVE_PASSWORD_STORE=gnome  # Use GNOME keyring as the password store for Brave browser

# =========================================================================================
# Aliases
# =========================================================================================
alias lg="eza -l --icons --group-directories-first --color=auto --git"  # Long format with git info
alias tree="eza -T --icons --group-directories-first --color=auto"      # Tree view
alias la="eza -a --icons --group-directories-first --color=auto"        # Show all files including hidden
alias lA="eza -A --icons --group-directories-first --color=auto"        # Show all files except . and ..
alias ll="eza -lh --icons --group-directories-first --color=auto"       # Long format with human-readable sizes
alias ls="eza --icons --group-directories-first --color=auto"           # Default listing with icons
alias update="sudo pacman -Syu && zinit self-update && zinit update --all"

alias r="ranger"
alias nano='micro'
alias gce='gh copilot explain'
alias gcs='gh copilot suggest'

# =========================================================================================
# Keybindings
# =========================================================================================
bindkey -e
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char
bindkey '^R' fzf-history-widget

# zsh-autocomplete configuration
zstyle ':autocomplete:*' min-input 2  # Start autocomplete after 2 characters
zstyle ':autocomplete:*' max-lines 10 # Limit the number of suggestions

# =========================================================================================
# Variables
# =========================================================================================
# Reduce completion delay
export KEYTIMEOUT=1

# Enable colored output for `ls` and other commands
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

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

# History file configuration
export HISTFILE=~/.zsh_history
export HISTSIZE=50000         # Increased from 10000 for more history retention
export SAVEHIST=50000         # Should match HISTSIZE

# Extract archives
function extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2) tar xjf "$1" ;;
            *.tar.gz) tar xzf "$1" ;;
            *.bz2) bunzip2 "$1" ;;
            *.rar) unrar x "$1" ;;
            *.gz) gunzip "$1" ;;
            *.tar) tar xf "$1" ;;
            *.tbz2) tar xjf "$1" ;;
            *.tgz) tar xzf "$1" ;;
            *.zip) unzip "$1" ;;
            *.Z) uncompress "$1" ;;
            *.7z) 7z x "$1" ;;
            *) echo "Cannot extract '$1'" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}
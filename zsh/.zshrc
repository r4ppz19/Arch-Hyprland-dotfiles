# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# This improves shell startup time by preloading the prompt.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path Management
# Ensure the PATH variable includes custom directories for executables.
typeset -U path
path=(
  $HOME/.local/bin       # Local binaries
  $HOME/.cargo/bin       # Rust binaries
  $HOME/.npm-global/bin  # Global npm binaries
  ${path[@]}             # Preserve existing PATH entries
)
export PATH

# Defaults
# Set default applications for editing, viewing, and terminal usage.
export EDITOR="code"      # Default editor is Visual Studio Code
export VISUAL="code"      # Default visual editor is Visual Studio Code
export TERMINAL="kitty"   # Default terminal emulator is Kitty
export BRAVE_PASSWORD_STORE=gnome  # Use GNOME keyring as the password store for Brave browser

# Aliases
# Define shortcuts for commonly used commands.
alias ls="eza --icons --group-directories-first --color=auto"  # Enhanced ls command
alias r="ranger"                                              # File manager shortcut
# alias rm="trash-put"                                        # Uncomment to use trash-put for safer deletions
alias nano='micro'                                          # Uncomment to replace nano with micro
alias gce='gh copilot explain'                              # Uncomment for GitHub Copilot explain
alias gcs='gh copilot suggest'                              # Uncomment for GitHub Copilot suggest

# Keybindings
# Customize keybindings for better navigation.
bindkey -e  # Use Emacs keybindings (default)
bindkey "^[[1;5D" backward-word  # Ctrl + Left = Move left by word
bindkey "^[[1;5C" forward-word   # Ctrl + Right = Move right by word

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

# Powerlevel10k prompt
zinit ice depth=1
zinit light romkatv/powerlevel10k

# Autosuggestions
zinit light zsh-users/zsh-autosuggestions
# zinit light marlonrichert/zsh-autocomplete

# Completions
zinit light zsh-users/zsh-completions

# History substring search
zinit light zsh-users/zsh-history-substring-search

# Syntax highlighting
# zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-syntax-highlighting
# Directory navigation tools
zinit light mrjohannchang/zsh-interactive-cd

# Load Powerlevel10k configuration if it exists.
# To customize the prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

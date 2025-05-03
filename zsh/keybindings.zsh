# FZF keybindings (keep this!)
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

# =========================================================================================
# Keybindings
# =========================================================================================
bindkey -e  # Explicitly set emacs mode (default but ensures no conflicts)

# Modern word jumps (Alt+←/→ and Ctrl+←/→)
bindkey '^[[1;3D' backward-word    # Alt+←
bindkey '^[[1;3C' forward-word     # Alt+→
bindkey '^[[1;5D' backward-word    # Ctrl+←
bindkey '^[[1;5C' forward-word     # Ctrl+→


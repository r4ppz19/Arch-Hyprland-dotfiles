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


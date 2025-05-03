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

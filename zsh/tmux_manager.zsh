# =================================================================
# Robust TMUX Session Manager
# =================================================================

if [[ -z "$TMUX" ]] && [[ $- == *i* ]] && command -v tmux &>/dev/null; then
  # Color definitions
  local red="\033[31m" green="\033[32m" yellow="\033[33m" reset="\033[0m"
  
  # Get existing sessions
  local sessions=(${(f)"$(tmux list-sessions -F '#{session_name}' 2>/dev/null)"})
  local session_count=${#sessions}
  local choice

  if (( session_count > 0 )); then
    echo "${green}\nTMUX Sessions:${reset}"
    tmux list-sessions
    echo "${yellow}\nPress Enter to attach ${sessions[1]}"
    echo "Options: [number] | n(new) | q(quit)${reset}"

    read -t 30 "choice?Choice (${sessions[1]}/n/q): "
    
    case "$choice" in
      ""|1) 
        tmux attach -t "${sessions[1]}" || echo "${red}Attach failed!${reset}" ;;
      [2-9])
        if (( choice <= session_count )); then
          tmux attach -t "${sessions[choice]}" || echo "${red}Invalid session!${reset}"
        else
          echo "${red}No session $choice${reset}"
        fi ;;
      n|N)
        read "session_name?Session name (default=main): "
        session_name="${session_name//[^a-zA-Z0-9_]/_}"
        tmux new-session -A -s "${session_name:-main}" ;;
      q|Q) : ;;
      *) echo "${red}Invalid choice!${reset}" ;;
    esac
  else
    echo "${yellow}No existing sessions${reset}"
    read "choice?Create new? [Y/n]: "
    case "$choice" in
      n|N) : ;;
      *)
        read "session_name?Session name (default=main): "
        session_name="${session_name//[^a-zA-Z0-9_]/_}"
        tmux new-session -A -s "${session_name:-main}" ;;
    esac
  fi
fi


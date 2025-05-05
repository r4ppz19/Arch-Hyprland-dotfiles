# This file sources other configuration files to keep things modular.
# This .zshrc is located within your dotfiles directory, symlinked to ~/.zshrc.
# The order of sourcing is critical!

# Basic shell setup - check if interactive
# =========================================================================
# Only load interactive-specific configurations in interactive shells.
# This prevents issues when running non-interactive scripts that start with zsh.
if [[ $- == *i* ]]; then

  # =================================================================
  # TMUX Session Manager
  # =================================================================

  if [[ -z "$TMUX" ]] && [[ $- == *i* ]] && command -v tmux &>/dev/null; then
    # Color definitions
    local red="\033[31m" green="\033[32m" yellow="\033[33m" reset="\033[0m"
    
    while true; do
      clear
      # Get existing sessions
      local sessions=(${(f)"$(tmux list-sessions -F '#{session_name}' 2>/dev/null)"})
      local session_count=${#sessions}
      local choice

      if (( session_count > 0 )); then
        echo "${green}Available TMUX Sessions:${reset}"
        tmux list-sessions
        echo "\n${yellow}Press Enter to attach ${sessions[1]}"
        echo "Options: [number] | n(new) | q(quit)${reset}"

        # Timeout handling that exits completely
        if ! read -t 30 "choice?Choice: "; then
          echo "\n${red}Timeout reached, starting normal terminal session.${reset}"
          sleep 1
          clear
          break  # Exit completely to normal shell
        fi

        case "$choice" in
          ""|1)
            clear
            if tmux attach -t "${sessions[1]}" 2>/dev/null; then
              break
            else
              echo "${red}Attach failed! Session may have been removed${reset}"
              sleep 1
              continue
            fi
            ;;

          n|N)
            clear
            read "session_name?Session name (default=main): "
            session_name="${session_name//[^a-zA-Z0-9_]/_}"
            if tmux new-session -A -s "${session_name:-main}" 2>/dev/null; then
              break
            else
              echo "${red}Failed to create session! Invalid name or server problem${reset}"
              sleep 1
              continue
            fi
            ;;

          q|Q)
            clear
            break 2>/dev/null || exit
            ;;

          *)
            if [[ "$choice" =~ ^[0-9]+$ ]]; then
              if (( choice >= 1 && choice <= session_count )); then
                clear
                if tmux attach -t "${sessions[choice]}" 2>/dev/null; then
                  break
                else
                  echo "${red}Attach failed! Session may have been removed${reset}"
                  sleep 1
                  continue
                fi
              else
                echo "${red}No session number $choice${reset}"
                sleep 1
                continue
              fi
            else
              echo "${red}Invalid choice!${reset}"
              sleep 1
              continue
            fi
            ;;
        esac

      else  # No existing sessions
        echo "${yellow}No existing TMUX sessions found${reset}"
        read "choice?Create new session? [Y/n]: "
        case "$choice" in
          n|N)
            clear
            break
            ;;

          *)
            clear
            read "session_name?Session name (default=main): "
            session_name="${session_name//[^a-zA-Z0-9_]/_}"
            if tmux new-session -A -s "${session_name:-main}" 2>/dev/null; then
              break
            else
              echo "${red}Failed to create session! Invalid name or server problem${reset}"
              sleep 1
              continue
            fi
            ;;
        esac
      fi
    done
  fi

  # Instant Prompt (Powerlevel10k) - Load extremely early for perceived speed
  # =========================================================================
  # Load Powerlevel10k instant prompt cache. Keep this near the top!
  # This path is standard and typically outside the dotfiles directory.
  if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
  fi


  # Plugin Management (Antidote) and Completions
  # =========================================================================
  # Initialize Zsh's completion system.  
  autoload -Uz compinit
  compinit
  
  # Load Antidote from its installation directory.
  # Ensure this path is correct for your setup. This is typically a fixed install location.
  source ${ZDOTDIR:-~}/.antidote/antidote.zsh

  # Define the base directory for your Zsh configuration within your dotfiles.
  # Use ${ZDOTDIR:-$HOME} which correctly resolves to your home or ZDOTDIR.
  local dotfiles_zsh_dir="${ZDOTDIR:-$HOME}/Arch-dotfiles/zsh"

  # Path to plugin list and generated file.
  local plugins_txt_path="$dotfiles_zsh_dir/zsh_plugins.txt"
  local plugins_zsh_path="$dotfiles_zsh_dir/zsh_plugins.zsh"

  if [[ ! -f "$plugins_zsh_path" ]]; then
    echo "Generating $plugins_zsh_path..."
    if [[ -f "$plugins_txt_path" ]]; then
      antidote bundle < "$plugins_txt_path" > "$plugins_zsh_path"
      echo "Done generating plugins."
    else
      echo "Error: $plugins_txt_path not found! Cannot generate plugin sourcing file."
      echo "Please ensure $plugins_txt_path exists."
    fi
  fi
  # Source the file generated by Antidote which loads your plugins.
  source "$plugins_zsh_path" || echo "Error sourcing $plugins_zsh_path"

  compinit -D

  # Source Modular Configuration Files
  # =========================================================================
  # Define the base directory for your modular Zsh configuration files.
  # This is the same directory where this .zshrc file resides (via symlink).
  local zsh_config_dir="$dotfiles_zsh_dir" # This is the same variable, just aliased for clarity if needed

  # Source the modular files in a logical sequence from the determined directory.
  if [[ -d "$zsh_config_dir" ]]; then
    # Order explained below, but roughly: Environment -> Behavior -> Commands -> Interactive
    source "$zsh_config_dir/path.zsh"         || echo "Error sourcing $zsh_config_dir/path.zsh"
    source "$zsh_config_dir/env_vars.zsh"     || echo "Error sourcing $zsh_config_dir/env_vars.zsh"
    source "$zsh_config_dir/setopt.zsh"       || echo "Error sourcing $zsh_config_dir/setopt.zsh"
    # Aliases and functions define commands. Source them after environment is ready.
    source "$zsh_config_dir/aliases.zsh"      || echo "Error sourcing $zsh_config_dir/aliases.zsh"
    source "$zsh_config_dir/functions.zsh"    || echo "Error sourcing $zsh_config_dir/functions.zsh"
    # Keybindings define interactive behavior, often relying on functions/aliases. Source last.
    source "$zsh_config_dir/keybindings.zsh"  || echo "Error sourcing $zsh_config_dir/keybindings.zsh"
  else
    echo "Warning: Modular Zsh config directory '$zsh_config_dir' not found. Skipping modular config."
    echo "Please ensure your Zsh dotfiles are in '$dotfiles_zsh_dir'."
  fi


  # Load Powerlevel10k config - Typically loaded last
  # =========================================================================
  # Source the Powerlevel10k configuration file. This applies prompt styles
  # after most other shell settings are established.
  # This file is typically located in your home directory (~/).
  # If you moved this file, update the path accordingly.
  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

fi # End of interactive shell check

# Any configuration that *must* run in non-interactive shells (e.g., basic PATH
# adjustments for scripts) would go here, outside the 'if' block. Based on your
# current config, everything seems interactive-specific.

# End of .zshrc
# =========================================================================

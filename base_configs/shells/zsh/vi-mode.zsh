#=================================================#
#   _    ___              __  ___          __     #
#  | |  / (_)___ ___     /  |/  /___  ____/ /__   #
#  | | / / / __ `__ \   / /|_/ / __ \/ __  / _ \  #
#  | |/ / / / / / / /  / /  / / /_/ / /_/ /  __/  #
#  |___/_/_/ /_/ /_/  /_/  /_/\____/\__,_/\___/   #
#                                                 #
#=================================================#

# INFO: This adds support for extensive vi mode editing
# using the zsh-vi-mode plugin.


export ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK        
export ZVM_KEYTIMEOUT=0
export ZVM_VI_HIGHLIGHT_BACKGROUND=#45475b

# NOTE: This function writes to a hidden file in the home dir.
# This is called each time the vim mode changes and is read from
# to update the dynamic vim mode starship prompt.
# It CAN be safely removed :)
function zvm_after_select_vi_mode() {
  case $ZVM_MODE in
    $ZVM_MODE_NORMAL)
      echo 'n' > "$HOME/.current_vi_mode"
      ;;
    $ZVM_MODE_INSERT)
      echo 'i' > "$HOME/.current_vi_mode"
      ;;
    $ZVM_MODE_VISUAL)
      echo 'v' > "$HOME/.current_vi_mode"
      ;;
    $ZVM_MODE_REPLACE)
      echo 'r' > "$HOME/.current_vi_mode"
      ;;
    $ZVM_MODE_VISUAL_LINE)
      echo 'vl' > "$HOME/.current_vi_mode"
      ;;
  esac
}

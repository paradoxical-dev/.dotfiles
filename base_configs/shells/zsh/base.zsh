#=======================================================#
#      ____                     ______            ____  #
#     / __ )____ _________     / ____/___  ____  / __/  #
#    / __  / __ `/ ___/ _ \   / /   / __ \/ __ \/ /_    #
#   / /_/ / /_/ (__  )  __/  / /___/ /_/ / / / / __/    #
#  /_____/\__,_/____/\___/   \____/\____/_/ /_/_/       #
#                                                       #
#=======================================================#

# INFO: This file will store the base zsh cofniguration,
# including: history, keybinds, startup commands, etc.


#=== HISTORY ===#
HISTSIZE=10000
SAVEHIST=10000
HISTFILE="$HOME/zsh/.zsh_history"
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_ALL_DUPS

# TODO: find out how to inlude OMZ plugins

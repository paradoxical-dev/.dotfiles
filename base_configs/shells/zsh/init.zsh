#========================================= #
#            _____  _____ __  __           #
#           /__  / / ___// / / /           #
#             / /  \__ \/ /_/ /            #
#            / /_____/ / __  /             #
#           /____/____/_/ /_/              #
#                                          #
#========================================= #

# WARNING: This file is not to be edited. It is 
# used to simply source the shell config scripts.
# To edit the shell please view the files within your
# $HOME/zsh directory
                    
ZSH_CONFIG_DIR="$HOME/zsh"

for conf_file in "$ZSH_CONFIG_DIR"/*.zsh; do
    [ -r "$conf_file" ] && source "$conf_file"
done

unset conf_file

#!/bin/bash

#=============================================================#
#  This file stores all functions deemed 'utility functions'  #
#     When called within the main scirpt the following        #
#      functions will be sourced and used throughout          #
#=============================================================#

# @param {string} command
pkg_exists() {
    qlist -I "$1" &> /dev/null || command -v "$1" &> /dev/null
}

handle_backups(){
    local pkg="$1"
    local conf_path="${conf_path_map[$pkg]}"
    local dot_file="${pkg_conf_map[$pkg]}"

    if [[ ! -z "$conf_path" ]]; then
        if [[ -e "$conf_path" ]]; then

            cb() {
                local selection="$pkg"
                case "$selection" in
                    "Move config to .bak")
                        mv "$conf_path" "$conf_path.bak"; 
                        echo -e "$green Backup cpmplete"
                        echo "Copying config file $dot_file to $conf_path"
                        cp "$dot_file" "$conf_path"
                        ;;
                    "Overwrite config")
                        echo -e "${orange}Overwriting config file at $conf_path with $dot_file...${color_end}"
                        cp "$dot_file" "$conf_path"
                        ;;
                    "Skip")
                        echo "Skipping configuration of $pkg"
                        ;;
                esac
            }
            local choices=("Move config to .bak" "Overwrite config" "Skip")
            local prompt="Config file found for $pkg. Next steps?"
            choose_one "$prompt" cb "${choices[@]}"

            unset -f cb

        elif [[ ! -z "$dot_file" && -e $dot_file ]]; then
            echo "Copying config file $dot_file to $conf_path..."
            if ! cp "$dot_file" "$conf_path"; then
                echo -e "${orange}No directory $conf_path. Creating directory...${color_end}"
                mkdir -p "$conf_path"
                cp "$dot_file" "$conf_path"
            fi
        fi
    else
        echo "No config file required for $pkg"
    fi
}

export -f pkg_exists

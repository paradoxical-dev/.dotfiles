#!/bin/bash

#=============================================================#
#  This file stores all functions deemed 'utility functions'  #
#     When called within the main scirpt the following        #
#      functions will be sourced and used throughout          #
#=============================================================#

# Query package list or command existance
# ---
# @param {string} command
pkg_exists() {
    qlist -I "$1" &> /dev/null || command -v "$1" &> /dev/null
}

# Copy directories or files accordingly; creating dirs when needed
# ---
# @param {string} path to source file/dir
# @param {string} path to destination file/dir
dynamic_copy() {
    local source="$1"
    local dest="$2"

    mkdir -p "$(dirname "$dest")"
    if [ -d "$source" ]; then
        cp -r "$source" "$dest"
    else
        cp "$source" "$dest"
    fi
}

# Handle cases where backups may be necessary
# ---
# @param {string} package name
# @param {string} path to potential user config file
# @param {string} path to the stored config file
handle_backups(){
    local pkg="$1"
    local conf_path="$2"
    local dot_file="$3"

    if [[ ! -z "$conf_path" ]]; then
        if [[ -e "$conf_path" ]]; then

            # callback to handle the users backup preference
            cb() {
                local selection="$1"
                case "$selection" in
                    "Move config to .bak")
                        mv "$conf_path" "$conf_path.bak"; 
                        echo -e "$green Backup complete"
                        echo "Copying config file $dot_file to $conf_path"
                        dynamic_copy "$dot_file" "$conf_path"
                        ;;
                    "Overwrite config")
                        echo -e "${orange}Overwriting config file at $conf_path with $dot_file...${color_end}"
                        if [[ -d "$conf_path" ]]; then
                            rm -r "$conf_path"
                        fi
                        dynamic_copy "$dot_file" "$conf_path"
                        ;;
                    "Skip")
                        echo "Skipping configuration of $pkg"
                        ;;
                esac
            }

            # prompt user with backup options
            local choices=("Move config to .bak" "Overwrite config" "Skip")
            local prompt="Config file found for $pkg. Next steps?"
            choose_one "$prompt" cb "${choices[@]}"

            # remove `cb` func from global scope
            unset -f cb

        elif [[ ! -z "$dot_file" && -e $dot_file ]]; then
            # continue config if no user config present and stored config exists
            echo "Copying config file $dot_file to $conf_path..."
            dynamic_copy "$dot_file" "$conf_path"
        fi
    else
        echo "No config file required for $pkg"
    fi
}

export -f pkg_exists
export -f dynamic_copy
export -f handle_backups

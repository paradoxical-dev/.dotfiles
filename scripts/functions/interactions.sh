#!/bin/bash

#===========================================================#
#    This file stores all interaction specific functions    #
#     When called within the main scirpt the following      #
#      functions will be sourced and used throughout        #
#===========================================================#

# allow single selection of given options
# ---
# @param {string} header prompt
# @param {function | command} callback for selection
# @param {list} list of choices
choose_one() {
    local header="$1"
    local cb="$2"
    shift 2
    local choices=("$@")

    local selection=$($gum choose --cursor.foreground "#0fe" \
    --selected.foreground "#0fe" --header.foreground "#f0e" \
    --header="$header" "${choices[@]}")

    "$cb"  "$selection"
}

# allow multiple selections of given options
# ---
# @param {string} header prompt
# @param {function | command} callback for selections
# @param {list} list of choices
choose_multi() {
    local header="$1"
    local cb="$2"
    shift 2
    local choices=("$@")

    local selections=$($gum choose --cursor.foreground "#0fe" \
    --selected.foreground "#0fe" --header.foreground "#f0e" \
    --header="$header" --no-limit "${choices[@]}")

    for selected in $selections; do
        "$cb" "$selected"
    done
}

# prompt the user for confirmation of a given option
# ---
# @param {string} header prompt
gum_confirm() {
    local header="$1"
    
    $gum confirm "$header" \
    --selected.background "#0fe" \
    --prompt.foreground "#0fe"
}

# spinner for commands which require bg work
# ---
# @param {string} spinner prompt
# @param {command} command to wait on
spinner() {
    local title="$1"
    shift

    $gum spin --title "$title" \
    --spinner "points" \
    --spinner.foreground "#0fe" \
    -- "$@"
}

# returns users typed input
# ---
# @param {string} prompt for the user
# @param {string} guide text for the user
input() {
    local header="$1"
    local placeholder="$2"

    $gum input --header "$header" --placeholder "$placeholder" \
    --header.foreground "#0fe" --prompt.foreground "#0fe" \
    --cursor.foreground "#fff"
}

# pretty formatted messages
# ---
# @param {string | list} the message to be displayed
inform_msg() {
    $gum style --border "rounded" --border-foreground "#0fe" \
    --align "center" --width 50 --margin "1 2" --padding "2 4" \
    "$@"
}

# a simple greeter for the script
greet(){
    $gum style --align "center" \
    "Hello and welcome to..." \
     '
        ________            ______                    
       /_  __/ /_  ___     / ____/___  _________ ____ 
        / / / __ \/ _ \   / /_  / __ \/ ___/ __ `/ _ \
       / / / / / /  __/  / __/ / /_/ / /  / /_/ /  __/
      /_/ /_/ /_/\___/  /_/    \____/_/   \__, /\___/ 
                                         /____/       
                                  by paradoxical-dev
     '
    sleep 0.5
}

export -f unmask_package
export -f choose_one
export -f choose_multi
export -f gum_confirm
export -f spinner
export -f input
export -f inform_msg
export -f greet

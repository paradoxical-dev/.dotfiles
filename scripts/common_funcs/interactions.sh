#!/bin/bash

#===========================================================#
#    This file stores all interaction specific functions    #
#     When called within the main scirpt the following      #
#      functions will be sourced and used throughout        #
#===========================================================#

# @param {string} package name
# @param {list | string} keywords
# @param {string} emerge package name 
unmask_package() {
    local pkg=$1
    local keywords=$2
    local pkg_repo=$3

    echo -e "$orangeThe package $pkg is currently masked by keyword(s) $keywords $color_end"
    local unmask=$($gum confirm "Unmask package $1?" --prompt.foreground "#0fe" \
    selected.background "#0fe")
}

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

# @param {string} header prompt
gum_confirm() {
    local header="$1"
    
    $gum confirm "$header" \
    --selected.background "#0fe" \
    --prompt.foreground "#0fe"
}

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

# @param {string | list} the message to be displayed
inform_msg() {
    $gum format --border-foregound "#0fe" --border "rounded" \
    --align "center" --width 50 --margin "1 2" --padding "2 4" \
    "$@"
}

# @param {string} prompt for the user
# @param {string} guide text for the user
input() {
    local header="$1"
    local placeholder="$2"

    $gum input --header "$header" --placeholder "$placeholder" \
    --header.foreground "#0fe" --prompt.foreground "#0fe" \
    --cursor.foreground "#fff"
}

export -f unmask_package
export -f choose_one
export -f choose_multi
export -f gum_confirm
export -f spinner
export -f input

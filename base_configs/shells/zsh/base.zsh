#=======================================================#
#      ____                     ______            ____  #
#     / __ )____ _________     / ____/___  ____  / __/  #
#    / __  / __ `/ ___/ _ \   / /   / __ \/ __ \/ /_    #
#   / /_/ / /_/ (__  )  __/  / /___/ /_/ / / / / __/    #
#  /_____/\__,_/____/\___/   \____/\____/_/ /_/_/       #
#                                                       #
#=======================================================#

# INFO: This will store the base zsh cofniguration,
# including: history, keybinds, startup commands, etc.

#=== DIR CHECKS ===#
if [[ ! -d "${XDG_CONFIG_HOME:-$HOME/.config}/zsh" ]]; then
    mkdir -p $(dirname "${$XDG_CONFIG_HOME:-$HOME/.config}/zsh")
elif [[ ! -d "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/oh-my-zsh" ]]; then
    echo -e "\e[1;33m!!! Oh My Zsh not installed. Installing now...\e[1;0m"
    ZSH="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/oh-my-zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

#=== HISTORY ===#
HISTSIZE=10000
HISTFILE="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/zsh_history"
SAVEHIST=10000
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

#=== KEYBINDS ===#
bindkey -v
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

#=== OMZ ===#
export ZSH="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/oh-my-zsh"
export ZSH_CUSTOM="${ZSH_CUSTOM:-$ZSH/custom}"

for entry in \
    "fzf-tab https://github.com/Aloxaf/fzf-tab" \
    "zsh-vi-mode https://github.com/jeffreytse/zsh-vi-mode" \
    "zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting" \
    "zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions" \
    "zsh-completions https://github.com/zsh-users/zsh-completions"; do

    read -r plugin url <<< "$entry"

    [[ -d "$ZSH_CUSTOM/plugins/$plugin" ]] || git clone "$url" "$ZSH_CUSTOM/plugins/$plugin"
done

plugins=(
    sudo
    copybuffer
    copyfile
    dirhistory
    fzf-tab
    zsh-vi-mode
    zsh-autosuggestions
    zsh-syntax-highlighting
)
fpath+="$ZSH_CUSTOM/plugins/zsh-completions/src"

source $ZSH/oh-my-zsh.sh

#=== MISC ===#
# case insensitive completion
zstyle ":completion:*" matcher-list "m:{a-z}={A-Za-z}"


#========================================#
#       ___    ___                       #
#      /   |  / (_)___ _________  _____  #
#     / /| | / / / __ `/ ___/ _ \/ ___/  #
#    / ___ |/ / / /_/ (__  )  __(__  )   #
#   /_/  |_/_/_/\__,_/____/\___/____/    #
#                                        #
#========================================#
                                   
# INFO: Store your aliases here. These starters
# have been categorized but feel free to break this

#=== APPS ===#
alias c="clear"
alias ff="fastfetch"
alias fe="yazi"
alias v="nvim"
alias wifi="nmtui"
alias ai="aider --model ollama_chat/qwen2.5-coder:14b --weak-model ollama_chat/llama3.2:latest --dark-mode --no-auto-commits --pretty --stream"

#=== PKG MANAGEMENT ===#
# TODO: Update with emerge shortcuts

alias compile-kernel="make && make modules_install && make install"

#=== COMMANDS ===#
alias ls="eza -a --icons"
alias ll="eza -al --icons"
alias lt="eza -a --tree --level=1 --icons"
alias tldr="$HOME/.cargo/bin/tldr" # Only if manually built

#=== GIT ===#
alias gs="git status"
alias ga="git add"
alias gc="git commit -m"
alias gp="git push"
alias gpl="git pull"
alias gst="git stash"
alias gsp="git stash; git pull"
alias gcheck="git checkout"
alias gcredential="git config credential.helper store"
alias gg="lazygit"


#======================================================================#
#       ______           _                                       __    #
#      / ____/___ _   __(_)________  ____  ____ ___  ___  ____  / /_   #
#     / __/ / __ \ | / / / ___/ __ \/ __ \/ __ `__ \/ _ \/ __ \/ __/   #
#    / /___/ / / / |/ / / /  / /_/ / / / / / / / / /  __/ / / / /_     #
#   /_____/_/ /_/|___/_/_/   \____/_/ /_/_/ /_/ /_/\___/_/ /_/\__/     #
#                                                                      #
#======================================================================#

# INFO: Extra environment variables to be used within the shell

#=== THEME CONTROL ===#
export SYSTEM_THEME=$(cat "$HOME/.system-theme")

#=== NVIM MANPAGER ===#
export MANPAGER='nvim +Man!'
                                      

#============================#
#        ______      ____    #
#       / ____/___  / __/    #
#      / /_  /_  / / /_      #
#     / __/   / /_/ __/      #
#    /_/     /___/_/         #
#                            #
#============================#

# INFO: Used to configure Fzf, including menu options
# and tab completion sources

#=== BASE ===#
eval "$(fzf --zsh)"
zstyle ":completion:*" menu no
zstyle ":fzf-tab:complete:cd:*" fzf-preview "eza -1 --color=always $realpath"
zstyle ":fzf-tab:*" use-fzf-default-opts yes

# dynamic theme switching
update_fzf_theme() {
    case "$SYSTEM_THEME" in
        "echelon")
            export FZF_DEFAULT_OPTS='
            --color=fg+:#f8f8fb,bg+:#45475b
            --color=hl:#b4befe,hl+:#94e2d5,info:#f5e0dc,marker:#f38ba8
            --color=prompt:#b4befe,spinner:#94e2d5,pointer:#b4befe,header:#f5c2e7
            --color=border:#404040,label:#aeaeae,query:#f8f8fb
            --border="rounded" --preview-window="border-rounded"
            --prompt=" " --marker=""
            --separator="─" --scrollbar="│" --info="right"'
            ;;
        *)
            export FZF_DEFAULT_OPTS='
            --border="rounded" --preview-window="border-rounded"
            --prompt=" " --marker=""
            --separator="─" --scrollbar="│" --info="right"'
            ;;

    esac
}
SYSTEM_THEME=$(cat "$HOME/.system-theme")
update_fzf_theme

#=== FZF PREVIEWS ===#
# Service status
zstyle ":fzf-tab:complete:rc-service-*:*" fzf-preview "rc-service $word status"

# File content
zstyle ":fzf-tab:complete:*:*" fzf-preview "less $realpath"
export LESSOPEN="|$HOME/.dotfiles/scripts/etc/lessfilter.sh %s"
zstyle ":fzf-tab:complete:*:options" fzf-preview 
zstyle ":fzf-tab:complete:*:argument-1" fzf-preview

# Env vars
zstyle ":fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*" \
fzf-preview "echo ${(P)word}"

# Dynamic man pages for commands
zstyle ":fzf-tab:complete:-command-:*" fzf-preview \
"(out=$(tldr --color always "$word") 2>/dev/null && echo $out) || (out=$(MANWIDTH=$FZF_PREVIEW_COLUMNS man "$word") 2>/dev/null && echo $out) || (out=$(which "$word") && echo $out) || echo "${(P)word}""


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

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

#=== COMMANDS ===#
alias ls="eza -a --icons"
alias ll="eza -al --icons"
alias lt="eza -a --tree --level=1 --icons"
alias shutdown="systemctl poweroff"

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

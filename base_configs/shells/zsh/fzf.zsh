#============================#
#        ______      ____    #
#       / ____/___  / __/    #
#      / /_  /_  / / /_      #
#     / __/   / /_/ __/      #
#    /_/     /___/_/         #
#                            #
#============================#

# INFO: Used to configure Fzf. This can get pretty long
# so its best to keep it separate from the main config

#=== BASE ===#

# TODO: Replace the nix variables with standard values
# TODO: find a way to dynamically update fzf theme values
eval "$(fzf --zsh)"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:*' use-fzf-default-opts yes
export FZF_DEFAULT_OPTS='
--color=fg+:${fzf-colors.fg_plus},bg+:${fzf-colors.bg_plus}
--color=hl:${fzf-colors.hl},hl+:${fzf-colors.hl_plus},info:${fzf-colors.info},marker:${fzf-colors.marker}
--color=prompt:${fzf-colors.prompt},spinner:${fzf-colors.spinner},pointer:${fzf-colors.pointer},header:${fzf-colors.header}
--color=border:${fzf-colors.border},label:#aeaeae,query:${fzf-colors.fg_plus},gutter:-1
--border="rounded" --preview-window="border-rounded"
--prompt=" " --marker=""
--separator="─" --scrollbar="│" --info="right"'


#=== FZF PREVIEWS ===#

# Service status
# zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'rc-service $word status' TODO: needs updated for openrc

# File content
zstyle ':fzf-tab:complete:*:*' fzf-preview 'less $realpath'
export LESSOPEN='|${config.home.homeDirectory}dots/scripts/lessfilter.sh %s'
zstyle ':fzf-tab:complete:*:options' fzf-preview 
zstyle ':fzf-tab:complete:*:argument-1' fzf-preview

# Env vars
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' \
fzf-preview 'echo ''${(P)word}'

# Dynamic man pages for commands
zstyle ':fzf-tab:complete:-command-:*' fzf-preview \
'(out=$(tldr --color always "$word") 2>/dev/null && echo $out) || (out=$(MANWIDTH=$FZF_PREVIEW_COLUMNS man "$word") 2>/dev/null && echo $out) || (out=$(which "$word") && echo $out) || echo "''${(P)word}"'

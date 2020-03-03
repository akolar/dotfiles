bindkey -v

plugins=(git git-flow-completion arch virtualenvwrapper virtualenv-prompt pyenv)

autoload -U compinit
autoload -Uz zcalc
compinit
setopt autocd
setopt hist_ignore_space
setopt share_history
setopt hist_ignore_all_dups

zstyle ':completion:*:processes-names' command          'ps c -u ${USER} -o command | uniq'
zstyle ':completion:*:default'         list-colors      ${(s.:.)LS_COLORS}
zstyle ':completion:*:matches'         group            'yes'
zstyle ':completion:*'                 group-name       ''
zstyle ':completion:*:options'         auto-description '%d'
zstyle ':completion:*:options'         description      'yes'
zstyle ':completion:*'                 verbose          true
zstyle ':completion:*:*:-subscript-:*' tag-order        indexes parameters
zstyle ':completion:*:-command-:*:'    verbose          false
zstyle ':completion:*:warnings'        format           $'%{\e[0;33;4m%}No matches for:%{\e[0m%} %d'
zstyle ':completion:*:descriptions'    format           $'%{\e[0;33;4m%}completing %B%d%b%{\e[0m%}'
zstyle ':completion:*:messages'        format           '%d'

# Vi mode
bindkey '^P' up-line-or-search
bindkey '^N' down-line-or-search
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward
bindkey '^e' history-incremental-search-forward

function zle-line-init zle-keymap-select {
    VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]%  %{$reset_color%}"
    RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/} $EPS1"
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select
export KEYTIMEOUT=1

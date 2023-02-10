# {{{ Abbreviations
alias se='sudoedit'
alias ev='evince'
# }}}
# {{{ Command shortcuts
alias ssh="TERM=xterm-color ssh"
alias dut="du -chd1"
alias copy="xclip -selection clipboard"
alias mysql='mysql -u root -p'
alias yt="youtube-dl -x -o '~/Music/0_Phone/%(title)s.%(ext)s' --audio-format mp3 --audio-quality 320K -i --restrict-filenames"
alias pb='pbpst -S'
alias extract='als -x'
alias pacupg='pacaur -Syu'
alias pacin='pacaur -S'
# }}}
# {{{ ls
unalias ls
alias ls="ls --group-directories-first --color=auto --hide '*.pyc' --hide '__pycache__' --hide '*.class'"
unalias l
alias l="ls -lA1h"
# }}}
# {{{ rm
alias rm='nocorrect rm'
# }}}
# {{{ ZSH
alias -g S='>& /dev/null &!'
# }}}
# {{{ bitwarden
alias bwu="export BW_SESSION=\$(bw unlock | grep -E '^\\\$ export BW_SESSION=' | sed -En 's/^\\\$ export BW_SESSION=\"(.*?)\"\$/\1/p')"
# }}}

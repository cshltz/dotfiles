alias ls='ls --color=auto'
alias l='ls -l'
alias ll='ls -lahF'
alias lls='ls -lahFtr'
alias la='ls -A'
alias lla='ls -lA'
alias lc='ls -CF'

alias vi='nvim'
alias cls='clear'

function cdd(){
    local basePath="/mnt/d/dev/proj"
    if [[ -d "$basePath/$1" ]]; then
        cd "$basePath/$1"
    else
        cd "$basePath"
    fi
}

function rmrf(){
    rm -rf "$@"
}

function rmf(){
    rm -f "$@"
}

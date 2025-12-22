alias ls='ls --color=auto'
alias l='ls -l'
alias ll='ls -lahF'
alias lls='ls -lahFtr'
alias la='ls -A'
alias lla='ls -lA'
alias lc='ls -CF'

alias gs='git status'
alias ga='git add'
alias gaa='git add .'
alias gp='git push'
alias gpo='git push origin'
alias gtd='git tag --delete'
alias gtdr='git tag --delete origin'
alias gr='git branch -r'
alias gplo='git pull origin'
alias gb='git branch '
alias gc='git commit'
alias gcm='git commit -m '
alias gd='git diff'
alias gco='git checkout '
alias gl='git log'
alias gr='git remote'
alias grs='git remote show'
alias glo='git log --pretty="oneline"'
alias glol='git log --graph --oneline --decorate'

alias vi='nvim'
alias vh=nvim_open
alias vicd=nvim_cd_open
alias cdvi=nvim_cd_open

alias cls=clear

function cdd(){
    cd /mnt/d/dev/proj
}

function nvim_open() {
    if [[ -z "$@" ]]; then
        nvim .
    else
        nvim "$@"
    fi
}

function nvim_cd_open() {
    cd "$1" && nv
}

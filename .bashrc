export PS1='\u@\h \w$ '

export HISTSIZE=10000000
export HISTFILESIZE=1000000000
export HISTCONTROL=ignoredups:ignorespace
export HISTTIMEFORMAT="[%F %T] "

export LS_COLORS="$LS_COLORS:ex=01;32"

export PATH="$HOME/.bin:$PATH"
export PATH="$PATH:/opt/homebrew/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/go/bin"

alias ll='ls -lhF --color'
alias la='ls -lahF --color'
alias ltr='ls -ltrhF --color'
alias ..='cd ..'
alias fs='sift --targets --no-conf --exclude-dirs "*.git"'
alias fsp='sift --targets --no-conf --exclude-dirs "*.git" --ipath'

alias tzf='tar tzf'
alias xzf='tar xzf'
alias tjf='tar tjf'
alias xjf='tar xjf'
alias tJf='tar tJf'
alias xJf='tar xJf'

alias vi='nvim -p'
alias rg='rg --smart-case --max-columns=150 --max-columns-preview'

alias ga='git add'
alias gb='git branch'
alias gco='git checkout'
alias gcor='git branch -r | grep -v "\->" | sed "s/origin\///" | fzf --height=40% --reverse | xargs -I {} git checkout {}'
alias gci='git commit'
alias gcia='git commit -a'
alias gd='git diff'
alias gl='git log --pretty=oneline --abbrev-commit --reverse -P | cat'
alias gs='git status'
alias lg='lazygit'

alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

function f { if [[ -d $_ ]] ; then cd $_ ; else cd `dirname $_` ; fi }

function httpdir { python3 -m http.server $1; }

source .bashrc.local

eval "$(fzf --bash)"
eval "$(zoxide init bash --cmd j)"
eval "$(fnm env)"


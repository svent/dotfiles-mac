git_branch_prompt() {
    local b
    b=$(git branch --show-current 2>/dev/null)
    if [[ -n "$b" && "$b" != "main" ]]; then
        printf '\e[32m(%s)\e[0m ' "$b"
    fi
}

export PS1='\u@\h \w $(git_branch_prompt)\$ '

export HISTSIZE=10000000
export HISTFILESIZE=1000000000
export HISTCONTROL=ignoredups:ignorespace
export HISTTIMEFORMAT="[%F %T] "

export LS_COLORS="$LS_COLORS:ex=01;32"
export EDITOR='nvim -p'

export PATH="$HOME/.bin:$PATH"
export PATH="$PATH:/opt/homebrew/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/go/bin"

ulimit -n 40960

alias ll='ls -lhF --color'
alias la='ls -lahF --color'
alias ltr='ls -ltrhF --color'
alias ..='cd ..'

alias tzf='tar tzf'
alias xzf='tar xzf'
alias tjf='tar tjf'
alias xjf='tar xjf'
alias tJf='tar tJf'
alias xJf='tar xJf'

alias vi='nvim -p'
alias rg='rg --smart-case --max-columns=150 --max-columns-preview'
alias y='yazi'

alias ga='git add'
alias gb='git branch'
alias gco='git checkout'
alias gcol='git branch | grep -v "\->" | sed "s/origin\///" | fzf --height=40% --reverse | xargs -I {} git checkout {}'
alias gcor='git branch -r | grep -v "\->" | sed "s/origin\///" | fzf --height=40% --reverse | xargs -I {} git checkout {}'
alias gci='git commit'
alias gcia='git commit -a'
alias gd='git diff'
alias gl='git log --pretty=oneline --abbrev-commit --reverse -P | cat'
alias gs='git status'
alias lg='lazygit'

alias zoc='zo -c'
alias cmsg='git commit -a -e -m "$(git diff HEAD | zo /cmsg)"'
changelog() {
    latest_tag=$(git for-each-ref --sort=-taggerdate --format='%(refname:short)' refs/tags | head -n1)
    echo "changelog since $latest_tag:"
    (git log "$latest_tag.."; git diff "$latest_tag..") | zo '/codex analyze this git log and git diff and update @!CHANGELOG.md to prepare releasing the next version'
}

alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

f() { if [[ -d $_ ]] ; then cd $_ ; else cd `dirname $_` ; fi }

httpdir() { python3 -m http.server $1; }

source ~/.bashrc.local

eval "$(fzf --bash)"
eval "$(zoxide init bash --cmd j)"
eval "$(fnm env)"

# show color always using ls
alias ls='ls --color=always'

# usefull to use with gdb
ulimit -c unlimited

# run last command as sudo
alias fuck='sudo $(history -p \!\!)'

# load colors
if [ -f ~/.colors ]; then
    source ~/.colors
fi

# load git prompt
if [ -f ~/.gitprompt ]; then
    source ~/.gitprompt
fi

# load tmux config
if [ -f .projects.tmux ]; then
	source .projects.tmux
fi

export PS1="\[\$txtgrn\]\n\w\[\$txtrst\] \$git_prompt\n$ "

# osx only
function hide-all-files() {
  defaults write com.apple.finder AppleShowAllFiles NO && killall Finder
}

function show-all-files() {
  defaults write com.apple.finder AppleShowAllFiles YES && killall Finder
}

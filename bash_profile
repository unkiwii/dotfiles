# export important variables
export COCOS2DX_ROOT=/usr/local/etc/cocos2d-x

alias ls='ls --color=always'

ulimit -c unlimited

# find in files
#fif() { grep -w -H -I -r --color=always $1 * | less -r; }
alias grep='grep -w -H -I -r -n --color=always'

export PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/home/lucas/android/sdk/tools:/home/lucas/android/sdk/platform-tools
export NDK_ROOT=/home/lucas/android/ndk

export PROMPT_COMMAND="~/.hgext/hgprompt.sh"
export PS1="\n\[\033[32m\]\w\[\033[0m\]$ "

export LD_LIBRARY_PATH=/usr/lib32:$LD_LIBRARY_PATH

stty -ixon
bind 'Control-s: '

source ~/.jakesnakerc

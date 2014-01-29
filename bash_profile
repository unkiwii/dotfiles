# If not running interactively, don't do anything
case $- in
	*i*) ;;
*) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
	xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
	if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
		# We have color support; assume it's compliant with Ecma-48
		# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
		# a case would tend to support setf rather than setaf.)
		color_prompt=yes
	else
		color_prompt=
	fi
fi

# enable color support
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi

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

if [ -f .jakesnakerc ];
then
	source .jakesnakerc
fi

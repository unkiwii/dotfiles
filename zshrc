# Path to your oh-my-zsh installation.
export ZSH=/Users/lsanchez/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# ZSH_THEME="robbyrussell"
ZSH_THEME="unkiwii"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git golang)

# User configuration

export GOPATH=~/projects/go

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/usr/local/go/bin:/opt/bin:/Users/lsanchez/SDKs/android-sdk/platform-tools:/Users/lsanchez/SDKs/android-sdk/tools:/Users/lsanchez/ant/bin:/Users/lsanchez/SDKs/android-ndk:/Users/lsanchez/projects/go/bin:/opt/bin"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

if [ -f ~/.projects.tmux ]; then
    source ~/.projects.tmux
fi

# if [ -f ~/.colors ]; then
#     source ~/.colors
# fi
# 
# if [ -f ~/.gitprompt ]; then
#     source ~/.gitprompt
# fi

function hide-all-files() {
  defaults write com.apple.finder AppleShowAllFiles NO && killall Finder
}

function show-all-files() {
  defaults write com.apple.finder AppleShowAllFiles YES && killall Finder
}

function ff {
  function __ff_usage__ {
    echo ""
    echo "Find in files recursively starting in the current directory"
    echo ""
    echo "Usage: ff \"FILTER\" TERM"
    echo ""
    echo "  FILTER    in what files to search: *.c, *.go, etc., must be inside quotes"
    echo "  TERM      what to find?"
    echo ""
    echo "Example:"
    echo ""
    echo " Find every call to filter function in all javascript files:"
    echo "  ff \"*.js\" \".filter\""
    echo ""
  }
  if [[ "$1" == "" ]]; then
    __ff_usage__
    return
  fi
  if [[ "$2" == "" ]]; then
    __ff_usage__
    return
  fi
  find . -name "$1" | xargs grep -n "$2"
}

echo `ifconfig en0 | grep "inet " | awk '{print $2}'` > ~/.box-name

alias la='ls -la'
alias goedrans='cd ~/projects/go/src/bitbucket.org/edrans/'
alias metzoo-stg='ssh lsanchez@staging-metzoo01.dev.edrans.net'
alias metzoo-prod='ssh lsanchez@54.68.5.19'

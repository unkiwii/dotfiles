# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="unkiwii"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

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
plugins=(
  web-search
  nvm
  vi-mode
  colored-man-pages
  colorize
  fzf
  autojump
  docker-compose
  docker
  kubectl
  oc
)

# User configuration
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment

export LANG=en_US.UTF-8
# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
alias l='ls -la'

alias gl='git olog'
alias ga='git add'
alias gc='git commit -v'
alias gd='git diff'
alias gco='git checkout'
alias gst='git status'

alias sudo='doas'

bindkey "OD" backward-word
bindkey "OC" forward-word
bindkey "^[a" beginning-of-line
bindkey "^[e" end-of-line
bindkey -M menuselect "^[[Z" reverse-menu-complete

export KEYTIMEOUT=1
export SUDO_ASKPASS=$(which ssh-askpass)

# change vi-mode indicators
NORMAL="%{$fg_bold[blue]%}N%{$fg[blue]%}ORMAL%{$reset_color%}"
INSERT="%{$fg_bold[red]%}I%{$fg[red]%}NSERT%{$reset_color%}"

function vi_mode_prompt_info() {
  echo "${${KEYMAP/vicmd/$NORMAL}/(main|viins)/$INSERT}"
}

function zle-line-init() {
  zle reset-prompt
}
zle -N zle-line-init

if type "prettyping" > /dev/null; then
  alias ping='prettyping --nolegend'
fi

if type "bat" > /dev/null; then
  function bat-im() {
    back=$(head -n 1 ~/.config/current_background)
    bat --theme="gruvbox-$back" $@
  }
  alias cat='bat-im'
fi

if type "exa" > /dev/null; then
  alias l='exa -la'
  export EXA_COLORS="di=1;34:da=0;35"
fi

if [ -f ~/.zshrc.local ]; then
  source ~/.zshrc.local
fi

if [ ! -f ~/.config/current_background ]; then
  echo "dark" > ~/.config/current_background
fi

# ssh
export SSH_ENV="$HOME/.ssh/environment"

if [ ! -f ${SSH_ENV} ]; then
  mkdir "$HOME/.ssh"
  touch ${SSH_ENV}
fi

function start_agent {
  echo "Initializing new SSH agent..."
  /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
  echo "Succeed!"
  chmod 600 "${SSH_ENV}"
  . "${SSH_ENV}" > /dev/null
  /usr/bin/ssh-add;
}

# Source SSH settings, if applicable
if [ -f "${SSH_ENV}" ]; then
  . "${SSH_ENV}" > /dev/null
  ps -ef | ag ${SSH_AGENT_PID} | ag ssh-agent$ > /dev/null || {
    start_agent;
  }
else
  start_agent;
fi

# disables Sowftware Flow Control so Ctrl-s doesn't freezes the terminal emulator
stty -ixon

# Stop closing the shell with Ctrl-d
# see more at man zshoptions > IGNORE_EOF
setopt IGNORE_EOF

# startx if we are in text mode
if [[ ! $TMUX && ! $DISPLAY && $XDG_VTNR == 1 ]]; then
  startx
fi

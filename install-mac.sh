# install Xcode?
# install iTerm2?

# install homebrew
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# install some packages
brew install \
    autojump \
    bat \
    eza \
    fzf \
    golang \
    jq \
    neovim \
    tealdeer \
    the_silver_searcher \
    tmux \
    tree

# update tldr
tldr --update

# configure git
ln -sf ~/dotfiles/gitconfig ~/.gitconfig
ln -sf ~/dotfiles/gitignore ~/.gitignore
ln -sf ~/dotfiles/gitfunctions ~/.gitfunctions

# configure tmux
mkdir -p ~/.config/tmux
ln -sf ~/dotfiles/tmux/tmux.conf ~/.config/tmux/tmux.conf

# install tmux plugins
mkdir -p ~/.config/tmux/plugins
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
cd ~/.config/tmux/plugins/tpm/bindings
./install_plugins
cd -

# configure zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
ln -sf ~/dotfiles/zshrc ~/.zshrc
ln -sf ~/dotfiles/unkiwii.zsh-theme ~/.oh-my-zsh/custom/themes/unkiwii.zsh-theme
cp ~/dotfiles/zshrc.local.template ~/.zshrc.local

# configure neovim
ln -sf ~/dotfiles/nvim ~/.config/nvim

ensure_installed() {
  for arg in $*; do
    if type "$arg" > /dev/null; then
      echo "\e[0;32mFOUND:\e[0m $arg"
    else
      echo "\e[1;31m MISS:\e[0m $arg"
    fi
  done
}

# TODO: install us-altgr-intl.keylayout automatically

ensure_installed \
    ag \
    autojump \
    curl \
    eza \
    fzf \
    git \
    go \
    jq \
    make \
    man \
    nvim \
    ssh \
    tldr \
    tmux \
    tree \
    unzip \
    vim \
    zsh

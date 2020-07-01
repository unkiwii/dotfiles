export LC_ALL=C.UTF-8
export PATH="${PATH}:/usr/local/bin:/usr/local/go/bin:/home/unkiwii/go/bin"

# update packages
apt update

# upgrade system
apt upgrade

# install every base package
apt install -y \
    build-essential \
    make \
    curl \
    git \
    vim \
    tmux \
    zsh \
    autojump \
    unzip \
    man \
    jq \
    feh \
    conky \
    scrot \
    silversearcher-ag

# add nodejs repo and install nodejs (and npm)
curl -sL https://deb.nodesource.com/setup_12.x | bash -
apt install -y nodejs

# install go
curl -sSL https://dl.google.com/go/go1.14.4.linux-amd64.tar.gz | tar -xzC /usr/local

# install prettyping: a 'ping' replacement
mkdir -p /usr/local/bin
curl -sLo /usr/local/bin/prettyping https://raw.githubusercontent.com/denilsonsa/prettyping/master/prettyping \
    && chmod a+x /usr/local/bin/prettyping

# install bat: a 'cat' replacement
curl -sLo bat_0.9.0_amd64.deb https://github.com/sharkdp/bat/releases/download/v0.9.0/bat_0.9.0_amd64.deb \
    && dpkg -i bat_0.9.0_amd64.deb \
    && rm bat_0.9.0_amd64.deb

# install exa: a 'ls' replacement
curl -sLo exa.zip https://github.com/ogham/exa/releases/download/v0.8.0/exa-linux-x86_64-0.8.0.zip \
    && unzip -d /tmp/exa exa.zip \
    && mv /tmp/exa/exa* /usr/local/bin/exa \
    && rm -rf /tmp/exa \
    && rm exa.zip

# install tldr: a nice (and short) 'man'
npm install -g tldr
tldr --update

# configure git
ln -s ~/dotfiles/gitconfig ~/.gitconfig
ln -s ~/dotfiles/gitignore ~/.gitignore

# configure vim
mkdir -p .vim/colors
mkdir -p .vim/bundle
rm -rf .vim/bundle/Vundle.vim
git clone https://github.com/VundleVim/Vundle.vim.git .vim/bundle/Vundle.vim
rm ~/.vimrc
ln -s ~/dotfiles/vim/vimrc ~/.vimrc
rm ~/.vimrc.bundles
ln -s ~/dotfiles/vim/vimrc.bundles ~/.vimrc.bundles
rm ~/.vim/colors/mlessnau.vim
ln -s ~/dotfiles/vim/mlessnau.vim ~/.vim/colors/mlessnau.vim
vim +PluginInstall +qall

# configure tmux
ln -s ~/dotfiles/tmux.conf .tmux.conf

# configure zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
rm .zshrc
ln -s ~/dotfiles/zshrc .zshrc
cp zshrc.local.template ~/.zshrc.local

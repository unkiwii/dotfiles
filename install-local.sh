export LC_ALL=C.UTF-8
export PATH="${PATH}:/usr/local/bin:/usr/local/go/bin:/home/unkiwii/go/bin"

# step 0 (as root)
# apt install doas git
# echo 'permit persist unkiwii as root' > /etc/doas.conf

# step 1 (as unkiwii)
# git clone https://github.com/unkiwii/dotfiles
# sh dotfiles/install-local.sh

# update packages
doas apt update

# upgrade system
doas apt upgrade

# install every base package
doas apt install -y \
    xserver-xorg-core \
    xserver-xorg-video-intel \
    xinit \
    xinput \
    x11-xserver-utils \
    libx11-dev \
    libxinerama-dev \
    libxft-dev \
    libxrandr-dev \
    build-essential \
    fzf \
    make \
    curl \
    vim \
    pipewire \
    firefox-esr \
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

mkdir -p ~/.config

# TODO : git clone vim && configure && compile

# add nodejs repo and install nodejs (and npm)
# curl -sL https://deb.nodesource.com/setup_12.x | bash -
# apt install -y nodejs

# install go
# curl -sSL https://dl.google.com/go/go1.21.6.linux-amd64.tar.gz | tar -xzC /usr/local

# install prettyping: a 'ping' replacement
#mkdir -p /usr/local/bin
#curl -sLo /usr/local/bin/prettyping https://raw.githubusercontent.com/denilsonsa/prettyping/master/prettyping \
#    && chmod a+x /usr/local/bin/prettyping

# install bat: a 'cat' replacement
#curl -sLo bat_0.9.0_amd64.deb https://github.com/sharkdp/bat/releases/download/v0.9.0/bat_0.9.0_amd64.deb \
#    && dpkg -i bat_0.9.0_amd64.deb \
#    && rm bat_0.9.0_amd64.deb

# install exa: a 'ls' replacement
#curl -sLo exa.zip https://github.com/ogham/exa/releases/download/v0.8.0/exa-linux-x86_64-0.8.0.zip \
#    && unzip -d /tmp/exa exa.zip \
#    && mv /tmp/exa/exa* /usr/local/bin/exa \
#    && rm -rf /tmp/exa \
#    && rm exa.zip

# install tldr: a nice (and short) 'man'
#npm install -g tldr
#tldr --update

# install font
doas mkdir -p /usr/share/fonts/opentype
doas cp ~/dotfiles/Inconsolata\ for\ Powerline\ Nerd\ Font\ Complete\ Mono.otf /usr/share/fonts/opentype
doas fc-cache -f -v

# configure git
rm ~/.gitconfig
ln -s ~/dotfiles/gitconfig ~/.gitconfig
rm ~/.gitignore
ln -s ~/dotfiles/gitignore ~/.gitignore

# configure vim
mkdir -p ~/.vim/colors
mkdir -p ~/.vim/bundle
rm -rf ~/.vim/bundle/Vundle.vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
rm ~/.vimrc
ln -s ~/dotfiles/vim/vimrc ~/.vimrc
rm ~/.vimrc.bundles
ln -s ~/dotfiles/vim/vimrc.bundles ~/.vimrc.bundles
rm ~/.vim/colors/mlessnau.vim
ln -s ~/dotfiles/vim/mlessnau.vim ~/.vim/colors/mlessnau.vim
vim +PluginInstall +qall

# configure tmux
rm ~/.tmux.conf
ln -s ~/dotfiles/tmux.conf ~/.tmux.conf
mkdir -p ~/.config/tmux/skins
cp -r ~/dotfiles/tmux/skins ~/.config/tmux/skins

# configure zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
rm ~/.zshrc
ln -s ~/dotfiles/zshrc ~/.zshrc
cp ~/dotfiles/zshrc.local.template ~/.zshrc.local

# configure xinit / suckless
rm ~/work
ln -s ~/dotfiles/suckless/work ~/work
rm ~/.xinitrc
ln -s ~/dotfiles/suckless/xinitrc ~/.xinitrc
rm /usr/local/bin/power-menu
ln -s ~/dotfiles/suckless/power-menu /usr/local/bin/power-menu

# install suckless applications with default config
git clone https://git.suckless.org/dwm ~/.config/dwm
cd ~/.config/dwm
cp config.def.h config.def.h.back
git apply ~/dotfiles/suckless/patches/dwm-config.def.h
mv config.def.h config.h
mv config.def.h.back config.def.h

make
doas make install
cd -

git clone https://git.suckless.org/dmenu ~/.config/dmenu
cd ~/.config/dmenu
cp config.def.h config.h
make
doas make install
cd -

git clone https://git.suckless.org/st ~/.config/st
cd ~/.config/st
cp config.def.h config.def.h.back
git apply ~/dotfiles/suckless/patches/st-config.def.h
mv config.def.h config.h
mv config.def.h.back config.def.h
make
doas make install
cd -

git clone https://git.suckless.org/slock ~/.config/slock
cd ~/.config/slock
cp config.def.h config.def.h.back
git apply ~/dotfiles/suckless/patches/slock-config.def.h
mv config.def.h config.h
mv config.def.h.back config.def.h
make
doas make install
cd -

git clone https://git.suckless.org/slstatus ~/.config/slstatus
cd ~/.config/slstatus
cp config.def.h config.def.h.back
git apply ~/dotfiles/suckless/patches/slstatus-config.def.h
mv config.def.h config.h
mv config.def.h.back config.def.h
make
doas make install
cd -

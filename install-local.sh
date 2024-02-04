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
    xclip \
    ssh \
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
    bat \
    exa \
    tealdeer \
    scrot \
    silversearcher-ag

mkdir -p ~/.config
mkdir -p /usr/local/bin

# fix bat link
doas ln -s $(which /usr/bin/batcat) /usr/local/bin/bat

# update tldr
tldr --update

# install go
# a hacky way to get the latest go version
curl -sSL https://dl.google.com/go/$(curl -sL go.dev/dl | ag linux-amd64 | head -1 | sed 's/^.*\/dl\/\(.*\)">$/\1/') | doas tar -xzC /usr/local

# install Inconsolata font
doas mkdir -p /usr/share/fonts/opentype
doas cp ~/dotfiles/Inconsolata\ for\ Powerline\ Nerd\ Font\ Complete\ Mono.otf /usr/share/fonts/opentype
doas fc-cache -f -v

# configure git
rm ~/.gitconfig
ln -s ~/dotfiles/gitconfig ~/.gitconfig
rm ~/.gitignore
ln -s ~/dotfiles/gitignore ~/.gitignore

# configure tmux
rm ~/.tmux.conf
ln -s ~/dotfiles/tmux.conf ~/.tmux.conf
mkdir -p ~/.config/tmux/skins
cp -r ~/dotfiles/tmux/skins/* ~/.config/tmux/skins

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
doas rm /usr/local/bin/power-menu
doas ln -s ~/dotfiles/suckless/power-menu /usr/local/bin/power-menu

# install suckless applications
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

# TODO : git clone vim && configure && compile (and remove vim from apt install
vim +PluginInstall +qall
vim +GoInstallBinaries +qall

# TODO: check that everything is installed
check() {
  if type "$0" > /dev/null; then
    echo "\e[0;32mFOUND:\e[0m $0"
  else
    echo "\e[1;31m MISS:\e[0m $0"
  fi
}

check xclip
check fzf
check make
check curl
check ssh
check firefox
check tmux
check zsh
check autojump
check unzip
check feh
check tldr
check ag
check scrot
check man
check jq
check dwm
check dmenu
check st
check slstatus
check slock
check go
check startx
check git
check vim

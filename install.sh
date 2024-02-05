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
    libxt-dev \
    libxft-dev \
    libxrandr-dev \
    libncurses-dev \
    build-essential \
    make \
    clang \
    libtool-bin \
    wpagui \
    xclip \
    ssh \
    fzf \
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

mkdir -p ~/.src
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
ln -s ~/dotfiles/tmux/tmux.conf ~/.tmux.conf
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
git clone https://git.suckless.org/dwm ~/.src/dwm
cd ~/.src/dwm
git checkout 6.4
cp config.def.h config.def.h.back
git apply ~/dotfiles/suckless/patches/dwm-config.def.h
mv config.def.h config.h
mv config.def.h.back config.def.h
make
doas make install
cd -

git clone https://git.suckless.org/dmenu ~/.src/dmenu
cd ~/.src/dmenu
cp config.def.h config.h
make
doas make install
cd -

git clone https://git.suckless.org/st ~/.src/st
cd ~/.src/st
cp config.def.h config.def.h.back
git apply ~/dotfiles/suckless/patches/st-config.def.h
mv config.def.h config.h
mv config.def.h.back config.def.h
make
doas make install
cd -

git clone https://git.suckless.org/slock ~/.src/slock
cd ~/.src/slock
cp config.def.h config.def.h.back
git apply ~/dotfiles/suckless/patches/slock-config.def.h
mv config.def.h config.h
mv config.def.h.back config.def.h
make
doas make install
cd -

git clone https://git.suckless.org/slstatus ~/.src/slstatus
cd ~/.src/slstatus
cp config.def.h config.def.h.back
git apply ~/dotfiles/suckless/patches/slstatus-config.def.h
mv config.def.h config.h
mv config.def.h.back config.def.h
make
doas make install
cd -

# compile, install and configure vim
git clone https://github.com/vim/vim.git ~/.src/vim
cd ~/.src/vim/src
./configure \
  --with-features=huge \
  --with-x \
  --disable-netbeans \
  --enable-browse \
  --enable-clipboard \
  --enable-mouseshape
make
doas make install
doas update-alternatives --install /usr/bin/vi vi /usr/local/bin/vim 100
doas update-alternatives --install /usr/bin/vim vim /usr/local/bin/vim 100
doas update-alternatives --install /usr/bin/vim vimdiff /usr/local/bin/vim 100
cd -

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

# Do this always at the end, this could be error prone and perhpahs we should do it in another session
vim +PluginInstall +qall
vim +GoInstallBinaries +qall

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
check wpa_gui

echo "\e[1;31mIMPORTANT: to have a working network follow the next steps\e[0m"
echo ""
echo "$ su -"
echo "$ sh dotfiles/intall-network.sh"

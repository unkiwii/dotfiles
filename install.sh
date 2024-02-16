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
    cmake \
    ninja-build \
    gettext \
    libtool-bin \
    wpagui \
    xclip \
    ssh \
    ssh-askpass \
    fzf \
    curl \
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
    ripgrep \
    silversearcher-ag

mkdir -p ~/.src
mkdir -p ~/.config
mkdir -p /usr/local/bin

# fix bat link
doas ln -s $(which /usr/bin/batcat) /usr/local/bin/bat

# update tldr
tldr --update

# install go
# a hacky way to remove the old go version, get the latest go version and install it
doas rm -rf /usr/local/go && curl -sSL https://dl.google.com/go/$(curl -sL go.dev/dl | ag linux-amd64 | head -1 | sed 's/^.*\/dl\/\(.*\)">$/\1/') | doas tar -xzC /usr/local

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

# configure cron
crontab -u unkiwii ~/dotfiles/cron/crontab

# configure xinit / suckless
rm ~/.xinitrc
ln -s ~/dotfiles/suckless/xinitrc ~/.xinitrc
doas rm /usr/local/bin/power-menu
doas ln -s ~/dotfiles/suckless/power-menu /usr/local/bin/power-menu

# install suckless applications
clone_patch_install() {
  url=$1
  shift

  name=$1
  shift

  patch=$1
  if [ ! -z "$patch" ]; then
    shift
  fi

  branch=""
  if [ ! -z "$1" ]; then
    branch="--branch $1"
    shift
  fi

  rm -rf ~/.src/$name
  git clone --depth 1 $branch https://$url ~/.src/$name

  cd ~/.src/$name

  patchfile=~/dotfiles/suckless/patches/$patch
  if [ -e "$patchfile" ]; then
    git apply $patchfile
  fi

  cp config.def.h config.h
  make
  doas make install
  cd -
}

clone_patch_install git.suckless.org/dwm dwm 'dwm-systray-6.4-config.def.h' 6.4
clone_patch_install git.suckless.org/dmenu dmenu
clone_patch_install git.suckless.org/slock slock 'slock-config.def.h'
clone_patch_install git.suckless.org/st st 'st-config.def.h'
clone_patch_install git.suckless.org/slstatus slstatus 'slstatus-config.def.h'
clone_patch_install github.com/dudik/herbe.git herbe 'herbe-config.def.h'

# compile, install and configure vim
git clone --depth 1 https://github.com/vim/vim.git ~/.src/vim
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
git clone --depth 1 https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
rm ~/.vimrc
ln -s ~/dotfiles/vim/vimrc ~/.vimrc
rm ~/.vimrc.bundles
ln -s ~/dotfiles/vim/vimrc.bundles ~/.vimrc.bundles
rm ~/.vim/colors/mlessnau.vim
ln -s ~/dotfiles/vim/mlessnau.vim ~/.vim/colors/mlessnau.vim

git clone --depth 1 --branch stable https://github.com/neovim/neovim.git ~/.src/neovim
cd ~/.src/neovim
make CMAKE_BUILD_TYPE=RelWithDebInfo
doas make install
cd -

ln -s ~/dotfiles/nvim ~/.config/nvim

# Do this always at the end, this could be error prone and perhpahs we should do it in another session
vim +PluginInstall +qall
vim +GoInstallBinaries +qall

ensure_installed() {
  for arg in $*; do
    if type "$arg" > /dev/null; then
      echo "\e[0;32mFOUND:\e[0m $arg"
    else
      echo "\e[1;31m MISS:\e[0m $arg"
    fi
  done
}

ensure_installed \
    ag \
    autojump \
    curl \
    dmenu \
    dwm \
    feh \
    firefox \
    fzf \
    git \
    go \
    jq \
    make \
    man \
    nvim \
    rg \
    scrot \
    slock \
    slstatus \
    ssh \
    st \
    startx \
    tldr \
    tmux \
    unzip \
    vim \
    wpa_gui \
    xclip \
    zsh

echo "\e[1;31mIMPORTANT: to have a working network follow the next steps\e[0m"
echo ""
echo "$ su -"
echo "$ sh dotfiles/intall-network.sh"

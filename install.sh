export LC_ALL=C.UTF-8
export PATH="${PATH}:/usr/local/bin:/usr/local/go/bin:/home/$USER/go/bin"

# this function always creates a new link removing the old one if is there
replacelink() {
  local src=$1
  local dst=$2
  rm $dst 2>/dev/null
  ln -s $src $dst
}

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
    libpng-dev \
    libjpeg-dev \
    build-essential \
    make \
    clang \
    cmake \
    ninja-build \
    gettext \
    libtool-bin \
    wpagui \
    bind9 \
    resolvconf \
    openvpn \
    nmap \
    pass \
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
    sxiv \
    trash-cli \
    bat \
    exa \
    bc \
    tree \
    tty-clock \
    tealdeer \
    pandoc \
    wkhtmltopdf \
    zathura \
    flameshot \
    ncal \
    ripgrep \
    silversearcher-ag

mkdir -p ~/.src
mkdir -p ~/.config
mkdir -p /usr/local/bin

# fix bat link
doas ln -s $(which /usr/bin/batcat) /usr/local/bin/bat

# install clock
replacelink ~/dotfiles/clock /usr/local/bin/clock

# update tldr
tldr --update

# install sxiv key mappings
mkdir -p ~/.config/sxiv/exec
replacelink ~/dotfiles/sxiv-key-handler ~/.config/sxiv/exec/key-handler

# install zathura configuration
mkdir -p ~/.config/zathura
replacelink ~/dotfiles/zathurarc ~/.config/zathura/zathurarc

# install go
# a hacky way to remove the old go version, get the latest go version and install it
doas rm -rf /usr/local/go && curl -fsSL https://dl.google.com/go/$(curl -sL go.dev/dl | ag linux-amd64 | head -1 | sed 's/^.*\/dl\/\(.*\)">$/\1/') | doas tar -xzC /usr/local

# install fonts
doas mkdir -p /usr/share/fonts/truetype
# Go font
git clone --depth 1 https://go.googlesource.com/image ~/.src/go-image
doas mv ~/.src/go-image/font/gofont/ttfs/*.ttf /usr/share/fonts/truetype
rm -rf ~/.src/go-image
# Inconsolata font
curl -fsSL https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Inconsolata.zip > Inconsolata.zip
unzip -j Inconsolata.zip InconsolataNerdFontMono-Regular.ttf
rm Inconsolata.zip
doas mv InconsolataNerdFontMono-Regular.ttf /usr/share/fonts/truetype/InconsolataNerdFontMono-Regular.ttf
# update fonts cache
doas fc-cache -f -v

# configure git
replacelink ~/dotfiles/gitconfig ~/.gitconfig
replacelink ~/dotfiles/gitignore ~/.gitignore
replacelink ~/dotfiles/gitfunctions ~/.gitfunctions

# configure tmux
replacelink ~/dotfiles/tmux/tmux.conf ~/.tmux.conf
mkdir -p ~/.config/tmux/skins
cp -r ~/dotfiles/tmux/skins/* ~/.config/tmux/skins

# configure zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
doas chsh -s $(which zsh) $USER
replacelink ~/dotfiles/zshrc ~/.zshrc
replacelink ~/dotfiles/unkiwii.zsh-theme ~/.oh-my-zsh/custom/themes/unkiwii.zsh-theme
cp ~/dotfiles/zshrc.local.template ~/.zshrc.local

# configure cron
crontab -u $USER ~/dotfiles/cron/crontab

# download and save github readme template for pandoc
curl -fsSL https://raw.githubusercontent.com/tajmone/pandoc-goodies/master/templates/html5/github/GitHub.html5 > github.html
doas mkdir -p /usr/share/pandoc/data/templates
doas cp github.html /usr/share/pandoc/data/templates/github.html
doas cp github.html /usr/share/pandoc/data/templates/github.html5
rm github.html
doas replacelink ~/dotfiles/mdview /usr/local/bin/mdview

# configure xinit / suckless
doas replacelink ~/dotfiles/suckless/xinitrc ~/.xinitrc
doas replacelink ~/dotfiles/suckless/power-menu /usr/local/bin/power-menu
doas replacelink ~/dotfiles/suckless/save-patch /usr/local/bin/save-patch
doas replacelink ~/dotfiles/suckless/update_monitor_layout /usr/local/bin/update_monitor_layout

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

  rm -rf ~/.src/$name 2>/dev/null
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

clone_patch_install git.suckless.org/dwm dwm 'dwm.patch' 6.4
clone_patch_install git.suckless.org/dmenu dmenu
clone_patch_install git.suckless.org/slock slock 'slock.patch'
clone_patch_install git.suckless.org/st st 'st.patch'
clone_patch_install git.suckless.org/slstatus slstatus 'slstatus.patch'
clone_patch_install git.suckless.org/farbfeld farbfeld
clone_patch_install git.suckless.org/sent sent 'sent.patch'
clone_patch_install github.com/dudik/herbe.git herbe 'herbe.patch'

# compile, install and configure neovim
git clone --depth 1 --branch stable https://github.com/neovim/neovim.git ~/.src/neovim
cd ~/.src/neovim
make CMAKE_BUILD_TYPE=RelWithDebInfo
doas make install
cd -

replacelink ~/dotfiles/nvim ~/.config/nvim

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
    bc \
    curl \
    dmenu \
    dwm \
    feh \
    firefox \
    flameshot \
    fzf \
    git \
    go \
    jq \
    make \
    man \
    ncal \
    nvim \
    rg \
    slock \
    slstatus \
    ssh \
    st \
    startx \
    tldr \
    tmux \
    tree \
    unzip \
    vim \
    wpa_gui \
    xclip \
    zsh

echo "\e[1;31mIMPORTANT: to have a working network follow the next steps\e[0m"
echo ""
echo "$ su -"
echo "$ sh dotfiles/intall-network.sh"

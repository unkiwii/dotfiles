export LC_ALL=C.UTF-8
export PATH="${PATH}:/usr/local/bin:/usr/local/go/bin:/home/$USER/go/bin"

# update packages
doas apt update

# upgrade system
doas apt upgrade

# install every base package
doas apt install -y \
    autojump \
    bat \
    bc \
    bind9 \
    build-essential \
    clang \
    cmake \
    curl \
    exa \
    feh \
    firefox-esr \
    flameshot \
    fzf \
    gettext \
    imagemagick \
    jq \
    libjpeg-dev \
    libncurses-dev \
    libpng-dev \
    libtool-bin \
    libx11-dev \
    libxft-dev \
    libxinerama-dev \
    libxrandr-dev \
    libxt-dev \
    make \
    man \
    ncal \
    ninja-build \
    nmap \
    openvpn \
    pandoc \
    pass \
    picom \
    pipewire \
    python3 \
    python3-pip \
    resolvconf \
    ripgrep \
    silversearcher-ag
    ssh \
    ssh-askpass \
    sxiv \
    tealdeer \
    tmux \
    trash-cli \
    tree \
    tty-clock \
    unzip \
    wkhtmltopdf \
    wpagui \
    x11-xserver-utils \
    xclip \
    xinit \
    xinput \
    xserver-xorg-core \
    xserver-xorg-video-intel \
    zathura \
    zsh \

mkdir -p ~/.src
mkdir -p ~/.config
mkdir -p /usr/local/bin

# fix bat link
doas ln -s $(which /usr/bin/batcat) /usr/local/bin/bat

# install clock
doas ln -sf ~/dotfiles/clock /usr/local/bin/clock
doas ln -sf ~/dotfiles/suckless/clockwall /usr/local/bin/clockwall

# update tldr
tldr --update

# install sxiv key mappings
mkdir -p ~/.config/sxiv/exec
ln -sf ~/dotfiles/sxiv-key-handler ~/.config/sxiv/exec/key-handler

# install zathura configuration
mkdir -p ~/.config/zathura
ln -sf ~/dotfiles/zathurarc ~/.config/zathura/zathurarc

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
echo "if there's no misses, reboot with 'sudo reboot'"
unzip -j Inconsolata.zip InconsolataNerdFontMono-Regular.ttf
rm Inconsolata.zip
doas mv InconsolataNerdFontMono-Regular.ttf /usr/share/fonts/truetype/InconsolataNerdFontMono-Regular.ttf
# configure fonts
mkdir -p ~/.config/fontconfig
ln -sf ~/dotfiles/fonts.conf ~/.config/fontconfig/fonts.conf
# update fonts cache
doas fc-cache -f -v

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
doas chsh -s $(which zsh) $USER
ln -sf ~/dotfiles/zshrc ~/.zshrc
ln -sf ~/dotfiles/zshrc.ssh ~/.zshrc.ssh
ln -sf ~/dotfiles/unkiwii.zsh-theme ~/.oh-my-zsh/custom/themes/unkiwii.zsh-theme
cp ~/dotfiles/zshrc.local.template ~/.zshrc.local

# configure cron
crontab -u $USER ~/dotfiles/cron/crontab
doas mkdir -p /usr/share/sounds
cp ~/dotfiles/cron/notification.mp3 /usr/share/sounds/notification.mp3

# download and save github readme template for pandoc
curl -fsSL https://raw.githubusercontent.com/tajmone/pandoc-goodies/master/templates/html5/github/GitHub.html5 > github.html
doas mkdir -p /usr/share/pandoc/data/templates
doas cp github.html /usr/share/pandoc/data/templates/github.html
doas cp github.html /usr/share/pandoc/data/templates/github.html5
rm github.html
doas ln -sf ~/dotfiles/mdview /usr/local/bin/mdview

# configure xinit / suckless
mkdir -p ~/.config/suckless
ln -sf ~/dotfiles/suckless/xinitrc ~/.xinitrc
ln -sf ~/dotfiles/suckless/Xresources ~/.Xresources
doas ln -sf ~/dotfiles/suckless/power-menu /usr/local/bin/power-menu
doas ln -sf ~/dotfiles/suckless/set-keyboard-layout /usr/local/bin/set-keyboard-layout

# install and configure wal (pywal16)
python3 -m venv ~/.local/lib/python
pip3 install --user pywal16
ln -sf ~/dotfiles/wal/images ~/.config/wal/images
ln -sf ~/dotfiles/wal/after.sh ~/.config/wal/after.sh
rm -r ~/.config/wal/templates
ln -sf ~/dotfiles/wal/templates ~/.config/wal/templates
doas ln -sf ~/dotfiles/wal/wallpapermenu /usr/local/bin/wallpapermenu

# allow user to reboot and shutdown without sudo nor password
sudo tee -a /etc/sudoers.d/00_$USER <<EOF
$USER $HOST=NOPASSWD:/usr/bin/shutdown,/usr/bin/reboot
EOF

# install/configure automatic monitor layout management
doas ln -sf ~/dotfiles/suckless/update-monitor-layout /usr/local/bin/update-monitor-layout
doas ln -sf ~/dotfiles/suckless/99-drm.rules /etc/udev/rules.d/99-drm.rules

# install composer (picom)
mkdir -p ~/.config/picom
ln -sf ~/dotfiles/suckless/picom.conf ~/.config/picom/picom.conf

# install suckless applications
clone_patch_install() {
  url=$1
  shift

  name=$1
  shift

  patch=$1
  [ ! -z "$patch" ] && shift

  branch=""
  [ ! -z "$1" ] && branch="--branch $1" && shift

  rm -rf ~/.src/$name 2>/dev/null
  git clone $branch https://$url ~/.src/$name

  cd ~/.src/$name

  if [ ! -z "$patch" ]; then
    patchfile=~/dotfiles/suckless/patches/$patch
    [ -e "$patchfile" ] && git apply $patchfile
  fi

  make
  doas make install
  cd -
}

clone_patch_install github.com/unkiwii/dwm dwm
clone_patch_install github.com/unkiwii/st st
clone_patch_install github.com/unkiwii/dmenu dmenu
clone_patch_install github.com/unkiwii/slock slock
clone_patch_install github.com/unkiwii/slstatus slstatus
clone_patch_install git.suckless.org/farbfeld farbfeld
clone_patch_install git.suckless.org/sent sent 'sent.patch'
clone_patch_install github.com/dudik/herbe.git herbe 'herbe.patch'

# compile, install and configure neovim
git clone --depth 1 --branch stable https://github.com/neovim/neovim.git ~/.src/neovim
cd ~/.src/neovim
make CMAKE_BUILD_TYPE=RelWithDebInfo
doas make install
cd -
ln -sf ~/dotfiles/nvim ~/.config/nvim

# install todo list applicaton
rm -rf ~/.src/godo 2>/dev/null
git clone https://github.com/unkiwii/godo.git ~/.src/godo
cd ~/.src/godo
go mod tidy
go install ./cmd/godo
doas ln -sf ~/dotfiles/godo/new-godo-window /usr/local/bin/new-godo-window
cd -

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
    wal \
    wpa_gui \
    xclip \
    zsh

echo "\e[1;31mIMPORTANT: to have a working network follow the next steps\e[0m"
echo ""
echo "$ su -"
echo "$ sh dotfiles/intall-network.sh"

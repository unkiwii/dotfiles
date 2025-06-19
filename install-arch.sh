# TODO: before this install git and base-devel packages
# TODO: add to readme: 1. sudo pacman -S git base-devel
# TODO: add to readme: 2. git clone https://github.com/unkiwii/dotfiles
# TODO: add to readme: 3. run install-arch.sh

sudo pacman -S \
  bat \
  bc \
  coreutils \
  cronie \
  curl \
  eza \
  feh \
  flameshot \
  fzf \
  go \
  man-db \
  neovim \
  openssh \
  openvpn \
  pipewire \
  sxiv \
  tealdeer \
  texinfo \
  the_silver_searcher \
  tmux \
  tree \
  ttf-go-nerd \
  ttf-inconsolata-nerd \
  unzip \
  util-linux \
  vim \
  xclip \
  xorg-randr \
  xorg-xinit \
  xorg-xserver \
  zathura \
  zsh

# TODO:: missing packages/programs
# pandoc \
# wkhtmltopdf \
# wpagui \
# bind9 \
# resolvconf \
# nmap \

# turn off go telemetry
go telemetry off

# install yay: an AUR helper
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd -
rm -rf yay

# install packages from AUR
yay -S --noconfirm \
  autojump \
  librewolf-bin \
  tty-clock

mkdir -p ~/.src
mkdir -p ~/.config

# update tldr
tldr --update

# install clock
sudo ln -sf ~/dotfiles/clock /usr/local/bin/clock

# install sxiv key mappings
mkdir -p ~/.config/sxiv/exec
ln -sf ~/dotfiles/sxiv-key-handler ~/.config/sxiv/exec/key-handler

# install zathura configuration
mkdir -p ~/.config/zathura
ln -sf ~/dotfiles/zathurarc ~/.config/zathura/zathurarc

# configure git
ln -sf ~/dotfiles/gitconfig ~/.gitconfig
ln -sf ~/dotfiles/gitignore ~/.gitignore
ln -sf ~/dotfiles/gitfunctions ~/.gitfunctions

# configure tmux
mkdir -p ~/.config/tmux/skins
ln -sf ~/dotfiles/tmux/tmux.conf ~/.config/tmux/tmux.conf
ln -s ~/dotfiles/tmux/skins ~/.config/tmux

# configure zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
doas chsh -s $(which zsh) $USER
ln -sf ~/dotfiles/zshrc ~/.zshrc
ln -sf ~/dotfiles/unkiwii.zsh-theme ~/.oh-my-zsh/custom/themes/unkiwii.zsh-theme
cp ~/dotfiles/zshrc.local.template ~/.zshrc.local

# configure cron
systemctl enable cronie.service
crontab -u $USER ~/dotfiles/cron/crontab

# configure xinit / suckless
ln -sf ~/dotfiles/suckless/xinitrc ~/.xinitrc
sudo ln -sf ~/dotfiles/suckless/power-menu /usr/local/bin/power-menu

# install/configure automatic monitor layout management
sudo ln -sf ~/dotfiles/suckless/update-monitor-layout /usr/local/bin/update-monitor-layout
sudo ln -sf ~/dotfiles/suckless/99-drm.rules /etc/udev/rules.d/99-drm.rules

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
  sudo make install
  cd -
}

# TODO: move everything here to github.com/unkiwii
clone_patch_install github.com/unkiwii/dwm dwm
clone_patch_install github.com/unkiwii/st st
clone_patch_install git.suckless.org/dmenu dmenu
clone_patch_install git.suckless.org/slock slock 'slock.patch'
clone_patch_install git.suckless.org/slstatus slstatus 'slstatus.patch'
clone_patch_install git.suckless.org/farbfeld farbfeld
clone_patch_install git.suckless.org/sent sent 'sent.patch'
clone_patch_install github.com/dudik/herbe.git herbe 'herbe.patch'

# configure neovim
ln -sf ~/dotfiles/nvim ~/.config/nvim

# install todo list applicaton
rm -rf ~/.src/godo 2>/dev/null
git clone https://github.com/unkiwi/godo.git ~/.src/godo
cd ~/.src/godo
go mod tidy
go install ./cmd/godo
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
  bat \
  bc \
  cal \
  crond \
  curl \
  dmenu \
  dwm \
  exa \
  feh \
  flameshot \
  fzf \
  git \
  go \
  jq \
  librewolf \
  make \
  man \
  nvim \
  slock \
  slstatus \
  ssh \
  st \
  startx \
  sxiv \
  tldr \
  tmux \
  tree \
  tty-clock \
  unzip \
  vim \
  wpa_gui \ # TODO: ver después
  xclip \
  zathura \
  zsh

echo "\e[1;31mIMPORTANT: to have a working network follow the next steps\e[0m"
echo ""
echo "$ su -"
echo "$ sh dotfiles/intall-network.sh"

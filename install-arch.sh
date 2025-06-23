# save old sudoers file and replace it with one that let the user run EVERY command without asking for a password
SUDO_FILENAME=00_$USER
SUDO_FILE=/etc/sudoers.d/$SUDO_FILENAME
SUDO_FILE_BACKUP=$HOME/$SUDO_FILENAME
sudo cp $SUDO_FILE $SUDO_FILE_BACKUP && sudo tee $SUDO_FILE <<EOF
$USER ALL=(ALL:ALL)NOPASSWD:ALL
EOF

# update everything
sudo pacman -Syu

# install packages from Arch repos
sudo pacman -S --needed --noconfirm \
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
  jq \
  man-db \
  neovim \
  nvm \
  openssh \
  openvpn \
  pipewire \
  qt5ct \
  sxiv \
  tealdeer \
  texinfo \
  the_silver_searcher \
  thunar \
  tmux \
  tree \
  ttf-inconsolata-nerd \
  noto-fonts-emoji \
  unzip \
  util-linux \
  vim \
  vlc \
  xclip \
  xdotool \
  xorg-server \
  xorg-xinit \
  xorg-xrandr \
  zathura \
  zsh

# TODO:: missing packages/programs
# pandoc \
# wkhtmltopdf \
# wpagui \
# bind9 \
# resolvconf \
# nmap \

mkdir -p ~/.src
mkdir -p ~/.config

# install latest node version
source /usr/share/nvm/init-nvm.sh
nvm install --lts

# install yay: an AUR helper
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd -
rm -rf yay

# install packages from AUR
yay -S --noconfirm \
  adwaita-qt5-git \
  autojump \
  google-chrome \
  librewolf-bin \
  slack-desktop \
  ttf-go-mono-git \
  tty-clock

# configure fonts
mkdir -p ~/.config/fontconfig
ln -sf ~/dotfiles/fonts.conf ~/.config/fontconfig/fonts.conf

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
mkdir -p ~/.config/tmux
ln -sf ~/dotfiles/tmux/tmux.conf ~/.config/tmux/tmux.conf
ln -sf ~/dotfiles/tmux/skins ~/.config/tmux/skins

# install tmux plugins
mkdir -p ~/.config/tmux/plugins
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
cd ~/.config/tmux/plugins/tpm/bindings
./install_plugins
cd -

# configure zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
sudo chsh -s $(which zsh) $USER
ln -sf ~/dotfiles/zshrc ~/.zshrc
ln -sf ~/dotfiles/unkiwii.zsh-theme ~/.oh-my-zsh/custom/themes/unkiwii.zsh-theme
cp ~/dotfiles/zshrc.local.template ~/.zshrc.local

# configure cron
systemctl enable cronie.service
crontab -u $USER ~/dotfiles/cron/crontab

# configure xinit / suckless
ln -sf ~/dotfiles/suckless/xinitrc ~/.xinitrc
sudo ln -sf ~/dotfiles/suckless/power-menu /usr/local/bin/power-menu

# allow user to reboot and shutdown without sudo nor password
sudo tee -a /etc/sudoers.d/00_$USER <<EOF
$USER $HOSTNAME=NOPASSWD:/usr/bin/shutdown,/usr/bin/reboot
EOF

# install/configure automatic monitor layout management
sudo ln -sf ~/dotfiles/suckless/update-monitor-layout /usr/local/bin/update-monitor-layout
sudo ln -sf ~/dotfiles/suckless/99-drm.rules /etc/udev/rules.d/99-drm.rules

# configure gtk theme
mkdir -p ~/.config/gtk-3.0
ln -sf ~/dotfiles/gtk-3.0-settings.ini ~/.config/gtk-3.0/settings.ini

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
clone_patch_install github.com/unkiwii/dmenu dmenu
clone_patch_install github.com/unkiwii/slock slock
clone_patch_install github.com/unkiwii/slstatus slstatus
clone_patch_install git.suckless.org/farbfeld farbfeld
clone_patch_install git.suckless.org/sent sent 'sent.patch'
clone_patch_install github.com/dudik/herbe.git herbe 'herbe.patch'

# configure go
goroot=$(ls -l $(which go) | cut -d '>' -f 2- | cut -d '/' -f 2- | sed 's/\/bin\/go//' | awk '{print "/"$1}')
GOROOT=$goroot go telemetry off
echo "export GOROOT=$goroot" >> .zshrc.local
echo "export GOPATH=$HOME/go" >> .zshrc.local
echo 'export PATH=$PATH:$GOPATH/bin' >> .zshrc.local

# install todo list applicaton
rm -rf ~/.src/godo 2>/dev/null
git clone https://github.com/unkiwii/godo.git ~/.src/godo
cd ~/.src/godo
GOROOT=$goroot go mod tidy
GOROOT=$goroot go install ./cmd/godo
sudo ln -sf ~/dotfiles/godo/new-godo-window /usr/local/bin/new-godo-window
cd -
rm -rf ~/.src/godo

# configure neovim
ln -sf ~/dotfiles/nvim ~/.config/nvim
nvim --headless "+Lazy! sync" +qa

ensure_installed() {
  misses=()
  echo "Checking installed programs"
  for arg in $*; do
    if type "$arg" > /dev/null; then
      echo -n "."
    else
      echo -n "x"
      misses+=($arg)
    fi
  done
  echo ""
  [ ${#misses[@]} -eq 0 ] && echo "Everything is installed correctly"
  for i in $(seq 0 ${#misses[@]}); do
    [ ! -z ${misses[$i]} ] && echo "MISSING: ${misses[$i]}"
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
  vlc \
  xclip \
  zathura \
  zsh

# move the original sudo file to where it belongs
sudo mv $SUDO_FILE_BACKUP $SUDO_FILE

echo ""
echo "DONE"
echo ""

# TODO: Install network applications

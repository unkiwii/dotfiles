echo off
echo Installing...

# set the current installer (brew, apt-get or yum)
if [ "$(uname)" == "Darwin" ]; then
  INSTALL="sudo brew install" #TODO: force yes
else
  if [ -z $(which apt-get) ]; then
    INSTALL="sudo yum install" #TODO: force yes
  else
    INSTALL="sudo apt-get --force-yes --yes install"
  fi
fi

$INSTALL git

$(pwd)/install.vim.sh
$(pwd)/install.tmux.sh
$(pwd)/install.zsh.sh

if [ "$(uname)" == "Linux" ]; then
  $(pwd)/install.urxvt.sh
else
  $INSTALL macvim --override-system-vim
fi

echo Done!
echo on

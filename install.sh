echo Installing...

if [ -z "$INSTALL" ]; then
  echo "Must define INSTALL env var"
  echo ""
  echo "Examples:"
  echo ""
  echo " Debian: apt-get install"
  echo " Fedora: yum install"
  echo "  MacOS: brew install"
  exit 1
fi

$(pwd)/install.git.sh
$(pwd)/install.vim.sh
$(pwd)/install.tmux.sh
$(pwd)/install.zsh.sh

while :
do
  read -p "Do you want to install suckless.org tools (y/n)? " choice
  case "$choice" in
    y|Y )
      echo "installing suckless tools"
      # $(pwd)/install.suckless.sh
      break
      ;;
    n|N )
      break
      ;;
  esac
done

echo Done!

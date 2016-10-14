echo off
echo + [ZSH] Installing...

$INSTALL zsh

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

rm ~/.zshrc >& /dev/null
ln -s $(pwd)/zshrc ~/.zshrc

cp $(pwd)/zshrc.local ~/.zshrc.local

echo + [ZSH] Done!
echo on

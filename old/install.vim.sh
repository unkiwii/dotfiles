echo + [VIM] Installing...

echo install vim 8 by hand or change this script to select the correct version or clone and build

mkdir ~/.vim
mkdir ~/.vim/colors
mkdir ~/.vim/bundle

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

rm ~/.vim/colors/mlessnau.vim >& /dev/null
ln -s $(pwd)/mlessnau.vim ~/.vim/colors/mlessnau.vim

rm ~/.vimrc >& /dev/null
ln -s $(pwd)/vimrc ~/.vimrc

rm ~/.vimrc.bundles >& /dev/null
ln -s $(pwd)/vimrc.bundles ~/.vimrc.bundles

vim +PluginInstall +qall

echo + [VIM] Done!

mkdir ~/.vim
mkdir ~/.vim/colors
mkdir ~/.vim/bundle
mkdir ~/.vim/autoload

curl -Sso ~/.vim/autoload/pathogen.vim https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim

cd ~/.vim/bundle 
rm -rf vizardry
git clone https://github.com/ardagnir/vizardry
cd -

rm ~/.vim/colors/unkiwii.vim >& /dev/null
ln -s $(pwd)/unkiwii.vim ~/.vim/colors/unkiwii.vim

rm ~/.vim/colors/mlessnau.vim >& /dev/null
ln -s $(pwd)/mlessnau.vim ~/.vim/colors/mlessnau.vim

rm ~/.vim/filetype.vim >& /dev/null
ln -s $(pwd)/filetype.vim ~/.vim/filetype.vim

rm ~/.vimrc >& /dev/null
ln -s $(pwd)/vimrc ~/.vimrc

rm ~/.Xdefaults >& /dev/null
ln -s $(pwd)/Xdefaults ~/.Xdefaults

rm -rf ~/.xcolors >& /dev/null
ln -s $(pwd)/xcolors ~/.xcolors

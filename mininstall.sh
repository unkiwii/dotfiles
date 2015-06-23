mkdir ~/.vim
mkdir ~/.vim/colors
mkdir ~/.vim/bundle
mkdir ~/.vim/autoload

curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

cd ~/.vim/bundle 
rm -rf vizardry
git clone https://github.com/ardagnir/vizardry
cd -

rm ~/.tmux.conf >& /dev/null
ln -s $(pwd)/tmux.conf ~/.tmux.conf

rm ~/.vim/colors/unkiwii.vim >& /dev/null
ln -s $(pwd)/unkiwii.vim ~/.vim/colors/unkiwii.vim

rm ~/.vim/colors/mlessnau.vim >& /dev/null
ln -s $(pwd)/mlessnau.vim ~/.vim/colors/mlessnau.vim

rm ~/.vimrc >& /dev/null
ln -s $(pwd)/vimrc ~/.vimrc

rm -rf ~/.projects.tmux >& /dev/null
ln -s $(pwd)/projects.tmux ~/.projects.tmux

sudo rm -rf /usr/bin/vimcat >& /dev/null
sudo ln -s $(pwd)/vimcat /usr/bin/vimcat

echo DONE!

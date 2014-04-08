sudo apt-get install mercurial
sudo apt-get install git
sudo apt-get install tmux
sudo apt-get install vim
sudo apt-get install vim-gtk
sudo apt-get install rxvt-unicode
sudo apt-get install lua5.2
sudo apt-get install conky
sudo apt-get install exuberant-ctags

mkdir ~/.fonts
mkdir ~/.vim
mkdir ~/.vim/colors
mkdir ~/.vim/bundle
mkdir ~/.vim/autoload
mkdir ~/.hgext
mkdir ~/.tasks
mkdir ~/.apps

hg clone http://bitbucket.org/sjl/hg-prompt/ ~/.hgext/hg-prompt
hg clone http://hg@bitbucket.org/astiob/hgshelve ~/.hgext/hg-shelve

cd ~/.apps
hg clone http://bitbucket.org/sjl/t/
cd -

curl -Sso ~/.vim/autoload/pathogen.vim https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim

cd ~/.vim/bundle 
rm -rf vizardry
git clone https://github.com/ardagnir/vizardry
cd -

cp Inconsolata.otf ~/.fonts

rm ~/.bash_profile >& /dev/null
ln -s $(pwd)/bash_profile ~/.bash_profile

rm ~/.fonts.conf >& /dev/null
ln -s $(pwd)/fonts.conf ~/.fonts.conf

rm ~/.hgext/hgprompt.sh >& /dev/null
ln -s $(pwd)/hgprompt.sh ~/.hgext/hgprompt.sh

rm ~/.hgrc >& /dev/null
ln -s $(pwd)/hgrc ~/.hgrc

rm ~/.tmux.conf >& /dev/null
ln -s $(pwd)/tmux.conf ~/.tmux.conf

rm ~/.vim/colors/unkiwii.vim >& /dev/null
ln -s $(pwd)/unkiwii.vim ~/.vim/colors/unkiwii.vim

rm ~/.vim/colors/mlessnau.vim >& /dev/null
ln -s $(pwd)/mlessnau.vim ~/.vim/colors/mlessnau.vim

rm ~/.vimrc >& /dev/null
ln -s $(pwd)/vimrc ~/.vimrc

rm ~/.Xdefaults >& /dev/null
ln -s $(pwd)/Xdefaults ~/.Xdefaults

rm -rf ~/.xcolors >& /dev/null
ln -s $(pwd)/xcolors ~/.xcolors

rm -rf ~/.conky >& /dev/null
ln -s $(pwd)/conky ~/.conky

rm -rf ~/.conkyrc >& /dev/null
ln -s $(pwd)/conkyrc ~/.conkyrc

rm -rf ~/.projects.tmux >& /dev/null
ln -s $(pwd)/projects.tmux ~/.projects.tmux

sudo rm -rf /usr/bin/vimcat >& /dev/null
sudo ln -s $(pwd)/vimcat /usr/bin/vimcat

echo DONE!

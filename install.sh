sudo apt-get install mercurial
sudo apt-get install vim
sudo apt-get install vim-gtk
sudo apt-get install tmux
sudo apt-get install urxvt

mkdir ~/.fonts
mkdir ~/.vim
mkdir ~/.vim/colors
mkdir ~/.vim/bundle
mkdir ~/.vim/autoload
mkdir ~/.hgext

hg clone http://bitbucket.org/sjl/hg-prompt/ ~/.hgext/hg-prompt
hg clone http://hg@bitbucket.org/astiob/hgshelve ~/.hgext/hg-shelve

curl -Sso ~/.vim/autoload/pathogen.vim https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim

cd ~/.vim/bundle 
git clone https://github.com/ardagnir/vizardry
cd -

cp Inconsolata.otf ~/.fonts

if [ -f ~/.bash_profile ];
then
	rm ~/.bash_profile
fi
ln -s $(pwd)/bash_profile ~/.bash_profile

if [ -f ~/.fonts.conf ];
then
	rm ~/.fonts.conf
fi
ln -s $(pwd)/fonts.conf ~/.fonts.conf

if [ -f ~/.hgext/hgprompt.sh ];
then
	rm ~/.hgext/hgprompt.sh
fi
ln -s $(pwd)/hgprompt.sh ~/.hgext/hgprompt.sh

if [ -f ~/.hgrc ];
then
	rm ~/.hgrc
fi
ln -s $(pwd)/hgrc ~/.hgrc

if [ -f ~/.tmux.conf ];
then
	rm ~/.tmux.conf
fi
ln -s $(pwd)/tmux.conf ~/.tmux.conf

if [ -f ~/.vim/colors/unkiwii.vim ];
then
	rm ~/.vim/colors/unkiwii.vim
fi
ln -s $(pwd)/unkiwii.vim ~/.vim/colors/unkiwii.vim

if [ -f ~/.vimrc ];
then
	rm ~/.vimrc
fi
ln -s $(pwd)/vimrc ~/.vimrc

if [ -f ~/.Xdefaults ];
then
	rm ~/.Xdefaults
fi
ln -s $(pwd)/Xdefaults ~/.Xdefaults

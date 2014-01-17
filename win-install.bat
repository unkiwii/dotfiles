mkdir %userprofile%\vimfiles 2> NUL
mkdir %userprofile%\vimfiles\colors 2> NUL
mkdir %userprofile%\vimfiles\bundle 2> NUL
mkdir %userprofile%\vimfiles\autoload 2> NUL

if exist %userprofile%\.hgext (
	rmdir /q /s %userprofile%\.hgext
)
mkdir %userprofile%\.hgext
hg clone http://hg@bitbucket.org/astiob/hgshelve %userprofile%\.hgext\hg-shelve

if exist %userprofile%\vimfiles\autoload\pathogen.vim (
	del %userprofile%\vimfiles\autoload\pathogen.vim
)
git clone https://github.com/tpope/vim-pathogen.git tmpdir
copy tmpdir\autoload\pathogen.vim %userprofile%\vimfiles\autoload\pathogen.vim
rmdir /q /s tmpdir

if exist %userprofile%\vimfiles\bundle\vizardry (
	rmdir /q /s %userprofile%\vimfiles\bundle\vizardry
)
git clone https://github.com/ardagnir/vizardry %userprofile%\vimfiles\bundle\vizardry

if exist %userprofile%\mercurial.ini (
	del %userprofile%\mercurial.ini
)
mklink %userprofile%\mercurial.ini %~dp0win-hgrc

if exist %userprofile%\vimfiles\colors\unkiwii.vim (
	del %userprofile%\vimfiles\colors\unkiwii.vim
)
mklink %userprofile%\vimfiles\colors\unkiwii.vim %~dp0unkiwii.vim

if exist %userprofile%\_vimrc (
	del %userprofile%\_vimrc
)
mklink %userprofile%\_vimrc %~dp0vimrc

regedit /s "win-cmd-colors.reg"

pause

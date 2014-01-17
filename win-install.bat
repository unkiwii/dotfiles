mkdir %userprofile%\vimfiles
mkdir %userprofile%\vimfiles\colors
mkdir %userprofile%\vimfiles\bundle
mkdir %userprofile%\vimfiles\autoload

if exist %userprofile%\.hgext (
	rmdir /q /s %userprofile%\.hgext
)

mkdir %userprofile%\.hgext
hg clone http://hg@bitbucket.org/astiob/hgshelve %userprofile%\.hgext\hg-shelve

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

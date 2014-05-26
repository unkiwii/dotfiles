@echo off

@echo Creating vimfiles folders
mkdir %userprofile%\vimfiles
mkdir %userprofile%\vimfiles\colors
mkdir %userprofile%\vimfiles\bundle
mkdir %userprofile%\vimfiles\autoload

if exist %userprofile%\.hgext (
	rmdir /q /s %userprofile%\.hgext
)
mkdir %userprofile%\.hgext
@echo Mercurial extensions folder created at %userprofile%\.hgext

@echo getting hg-shelve...
hg clone http://hg@bitbucket.org/astiob/hgshelve %userprofile%\.hgext\hg-shelve
@echo hg-shelve cloned!

if exist %userprofile%\vimfiles\autoload\pathogen.vim (
	del %userprofile%\vimfiles\autoload\pathogen.vim
)

@echo getting vim-pathogen
if exist tmpdir (
	rmdir /q /s tmpdir
)
git clone https://github.com/tpope/vim-pathogen.git tmpdir
copy /y tmpdir\autoload\pathogen.vim %userprofile%\vimfiles\autoload\pathogen.vim
rmdir /q /s tmpdir
@echo vim-pathogen cloned!

if exist %userprofile%\vimfiles\bundle\vizardry (
	rmdir /q /s %userprofile%\vimfiles\bundle\vizardry
)

@echo getting vizardry
git clone https://github.com/ardagnir/vizardry %userprofile%\vimfiles\bundle\vizardry
@echo vizardry cloned!

if exist %userprofile%\mercurial.ini (
	del %userprofile%\mercurial.ini
)
mklink %userprofile%\mercurial.ini %~dp0win-hgrc
@echo Link to mercurial.ini made

if exist %userprofile%\vimfiles\colors\unkiwii.vim (
	del %userprofile%\vimfiles\colors\unkiwii.vim
)
mklink %userprofile%\vimfiles\colors\unkiwii.vim %~dp0unkiwii.vim
@echo Link to unkiwii.vim made

if exist %userprofile%\vimfiles\colors\mlessnau.vim (
	del %userprofile%\vimfiles\colors\mlessnau.vim
)
mklink %userprofile%\vimfiles\colors\mlessnau.vim %~dp0mlessnau.vim
@echo Link to mlessnau.vim made

if exist %userprofile%\vimfiles\filetype.vim (
	del %userprofile%\vimfiles\filetype.vim
)
mklink %userprofile%\vimfiles\filetype.vim %~dp0filetype.vim
@echo Link to filetype.vim made

if exist %userprofile%\_vimrc (
	del %userprofile%\_vimrc
)
mklink %userprofile%\_vimrc %~dp0vimrc
@echo Link to _vimrc made

@echo Setting CMD.EXE colors
regedit /s "win-cmd-colors.reg"

@echo Copying PuTTY tools to %userprofile%
copy /y %~dp0putty\*.exe %userprofile%

@echo Adding paegent.exe to startup
regedit /s "putty\win-ssh.reg"
@echo You must use puttygen.exe to generate your ssh key .ppk file and named it hg.ppk

@echo All done.

pause
@echo on

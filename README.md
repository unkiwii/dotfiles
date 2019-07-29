# Install process

## macOS

1. Install [Docker for macOS](https://docs.docker.com/docker-for-mac/install/)
2. Install [iTerm2](https://www.iterm2.com/downloads.html)
4. Run `make build`
5. Run `make start`

## Windows

### TODO

## GNU/Linux

### TODO

# OLD Install process

## Unix/Mac

Run install.sh  

This will install:  
1. mercurial  
2. git  
3. tmux  
4. vim  
5. vim-gtk  
6. rxvt-unicode  
7. lua5.2  
8. conky  
9. exuberant-ctags  

## Windows

### IMPORTANT: You will need to have mercurial and git installed

Run win-install.bat as Administrator.


# Contents

* **bash_profile** : Configuration for bash.
* **BlackMamba.themepack** : A dark theme for Windows 7.
* **conky/** : A folder containing a lua script and an image for conky.
* **conkyrc** : A file with conky configuration.
* **fonts.conf** : Tells gnome (and other compositors) how to render the fonts.
* **hgprompt.sh** : Script configured as `PROMPT_COMMAND` in linux platforms to improve the prompt with `hg prompt`.
* **hgrc** : Global configuration for mercurial.
* **Inconsolata.otf** : A pretty nice monospaced font with antialias.
* **Inconsolata.ttf** : The same font but ttf (for Android).
* **install.sh** : Script to install all files of this repo in a linux platform.
* **install_android.sh** : Script to install files on an Android device.
* **mlessnau.vim** : A dark theme for vim and gvim.
* **project.vimrc.template** : A .vimrc file to load per project. Copy this file to your project folder, rename it to `.project.vimrc` and configure it.
* **projects.tmuxrc** : Functions for bash that creates a new tmux session for a given project.
* **putty/** : A folder with PuTTY tools to use ssh in Windows.
* **tmux.conf** : Configuration file for tmux.
* **unkiwii.vim** : A dark theme for vim and gvim.
* **vimcat** : A nice bash script to print colored files, like cat but with the power of vim synstax highlighting.
* **vimrc** : Global configuration file for vim and gvim.
* **win-cmd-colors.reg** : A windows registry file to change the colors of `CMD.EXE`.
* **win-hgrc** : Global configuration for mercurial (only for Windows). This file will be renamed to `mercurial.ini`.
* **win-install.bat** : Script to install all files of this repo in a windows platform.
* **xcolors/** : A folder with colors for urxvt console emulator.
* **Xdefaults** : Configuration file for urxvt terminal. Works with rxvt also.


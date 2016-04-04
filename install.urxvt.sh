echo off
echo + [URXVT] Installing...

$INSTALL rxvt-unicode

mkdir ~/.fonts
cp Inconsolata.otf ~/.fonts

rm ~/.Xdefaults >& /dev/null
ln -s $(pwd)/Xdefaults ~/.Xdefaults

rm -rf ~/.xcolors >& /dev/null
ln -s $(pwd)/xcolors ~/.xcolors

echo + [URXVT] Done!
echo on

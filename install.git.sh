echo off
echo + [GIT] Installing...

$INSTALL git

rm ~/.gitconfig >& /dev/null
ln -s $(pwd)/gitconfig ~/.gitconfig

echo + [GIT] Done!
echo on

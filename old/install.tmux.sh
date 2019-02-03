echo + [TMUX] Installing...

$INSTALL tmux

rm ~/.tmux.conf >& /dev/null
ln -s $(pwd)/tmux.conf ~/.tmux.conf

rm -rf ~/.projects.tmux >& /dev/null
ln -s $(pwd)/projects.tmux ~/.projects.tmux

echo + [TMUX] Done!

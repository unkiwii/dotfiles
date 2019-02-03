echo + [SUCKLESS] Installing...

mkdir ~/.suckless
cd ~/.suckless

function installtool() {
	git clone http://git.suckless.org/$1
	rm ~/.suckless/$1/config.h >& /dev/null
	if [ -e $(pwd)/suckless/$1-config.h ]; then
		ln -s $(pwd)/suckless/$1-config.h ~/.suckless/$1/config.h
	fi
}

installtool dwm
installtool dmenu
installtool st
installtool slock

echo + [SUCKLESS] Done!

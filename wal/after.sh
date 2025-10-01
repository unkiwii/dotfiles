#!/usr/bin/env sh

# update xrdb
xrdb -merge ~/.Xresources
xrdb -merge ~/.cache/wal/colors-st.Xresources

# reload all st instances
pkill --signal USR1 -x st

# reload all nvim instances
pkill --signal USR1 -x nvim

# TODO:update other applications (dmenu, dwm, slstatus, nvim, etc)

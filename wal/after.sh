#!/usr/bin/env sh

# update xrdb
xrdb -merge ~/.Xresources
xrdb -merge ~/.cache/wal/colors-st.Xresources

# reload all st instances
pidof st | xargs kill -s USR1

# reload all nvim instances
pidof nvim | xargs kill -s USR1

# TODO:update other applications (dmenu, dwm, slstatus, nvim, etc)

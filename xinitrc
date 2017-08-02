#!/bin/sh

# set monitor output
mode="$(xrandr -q | grep -A1 "HDMI-1 connected" | tail -1 | awk '{ print $1 }')"
if [ -n "$mode" ]; then
  xrandr --output eDP1 --mode 1366x768 --pos 0x736 --rotate normal --output HDMI1 --mode 1920x1080 --pos 1366x0 --rotate normal 
else
  xrandr --output eDP1 --mode 1366x768 --pos 0x0   --rotate normal --output HDMI1 --off
fi

# set background
feh --bg-fill '/usr/share/images/deathwing-1920x1080.jpg'

# set keyboard layout
#
# NOTE: all options can be ound at /usr/share/X11/xkb/rules/base.lst
#
# -layout us                      set the keyboard layout to US
# -variant altgr-intl             set the variant to use AltGr for áéíóú ÁÉÍÓÚ ñÑ
# -option                         clear all options
# -option ctrl:nocaps             capslock behave like ctrl
# -option altwin:swap_alt_win     swaps alt and win keys
# -option lv3:ralt_switch         remaps Alt_R to AltGr
setxkbmap \
  -layout us \
  -variant altgr-intl \
  -option \
  -option ctrl:nocaps \
  -option altwin:swap_alt_win \
  -option lv3:ralt_switch

# run conky in background
(conky -q|while read LINE;do xsetroot -name "$LINE";done) &

# start a terminal (with tmux)
(sleep 1s; st -e tmux) &

# network icon for systray
(sleep 3s; nm-applet) &

# and a chat program
(sleep 7s; ~/.TelegramDesktop/Telegram) &

# dropbox init
if [ -f ~/bin/dropbox.py ]; then
  (sleep 60s; ~/bin/dropbox.py start) &
fi

# volume control for systray
(sleep 120s; volumeicon) &

# set xautolock to lock screen after 5 minutes
# (sleep 240s; xautolock -time 5 -locker slock) &

# start dwm
exec dwm

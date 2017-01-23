#!/bin/sh

mode="$(xrandr -q|grep -A1 "HDMI1 connected"| tail -1 |awk '{ print $1 }')"
if [ -n "$mode" ]; then
  xrandr --output HDMI1 --mode 1920x1080 --pos 1366x0 --rotate normal --output eDP1 --mode 1366x768 --pos 0x736 --rotate normal
else
  xrandr --output eDP1 --mode 1366x768
fi

#!/bin/sh

mode="$(xrandr -q|grep -A1 "HDMI1 connected"| tail -1 |awk '{ print $1 }')"
if [ -n "$mode" ]; then
	xrandr --output HDMI1 --mode 1920x1080
	xrandr --output eDP1 --mode 1366x768 --pos 224x1080
else
	xrandr --output eDP1 --mode 1366x768
fi

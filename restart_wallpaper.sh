#!/usr/bin/env bash

pkill -f "wallpaper_loop.sh" 2>/dev/null
pkill -x mpvpaper 2>/dev/null
pkill -x swaybg 2>/dev/null
rm -f /tmp/wallpaper_loop.lock

pgrep -x awww-daemon >/dev/null 2>&1 || awww-daemon >/dev/null 2>&1 &

nohup bash "$HOME/.config/wallpaper_loop.sh" >/dev/null 2>&1 &

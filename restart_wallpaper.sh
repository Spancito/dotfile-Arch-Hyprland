#!/usr/bin/env bash
pkill -f "wallpaper_loop.sh" 2>/dev/null
rm -f /tmp/wallpaper_loop.lock

nohup bash "$HOME/.config/wallpaper_loop.sh" > /tmp/wallpaper.log 2>&1 &

#!/usr/bin/env bash
killall waybar 2>/dev/null
killall swaync 2>/dev/null
sleep 0.1

waybar &
swaync &

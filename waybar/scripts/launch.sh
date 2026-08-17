#!/bin/bash

killall waybar 2>/dev/null
killall swaync 2>/dev/null
sleep 0.2

waybar &
swaync &

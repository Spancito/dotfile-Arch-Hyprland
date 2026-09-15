#!/usr/bin/env bash

DIR="$HOME/.config/wallpapers/Pictures/Wallpapers"

if ! pgrep -x "awww-daemon" > /dev/null; then
    awww-daemon &
    sleep 1
fi

if ! pgrep -x "dunst" > /dev/null; then
    dunst &
    sleep 1
fi

while true; do
    find "$DIR" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.webp" \) | shuf | while read -r img; do
        awww img "$img"
        matugen image "$img" --prefer=darkness
        sleep 3600
    done
done

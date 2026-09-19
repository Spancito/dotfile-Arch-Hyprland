#!/usr/bin/env bash

DIR="$HOME/.config/wallpapers/Pictures/Wallpapers"

while true; do
    archivo=$(find "$DIR" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.webp" -o -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.webm" \) | shuf -n 1)

    if [ -n "$archivo" ]; then
        extension="${archivo##*.}"
        extension=$(echo "$extension" | tr '[:upper:]' '[:lower:]')

        if [ "$extension" = "png" ] || [ "$extension" = "jpg" ] || [ "$extension" = "jpeg" ] || [ "$extension" = "webp" ]; then
            pkill -x mpvpaper
            matugen image -t scheme-expressive "$archivo"
            pkill -x swaybg
            swaybg -i "$archivo" -m fill >/dev/null 2>&1 &
        elif [ "$extension" = "mp4" ] || [ "$extension" = "mkv" ] || [ "$extension" = "webm" ]; then
            pkill -x swaybg
            ffmpeg -y -v error -ss 00:00:02 -i "$archivo" -vframes 1 -update 1 /tmp/current_wallpaper.jpg
            matugen image -t scheme-expressive /tmp/current_wallpaper.jpg
            pkill -x mpvpaper
            mpvpaper -o "no-audio loop-file=inf" "*" "$archivo" >/dev/null 2>&1 &
        fi
    fi

    sleep 600
done

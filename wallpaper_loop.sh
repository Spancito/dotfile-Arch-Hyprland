#!/usr/bin/env bash

LOCKFILE="/tmp/wallpaper_loop.lock"
DIR="$HOME/.config/wallpapers/Pictures/Wallpapers"
INTERVAL=3600

if [ -e "$LOCKFILE" ]; then
    OLD_PID=$(cat "$LOCKFILE" 2>/dev/null)
    if [ -n "$OLD_PID" ] && kill -0 "$OLD_PID" 2>/dev/null; then
        exit 0
    fi
fi

echo $$ > "$LOCKFILE"

trap 'rm -f "$LOCKFILE"; pkill -x swaybg; pkill -x mpvpaper; exit 0' EXIT TERM INT

while true; do
    archivo=$(find "$DIR" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.webp" -o -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.webm" \) | shuf -n 1)

    if [ -n "$archivo" ]; then
        extension="${archivo##*.}"
        extension=$(echo "$extension" | tr '[:upper:]' '[:lower:]')

        if [ "$extension" = "png" ] || [ "$extension" = "jpg" ] || [ "$extension" = "jpeg" ] || [ "$extension" = "webp" ]; then
            pkill -x mpvpaper
            matugen image -t scheme-vibrant "$archivo"
            pkill -x swaybg
            swaybg -i "$archivo" -m fill >/dev/null 2>&1 &
        elif [ "$extension" = "mp4" ] || [ "$extension" = "mkv" ] || [ "$extension" = "webm" ]; then
            pkill -x swaybg
            ffmpeg -y -v error -ss 00:00:02 -i "$archivo" -vframes 1 -update 1 /tmp/current_wallpaper.jpg
            matugen image -t scheme-vibrant /tmp/current_wallpaper.jpg
            pkill -x mpvpaper
            mpvpaper -o "no-audio loop-file=inf" "*" "$archivo" >/dev/null 2>&1 &
        fi
    fi

    sleep $INTERVAL
done

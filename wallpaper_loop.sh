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

        if [[ "$extension" =~ ^(png|jpg|jpeg|webp)$ ]]; then
            pkill -x mpvpaper
            pkill -x swaybg
            swaybg -i "$archivo" -m fill >/dev/null 2>&1 &
            matugen image -t scheme-fidelity "$archivo" >/dev/null 2>&1 &
        elif [[ "$extension" =~ ^(mp4|mkv|webm)$ ]]; then
            pkill -x swaybg
            pkill -x mpvpaper
            mpvpaper -o "no-audio loop" "*" "$archivo" >/dev/null 2>&1 &
            
            filename=$(basename -- "$archivo")
            THUMB_DIR="$HOME/.cache/wallpaper_thumbs"
            mkdir -p "$THUMB_DIR"
            THUMB_PATH="$THUMB_DIR/${filename}.png"
            
            if [ ! -f "$THUMB_PATH" ]; then
                ffmpeg -y -v error -ss 00:00:02 -i "$archivo" -vframes 1 -update 1 "$THUMB_PATH"
            fi
            
            matugen image -t scheme-fidelity "$THUMB_PATH" >/dev/null 2>&1 &
        fi
        
        echo "$archivo" > /tmp/current_wallpaper_path
    fi
    sleep $INTERVAL
done

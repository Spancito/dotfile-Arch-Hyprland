#!/bin/bash

WALL_DIR="$HOME/.config/wallpapers/Pictures/Wallpapers"
THUMB_DIR="$HOME/.cache/wallpaper_thumbs"

mkdir -p "$THUMB_DIR"

ROFI_INPUT=""
while IFS= read -r file; do
    filename=$(basename "$file")
    icon_path="$file"
    
    if [[ "$filename" =~ \.(mp4|mkv|webm)$ ]]; then
        thumb_path="$THUMB_DIR/${filename}.png"
        if [ ! -f "$thumb_path" ]; then
            ffmpeg -y -ss 00:00:01 -i "$file" -vframes 1 -q:v 2 "$thumb_path" &>/dev/null
        fi
        icon_path="$thumb_path"
    fi
    
    ROFI_INPUT+="${filename}\0icon\x1f${icon_path}\n"
done < <(find "$WALL_DIR" -maxdepth 1 -type f \( -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.webm" -o -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.webp" \))

SELECTED=$(echo -e "$ROFI_INPUT" | rofi -dmenu -i -theme "$HOME/.config/rofi/themes/wallpaper.rasi")

if [ -n "$SELECTED" ]; then
    FULL_PATH="$WALL_DIR/$SELECTED"
    extension="${SELECTED##*.}"
    extension=$(echo "$extension" | tr '[:upper:]' '[:lower:]')
    
    if [[ "$extension" =~ ^(png|jpg|jpeg|webp)$ ]]; then
        OLD_PIDS=$(pgrep -x swaybg)
        OLD_VIDS=$(pgrep -x mpvpaper)
        
        swaybg -i "$FULL_PATH" -m fill >/dev/null 2>&1 &
        matugen image -t scheme-fidelity "$FULL_PATH" >/dev/null 2>&1 &
        
        sleep 0.3
        
        [ -n "$OLD_PIDS" ] && echo "$OLD_PIDS" | xargs -r kill 2>/dev/null
        [ -n "$OLD_VIDS" ] && echo "$OLD_VIDS" | xargs -r kill 2>/dev/null
    elif [[ "$extension" =~ ^(mp4|mkv|webm)$ ]]; then
        OLD_PIDS=$(pgrep -x swaybg)
        OLD_VIDS=$(pgrep -x mpvpaper)
        
        mpvpaper -o "no-audio loop" "*" "$FULL_PATH" >/dev/null 2>&1 &
        
        THUMB_PATH="$THUMB_DIR/${SELECTED}.png"
        if [ ! -f "$THUMB_PATH" ]; then
            ffmpeg -y -v error -ss 00:00:02 -i "$FULL_PATH" -vframes 1 -update 1 "$THUMB_PATH"
        fi
        matugen image -t scheme-fidelity "$THUMB_PATH" >/dev/null 2>&1 &
        
        sleep 0.3
        
        [ -n "$OLD_PIDS" ] && echo "$OLD_PIDS" | xargs -r kill 2>/dev/null
        [ -n "$OLD_VIDS" ] && echo "$OLD_VIDS" | xargs -r kill 2>/dev/null
    fi
fi

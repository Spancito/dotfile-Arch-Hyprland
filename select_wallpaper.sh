#!/bin/bash

WALL_DIR="$HOME/.config/wallpapers/Pictures/Wallpapers"
THUMB_DIR="$HOME/.cache/wallpaper_thumbs"

mkdir -p "$THUMB_DIR"

if [ ! -d "$WALL_DIR" ]; then
    notify-send "Error" "La carpeta $WALL_DIR no existe."
    exit 1
fi

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
    
    pkill mpvpaper
    mpvpaper -o "no-audio --loop-playlist --keepaspect=no" '*' "$FULL_PATH" &

    if [[ "$SELECTED" =~ \.(mp4|mkv|webm)$ ]]; then
        TEMP_FRAME="/tmp/matugen_frame.png"
        ffmpeg -y -i "$FULL_PATH" -vframes 1 "$TEMP_FRAME" &>/dev/null
        matugen image "$TEMP_FRAME"
    else
        matugen image "$FULL_PATH"
    fi

    pkill -SIGUSR2 waybar || (killall waybar && waybar &)
    hyprctl reload
fi

#!/usr/bin/env bash

WALL_DIR="$HOME/.config/wallpapers/Pictures/Wallpapers"

pgrep -x awww-daemon >/dev/null 2>&1 || awww-daemon >/dev/null 2>&1 &

ROFI_INPUT=""
while IFS= read -r file; do
  filename=$(basename "$file")
  ROFI_INPUT+="${filename}\0icon\x1f${file}\n"
done < <(find "$WALL_DIR" -maxdepth 1 -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.webp" \))

SELECTED=$(echo -en "$ROFI_INPUT" | rofi -dmenu -i -theme "$HOME/.config/rofi/themes/wallpaper.rasi")

if [ -n "$SELECTED" ]; then
  FULL_PATH="$WALL_DIR/$SELECTED"
  if [ -f "$FULL_PATH" ]; then
    awww img "$FULL_PATH" --transition-type wipe --transition-angle 30 --transition-step 90 --transition-duration 1.5 >/dev/null 2>&1
    python3 "$HOME/.config/apply_theme.py" "$FULL_PATH" >/dev/null 2>&1 &
    echo "$FULL_PATH" >/tmp/current_wallpaper_path
  fi
fi

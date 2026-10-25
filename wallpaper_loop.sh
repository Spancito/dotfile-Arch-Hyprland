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

echo $$ >"$LOCKFILE"
trap 'rm -f "$LOCKFILE"; exit 0' EXIT TERM INT

pgrep -x awww-daemon >/dev/null 2>&1 || awww-daemon >/dev/null 2>&1 &

while true; do
  archivo=$(find "$DIR" -maxdepth 1 -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.webp" \) | shuf -n 1)

  if [ -n "$archivo" ]; then
    awww img "$archivo" --transition-type wipe --transition-angle 30 --transition-step 90 --transition-duration 1.5 >/dev/null 2>&1
    python3 "$HOME/.config/apply_theme.py" "$archivo" >/dev/null 2>&1 &
    echo "$archivo" >/tmp/current_wallpaper_path
  fi

  sleep $INTERVAL &
  wait $!
done

#!/usr/bin/env bash
LOCKFILE="/tmp/wallpaper_loop.lock"
DIR="$HOME/.config/wallpapers/Pictures/Wallpapers"
INTERVAL=600

if [ -e "$LOCKFILE" ]; then
    OLD_PID=$(cat "$LOCKFILE" 2>/dev/null)
    if [ -n "$OLD_PID" ] && kill -0 "$OLD_PID" 2>/dev/null; then
        exit 0
    fi
fi

echo $$ > "$LOCKFILE"

trap 'rm -f "$LOCKFILE"; pkill -x swaybg; pkill -x mpvpaper; exit 0' EXIT TERM INT

get_scheme_type() {
    local filepath="$1"
    python3 -W ignore -c "
import math, sys
from PIL import Image
try:
    img = Image.open(sys.argv[1]).convert('HSV')
    arr = list(img.getdata())
    step = max(1, len(arr) // 5000)
    hues = [h for h, s, v in arr[::step][:5000] if s > 30 and v > 30]
    if len(hues) < 100:
        print('scheme-neutral')
        sys.exit(0)
    angles = [h * 2 * math.pi / 255.0 for h in hues]
    r = math.sqrt(sum(math.sin(a) for a in angles)**2 + sum(math.cos(a) for a in angles)**2) / len(hues)
    if (1 - r) < 0.10:
        print('scheme-neutral')
    else:
        print('scheme-fidelity')
except:
    print('scheme-fidelity')
" "$filepath"
}

while true; do
    archivo=$(find "$DIR" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.webp" -o -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.webm" \) | shuf -n 1)

    if [ -n "$archivo" ]; then
        extension="${archivo##*.}"
        extension=$(echo "$extension" | tr '[:upper:]' '[:lower:]')

        if [ "$extension" = "png" ] || [ "$extension" = "jpg" ] || [ "$extension" = "jpeg" ] || [ "$extension" = "webp" ]; then
            pkill -x mpvpaper
            scheme=$(get_scheme_type "$archivo")
            matugen image -t "$scheme" "$archivo"
            pkill -x swaybg
            swaybg -i "$archivo" -m stretch >/dev/null 2>&1 &
        elif [ "$extension" = "mp4" ] || [ "$extension" = "mkv" ] || [ "$extension" = "webm" ]; then
            pkill -x swaybg
            ffmpeg -y -v error -ss 00:00:02 -i "$archivo" -vframes 1 -update 1 /tmp/current_wallpaper.jpg
            scheme=$(get_scheme_type "/tmp/current_wallpaper.jpg")
            matugen image -t "$scheme" /tmp/current_wallpaper.jpg
            pkill -x mpvpaper
            mpvpaper -o "no-audio loop-file=inf --keepaspect=no" "*" "$archivo" >/dev/null 2>&1 &
        fi
    fi

    sleep $INTERVAL
done

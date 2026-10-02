MY_PID=$$

for pid in $(pgrep -f "wallpaper_loop.sh"); do
    if [ "$pid" -ne "$MY_PID" ]; then
        kill -9 "$pid" 2>/dev/null
    fi
done

pkill -9 mpvpaper 2>/dev/null

nohup bash /home/spancito/.config/wallpaper_loop.sh > /tmp/wallpaper.log 2>&1 &

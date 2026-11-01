import QtQuick
import Quickshell
import Quickshell.Io
import "components"
import "."

ShellRoot {
    id: root

    WallpaperSelector {
        id: wallpaperSelectorModal
        visible: false
    }

    IpcHandler {
        target: "wallpaper"

        function toggle() {
            wallpaperSelectorModal.visible = !wallpaperSelectorModal.visible;
        }
        function open() {
            wallpaperSelectorModal.visible = true;
        }
        function close() {
            wallpaperSelectorModal.visible = false;
        }
        function nextRandom() {
            root.changeRandomWallpaper();
        }
        function reloadTheme() {
            Theme.reload();
        }
    }

    NotificationPopup {
        id: notificationPopup
    }

    Variants {
        model: Quickshell.screens

        delegate: TopBar {
            required property var modelData
            screen: modelData
        }
    }

    Timer {
        id: wallpaperLoopTimer
        interval: 3600000
        running: true
        repeat: true
        triggeredOnStart: false

        onTriggered: {
            root.changeRandomWallpaper();
        }
    }

    Process {
        id: randomWallpaperProc
    }

    function changeRandomWallpaper() {
        var wpDir = Quickshell.env("HOME") + "/.config/wallpapers/Pictures/Wallpapers";
        var cmd = "pgrep -x awww-daemon >/dev/null 2>&1 || awww-daemon >/dev/null 2>&1 & " +
                  "archivo=$(find '" + wpDir + "' -maxdepth 1 -type f \\( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' \\) | shuf -n 1); " +
                  "if [ -n \"$archivo\" ]; then " +
                  "  awww img \"$archivo\" --transition-type any --transition-angle 30 --transition-step 90 --transition-duration 1.5; " +
                  "  python3 " + Quickshell.env("HOME") + "/.config/apply_theme.py \"$archivo\"; " +
                  "  echo \"$archivo\" > /tmp/current_wallpaper_path; " +
                  "fi";
        randomWallpaperProc.running = false;
        randomWallpaperProc.command = ["bash", "-c", cmd];
        randomWallpaperProc.running = true;
    }
}

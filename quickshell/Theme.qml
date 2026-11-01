pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property string colorsPath: Quickshell.env("HOME") + "/.config/hypr/colors/colors.lua"

    property string rawColors: ""
    property var colorsJson: {
        try {
            if (rawColors && rawColors.length > 0) return JSON.parse(rawColors);
        } catch(e) {}
        return {};
    }

    Process {
        id: colorReader
        command: ["python3", "-c", "
import re, json, os
path = os.path.expanduser('~/.config/hypr/colors/colors.lua')
colors = {}
if os.path.exists(path):
    with open(path, 'r') as f:
        for line in f:
            m = re.match(r'M\\.([a-zA-Z0-9_]+)\\s*=\\s*\"rgba\\(([0-9a-fA-F]{6})[0-9a-fA-F]{2}\\)\"', line.strip())
            if m:
                colors[m.group(1)] = '#' + m.group(2)
print(json.dumps(colors))
"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                if (data && data.length > 0) {
                    root.rawColors = data;
                }
            }
        }
    }

    function reload() {
        colorReader.running = true;
    }

    property color primary: colorsJson.primary || "#c5c3ea"
    property color on_primary: colorsJson.on_primary || "#2e2d4c"
    property color secondary: colorsJson.secondary || "#c7c4d7"
    property color on_secondary: colorsJson.on_secondary || "#302f3d"
    property color tertiary: colorsJson.tertiary || "#e9b9cf"
    property color on_tertiary: colorsJson.on_tertiary || "#462637"
    property color surface: colorsJson.surface || "#131318"
    property color on_surface: colorsJson.on_surface || "#e4e1e9"
    property color surface_container: colorsJson.surface_container || "#201f25"
    property color surface_container_high: colorsJson.surface_container_high || "#2a2930"
    property color on_surface_variant: colorsJson.on_surface_variant || "#c8c5d0"
    property color outline: colorsJson.outline || "#928f9a"
    property color error: colorsJson.error || "#ffb4ab"
    property color on_error: colorsJson.on_error || "#690005"

    readonly property color barBackground: Qt.rgba(surface.r, surface.g, surface.b, 0.75)
    readonly property color popupBackground: Qt.rgba(surface_container.r, surface_container.g, surface_container.b, 0.96)
    readonly property color popupBorder: primary
    readonly property color activeBorder: primary
    readonly property color itemHover: Qt.rgba(primary.r, primary.g, primary.b, 0.15)
    readonly property color activeAccent: primary
    readonly property color mutedText: on_surface_variant

    Behavior on primary { ColorAnimation { duration: 350; easing.type: Easing.OutQuad } }
    Behavior on on_primary { ColorAnimation { duration: 350; easing.type: Easing.OutQuad } }
    Behavior on secondary { ColorAnimation { duration: 350; easing.type: Easing.OutQuad } }
    Behavior on tertiary { ColorAnimation { duration: 350; easing.type: Easing.OutQuad } }
    Behavior on surface { ColorAnimation { duration: 350; easing.type: Easing.OutQuad } }
    Behavior on on_surface { ColorAnimation { duration: 350; easing.type: Easing.OutQuad } }
    Behavior on surface_container { ColorAnimation { duration: 350; easing.type: Easing.OutQuad } }
    Behavior on on_surface_variant { ColorAnimation { duration: 350; easing.type: Easing.OutQuad } }
    Behavior on outline { ColorAnimation { duration: 350; easing.type: Easing.OutQuad } }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            root.reload();
        }
    }
}

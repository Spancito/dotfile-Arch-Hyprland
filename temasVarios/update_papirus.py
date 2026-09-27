import sys
import math
import subprocess
import os

def hex_to_rgb(hex_color):
    hex_color = hex_color.lstrip('#')
    return tuple(int(hex_color[i:i+2], 16) for i in (0, 2, 4))

def color_distance(c1, c2):
    return math.sqrt(sum((a - b) ** 2 for a, b in zip(c1, c2)))

papirus_colors = {
    "black": "#323232",
    "blue": "#42A5F5",
    "bluegrey": "#607D8B",
    "breeze": "#4d90fe",
    "brown": "#795548",
    "carmine": "#E32636",
    "cyan": "#00BCD4",
    "darkcyan": "#009688",
    "deeporange": "#FF5722",
    "green": "#4CAF50",
    "grey": "#9E9E9E",
    "indigo": "#3F51B5",
    "magenta": "#E91E63",
    "nordic": "#88c0d0",
    "orange": "#FF9800",
    "palebrown": "#a1887f",
    "paleorange": "#ffb74d",
    "pink": "#F06292",
    "red": "#F44336",
    "teal": "#009688",
    "violet": "#9C27B0",
    "white": "#FAFAFA",
    "yaru": "#E95420",
    "yellow": "#FBC02D"
}

if len(sys.argv) < 2:
    print("Usage: update_papirus.py <hex_color>")
    sys.exit(1)

target_hex = sys.argv[1]
target_rgb = hex_to_rgb(target_hex)

closest_name = "blue"
min_dist = float('inf')

for name, hex_val in papirus_colors.items():
    dist = color_distance(target_rgb, hex_to_rgb(hex_val))
    if dist < min_dist:
        min_dist = dist
        closest_name = name

theme_path = os.path.expanduser("~/.local/share/icons/Papirus-Dark")
print(f"Applying color: {closest_name} to {theme_path}")
subprocess.run(["papirus-folders", "-C", closest_name, "-t", theme_path])

subprocess.run(["gtk-update-icon-cache", "-f", "-t", theme_path], stderr=subprocess.DEVNULL)

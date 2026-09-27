import sys
import os
import subprocess
import shutil
import xml.etree.ElementTree as ET

if len(sys.argv) < 2:
    print("Usage: generate_hyprcursor.py <hex_color>")
    sys.exit(1)

color = sys.argv[1]

state_file = "/tmp/afterglow_dynamic_state"
try:
    with open(state_file, "r") as f:
        state = f.read().strip()
except:
    state = "B"

if state == "A":
    theme_name = "AfterglowDynamic_B"
    next_state = "B"
else:
    theme_name = "AfterglowDynamic_A"
    next_state = "A"

with open(state_file, "w") as f:
    f.write(next_state)

work_dir = "/tmp/hyprcursor_work"
output_dir = os.path.expanduser("~/.local/share/icons/")
src_dir = os.path.expanduser("~/.local/share/Afterglow-Cursors-src/src")

shutil.rmtree(work_dir, ignore_errors=True)
os.makedirs(work_dir, exist_ok=True)
os.makedirs(output_dir, exist_ok=True)

manifest = f"""name = {theme_name}
description = Dynamic Afterglow Cursors
version = 1.0
cursors_directory = hyprcursors
"""
with open(f"{work_dir}/manifest.hl", "w") as f:
    f.write(manifest)

hotspots = {}
config_dir = os.path.join(src_dir, "config")
for cfg_file in os.listdir(config_dir):
    if not cfg_file.endswith(".cursor"): continue
    base = cfg_file[:-7]
    with open(os.path.join(config_dir, cfg_file), "r") as f:
        lines = f.readlines()
        for line in lines:
            parts = line.strip().split()
            if len(parts) >= 4 and parts[0] == "24":
                hx, hy = parts[1], parts[2]
                hotspots[base] = (hx, hy)
                break

aliases = {}
with open(os.path.join(src_dir, "cursorList"), "r") as f:
    lines = f.readlines()
    for line in lines:
        parts = line.strip().split()
        if len(parts) >= 2:
            aliases.setdefault(parts[0], []).append(parts[1])

hyprcursors_dir = f"{work_dir}/hyprcursors"
os.makedirs(hyprcursors_dir, exist_ok=True)

svg_dir = os.path.join(src_dir, "svg")
ET.register_namespace('', 'http://www.w3.org/2000/svg')
ET.register_namespace('cc', 'http://creativecommons.org/ns#')
ET.register_namespace('dc', 'http://purl.org/dc/elements/1.1/')
ET.register_namespace('rdf', 'http://www.w3.org/1999/02/22-rdf-syntax-ns#')

svg_files = [f for f in os.listdir(svg_dir) if f.endswith(".svg")]

for file in svg_files:
    base = file[:-4]
    
    filepath = os.path.join(svg_dir, file)
    tree = ET.parse(filepath)
    root = tree.getroot()
    
    for elem in root.iter():
        tag = elem.tag.split('}')[-1]
        if tag in ['path', 'rect', 'circle', 'polygon', 'polyline']:
            fill = elem.get('fill', '').lower()
            if fill in ['none']:
                continue
            elif fill in ['#fff', '#ffffff']:
                elem.set('fill', '#111111')
            else:
                elem.set('fill', color)
                
    shape_dir = f"{hyprcursors_dir}/{base}"
    os.makedirs(shape_dir, exist_ok=True)
    tree.write(f"{shape_dir}/{file}", encoding="utf-8", xml_declaration=True)
    
    hx, hy = hotspots.get(base, ("0", "0"))
    meta = f"define_size = 32, {file}, {hx}, {hy}\n"
    for alias in aliases.get(base, []):
        meta += f"define_override = {alias}\n"
        
    with open(f"{shape_dir}/meta.hl", "w") as f:
        f.write(meta)

compiled_out = f"/tmp/{theme_name}_compiled"
shutil.rmtree(compiled_out, ignore_errors=True)
os.makedirs(compiled_out, exist_ok=True)

subprocess.run(["hyprcursor-util", "--create", work_dir, "--output", compiled_out], check=True, stdout=subprocess.DEVNULL)

final_dest = f"{output_dir}/{theme_name}"
shutil.rmtree(final_dest, ignore_errors=True)
shutil.copytree(f"{compiled_out}/theme_{theme_name}", final_dest)

subprocess.run(["hyprctl", "setcursor", theme_name, "32"], stdout=subprocess.DEVNULL)
subprocess.run(f"sed -i 's/hl.env(\"HYPRCURSOR_THEME\", .*/hl.env(\"HYPRCURSOR_THEME\", \"{theme_name}\")/' ~/.config/hypr/hyprland.lua", shell=True)

if shutil.which("xcursorgen"):
    xcursor_out = f"/tmp/xcursor_work"
    shutil.rmtree(xcursor_out, ignore_errors=True)
    os.makedirs(xcursor_out, exist_ok=True)
    
    xcursor_theme_dir = f"{output_dir}/{theme_name}/cursors"
    os.makedirs(xcursor_theme_dir, exist_ok=True)
    
    with open(f"{output_dir}/{theme_name}/index.theme", "w") as f:
        f.write(f"[Icon Theme]\nName={theme_name}\n")
        
    for file in svg_files:
        base = file[:-4]
        svg_path = f"{hyprcursors_dir}/{base}/{file}"
        png_path = f"{xcursor_out}/{base}.png"
        
        subprocess.run(["rsvg-convert", "-w", "32", "-h", "32", "-o", png_path, svg_path])
        
        hx, hy = hotspots.get(base, ("0", "0"))
        hx = int(round(float(hx) * (32.0 / 24.0)))
        hy = int(round(float(hy) * (32.0 / 24.0)))
        
        cursor_conf = f"{xcursor_out}/{base}.cursor"
        with open(cursor_conf, "w") as f:
            f.write(f"32 {hx} {hy} {png_path}\n")
            
        out_cursor = f"{xcursor_theme_dir}/{base}"
        subprocess.run(["xcursorgen", cursor_conf, out_cursor])
        
        for ov in aliases.get(base, []):
            ov_path = f"{xcursor_theme_dir}/{ov}"
            if not os.path.exists(ov_path):
                try:
                    os.symlink(base, ov_path)
                except:
                    pass

subprocess.run(f"sed -i 's/hl.env(\"XCURSOR_THEME\", .*/hl.env(\"XCURSOR_THEME\", \"{theme_name}\")/' ~/.config/hypr/hyprland.lua", shell=True)
print(f"Hyprcursor and Xcursor themes '{theme_name}' generated successfully.")
subprocess.run(["gsettings", "set", "org.gnome.desktop.interface", "cursor-theme", theme_name])
subprocess.run(["gsettings", "set", "org.gnome.desktop.interface", "cursor-size", "32"])
subprocess.run(["dbus-update-activation-environment", "--systemd", f"XCURSOR_THEME={theme_name}", "XCURSOR_SIZE=32", f"HYPRCURSOR_THEME={theme_name}", "HYPRCURSOR_SIZE=32"])

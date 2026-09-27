import json, os

settings_path = os.path.expanduser("~/.config/Code - OSS/User/settings.json")
theme_path = os.path.expanduser("~/.config/matugen/vscode-colors-generated.json")

try:
    with open(settings_path, "r") as f:
        settings = json.load(f)
except Exception:
    settings = {}

try:
    with open(theme_path, "r") as f:
        theme = json.load(f)
except Exception as e:
    print(f"Error reading theme: {e}")
    exit(1)

theme["window.transparent"] = True
settings.update(theme)

os.makedirs(os.path.dirname(settings_path), exist_ok=True)
with open(settings_path, "w") as f:
    json.dump(settings, f, indent=4)

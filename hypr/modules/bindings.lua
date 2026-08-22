--- Keybindings --

local terminal      = "kitty"
local fileManager   = "thunar"
local menu          = "rofi -show drun -theme ~/.config/rofi/.local/share/rofi/themes/minimal.rasi"
local mainMod       = "SUPER"


hl.bind(mainMod .. " + T",         hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E",         hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + D",         hl.dsp.exec_cmd("pkill rofi || " .. menu))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("walset"))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("~/.config/waybar/scripts/launch.sh"))
hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd("~/.config/hypr/scripts/wlogout.sh"))
hl.bind(mainMod .. " + N",     hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))

hl.bind(mainMod .. " + Q", hl.dsp.window.close()) 
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + O", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + P", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + ESCAPE", hl.dsp.exec_cmd('pactl set-source-mute @DEFAULT_SOURCE@ toggle && (pactl get-source-mute @DEFAULT_SOURCE@ | grep -q "yes" && notify-send -t 1000 "Micrófono" "Muteado" -i microphone-sensitivity-muted-symbolic || notify-send -t 1000 "Micrófono" "Desmuteado" -i microphone-sensitivity-high-symbolic)'))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("brave"))
hl.bind(mainMod .. " + G", hl.dsp.exec_cmd("brave --app=https://gemini.google.com"))
hl.bind(mainMod .. " + H", hl.dsp.exec_cmd("brave --app=https://web.whatsapp.com"))

-- flechas --
hl.bind("MOD5 + W", hl.dsp.send_shortcut({mods = "", key = "Up",window = "activewindow",}), { repeating = true }) 
hl.bind("MOD5 + A", hl.dsp.send_shortcut({mods = "", key = "Left", window = "activewindow",}), { repeating = true })
hl.bind("MOD5 + S", hl.dsp.send_shortcut({mods = "", key = "Down", window = "activewindow",}), { repeating = true })
hl.bind("MOD5 + D", hl.dsp.send_shortcut({mods = "", key = "Right", window = "activewindow",}), { repeating = true })
hl.bind("SHIFT + MOD5 + W", hl.dsp.send_shortcut({mods = "SHIFT", key = "Up", window = "activewindow",}), { repeating = true })
hl.bind("SHIFT + MOD5 + A", hl.dsp.send_shortcut({mods = "SHIFT", key = "Left", window = "activewindow",}), { repeating = true })
hl.bind("SHIFT + MOD5 + S", hl.dsp.send_shortcut({mods = "SHIFT", key = "Down", window = "activewindow",}), { repeating = true })
hl.bind("SHIFT + MOD5 + D", hl.dsp.send_shortcut({mods = "SHIFT", key = "Right", window = "activewindow",}), { repeating = true })
hl.bind("CTRL + MOD5 + W", hl.dsp.send_shortcut({mods = "CTRL", key = "Up", window = "activewindow",}), { repeating = true })
hl.bind("CTRL + MOD5 + A", hl.dsp.send_shortcut({mods = "CTRL", key = "Left", window = "activewindow",}), { repeating = true })
hl.bind("CTRL + MOD5 + S", hl.dsp.send_shortcut({mods = "CTRL", key = "Down", window = "activewindow",}), { repeating = true })
hl.bind("CTRL + MOD5 + D", hl.dsp.send_shortcut({mods = "CTRL", key = "Right", window = "activewindow",}), { repeating = true })
hl.bind("CTRL + SHIFT + MOD5 + W", hl.dsp.send_shortcut({mods = "CTRL SHIFT", key = "Up", window = "activewindow",}), { repeating = true })
hl.bind("CTRL + SHIFT + MOD5 + A", hl.dsp.send_shortcut({mods = "CTRL SHIFT", key = "Left", window = "activewindow",}), { repeating = true })
hl.bind("CTRL + SHIFT + MOD5 + S", hl.dsp.send_shortcut({mods = "CTRL SHIFT", key = "Down", window = "activewindow",}), { repeating = true })
hl.bind("CTRL + SHIFT + MOD5 + D", hl.dsp.send_shortcut({mods = "CTRL SHIFT", key = "Right", window = "activewindow",}), { repeating = true })

--- move and focus ---
hl.bind(mainMod .. " + J",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + I",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + K",  hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({direction = "left" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({direction = "right" }))
hl.bind(mainMod .. " + SHIFT + I", hl.dsp.window.move({direction = "up" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({direction = "down" }))

for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })


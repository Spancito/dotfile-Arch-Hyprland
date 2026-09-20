local terminal      = "kitty"
local fileManager   = "thunar"
local menu          = "rofi -show drun -theme $HOME/.config/rofi/.local/share/rofi/minimal.rasi"
local mainMod       = "SUPER"
local minecraft		= "prismlauncher"
local coding		= "zeditor"
local music 		= "zuno"
local capturas		= "flameshot gui"
local reinicioWallpaper	= "/home/spancito/.config/restart_wallpaper.sh &"

hl.bind(mainMod .. " + T",         hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E",         hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + D",         hl.dsp.exec_cmd("pkill rofi || " .. menu))
hl.bind(mainMod .. " + N",     hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + M", 		hl.dsp.exec_cmd(minecraft))
hl.bind(mainMod .. " + Tab", hl.dsp.focus({workspace = "r+1"}))
hl.bind(mainMod .. " + SHIFT + Tab", hl.dsp.focus({workspace = "r-1"}))

hl.bind(mainMod .. " + Q", hl.dsp.window.close()) 
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + O", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + P", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + ESCAPE", hl.dsp.exec_cmd('pactl set-source-mute @DEFAULT_SOURCE@ toggle && (pactl get-source-mute @DEFAULT_SOURCE@ | grep -q "yes" && notify-send -t 1000 "Micrófono" "Muteado" -i microphone-sensitivity-muted-symbolic || notify-send -t 1000 "Micrófono" "Desmuteado" -i microphone-sensitivity-high-symbolic)'))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("brave"))
hl.bind(mainMod .. " + G", hl.dsp.exec_cmd("brave --app=https://gemini.google.com"))
hl.bind(mainMod .. " + H", hl.dsp.exec_cmd("brave --app=https://web.whatsapp.com"))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("brave --app=https://crunchyroll.com/es/discover"))
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd(music))
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd(coding))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd(capturas))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(reinicioWallpaper))

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

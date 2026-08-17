--- Windowrules ---

local suppressMaximizeRule = hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})

hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})

hl.window_rule({
	name = "Vesktop-workspace",
	match = {
		initial_class = "(?i)^vesktop$",
	},
	workspace = "6 silent",
})

hl.window_rule({
	name = "WhatsApp",
	match = {
		initial_class = "(?i)^web.whatsapp.com$",
	},
	workspace = "9 silent",
})

hl.layer_rule({
    name     = "rofi",
    match    = { namespace = "rofi" },
    blur     = true,
    animation = "popin 87%",
})

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

hl.window_rule({
	name = "Capturas",
	match = {class = "flameshot"},
	float = true,
	size = {"400", "200"},
})

hl.window_rule({
    name    = "zed-blur",
    match   = { class = "^dev.zed.*" },
    opacity = "0.90 0.80",
    opaque  = false,
})

hl.window_rule({
	name = "Lyrics-Window",
	match = {
		class = "sptlrx",
	},
	float = true,
	size = {"600", "400"},
	move = "100%-620 100%-420",
	opacity = "1.00 0.80",
	opaque = false,
	workspace = "7 silent",
})

hl.layer_rule({
    name     = "Lyrics-Window",
    match    = { namespace = "sptlrx" },
    blur     = true,
    animation = "popin 87%",
})

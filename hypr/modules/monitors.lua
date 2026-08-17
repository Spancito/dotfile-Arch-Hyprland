--- Monitors ---

hl.monitor({output = "HDMI-A-1",mode = "1360x768@75", position = "0x0", scale = 1,})
hl.monitor({output = "DP-1",mode = "1366x768@60", position = "1360x0", scale = 1,})

-- Workspaces --

hl.workspace_rule({ workspace=1, monitor="HDMI-A-1"})
hl.workspace_rule({ workspace=2, monitor="HDMI-A-1"})
hl.workspace_rule({ workspace=3, monitor="HDMI-A-1"})
hl.workspace_rule({ workspace=4, monitor="HDMI-A-1"})
hl.workspace_rule({ workspace=5, monitor="HDMI-A-1"})
hl.workspace_rule({ workspace=6, monitor="DP-1"})
hl.workspace_rule({ workspace=7, monitor="DP-1"})
hl.workspace_rule({ workspace=8, monitor="DP-1"})
hl.workspace_rule({ workspace=9, monitor="DP-1"})
hl.workspace_rule({ workspace=10, monitor="DP-1"})

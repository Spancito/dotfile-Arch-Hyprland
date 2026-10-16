local micro = import("micro")
local config = import("micro/config")
local os = import("os")

local theme_path = config.ConfigDir .. "/colorschemes/matugen.micro"
local last_mod = 0

local function check_update()
    local fileinfo, err = os.Stat(theme_path)
    if err == nil and fileinfo ~= nil then
        local mod = fileinfo:ModTime():UnixNano()
        if last_mod ~= 0 and mod ~= last_mod then
            config.SetGlobalOption("colorscheme", "matugen")
        end
        last_mod = mod
    end
end

function onBufferOpen(buf)
    check_update()
end

function onViewOpen(v)
    check_update()
end

function preRune(v, r)
    check_update()
end

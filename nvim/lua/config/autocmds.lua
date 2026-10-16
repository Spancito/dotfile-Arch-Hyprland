local theme_file = vim.fn.stdpath("config") .. "/colors/matugen.lua"
local w = vim.uv.new_fs_event()
if w then
  w:start(theme_file, {}, vim.schedule_wrap(function(err, fname, status)
    if not err then
      package.loaded["colors.matugen"] = nil
      dofile(theme_file)
    end
  end))
end

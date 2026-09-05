-- Define all your shared settings, state, and loaded local overrides here
local M = {}

-- Default settings
M.scale = 1.5
M.theme = "pastel"
M.inner_gaps = 5
M.blur_global = false

-- Load optional local overrides
local has_local, local_settings = pcall(require, "lua.local-settings")
if has_local and type(local_settings) == "table" then
    M.scale = local_settings.scale or M.scale
    M.theme = local_settings.theme or M.theme
    M.inner_gaps = local_settings.inner_gaps or M.inner_gaps
    M.blur_global = local_settings.blur_global or M.blur_global
end

return M

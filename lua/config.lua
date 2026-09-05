-- Define all your shared settings, state, and loaded local overrides here
local M = {}

-- Default settings
M.scale = 1.5
-- M.theme = "pastel"

-- Load optional local overrides
local has_local, local_settings = pcall(require, "local-settings")
if has_local and type(local_settings) == "table" then
    M.scale = local_settings.scale or M.scale
    -- M.theme = local_settings.theme or M.theme
end

return M

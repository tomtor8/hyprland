-- Define all your shared settings, state, and loaded local overrides here
-- Default settings
local M = {
    corner_radius = 6,
    scale = 1.5,
    theme = "pastel",
    gaps_inner = 5,
    gaps_outer = 10,
    blur_global = false,
    layout_global = "dwindle",
}

-- Load optional local overrides
local ok, overrides = pcall(require, "lua.local-settings")
if ok and type(overrides) == "table" then
    for key, value in pairs(overrides) do
        M[key] = value
    end
end

return M

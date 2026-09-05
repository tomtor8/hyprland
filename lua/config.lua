-- Define all your shared settings, state, and loaded local overrides here
-- Default settings
local M = {
    scale = 1.5,
    theme = "pastel",
    inner_gaps = 5,
    blur_global = false,
}

-- Load optional local overrides
local ok, overrides = pcall(require, "lua.local-settings")
if ok and type(overrides) == "table" then
    for key, value in pairs(overrides) do
        M[key] = value
    end
end

return M

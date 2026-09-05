local M = {}

function M.setup(cfg)
    -- Access shared settings from config.lua via cfg
    -- e.g. cfg.scale
    hl.config({
        general = {
            col = {
                -- Accent orange for active border; subtle ui line for inactive
                active_border = "rgba(ff9e3bff)",
                inactive_border = "rgba(11151cff)",
            },
        },
        decoration = {
            shadow = {
                color = "rgba(000000ee)",
            },
        },
        group = {
            col = {
                border_active = "rgba(e6b450cc)",          -- Active unlocked border (Yellow/Gold)
                border_inactive = "rgba(11151ca6)",        -- Inactive border (Dark UI)
                border_locked_active = "rgba(36a3d9b3)",   -- Active locked border (Blue)
                border_locked_inactive = "rgba(f29668b3)", -- Inactive locked border (Orange/Coral)
            },
            groupbar = {
                text_color = "rgba(e6b450ff)",          -- Active title text (Gold)
                text_color_inactive = "rgba(5c6773ff)", -- Inactive title text (Comment gray)
                col = {
                    active = "rgba(0f131aee)",          -- Ayu Dark background
                    inactive = "rgba(0f131aee)",
                    locked_active = "rgba(0f131aee)",
                    locked_inactive = "rgba(0f131aee)",
                },
            },
        },
    })
end

return M

local M = {}

function M.setup(cfg)
    -- access shared settings from config.lua via cfg
    -- e.g. cfg.scale
    hl.config({
        general = {
            col = {
                active_border = "rgba(636a72ff)",
                inactive_border = "rgba(252b35ff)",
            },
        },
        decoration = {
            shadow = {
                color = "rgba(000000ee)",
            },
        },
        group = {
            col = {
                border_active = "rgba(4a5057cc)", -- Active unlocked border
                border_inactive = "rgba(1d212a99)", -- Inactive border
                border_locked_active = "rgba(8ca6dbb3)", -- Active locked border
                border_locked_inactive = "rgba(c49d82b3)", -- Inactive locked border
            },
            groupbar = {
                text_color = "rgba(adc6ffff)", -- Active title text
                text_color_inactive = "rgba(7c849bff)", -- Inactive title text
                col = {
                    active = "rgba(1d212aee)", -- Matches border_active
                    inactive = "rgba(1d212aee)", -- Matches border_inactive
                    locked_active = "rgba(1d212aee)", -- Matches border_locked_active
                    locked_inactive = "rgba(1d212aee)", -- Matches border_locked_inactive
                },
            },
        },
    })
end

return M

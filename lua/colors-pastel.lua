local M = {}

function M.setup(cfg)
    -- access shared settings from config.lua via cfg
    -- e.g. cfg.scale
    hl.config({
        general = {
            col = {
                active_border = "rgba(b4befedd)",   -- Lavender
                inactive_border = "rgba(313244dd)", -- Surface0
            },
        },
        decoration = {
            shadow = {
                color = "rgba(11111bee)",           -- Crust
            },
        },
        group = {
            col = {
                border_active = "rgba(b4befedd)",          -- Lavender
                border_inactive = "rgba(313244dd)",        -- Surface0
                border_locked_active = "rgba(fab387aa)",   -- Peach
                border_locked_inactive = "rgba(f9e2afaa)", -- Yellow
            },
            groupbar = {
                text_color = "rgba(cdd6f4ff)",          -- Text
                text_color_inactive = "rgba(a6adc8ff)", -- Subtext0
                col = {
                    active = "rgba(1e1e2eff)",          -- Base
                    inactive = "rgba(181825ff)",        -- Mantle
                    locked_active = "rgba(1e1e2eff)",   -- Base
                    locked_inactive = "rgba(181825ff)", -- Mantle
                },
            },
        },
    })
end

return M

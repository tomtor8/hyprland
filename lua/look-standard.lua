local M = {}

function M.setup(cfg)
    -- access shared settings from config.lua via cfg
    -- e.g. cfg.scale
    hl.config({
        general = {
            gaps_in = 5,
            gaps_out = 10,
            border_size = 3,
            -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
            resize_on_border = true,
            layout = "dwindle",
        },
        decoration = {
            rounding = 6,
            rounding_power = 6,
            -- Change transparency of focused and unfocused windows
            active_opacity = 1.0,
            inactive_opacity = 1.0,
            dim_inactive = false,
            dim_strength = 0.4,
            shadow = {
                enabled = true,
                range = 25,
                render_power = 4,
                offset = { 0, 0 },
                scale = 1.0,
                sharp = false,
            },
            blur = {
                enabled = true,
                size = 5,
                passes = 1,
                vibrancy = 0.1696,
            },
        },
        layout = {
            single_window_aspect_ratio = { 4, 3 },
        },
        cursor = {
            hide_on_key_press = true,
        },
        group = {
            groupbar = {
                enabled = true,
                font_family = "Lexend",
                font_size = 14,
                font_weight_active = "bold",
                rounding = 6,
                round_only_edges = false,
                indicator_height = 16,
                indicator_gap = -15,
                blur = true,
            },
        },
    })
end

return M

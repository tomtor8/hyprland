local M = {}

function M.setup(cfg)
    -- access shared settings from config.lua via cfg
    -- e.g. cfg.scale
    -- Window and Workspace rules {{{1
    -- Scratchpad rules {{{2

    hl.window_rule({
        match = {
            class = "^foot-scratch$",
        },
        float = true,
        size = { "(monitor_w * 0.6)", "(monitor_h * 0.7)" },
        animation = "slide left",
        workspace = "special:foot-scratchpad",
    })

    hl.window_rule({
        match = {
            class = "^note-scratch$",
        },
        float = true,
        size = { "(monitor_w * 0.6)", "(monitor_h * 0.7)" },
        animation = "slide left",
        workspace = "special:note-scratchpad",
    })

    hl.window_rule({
        match = {
            class = "^yazi-scratch$",
        },
        float = true,
        size = { "(monitor_w * 0.6)", "(monitor_h * 0.7)" },
        animation = "slide left",
        workspace = "special:yazi-scratchpad",
    })

    hl.window_rule({
        match = {
            class = "^kew$",
        },
        float = true,
        size = { "(monitor_w * 0.3)", "(monitor_h * 0.7)" },
        animation = "slide left",
        workspace = "special:music-scratchpad",
    })

    -- Application rules {{{2
    hl.window_rule({
        match = {
            class = "^(dev.noctalia.Noctalia)$",
        },
        float = true,
        size = { "(monitor_w * 0.5)", "(monitor_h * 0.8)" },
    })

    hl.window_rule({
        match = {
            class = "^(io.github.cboxdoerfer.FSearch|foot-snip|org.gnome.Nautilus|yazi)$",
        },
        float = true,
        size = { "(monitor_w * 0.5)", "(monitor_h * 0.6)" },
    })

    hl.window_rule({
        match = {
            class = "zen",
            initial_title = "About Zen Browser",
        },
        float = true,
        size = { "(monitor_w * 0.3)", "(monitor_h * 0.3)" },
    })

    hl.window_rule({
        match = {
            class = "xdg-desktop-portal-gtk",
            -- initial_title = "^(Open Folder|Open File|All Files|Open Files)$",
        },
        float = true,
        size = { "(monitor_w * 0.4)", "(monitor_h * 0.5)" },
        center = true
    })


    -- Hyprland window rules {{{2
    hl.window_rule({
        name = "move-hyprland-run",
        match = { class = "hyprland-run" },

        move = "20 monitor_h-120",
        float = true,
    })

    local suppressMaximizeRule = hl.window_rule({
        -- Ignore maximize requests from all apps. You'll probably like this.
        name = "suppress-maximize-events",
        match = { class = ".*" },

        suppress_event = "maximize",
    })
    suppressMaximizeRule:set_enabled(true)

    hl.window_rule({
        -- Fix some dragging issues with XWayland
        name = "fix-xwayland-drags",
        match = {
            class = "^$",
            title = "^$",
            xwayland = true,
            float = true,
            fullscreen = false,
            pin = false,
        },

        no_focus = true,
    })

    -- Workspace rules {{{1

    hl.workspace_rule({
        workspace = "1",
        persistent = true,
    })
    hl.workspace_rule({
        workspace = "2",
        persistent = true,
    })
    hl.workspace_rule({
        workspace = "3",
        persistent = true,
    })
    hl.workspace_rule({
        workspace = "4",
        persistent = true,
    })
    hl.workspace_rule({
        workspace = "5",
        persistent = true,
    })

    -- Layer Rules {{{1
    hl.layer_rule({
        match = { namespace = "^launcher$" },
        dim_around = true,
    })

    hl.layer_rule({
        name = "noctalia",
        match = {
            namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$",
        },
        no_anim = true,
        ignore_alpha = 0.5,
        blur = false,
        blur_popups = false,
    })
end

return M

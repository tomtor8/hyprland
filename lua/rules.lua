local M = {}

function M.setup(cfg)
    -- access shared settings from config.lua via cfg
    -- e.g. cfg.scale
    -- Window and Workspace rules {{{1
    -- Scratchpad rules {{{2
    local scratchpads = {
        {
            name = "yazi",
            cmd = "foot --app-id yazi-scratch -e yazi",
        },
        {
            name = "foot",
            cmd = "foot --app-id foot-scratch",
        },
        {
            name = "note",
            cmd = "foot --app-id note-scratch -e nvim ~/Documents/notepad.md 2>/dev/null",
        },
    }

    for _, scratch in ipairs(scratchpads) do
        local id = scratch.name .. "-scratch"
        local ws = "special:" .. id .. "pad"

        hl.workspace_rule({
            workspace = ws,
            on_created_empty = scratch.cmd,
        })

        hl.window_rule({
            name = id,
            match = {
                class = "^" .. id .. "$",
            },
            float = true,
            size = { "(monitor_w * 0.6)", "(monitor_h * 0.7)" },
            animation = "slide left",
            workspace = "^" .. ws .. "$",
        })
    end

    -- Application rules {{{2
    hl.window_rule({
        match = {
            class = "dev.noctalia.Noctalia",
        },
        float = true,
        size = { 1080, 920 },
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
            class = "org.gnome.Nautilus",
        },
        float = true,
        size = { "(monitor_w * 0.5)", "(monitor_h * 0.6)" },
    })

    hl.window_rule({
        match = {
            class = "^kew$",
        },
        float = true,
        workspace = "4 silent",
        size = { "(monitor_w * 0.3)", "(monitor_h * 0.8)" },
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
        default_name = "Web",
        layout = "master"
    })
    hl.workspace_rule({
        workspace = "2",
        persistent = true,
        default_name = "Term",
        layout = "lua:grid"
    })
    hl.workspace_rule({
        workspace = "3",
        persistent = true,
        default_name = "Read",
    })
    hl.workspace_rule({
        workspace = "4",
        persistent = true,
        default_name = "Media",
    })
    hl.workspace_rule({
        workspace = "5",
        persistent = true,
        default_name = "Other",
    })

    -- Ref https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
    -- "Smart gaps" / "No gaps when only"
    -- uncomment all if you wish to use that.
    -- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
    -- hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
    -- hl.window_rule({
    --     name  = "no-gaps-wtv1",
    --     match = { float = false, workspace = "w[tv1]" },
    --     border_size = 0,
    --     rounding    = 0,
    -- })
    -- hl.window_rule({
    --     name  = "no-gaps-f1",
    --     match = { float = false, workspace = "f[1]" },
    --     border_size = 0,
    --     rounding    = 0,
    -- })

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
        blur = true,
        blur_popups = true,
    })
end

return M

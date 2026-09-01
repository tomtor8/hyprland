------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = "auto",
})

-------------------
---- AUTOSTART ----
-------------------

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
hl.on("hyprland.start", function()
    hl.exec_cmd("~/.config/hypr/restart-hyprland-portals.fish")
    hl.exec_cmd("noctalia")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("XCURSOR_SIZE", "28")
hl.env("HYPRCURSOR_SIZE", "28")

-----------------------
----- PERMISSIONS -----
-----------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons

-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")

-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 10,

        border_size = 3,

        col = {
            active_border = "rgba(636a72ff)",
            inactive_border = "rgba(252b35ff)",
        },

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = true,

        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing = false,

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
            color = "rgba(000000ee)",
            offset = {0, 0},
            scale = 1.0,
            sharp = false
        },

        blur = {
            enabled = true,
            size = 5,
            passes = 1,
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },

    layout = {
        single_window_aspect_ratio = {4, 3},
    },

    cursor = {
        hide_on_key_press = true
    },
})

hl.config({
    group = {
        col = {
            border_active = "rgba(4a5057cc)",          -- Active unlocked border
            border_inactive = "rgba(1d212a99)",        -- Inactive border
            border_locked_active = "rgba(8ca6dbb3)",   -- Active locked border
            border_locked_inactive = "rgba(c49d82b3)", -- Inactive locked border
        },
        groupbar = {
            enabled = true,
            font_family = "Lexend",
            font_size = 14,
            font_weight_active = "bold",
            rounding = 6,
            round_only_edges = false,
            -- text_color = "rgba(e2e8f0ff)",             -- Active title text
            text_color = "rgba(adc6ffff)",             -- Active title text
            text_color_inactive = "rgba(7c849bff)",    -- Inactive title text
            indicator_height = 16,
            indicator_gap = -15,
            blur = true,
            col = {
                active = "rgba(1d212aee)",             -- Matches border_active
                inactive = "rgba(1d212aee)",           -- Matches border_inactive
                locked_active = "rgba(1d212aee)",      -- Matches border_locked_active
                locked_inactive = "rgba(1d212aee)",    -- Matches border_locked_inactive
            }
        },
    }
})


require("animations")

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

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
    dwindle = {
        preserve_split = true, -- You probably want this
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
    master = {
        new_status = "slave",
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
    },
})

----------------
----  MISC  ----
----------------

hl.config({
    misc = {
        force_default_wallpaper = 0, -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo = true, -- If true disables the random hyprland logo / anime girl background. :(
        middle_click_paste = false,
        enable_swallow = true,
        swallow_regex = "^(foot|kitty)$"
    },
})

---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout = "us,sk,es",
        kb_variant = "",
        kb_model = "",
        kb_options = "grp:shifts_toggle,caps:escape",
        kb_rules = "",

        follow_mouse = 1,

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = false,
        },
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
})

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
hl.device({
    name = "epic-mouse-v1",
    sensitivity = -0.5,
})

require("keybindings")

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- Example window rules that are useful

-- Workspace rules

hl.workspace_rule({
    workspace = "special:yazi-scratchpad",
    on_created_empty = "foot --app-id yazi-scratch -e yazi",
    animation = "slide"
})

hl.window_rule({
    name = "yazi-scratch",
    match = {
        class = "^yazi-scratch$"
    },
    float = true,
    size = { "(monitor_w * 0.6)", "(monitor_h * 0.7)" },
    animation = "slide"
})

hl.workspace_rule({
    workspace = "special:foot-scratchpad",
    on_created_empty = "foot --app-id foot-scratch",
    animation = "slide"
})

hl.window_rule({
    name = "foot-scratch",
    match = {
        class = "^foot-scratch$"
    },
    float = true,
    size = { "(monitor_w * 0.6)", "(monitor_h * 0.7)" },
    animation = "slide"
})

hl.workspace_rule({
    workspace = "special:note-scratchpad",
    on_created_empty = "foot --app-id note-scratch -e nvim ~/Documents/notepad.md 2>/dev/null",
    animation = "slide",
    no_rounding = false
})

hl.window_rule({
    name = "note-scratch",
    match = {
        class = "^note-scratch$"
    },
    float = true,
    size = { "(monitor_w * 0.6)", "(monitor_h * 0.7)" },
    animation = "slide"
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

-- Hyprland-run windowrule
hl.window_rule({
    name = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move = "20 monitor_h-120",
    float = true,
})

-- Monitors {{{1
hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = "auto",
})

-- Autostart {{{1
hl.on("hyprland.start", function()
    hl.exec_cmd("~/.config/hypr/restart-hyprland-portals.fish")
    hl.exec_cmd("noctalia")
end)

-- Environment variables {{{1
hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("XCURSOR_SIZE", "28")
hl.env("HYPRCURSOR_SIZE", "28")

-- Permissions {{{1
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

-- Look {{{1
require("colors-pastel")
require("look-standard")
require("animations")

-- Layout config {{{1
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

-- Miscellaneous {{{1
hl.config({
    misc = {
        force_default_wallpaper = 0, -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo = true, -- If true disables the random hyprland logo / anime girl background. :(
        middle_click_paste = false,
        enable_swallow = true,
        swallow_regex = "^(foot|kitty)$",
    },
})

-- Keyboard, mouse, trackpad {{{1
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
            natural_scroll = true,
        },
    },
})

hl.gesture({
    fingers = 3,
    direction = "vertical",
    action = "workspace",
})

-- Keybindings {{{1
require("keybindings")

-- Window and Workspace rules {{{1

hl.workspace_rule({
    workspace = "special:yazi-scratchpad",
    on_created_empty = "foot --app-id yazi-scratch -e yazi",
})

hl.window_rule({
    name = "yazi-scratch",
    match = {
        class = "^yazi-scratch$",
    },
    float = true,
    size = { "(monitor_w * 0.6)", "(monitor_h * 0.7)" },
    animation = "slide left",
    workspace = "^special:yazi-scratchpad$"
})

hl.workspace_rule({
    workspace = "special:foot-scratchpad",
    on_created_empty = "foot --app-id foot-scratch",
})

hl.window_rule({
    name = "foot-scratch",
    match = {
        class = "^foot-scratch$",
    },
    float = true,
    size = { "(monitor_w * 0.6)", "(monitor_h * 0.7)" },
    animation = "slide left",
    workspace = "^special:foot-scratchpad$"
})

hl.workspace_rule({
    workspace = "special:note-scratchpad",
    on_created_empty = "foot --app-id note-scratch -e nvim ~/Documents/notepad.md 2>/dev/null",
})

hl.window_rule({
    name = "note-scratch",
    match = {
        class = "^note-scratch$",
    },
    float = true,
    size = { "(monitor_w * 0.6)", "(monitor_h * 0.7)" },
    animation = "slide left",
    workspace = "^special:note-scratchpad$"
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

-- Hyprland-run windowrule
hl.window_rule({
    name = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move = "20 monitor_h-120",
    float = true,
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

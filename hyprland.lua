-- Load Local Settings {{{1
local cfg = require("lua.config")

-- Monitors {{{1
hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = cfg.scale,
})

-- Autostart {{{1
hl.on("hyprland.start", function()
    hl.exec_cmd("~/.config/hypr/scripts/restart-hyprland-portals.fish")
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
require("lua.colors-pastel").setup(cfg)
require("lua.look-standard").setup(cfg)
require("lua.animations").setup(cfg)

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

    gestures = {
        workspace_swipe_cancel_ratio = 0.1,
        -- workspace_swipe_min_speed_to_force = 10
    }
})

hl.gesture({
    fingers = 3,
    direction = "vertical",
    action = "workspace",
})

hl.gesture({
    -- 2..9
    fingers = 4,
    -- up|down|left|righ
    direction = "up",
    action = function()
        hl.exec_cmd("foot")
    end,
})

-- Keybindings {{{1
require("lua.keybindings").setup(cfg)

-- Window and Workspace rules {{{1
require("lua.rules").setup(cfg)

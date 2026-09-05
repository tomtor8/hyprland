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
-- Dynamically require the theme module based on cfg.theme
local theme_module = "lua.colors-" .. cfg.theme
local ok, theme = pcall(require, theme_module)

if ok and type(theme.setup) == "function" then
    theme.setup(cfg)
else
    require("lua.colors-pastel").setup(cfg) --default fallback
end

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

-- Custom Layouts {{{2

hl.layout.register("grid", {
    recalculate = function(ctx)
        local n = #ctx.targets
        if n == 0 then
            return
        end

        local area = ctx.area

        -- 1 Window: Centered at 70% width and 80% height
        if n == 1 then
            local w = math.floor(area.w * 0.70)
            local h = math.floor(area.h * 0.80)
            local x = area.x + math.floor((area.w - w) / 2)
            local y = area.y + math.floor((area.h - h) / 2)

            ctx.targets[1]:place({ x = x, y = y, w = w, h = h })
            return
        end

        -- 2 Windows: Half width, 80% height, side-by-side, vertically centered
        if n == 2 then
            local w = math.floor(area.w * 0.50)
            local h = math.floor(area.h * 0.80)
            local y = area.y + math.floor((area.h - h) / 2)

            ctx.targets[1]:place({ x = area.x, y = y, w = w, h = h })
            ctx.targets[2]:place({ x = area.x + w, y = y, w = w, h = h })
            return
        end

        -- 3 Windows: Top 2 side-by-side, 3rd centered at bottom
        if n == 3 then
            local w = math.floor(area.w * 0.50)
            local h = math.floor(area.h * 0.50)

            -- Top row
            ctx.targets[1]:place({ x = area.x, y = area.y, w = w, h = h })
            ctx.targets[2]:place({ x = area.x + w, y = area.y, w = w, h = h })

            -- Bottom row (centered)
            local x3 = area.x + math.floor((area.w - w) / 2)
            ctx.targets[3]:place({ x = x3, y = area.y + h, w = w, h = h })
            return
        end

        -- 4+ Windows: Balanced symmetric grid with centered last row
        local cols = math.ceil(math.sqrt(n))
        local rows = math.ceil(n / cols)

        local col_w = math.floor(area.w / cols)
        local row_h = math.floor(area.h / rows)

        -- Number of windows on the last row
        local last_row_count = n % cols
        if last_row_count == 0 then
            last_row_count = cols
        end

        -- Offset X for the last row to center its items
        local last_row_offset =
            math.floor((area.w - (last_row_count * col_w)) / 2)

        for i, target in ipairs(ctx.targets) do
            local col = (i - 1) % cols
            local row = math.floor((i - 1) / cols)

            local start_x = area.x
            -- If we are on the last row and it's incomplete, apply offset
            if row == rows - 1 and last_row_count < cols then
                start_x = start_x + last_row_offset
            end

            target:place({
                x = start_x + (col * col_w),
                y = area.y + (row * row_h),
                w = col_w,
                h = row_h,
            })
        end
    end,
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
    },
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

-- Imports & Variables {{{1
local funs = require("functions")
local terminal = "foot"
local fileManager = "nautilus"
local ipc = "noctalia msg "
local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- Close Windows & Exit Hyprland {{{1
hl.bind(
    mainMod .. " + Q",
    hl.dsp.window.close(),
    { description = "Close Window" }
)
hl.bind(
    mainMod .. " + ALT + M",
    hl.dsp.exec_cmd(
        "command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"
    ),
    { description = "Exit Hyprland Gracefully" }
)

-- Apps & Scripts {{{1
hl.bind(
    mainMod .. " + Return",
    hl.dsp.exec_cmd(terminal),
    { description = "Terminal Foot" }
)
hl.bind(
    mainMod .. " + E",
    hl.dsp.exec_cmd(fileManager),
    { description = "File Manager Nautilus" }
)
hl.bind(
    mainMod .. " + U",
    hl.dsp.exec_cmd("/home/tom/.local/bin/zen"),
    { description = "Zen Browser" }
)
hl.bind(
    mainMod .. " + Space",
    hl.dsp.exec_cmd("~/.config/hypr/hypr-commands-noctalia.lua"),
    { description = "Hyprland Command Palette" }
)
hl.bind(
    mainMod .. " + P",
    hl.dsp.exec_cmd("~/Code/lua/fuzzel_scripts/find-files2.lua"),
    { description = "Find Files & PDFs Script" }
)
hl.bind(
    mainMod .. " + M",
    hl.dsp.exec_cmd("~/Code/lua/fuzzel_scripts/find-music-kew.lua"),
    { description = "Kew Music Select" }
)
hl.bind(
    mainMod .. " + C",
    hl.dsp.exec_cmd("~/Code/lua/fuzzel_scripts/color-picker-hypr.lua"),
    { description = "Color Picker" }
)
hl.bind(
    mainMod .. " + G",
    hl.dsp.exec_cmd("~/Code/lua/fuzzel_scripts/buku-fuzzel.lua"),
    { description = "Buku Web Bookmarks" }
)

-- Noctalia Keybindings {{{1
hl.bind(
    "ALT + Space",
    hl.dsp.exec_cmd(ipc .. "panel-toggle launcher"),
    { description = "Noctalia Launcher" }
)
hl.bind(
    mainMod .. " + comma",
    hl.dsp.exec_cmd(ipc .. "settings-toggle"),
    { description = "Noctalia Settings" }
)
hl.bind(
    mainMod .. " + V",
    hl.dsp.exec_cmd(ipc .. "panel-toggle clipboard"),
    { description = "Clipboard Manager" }
)
hl.bind(
    "ALT + TAB",
    hl.dsp.exec_cmd(ipc .. "window-switcher"),
    { description = "Window Switcher" }
)
hl.bind(
    mainMod .. " + N",
    hl.dsp.exec_cmd(ipc .. "panel-toggle noctalia/notes:panel"),
    { description = "Noctalia Notes" }
)
hl.bind(
    mainMod .. " + X",
    hl.dsp.exec_cmd(ipc .. "panel-toggle session"),
    { description = "Session Panel" }
)
hl.bind(
    mainMod .. " + CTRL + B",
    hl.dsp.exec_cmd(ipc .. "bar-toggle"),
    { description = "Status Bar Toggle" }
)

-- Layout Toggles {{{1
hl.bind(
    mainMod .. " + ALT + P",
    hl.dsp.window.pseudo(),
    { description = "Pseudotile" }
)
hl.bind(
    mainMod .. " + ALT + J",
    hl.dsp.layout("togglesplit"),
    { description = "Split Toggle for Dwindle" }
)
hl.bind(
    mainMod .. " + ALT + F",
    hl.dsp.window.float({ action = "toggle" }),
    { description = "Float Window Toggle" }
)

-- Switch Layouts
-- -- hyprctl eval 'hl.config({ general = { layout = "master" } })' for scripting
-- hl.bind("ALT + SHIFT + M", function()
--     hl.config({ general = { layout = "master" } })
-- end)
--
-- hl.bind("ALT + SHIFT + D", function()
--     hl.config({ general = { layout = "dwindle" } })
-- end)

-- Focus Windows, {{{1
hl.bind(
    mainMod .. " + H",
    hl.dsp.focus({ direction = "left" }),
    { description = "Focus Window Left" }
)
hl.bind(
    mainMod .. " + L",
    hl.dsp.focus({ direction = "right" }),
    { description = "Focus Window Right" }
)
hl.bind(
    mainMod .. " + K",
    hl.dsp.focus({ direction = "up" }),
    { description = "Focus Window Up" }
)
hl.bind(
    mainMod .. " + J",
    hl.dsp.focus({ direction = "down" }),
    { description = "Focus Window Down" }
)

-- Swap Windows {{{1
hl.bind(
    mainMod .. " + SHIFT + H",
    hl.dsp.window.swap({ direction = "left" }),
    { description = "Swap Window Left" }
)
hl.bind(
    mainMod .. " + SHIFT + L",
    hl.dsp.window.swap({ direction = "right" }),
    { description = "Swap Window Right" }
)
hl.bind(
    mainMod .. " + SHIFT + J",
    hl.dsp.window.swap({ direction = "down" }),
    { description = "Swap Window Down" }
)
hl.bind(
    mainMod .. " + SHIFT + K",
    hl.dsp.window.swap({ direction = "up" }),
    { description = "Swap Window Up" }
)

-- Example: get window class {{{1
-- hl.bind("SUPER + Y", function()
--     -- in lambda functions use hl.dispatch()
--     -- see window selectors at naming conventions in hypr wiki
--     local win = hl.get_window("class:yazi-scratch")
--     if win then
--         hl.dispatch(hl.dsp.exec_cmd("notify-send 'yazi-scratch is active'"))
--     else
--         hl.dispatch(hl.dsp.exec_cmd("notify-send 'yazi-scratch NOT active'"))
--     end
--
-- end)

-- Window groups & tabs {{{1
hl.bind(
    mainMod .. " + ALT + G",
    hl.dsp.group.toggle(),
    { description = "Toggle Group" }
)
hl.bind(
    mainMod .. " + ALT + L",
    hl.dsp.group.next(),
    { description = "Focus Next Window in Group" }
)
hl.bind(
    mainMod .. " + ALT + H",
    hl.dsp.group.prev(),
    { description = "Focus Previous Window in Group" }
)

-- Focus Workspaces & Move Windows to Workspaces {{{1
-- Switch workspaces with CTRL + [0-9]
-- Move active window to a workspace with CTRL + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(
        "CTRL + " .. key,
        hl.dsp.focus({ workspace = i }),
        { description = "Focus Workspace " .. i }
    )
    hl.bind(
        "CTRL + SHIFT + " .. key,
        hl.dsp.window.move({ workspace = i }),
        { description = "Move Window to Workspace " .. i }
    )
end

hl.bind(
    "CTRL + down",
    hl.dsp.focus({ workspace = "+1" }),
    { description = "Focus Workspace Next" }
)
hl.bind(
    "CTRL + up",
    hl.dsp.focus({ workspace = "-1" }),
    { description = "Focus Workspace Previous" }
)

-- Scratchpads: Special Workspaces {{{1
hl.bind(
    mainMod .. " + ALT + E",
    hl.dsp.workspace.toggle_special("yazi-scratchpad"),
    { description = "Open Foot Scratchpad" }
)

hl.bind(
    mainMod .. " + ALT + Return",
    hl.dsp.workspace.toggle_special("foot-scratchpad"),
    { description = "Open Foot Scratchpad" }
)

hl.bind(
    mainMod .. " + ALT + N",
    hl.dsp.workspace.toggle_special("note-scratchpad"),
    { description = "Open Note Scratchpad" }
)

-- Minimize window {{{1
-- Works only for one window
hl.bind(mainMod .. " + ALT + Q", function()
    if hl.get_workspace("special:minimized") then
        hl.dispatch(hl.dsp.window.move({
            workspace = hl.get_active_workspace(),
            window = "tag:minimized",
        }))
        hl.dispatch(hl.dsp.window.clear_tags({ window = "tag:minimized" }))
    else
        hl.dispatch(hl.dsp.window.tag({
            tag = "minimized",
            window = hl.get_active_window(),
        }))
        hl.dispatch(hl.dsp.window.move({
            workspace = "special:minimized",
            follow = false,
        }))
    end
end, { description = "Minimize Single Window" })

-- Mouse Binds {{{1
-- Scroll through existing workspaces with mainMod + scroll
hl.bind("CTRL + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("CTRL + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Multimedia keys {{{1
hl.bind(
    "XF86AudioRaiseVolume",
    hl.dsp.exec_cmd(ipc .. "volume-up"),
    { locked = true, repeating = true }
)
hl.bind(
    "XF86AudioLowerVolume",
    hl.dsp.exec_cmd(ipc .. "volume-down"),
    { locked = true, repeating = true }
)
hl.bind(
    "XF86AudioMute",
    hl.dsp.exec_cmd(ipc .. "volume-mute"),
    { locked = true, repeating = true }
)
hl.bind(
    "XF86MonBrightnessUp",
    hl.dsp.exec_cmd(ipc .. "brightness-up"),
    { locked = true, repeating = true }
)
hl.bind(
    "XF86MonBrightnessDown",
    hl.dsp.exec_cmd(ipc .. "brightness-down"),
    { locked = true, repeating = true }
)

hl.bind(
    "XF86AudioNext",
    hl.dsp.exec_cmd(ipc .. "media next"),
    { locked = true }
)
hl.bind(
    "XF86AudioPlay",
    hl.dsp.exec_cmd(ipc .. "media toggle"),
    { locked = true }
)
hl.bind(
    "XF86AudioPrev",
    hl.dsp.exec_cmd(ipc .. "media previous"),
    { locked = true }
)

-- Resize Windows Submaps {{{1
hl.bind(
    mainMod .. " + R",
    hl.dsp.submap("resize"),
    { description = "Resize Window Submap" }
)

-- Start a submap called "resize".
hl.define_submap("resize", function()
    -- Set repeating binds for resizing the active window.
    local t = {
        -- key: keybind, values: x and y
        ["l"] = { 10, 0 },
        ["h"] = { -10, 0 },
        ["j"] = { 0, 10 },
        ["k"] = { 0, -10 },
    }

    for k, v in pairs(t) do
        hl.bind(
            k,
            hl.dsp.window.resize({ x = v[1], y = v[2], relative = true }),
            { repeating = true }
        )
    end

    -- Use `reset` to go back to the global submap
    hl.bind("escape", hl.dsp.submap("reset"))
end)

-- Screenshot Submaps {{{1
hl.bind(
    mainMod .. " + S",
    hl.dsp.submap("screenshots"),
    { description = "Screenshots" }
)
-- automatically reset the submap using "reset" here
hl.define_submap("screenshots", "reset", function()
    local t = {
        -- key: keybind, value: screenshot command, description
        ["r"] = { "noctalia msg screenshot-region", "Screenshot Region" },
        ["f"] = {
            "noctalia msg screenshot-fullscreen",
            "Screenshot Fullscreen",
        },
        ["o"] = {
            "/home/tom/Code/shell/ocr_screenshot_in_clipboard/ocr-screenshot-in-clipboard.fish --strip-newlines",
            "Screenshot to OCR Without Lines",
        },
        ["l"] = {
            "/home/tom/Code/shell/ocr_screenshot_in_clipboard/ocr-screenshot-in-clipboard.fish",
            "Screenshots to OCR Lines Preserved",
        },
    }

    for k, v in pairs(t) do
        hl.bind(
            k,
            hl.dsp.exec_cmd(v[1]),
            { repeating = false, description = v[2] }
        )
    end

    hl.bind("escape", hl.dsp.submap("reset"))
end)

-- Resize and Float Windows Submaps {{{1
-- Making Floating Windows and Resizing them
hl.bind(
    mainMod .. " + F",
    hl.dsp.submap("float_windows"),
    { description = "Float and Resize" }
)
-- 5.1 Resize and Float Submaps
-- automatically reset the submap using "reset" here
-- width and height as decimals
hl.define_submap("float_windows", "reset", function()
    local t = {
        -- key: keybind, values: width and height
        ["1"] = { 0.5, 0.6 },
        ["2"] = { 0.6, 0.7 },
        ["3"] = { 0.7, 0.8 },
        ["4"] = { 0.8, 0.9 },
        ["5"] = { 0.9, 0.9 },
        ["6"] = { 0.5, 0.93 },
    }

    for k, v in pairs(t) do
        hl.bind(k, function()
            funs.float_and_resize(v[1], v[2])
        end, {
            repeating = false,
            description = string.format(
                "Float and Resize: %s x %s",
                tostring(v[1]),
                tostring(v[2])
            ),
        })
    end

    hl.bind("escape", hl.dsp.submap("reset"))
end)

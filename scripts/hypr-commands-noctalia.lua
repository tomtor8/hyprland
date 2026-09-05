#!/usr/bin/env lua

-- Helper to execute a command and return stdout trimmed
local function capture(cmd)
    local pipe = io.popen(cmd, "r")
    if not pipe then
        return nil
    end
    local output = pipe:read("*a")
    pipe:close()
    return output and output:match("^%s*(.-)%s*$") or nil
end

-- Helper for error notifications
local function notify_error(msg)
    os.execute(
        string.format("notify-send -i 'dialog-error' 'hypr error' %q", msg)
    )
    os.exit(1)
end

-- Fetch layout and workspace_id in a single hyprctl/jq execution
local ws_info =
    capture([=[hyprctl -j activeworkspace | jq -r '"\(.tiledLayout) \(.id)"']=])
if not ws_info then
    notify_error("Failed to retrieve active workspace info")
    return
end

local layout, workspace_id = ws_info:match("(%S+)%s+(%S+)")
if not layout or not workspace_id then
    notify_error("Failed to parse workspace layout or ID")
end

local anim_info =
    capture([=[hyprctl -j getoption animations:enabled | jq '.bool']=])
if not anim_info then
    notify_error("Failed to retrieve animation info")
end

local anim_toggle = (anim_info == "true") and "false" or "true"

-- Use an ordered list of tables to preserve menu order
local commands = {
    -- tile, scroller, monocle, grid, deck, center_tile, vertical_tile
    -- right_tile, vertical_scroller, vertical_grid, vertical_deck,
    -- dwindle, fair, vertical_fair
    {
        "󰗘  Animations Toggle",
        string.format(
            [[hyprctl eval 'hl.config({ animations = { enabled = %s } })']],
            anim_toggle
        ),
    },
    { "󰂯  Bluetooth Toggle", "noctalia msg bluetooth-toggle" },
    {
        "  Control Center Home",
        "noctalia msg panel-toggle control-center home",
    },
    {
        "󰍹  Control Center Monitor",
        "noctalia msg panel-toggle control-center monitor",
    },
    { "󱍕  Desktop Widgets Edit", "noctalia msg desktop-widgets-edit" },
    {
        "󰱊  Dim Disable",
        [[hyprctl eval 'hl.config({ decoration = { dim_inactive = false } })']],
    },
    {
        "󰱊  Dim Inactive Windows 25%",
        [[hyprctl eval 'hl.config({ decoration = { dim_inactive = true, dim_strength = 0.25 } })']],
    },
    {
        "󰱊  Dim Inactive Windows 50%",
        [[hyprctl eval 'hl.config({ decoration = { dim_inactive = true, dim_strength = 0.5 } })']],
    },
    {
        "󰱊  Dim Inactive Windows 75%",
        [[hyprctl eval 'hl.config({ decoration = { dim_inactive = true, dim_strength = 0.75 } })']],
    },
    {
        "󱁐  Gaps Around Windows Remove",
        [=[sed -i -E 's/(gaps_(inner|outer)[[:space:]]*=[[:space:]]*)[0-9]+(,?)/\10\3/' ~/.config/hypr/lua/local-settings.lua]=],
    },
    {
        "󱍕  Group Lock Toggle",
        [[hyprctl dispatch 'hl.dsp.group.lock("toggle")']],
    },
    {
        "  Keybindings Cheatsheet",
        "noctalia msg panel-toggle kenn/keybind-cheatsheet:cheatsheet",
    },
    {
        "  Layout Dwindle Active Workspace",
        string.format(
            [[hyprctl eval 'hl.workspace_rule({ workspace = "%s", layout = "dwindle"})']],
            workspace_id
        ),
    },
    {
        "  Layout Master Active Workspace",
        string.format(
            [[hyprctl eval 'hl.workspace_rule({ workspace = "%s", layout = "master"})']],
            workspace_id
        ),
    },
    {
        "  Layout Scrolling Active Workspace",
        string.format(
            [[hyprctl eval 'hl.workspace_rule({ workspace = "%s", layout = "scrolling"})']],
            workspace_id
        ),
    },
    {
        "󰹟  Layout Monocle Active Workspace",
        string.format(
            [[hyprctl eval 'hl.workspace_rule({ workspace = "%s", layout = "monocle"})']],
            workspace_id
        ),
    },
    {
        "  Layout Dwindle",
        [[hyprctl reload && hyprctl eval 'hl.config({ general = { layout = "dwindle" } })']],
    },
    {
        "󰹟  Layout Monocle",
        [[hyprctl reload && hyprctl eval 'hl.config({ general = { layout = "monocle" } })']],
    },
    {
        "  Layout Scrolling",
        [[hyprctl reload && hyprctl eval 'hl.config({ general = { layout = "scrolling" } })']],
    },
    {
        "  Layout Master",
        [[hyprctl reload && hyprctl eval 'hl.config({ general = { layout = "master" } })']],
    },
    { "󱍕  Lockscreen Widgets Edit", "noctalia msg lockscreen-widgets-edit" },
    {
        "󰖔  Night Light Force Toggle",
        "noctalia msg nightlight-force-toggle",
    },
    { "  Noctalia Settings Toggle", "noctalia msg settings-toggle" },
    {
        "󰑓  Reload Config",
        "hyprctl reload",
    },
    { "  Scratchpad Status", "mmsg dispatch spawn,fish -c scratchpads" },
    {
        "  Search Files",
        "noctalia msg panel-toggle nightwatch75/file-search:panel",
    },
    { "  Session Lock", "noctalia msg session lock" },
    {
        "󰒲  Session Lock and Suspend",
        "noctalia msg session lock-and-suspend",
    },
    { "󰍃  Session Logout", "noctalia msg session logout" },
    {
        "󰹑  Screenshot Region and Annotate",
        [[fish -c "sleep 1; grim -g (slurp -d -c '#74c7ecff') - | satty -f - --copy-command wl-copy -o '~/Pictures/Screenshots/annotated-%Y%m%d-%H%M%S.png'"]],
    },
    {
        "󰹑  Screenshot Screen and Annotate",
        [[fish -c "sleep 1; grim - | satty -f - --copy-command wl-copy -o '~/Pictures/Screenshots/annotated-%Y%m%d-%H%M%S.png'"]],
    },
    { "  Status Bar Toggle", "noctalia msg bar-toggle" },
    {
        "󰔊  Text-to-Speech British English - Ryan",
        [[fish -c "edge-playback --text (wl-paste | string collect) -v en-GB-RyanNeural || notify-send 'TTS Error'"]],
    },
    {
        "󰔊  Text-to-Speech Mexican Spanish - Jorge",
        [[fish -c "edge-playback --text (wl-paste | string collect) -v es-MX-JorgeNeural || notify-send 'TTS Error'"]],
    },
    {
        "󰋱  Window Center",
        [[hyprctl dispatch 'hl.dsp.window.center()']],
    },
    {
        "󰖲  Window Float",
        [[hyprctl dispatch 'hl.dsp.window.float({ action = "toggle" })']],
    },
    {
        "󰊓  Window Fullscreen",
        [[hyprctl dispatch 'hl.dsp.window.fullscreen({ action = "toggle", mode = "fullscreen" })']],
    },
    {
        "  Window Maximize",
        [[hyprctl dispatch 'hl.dsp.window.fullscreen({ action = "toggle", mode = "maximized" })']],
    },
}

-- Format fuzzel menu input
local lines = {}
for _, item in ipairs(commands) do
    table.insert(lines, item[1] .. "\t" .. item[2])
end
local final_input = table.concat(lines, "\n")

-- Execute fuzzel picker
local safe_input = final_input:gsub("'", "'\\''")
local dmenu_cmd = string.format(
    "printf '%%s' '%s' | fuzzel --dmenu --placeholder=' active layout: %s' --with-nth=1 --accept-nth=2 --width=60",
    safe_input,
    layout
)

local chosen_command = capture(dmenu_cmd)

if not chosen_command or chosen_command == "" then
    os.exit(0)
end

-- print("EXECUTING:\n" .. chosen_command)
os.execute(chosen_command)

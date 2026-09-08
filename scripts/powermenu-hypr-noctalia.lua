#!/usr/bin/env lua

-- Helper to execute a shell command and return stdout trimmed
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
        string.format("notify-send -i 'dialog-error' 'Hypr Error' %q", msg)
    )
    os.exit(1)
end

-- Map menu items directly to their execution commands
local actions = {
    ["Logout"] = "command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'",
    ["Suspend"] = "noctalia msg session suspend",
    ["Lock"] = "noctalia msg session lock",
    ["Lock & Suspend"] = "noctalia msg session lock-and-suspend",
    ["Reboot"] = "hyprshutdown -t 'Restarting...' --post-cmd 'reboot' || systemctl reboot",
    ["Shutdown"] = "hyprshutdown -t 'Shutting down...' --post-cmd 'shutdown -P 0' || systemctl poweroff",
}

-- Build fuzzel options input list
local options =
    { "Logout", "Suspend", "Lock", "Lock & Suspend", "Reboot", "Shutdown" }

-- Quote every option individually for shell safety
local quoted_options = {}
for _, opt in ipairs(options) do
    table.insert(quoted_options, string.format("%q", opt))
end

-- Constructs: printf '%s\n' "Logout" "Suspend" "Lock" ... | fuzzel ...
local dmenu_cmd = string.format(
    [[printf '%%s\n' %s | fuzzel --dmenu --minimal-lines --hide-prompt --width=15]],
    table.concat(quoted_options, " ")
)
-- Concatenate items into a tab/space or multi-arg payload for printf
-- local dmenu_cmd = [[printf '%s\n' "Logout" "Suspend" "Lock" "Lock & Suspend" "Reboot" "Shutdown" | fuzzel --dmenu --minimal-lines --hide-prompt --width=15]]

local choice = capture(dmenu_cmd)

-- Graceful exit when pressing Esc or cancelling fuzzel
if not choice or choice == "" then
    os.exit(0)
end

-- Execute mapped action or notify if choice is unexpected
local cmd = actions[choice]
if cmd then
    local ok = os.execute(cmd)
    if not ok then
        notify_error(
            string.format("Failed to execute session action: %s", choice)
        )
    end
else
    notify_error(string.format("Invalid selection: %s", choice))
end

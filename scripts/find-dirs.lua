#!/usr/bin/env lua

local home = os.getenv("HOME") or "/home/tom"

---Executes a shell command asynchronously via nohup
---@param app string
---@param dir_path string
---@return boolean|nil
local function launch_app(app, dir_path)
    -- "nohup %s %s >/dev/null 2>&1 &" app: desktop agnostic
    -- Escape inner double quotes in arguments for the hyprctl call
    local safe_path = dir_path:gsub('"', '\\"')
    local full_cmd = string.format('%s "%s"', app, safe_path)

    -- Using long brackets [=[ ... ]=] keeps outer single/double quotes clean
    local cmd = string.format(
        [=[hyprctl eval 'hl.dispatch(hl.dsp.exec_cmd("%s"))']=],
        full_cmd:gsub('"', '\\"')
    )
    local ok, _, code = os.execute(cmd)
    if not ok then
        local notify = string.format(
            'notify-send -u critical "Error: Command failed" "Exit code: %d"',
            code or 1
        )
        os.execute(notify)
    end
    return ok
end

---Check if path exists and is a directory
---@param path string
---@return boolean
local function is_dir(path)
    local f, _, code = io.open(path .. "/", "r")
    if f then
        f:close()
        return true
    end
    -- Error code 13 (Permission denied) means directory exists
    return code == 13
end

---Capture stdout from a command
---@param cmd string
---@return string|nil
local function capture(cmd)
    local handle = io.popen(cmd)
    if not handle then
        return nil
    end
    local result = handle:read("*a")
    handle:close()
    return result and result:gsub("%s+$", "") or nil
end

---Formats dictionary/table with two columns for Fuzzel (Full Path \t Shortened Display Name)
---@param tbl table<string, string>
---@return string
local function two_col_str_for_fuzzel(tbl)
    local lines = {}
    for col1, col2 in pairs(tbl) do
        -- Clean trailing whitespace/newlines from path keys
        local clean_col1 = col1:gsub("[\r\n]", "")
        local clean_col2 = col2:gsub("[\r\n]", "")
        table.insert(lines, string.format("%s\t%s", clean_col1, clean_col2))
    end
    table.sort(lines, function(a, b)
        -- Sort alphabetically by display name (column 2)
        local display_a = a:match("\t(.*)$") or a
        local display_b = b:match("\t(.*)$") or b
        return display_a:lower() < display_b:lower()
    end)
    return table.concat(lines, "\n")
end

---Formats ordered list of application tables for Fuzzel (Tab-separated: Executable \t Label)
---@param app_list table List of tables with exec and label keys
---@return string
local function app_list_to_fuzzel_str(app_list)
    local lines = {}
    for _, item in ipairs(app_list) do
        table.insert(lines, string.format("%s\t%s", item.exec, item.label))
    end
    return table.concat(lines, "\n")
end

---Passes input string to Fuzzel via stdin using a fixed inspection file
---@param input_data string Data to feed to Fuzzel
---@param fuzzel_args string Command-line flags for Fuzzel
---@return string selection Chosen line (trimmed)
---@return integer exit_code Exit status of Fuzzel
local function run_fuzzel(input_data, fuzzel_args)
    local inspect_file_path = home .. "/.cache/fuzzel_input.txt"

    local f = io.open(inspect_file_path, "w")
    if not f then
        os.execute(
            [[notify-send -i "dialog-error" "Error" "Failed to write fuzzel input file."]]
        )
        os.exit(1)
    end

    f:write(input_data)
    f:close()

    local cmd = string.format("fuzzel %s < %q", fuzzel_args, inspect_file_path)
    local handle = io.popen(cmd, "r")

    if not handle then
        os.execute(
            [[notify-send -i "dialog-error" "Error" "Failed to open Fuzzel process."]]
        )
        os.exit(1)
    end

    local output = handle:read("*a")
    local _, _, code = handle:close()

    local selection = output and output:gsub("[\r\n]+$", "") or ""
    return selection, code or 0
end

------------------ APPLICATION DEFINITIONS -------------------------------
-- Custom applications menu for opening the chosen directory
local applications = {
    {
        exec = "foot --app-id yazi -e yazi",
        label = "Yazi File Manager (Foot)",
    },
    { exec = "nautilus", label = "Nautilus File Manager" },
    { exec = "zeditor", label = "Zed Editor" },
    { exec = "imv", label = "Image Viewer" },
    { exec = home .. "/.local/bin/zen --new-tab", label = "Zen Browser" },
    { exec = "foot -e nvim", label = "Neovim (Foot)" },
}

------------------ SEARCH DIRECTORIES WITH FD ----------------------------
local paths = { home .. "/Documents", "/mnt/sam_ssd/docs", home .. "/Pictures" }
local existing_paths = {}

for _, path in ipairs(paths) do
    if is_dir(path) then
        table.insert(existing_paths, string.format("%q", path))
    end
end

local fd_command
if #existing_paths == 0 then
    -- Fallback: search current directory for non-hidden directories
    fd_command = "fd --type d --exclude '.*'"
else
    -- Search target directories excluding hidden directories
    fd_command = string.format(
        "fd --type d --exclude '.*' . %s",
        table.concat(existing_paths, " ")
    )
end

local found_dirs = capture(fd_command)
if not found_dirs or found_dirs == "" then
    os.execute(
        "notify-send -i 'dialog-information' 'Fuzzel' 'No matching directories found.'"
    )
    os.exit(0)
end

------------------ BUILD DIRECTORY PATH MAP ------------------------------
local dir_paths = {}

for full_path in string.gmatch(found_dirs, "[^\n]+") do
    local clean_full_path = full_path:gsub("/+$", "")

    local prefix = ""
    local rest_path = clean_full_path

    -- Identify prefix and separate the trailing path string
    if clean_full_path:sub(1, #home) == home then
        prefix = "~"
        rest_path = clean_full_path:sub(#home + 1)
    elseif clean_full_path:sub(1, 13) == "/mnt/sam_ssd/" then
        prefix = "󱊟  "
        rest_path = clean_full_path:sub(14)
    elseif clean_full_path == "/mnt/sam_ssd" then
        prefix = "󱊟"
        rest_path = ""
    end

    local display_path = prefix .. rest_path

    -- Truncate if total display length exceeds 80 characters while keeping prefix intact
    if #display_path > 80 then
        -- Calculate how many characters we can retain from the end of rest_path
        -- 70 - #prefix - 3 (for "...")
        local max_rest_len = 80 - #prefix - 3
        if max_rest_len > 0 and #rest_path > max_rest_len then
            display_path = prefix .. "..." .. rest_path:sub(-max_rest_len)
        end
    end

    dir_paths[clean_full_path] = display_path
end

------------------ CHOOSE DIRECTORY PATH ---------------------------------
local dir_lines = two_col_str_for_fuzzel(dir_paths)
local dir_fuzzel_args =
    [[--dmenu --prompt="Directory > " --width=70 --minimal-lines --with-nth=2 --accept-nth=1 --counter]]

local chosen_dir_path, dir_exit_code = run_fuzzel(dir_lines, dir_fuzzel_args)

if dir_exit_code ~= 0 or chosen_dir_path == "" then
    os.exit(0)
end

if not is_dir(chosen_dir_path) then
    os.execute(
        "notify-send -i 'dialog-warning' 'Fuzzel' 'Chosen directory path does not exist.'"
    )
    os.exit(1)
end

------------------ CHOOSE APPLICATION TO OPEN WITH -----------------------
local app_lines = app_list_to_fuzzel_str(applications)
local app_fuzzel_args =
    [[--dmenu --prompt="Open with > " --width=45 --minimal-lines --with-nth=2 --accept-nth=1]]

local chosen_app_exec, app_exit_code = run_fuzzel(app_lines, app_fuzzel_args)

if app_exit_code ~= 0 or chosen_app_exec == "" then
    os.exit(0)
end

------------------ LAUNCH APPLICATION ------------------------------------
launch_app(chosen_app_exec, chosen_dir_path)

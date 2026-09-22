#!/usr/bin/env lua

-- local log = require("log")
local home = os.getenv("HOME")

---Executes a shell command asynchronously via nohup
---@param app string
---@param file_path string
---@return boolean|nil
local function launch_app(app, file_path)
    local cmd = string.format(
        "nohup %s %s >/dev/null 2>&1 &",
        app,
        os.date() and string.format("%q", file_path) or "'" .. file_path .. "'"
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

---Check if file or directory exists
---@param path string Absolute or relative path
---@return boolean
local function path_exists(path)
    local f = io.open(path, "r")
    if f then
        f:close()
        return true
    end
    return false
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

---Formats dictionary/table with two columns for Fuzzel
---@param tbl table<string, string>
---@return string
local function two_col_str_for_fuzzel(tbl)
    local lines = {}
    for col1, col2 in pairs(tbl) do
        table.insert(lines, string.format("%s\t%s", col1, col2))
    end
    table.sort(lines)
    return table.concat(lines, "\n")
end

---Passes input string to Fuzzel via stdin using a fixed inspection file
---@param input_data string Data to feed to Fuzzel
---@param fuzzel_args string Command-line flags for Fuzzel
---@return string selection Chosen line (trimmed)
---@return integer exit_code Exit status of Fuzzel
local function run_fuzzel(input_data, fuzzel_args)
    -- Use a fixed file in /tmp for easy debugging/inspection
    local inspect_file_path = home .. "/.cache/fuzzel_input.txt"

    -- Opening with "w" automatically clears/overwrites old file contents
    local f = io.open(inspect_file_path, "w")
    if not f then
        os.execute(
            [[notify-send -i "dialog-error" "Error" "Failed to write fuzzel input file."]]
        )
        os.exit(1)
    end

    f:write(input_data)
    f:close()

    -- Read from the static file into Fuzzel
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

------------------ CATEGORIES DEFINITION ---------------------------------
local categories = {
    ["PDFs"] = "pdf",
    ["Images"] = "jpg|png|jpeg",
    ["Text Files"] = "txt|md",
    ["Scripts"] = "sh|py|lua",
}

------------------ CHOOSE FILE CATEGORY ----------------------------------
local category_lines = two_col_str_for_fuzzel(categories)
local category_args =
    "--dmenu --hide-prompt --auto-select --minimal-lines --with-nth=1 --accept-nth=1"

local chosen_category, cat_code = run_fuzzel(category_lines, category_args)

if cat_code ~= 0 or chosen_category == "" then
    os.exit(0)
end

local chosen_extensions = categories[chosen_category]
if not chosen_extensions then
    os.execute(
        "notify-send -i 'dialog-error' 'Key Error' 'Selected category not found.'"
    )
    os.exit(1)
end

------------------ SEARCH PATHS ------------------------------------------
local paths = { "/home/tom/Documents", "/mnt/sam_ssd/docs", "/home/tom/Code" }
local existing_paths = {}

for _, path in ipairs(paths) do
    -- Direct filesystem check instead of shell call
    local check_handle = io.popen(string.format("test -d %q && echo 1", path))
    if check_handle then
        local res = check_handle:read("*a")
        check_handle:close()
        if res and res:find("1") then
            table.insert(existing_paths, string.format("%q", path))
        end
    end
end

local fd_command
if #existing_paths == 0 then
    fd_command = string.format([[fd '.*\.(%s)$']], chosen_extensions)
else
    fd_command = string.format(
        [[fd '.*\.(%s)$' %s]],
        chosen_extensions,
        table.concat(existing_paths, " ")
    )
end

local found_files_paths = capture(fd_command)
if not found_files_paths or found_files_paths == "" then
    os.execute(
        "notify-send -i 'dialog-information' 'Fuzzel' 'No matching files found.'"
    )
    os.exit(0)
end

------------------ BUILD FILE PATH MAP -----------------------------------
local file_paths = {}

for full_path in string.gmatch(found_files_paths, "[^\n]+") do
    local shortened_path = full_path:match("[^/]+/[^/]+$") or full_path
    shortened_path = shortened_path:gsub("[_-]", " ")

    if chosen_category == "PDFs" then
        shortened_path = shortened_path:gsub("%.pdf$", "")
    end

    if #shortened_path > 70 then
        file_paths[full_path] = "..." .. shortened_path:sub(-67)
    else
        file_paths[full_path] = shortened_path
    end
end

------------------ CHOOSE FILE PATH --------------------------------------
local file_lines = two_col_str_for_fuzzel(file_paths)

local placeholder_text = ""
if chosen_category == "Text Files" or chosen_category == "Scripts" then
    placeholder_text = "Alt+1: open in Zed"
elseif chosen_category == "PDFs" then
    placeholder_text = "Alt+1: open in Zen Browser"
end

local file_fuzzel_args = string.format(
    [[--dmenu --placeholder=%q --prompt="Search %s > " --width=60 --minimal-lines --with-nth=2 --accept-nth=1]],
    placeholder_text,
    chosen_category
)

local chosen_file_path, file_exit_code =
    run_fuzzel(file_lines, file_fuzzel_args)

if file_exit_code ~= 0 and file_exit_code ~= 10 or chosen_file_path == "" then
    os.exit(0)
end

if not path_exists(chosen_file_path) then
    os.execute(
        "notify-send -i 'dialog-warning' 'Fuzzel' 'Chosen file path does not exist.'"
    )
    os.exit(1)
end

------------------ OPEN FILE ---------------------------------------------
if chosen_category == "Text Files" or chosen_category == "Scripts" then
    local app = (file_exit_code == 10) and "zeditor" or "foot -e nvim"
    launch_app(app, chosen_file_path)
elseif chosen_category == "PDFs" then
    local app = (file_exit_code == 10) and (home .. "/.local/bin/zen --new-tab") or "xdg-open"
    launch_app(app, chosen_file_path)
else
    launch_app("xdg-open", chosen_file_path)
end

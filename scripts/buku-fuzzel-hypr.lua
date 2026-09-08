#!/usr/bin/env lua

---Execute a shell command and capture its stdout
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

---Escape string for single-quoted shell arguments
---@param str string
---@return string
local function shell_escape(str)
    return "'" .. string.gsub(str, "'", "'\\''") .. "'"
end

-- 1. Fetch raw bookmarks from Buku
local raw_buku = capture("/home/tom/.local/bin/buku --nostdin -p -f 5")
if not raw_buku or raw_buku == "" then
    os.exit(0)
end

-- 2. Parse and format lines natively
local formatted_lines = {}
for line in string.gmatch(raw_buku, "[^\r\n]+") do
    local fields = {}
    for field in string.gmatch(line .. "\t", "([^\t]*)\t") do
        table.insert(fields, field)
    end

    local id = fields[1]
    local title = fields[2]
    local tags = fields[3] or ""

    if id and title and id ~= "" then
        local tag_str = (tags ~= "") and (" # " .. tags) or ""
        table.insert(
            formatted_lines,
            string.format("%s | %s%s", id, title, tag_str)
        )
    end
end

if #formatted_lines == 0 then
    os.exit(0)
end

-- 3. Execute Fuzzel ONCE via printf pipe
local input_payload = table.concat(formatted_lines, "\n")
local fuzzel_cmd = string.format(
    "printf %%s %s | fuzzel --dmenu -p 'Bookmarks > ' --width=50",
    shell_escape(input_payload)
)

local fuzzel_read = io.popen(fuzzel_cmd)
if not fuzzel_read then
    os.exit(1)
end

local selection = fuzzel_read:read("*l")
local _, _, exit_code = fuzzel_read:close()

-- Exit status 0 = Enter, 10 = Custom keybinding (e.g. Alt+1)
if (exit_code ~= 0 and exit_code ~= 10) or not selection or selection == "" then
    os.exit(0)
end

-- 4. Extract ID and fetch URL from Buku
local id = string.match(selection, "^(%d+)")
if not id then
    os.exit(1)
end

local raw_record =
    capture(string.format("/home/tom/.local/bin/buku -p %s --format 1", id))
if not raw_record or raw_record == "" then
    os.exit(1)
end

-- Extract second TSV field (URL)
local record_fields = {}
for field in string.gmatch(raw_record .. "\t", "([^\t]*)\t") do
    table.insert(record_fields, field)
end

local url = record_fields[2]
if not url or url == "" then
    os.exit(1)
end

-- 5. Dispatch command based on $XDG_CURRENT_DESKTOP
-- make desktop names lowercase
local desktop = (os.getenv("XDG_CURRENT_DESKTOP") or ""):lower()
local zen_cmd =
    string.format("/home/tom/.local/bin/zen --new-tab %s", shell_escape(url))

if desktop == "hyprland" then
    local hypr_payload = string.format([[hl.dsp.exec_cmd("%s")]], zen_cmd)
    os.execute(string.format("hyprctl dispatch %s", shell_escape(hypr_payload)))
else
    os.execute(zen_cmd)
end

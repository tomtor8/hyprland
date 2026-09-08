#!/usr/bin/env lua

local home = os.getenv("HOME")
package.path = package.path .. ";" .. home .. "/Code/lua/modules/?.lua"

local in_out = require("ioutils")

-- the echo -e recognizes escape characters
local dmenu_command =
    "echo -e 'HEX\nRGB\nRGBA\nCMYK\nHSL\nHSV' | fuzzel --dmenu --minimal-lines --hide-prompt --width=10 --font='Exo:size=20' --line-height=40"

local chosen_format = in_out.get_fuzzel_output(dmenu_command)

-- pause the script for the fuzzel window to disappear
os.execute("sleep 1")

local chosen_color

-- hyprpicker -q quiet
-- -a copies the output to clipboard, -n sends notification
-- -f format, -o output format

if chosen_format == "RGB" then
    os.execute([[hyprpicker -q -a -n -f rgb -o "rgb({0}, {1}, {2})"]])
elseif chosen_format == "RGBA" then
    os.execute([[hyprpicker -q -a -n -f rgb -o "rgba({0}, {1}, {2}, 1.0)"]])
elseif chosen_format == "HEX" then
    os.execute([[hyprpicker -q -a -n -f hex]])
elseif chosen_format == "CMYK" then
    os.execute(
        [[hyprpicker -q -a -n -f cmyk -o "cmyk({0}%, {1}%, {2}%, {3}%)"]]
    )
elseif chosen_format == "HSL" then
    os.execute([[hyprpicker -q -a -n -f hsl -o "hsl({0}, {1}%, {2}%)"]])
elseif chosen_format == "HSV" then
    os.execute([[hyprpicker -q -a -n -f hsv -o "hsv({0}, {1}%, {2}%)"]])
else
    os.execute(
        "notify-send -i 'dialog-warning' 'Fuzzel' 'Failed to match color from color-picker output'"
    )
    os.exit(1)
end

-- if pressing Esc during color-picking
if chosen_color == nil or chosen_color == "" then
    os.exit(0)
end

local M = {}

local layout_modules = {
    "lua.layouts.manual",
    "lua.layouts.centered-master-column",
    "lua.layouts.grid-mango",
}

function M.setup(cfg)
    -- Built-in Layouts Setup {{{1
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
    -- }}}
    -- Import custom layout modules {{{1
    for _, module_name in ipairs(layout_modules) do
        local ok, err = pcall(require, module_name)
        if not ok then
            print(string.format("[hyprland] Failed to load layout '%s': %s", module_name, err))
        end
    end
    -- }}}
end

return M

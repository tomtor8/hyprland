local M = {}

---Make floating and resize active window
---If already floating, just resize window
---@param width_perc integer Window width 0.1-1.0
---@param height_perc integer Window width 0.1-1.0
---@return nil
function M.float_and_resize(width_perc, height_perc)
    local win = hl.get_active_window()
    if not win then
        return
    end -- Guard clause: exit early if no window is focused
    local mon = hl.get_active_monitor() or {}
    local scale = mon.scale or 1.5
    -- Calculate dimensions (with safe fallbacks and integer conversion)
    local width = mon.width and math.floor((mon.width * width_perc) / scale)
        or 1000
    local height = mon.height and math.floor((mon.height * height_perc) / scale)
        or 800
    -- Enable floating only if it's currently tiled
    if not win.floating then
        hl.dispatch(hl.dsp.window.float({ action = "on" }))
    end
    -- Perform common actions once
    hl.dispatch(hl.dsp.window.resize({ x = width, y = height }))
    hl.dispatch(hl.dsp.window.center())
end
return M

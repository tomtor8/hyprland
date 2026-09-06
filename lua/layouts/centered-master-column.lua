local state = {
    master_ratio = 0.50, -- Centered master column gets 50% width by default
}

local function clamp(x, min, max)
    return math.max(min, math.min(max, x))
end

hl.layout.register("cen_master_cols", {
    recalculate = function(ctx)
        local n = #ctx.targets
        if n == 0 then
            return
        end

        local area = ctx.area

        -- 1 Window: Fullscreen
        if n == 1 then
            ctx.targets[1]:place(area)
            return
        end

        -- 2 Windows: Master on Left/Center, 1 Stack on Right
        if n == 2 then
            ctx.targets[1]:place(ctx:split(area, "left", state.master_ratio))
            ctx.targets[2]:place(
                ctx:split(area, "right", 1.0 - state.master_ratio)
            )
            return
        end

        -- 3+ Windows: 3-Column Layout (Left Stack | Center Master | Right Stack)
        local side_ratio = (1.0 - state.master_ratio) / 2

        -- Slice area into 3 distinct vertical columns
        local left_area = ctx:split(area, "left", side_ratio)
        local right_area = ctx:split(area, "right", side_ratio)
        local master_area = ctx:split(
            ctx:split(area, "left", 1.0 - side_ratio),
            "right",
            state.master_ratio / (1.0 - side_ratio)
        )

        -- Categorize target windows
        local right_targets = {}
        local left_targets = {}

        for i = 2, n do
            if i % 2 == 0 then
                table.insert(right_targets, ctx.targets[i])
            else
                table.insert(left_targets, ctx.targets[i])
            end
        end

        -- 1. Place Master
        ctx.targets[1]:place(master_area)

        -- 2. Place Left Stack (Vertically Split)
        local left_count = #left_targets
        local left_h_base = math.floor(left_area.h / left_count)
        for idx, target in ipairs(left_targets) do
            local h = (idx == left_count)
                    and ((left_area.y + left_area.h) - (left_area.y + (idx - 1) * left_h_base))
                or left_h_base

            target:place({
                x = left_area.x,
                y = left_area.y + (idx - 1) * left_h_base,
                width = left_area.w,
                height = h,
            })
        end

        -- 3. Place Right Stack (Vertically Split)
        local right_count = #right_targets
        local right_h_base = math.floor(right_area.h / right_count)
        for idx, target in ipairs(right_targets) do
            local h = (idx == right_count)
                    and ((right_area.y + right_area.h) - (right_area.y + (idx - 1) * right_h_base))
                or right_h_base

            target:place({
                x = right_area.x,
                y = right_area.y + (idx - 1) * right_h_base,
                width = right_area.w,
                height = h,
            })
        end
    end,

    layout_msg = function(ctx, msg)
        local command, arg = msg:match("^(%S+)%s*(.*)$")

        if command == "mratio" then
            state.master_ratio =
                clamp(tonumber(arg) or state.master_ratio, 0.2, 0.8)
        elseif command == "mgrow" then
            state.master_ratio = clamp(state.master_ratio + 0.05, 0.2, 0.8)
        elseif command == "mshrink" then
            state.master_ratio = clamp(state.master_ratio - 0.05, 0.2, 0.8)
        else
            return "cen_master_cols: expected mratio <0.2..0.8>, mgrow, or mshrink"
        end

        return true
    end,
})

return "cen_master_cols"

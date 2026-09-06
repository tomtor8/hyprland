-- Custom Grid Layout
hl.layout.register("grid", {
    recalculate = function(ctx)
        local n = #ctx.targets
        if n == 0 then
            return
        end

        local area = ctx.area

        -- 1 Window: Centered floating box (70% width, 80% height)
        if n == 1 then
            local v_slice = ctx:split(area, "top", 0.90)
            local center = ctx:split(v_slice, "bottom", 0.888) -- ~0.80 height
            local h_slice = ctx:split(center, "left", 0.85)
            local box = ctx:split(h_slice, "right", 0.823) -- ~0.70 width

            ctx.targets[1]:place(box)
            return
        end

        -- 2 Windows: Side-by-side floating boxes (50% width, 80% height)
        if n == 2 then
            local v_slice = ctx:split(area, "top", 0.90)
            local body = ctx:split(v_slice, "bottom", 0.888)

            ctx.targets[1]:place(ctx:split(body, "left", 0.50))
            ctx.targets[2]:place(ctx:split(body, "right", 0.50))
            return
        end

        -- 3 Windows: Top 2 side-by-side, 3rd centered on bottom row
        if n == 3 then
            local top_half = ctx:split(area, "top", 0.50)
            local bottom_half = ctx:split(area, "bottom", 0.50)

            -- Top row split 50/50
            ctx.targets[1]:place(ctx:split(top_half, "left", 0.50))
            ctx.targets[2]:place(ctx:split(top_half, "right", 0.50))

            -- Bottom row centered 50% width box
            local b_left = ctx:split(bottom_half, "left", 0.75)
            local b_center = ctx:split(b_left, "right", 0.666)
            ctx.targets[3]:place(b_center)
            return
        end

        -- 4+ Windows: Uniform grid with centered incomplete last row
        local cols = math.ceil(math.sqrt(n))
        local rows = math.ceil(n / cols)

        local last_row_count = n % cols
        if last_row_count == 0 then
            last_row_count = cols
        end

        for i, target in ipairs(ctx.targets) do
            local row = math.floor((i - 1) / cols)

            -- Complete rows use built-in grid_cell helper
            if last_row_count == cols or row < (rows - 1) then
                target:place(ctx:grid_cell(i, cols))
            else
                -- Incomplete last row: center elements horizontally
                local col_w = math.floor(area.w / cols)
                local row_h = math.floor(area.h / rows)
                local last_row_offset =
                    math.floor((area.w - (last_row_count * col_w)) / 2)
                local col = (i - 1) % cols

                target:place({
                    x = area.x + last_row_offset + (col * col_w),
                    y = area.y + (row * row_h),
                    w = col_w,
                    h = row_h,
                })
            end
        end
    end,
})

return "grid"

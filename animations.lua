-- Curves and Beziers
hl.curve(
    "easeOutQuint",
    { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } }
)
hl.curve(
    "easeInOutCubic",
    { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } }
)
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

-- Bouncy Beziers
hl.curve("bounce", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.25 } } })
hl.curve("overshoot", { type = "bezier", points = { { 0.34, 1.3 }, { 0.64, 1 } } })

-- Tuned Springs (Balanced elasticity and dampening)
-- Smooth general spring with subtle bounce
hl.curve(
    "smoothBounce",
    { type = "spring", mass = 1.0, stiffness = 160, dampening = 15 }
    -- { type = "spring", mass = 0.8, stiffness = 100, dampening = 12 }
)
-- Snappier spring for window popins and exits
hl.curve(
    "playfulSpring",
    { type = "spring", mass = 0.8, stiffness = 180, dampening = 12 }
)

-- Animations
hl.animation({
    leaf = "global",
    enabled = true,
    speed = 10,
    bezier = "default",
})
hl.animation({
    leaf = "border",
    enabled = true,
    speed = 5.39,
    bezier = "easeOutQuint",
})
hl.animation({
    leaf = "windows",
    enabled = true,
    speed = 5,
    spring = "smoothBounce",
})
hl.animation({
    leaf = "windowsIn",
    enabled = true,
    speed = 4.5,
    spring = "playfulSpring",
    style = "popin 65%",
})
hl.animation({
    leaf = "windowsOut",
    enabled = true,
    speed = 4,
    spring = "playfulSpring",
    style = "popin 65%",
})
hl.animation({
    leaf = "fadeIn",
    enabled = true,
    speed = 2.2,
    bezier = "almostLinear",
})
hl.animation({
    leaf = "fadeOut",
    enabled = false,
    speed = 10,
    bezier = "almostLinear",
})
hl.animation({
    leaf = "fade",
    enabled = false,
    speed = 3.03,
    bezier = "quick",
})
hl.animation({
    leaf = "layers",
    enabled = true,
    speed = 4.5,
    spring = "smoothBounce",
})
hl.animation({
    leaf = "layersIn",
    enabled = true,
    speed = 4,
    spring = "playfulSpring",
    style = "slide top",
})
hl.animation({
    leaf = "layersOut",
    enabled = true,
    speed = 3.5,
    bezier = "easeOutQuint",
    style = "slide bottom",
})
hl.animation({
    leaf = "fadeLayersIn",
    enabled = true,
    speed = 2,
    bezier = "almostLinear",
})
hl.animation({
    leaf = "fadeLayersOut",
    enabled = true,
    speed = 1.8,
    bezier = "almostLinear",
})
hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = 4,
    spring = "smoothBounce",
    style = "slidevert",
})
hl.animation({
    leaf = "workspacesIn",
    enabled = true,
    speed = 4,
    spring = "smoothBounce",
    style = "slidevert",
})
hl.animation({
    leaf = "workspacesOut",
    enabled = true,
    speed = 4,
    spring = "smoothBounce",
    style = "slidevert",
})
hl.animation({
    leaf = "specialWorkspace",
    enabled = true,
    speed = 4.5,
    spring = "smoothBounce",
    style = "slide left",
})
hl.animation({
    leaf = "zoomFactor",
    enabled = true,
    speed = 6,
    spring = "smoothBounce",
})

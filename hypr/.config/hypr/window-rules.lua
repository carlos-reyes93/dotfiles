hl.window_rule({
  -- Ignore maximize requests from all apps. You'll probably like this.
  name           = "suppress-maximize-events",
  match          = { class = ".*" },

  suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
  -- Fix some dragging issues with XWayland
  name     = "fix-xwayland-drags",
  match    = {
    class      = "^$",
    title      = "^$",
    xwayland   = true,
    float      = true,
    fullscreen = false,
    pin        = false,
  },

  no_focus = true,
})

-- Hyprland-run windowrule
hl.window_rule({
  name  = "move-hyprland-run",
  match = { class = "hyprland-run" },

  move  = "20 monitor_h-120",
  float = true,
})
hl.window_rule({
  match = { class = "dev.noctalia.Noctalia" },
  float = true,
  size = { 1080, 920 },
})
-- ShowMeTheKey
hl.window_rule({
  name = "showmethekey-float",
  match = {
    class = "^one\\.alynx\\.showmethekey$",
  },
  float = true,
})

hl.window_rule({
  name = "showmethekey-gtk-float",
  match = {
    class = "^showmethekey-gtk$",
  },
  float = true,
})

hl.window_rule({
  name = "showmethekey-gtk-pin",
  match = {
    class = "^showmethekey-gtk$",
  },
  pin = true,
})

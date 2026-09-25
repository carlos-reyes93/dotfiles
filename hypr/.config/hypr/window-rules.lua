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
hl.window_rule({
  name = "steam",
  match = {
    class = "^steam"
  },
  workspace = "special:steam"
})
hl.window_rule({
  name = "obs",
  match = {
    class = "^com.obsproject.Studio"
  },
  workspace = "special:gsm"
})
hl.window_rule({
  name = "steam-games-to-ws5",
  match = {
    initial_class = "steam_app_.*"
  },
  workspace = "5"
})

hl.on("window.open", function(w)
  if w.class ~= "firefox" then return end
  if w.initial_title ~= "Mozilla Firefox" then return end

  local ff_windows = hl.get_windows({ class = "firefox" })
  if #ff_windows <= 1 then return end

  hl.dispatch(hl.dsp.window.float({ action = "set", window = w }))

  local sub
  sub = hl.on("window.title", function(tw)
    if tw.address ~= w.address then return end
    if tw.title == ""
        or tw.title == "Mozilla Firefox"
        or tw.title == "about:blank"
        or tw.title:match("^about:.*Mozilla Firefox$") then
      return
    end

    sub:remove()

    if tw.title:match("^Extension:") then
      hl.dispatch(hl.dsp.window.resize({ x = 800, y = 600, window = tw }))
      hl.dispatch(hl.dsp.window.center({ window = tw }))
      hl.dispatch(hl.dsp.focus({ window = tw }))
    else
      hl.dispatch(hl.dsp.window.float({ action = "unset", window = tw }))
    end
  end)
end)

hl.window_rule({
  name = "gsm-overlay-noblur",
  match = { title = "GSM Overlay" },
  no_blur = true,
  no_shadow = true,
  no_dim = true,
  move = "0 0",
  size = "2560 1440",
})
-- ── pin special-workspace windows so they can't be dragged out ──
local pin_map = {
  discord = "special:discord",
  gsm     = "special:gsm",
  steam   = "special:steam",
  code    = "special:code",
}

hl.on("window.open", function(w)
  local ws_name = w.workspace and w.workspace.name
  for tag, workspace in pairs(pin_map) do
    if ws_name == workspace then
      hl.dispatch(hl.dsp.window.tag({ tag = "+" .. tag, window = w }))
    end
  end
end)

hl.on("window.move_to_workspace", function(w, ws)
  for tag, workspace in pairs(pin_map) do
    local tagged = hl.get_windows({ tag = tag })
    for _, tw in ipairs(tagged) do
      if tw.address == w.address and ws.name ~= workspace then
        hl.dispatch(hl.dsp.window.move({ workspace = workspace, window = w }))
        return
      end
    end
  end
end)

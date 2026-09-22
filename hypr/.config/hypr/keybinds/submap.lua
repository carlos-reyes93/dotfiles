local home = os.getenv("HOME")
local noctaliaIPC = "noctalia msg "
local eww_bin = home .. "/.local/bin/eww"
local whichkey_window = "whichkey-bottom-right"
local C = require("config")

local mainMod = C.MOD
hl.on("hyprland.start", function()
  hl.exec_cmd(eww_bin .. " daemon")
end)

-- ── special workspaces ──────────────────────────────────────
local function toggle_special_app(name, class, cmd)
  local matches = hl.get_windows({ class = class })
  if #matches == 0 then
    hl.dispatch(hl.dsp.exec_cmd(
      string.format("[workspace special:%s silent] %s", name, cmd)
    ))
  end
  hl.dispatch(hl.dsp.workspace.toggle_special(name))
end

-- ── eww overlay helpers ──────────────────────────────────────
local function hide_overlay()
  hl.exec_cmd(eww_bin .. " close " .. whichkey_window .. " 2>/dev/null")
end

local function items_json_from(entries)
  local parts = {}
  for _, e in ipairs(entries) do
    table.insert(parts, string.format('{"key":"%s","desc":"%s"}', e.key, e.label))
  end
  return "[" .. table.concat(parts, ",") .. "]"
end

local function show_overlay(title, entries)
  hl.exec_cmd(string.format(
    "%s update title='%s' items='%s'",
    eww_bin, title, items_json_from(entries)
  ))
  hide_overlay()
  hl.exec_cmd(
    eww_bin .. " open " .. whichkey_window ..
    " --screen $(hyprctl monitors -j | jq '[.[] | select(.focused==true)][0].id')"
  )
end

-- ── Generic submap factory ───────────────────────────────────
-- entries: array of either
--   { key, label, action = function() ... end }                  -- leaf
--   { key, label, submap = "child_name", entries = {...} }        -- branch
--
-- Builds the submap's keybinds AND its eww overlay from one table,
-- recursing into any nested branches automatically.
-- Returns a `show()` function you can call to enter this submap from outside.
local function make_submap(name, entries, parent_name, parent_entries)
  hl.define_submap(name, function()
    for _, e in ipairs(entries) do
      if e.submap then
        -- Branch: recursively build the child, then bind into it
        make_submap(e.submap, e.entries, name, entries)
        hl.bind(e.key, function()
          show_overlay(e.submap, e.entries)
          hl.dispatch(hl.dsp.submap(e.submap))
        end)
      else
        -- Leaf: run the action and fully exit
        hl.bind(e.key, function()
          hide_overlay()
          hl.dispatch(hl.dsp.submap("reset"))
          if e.action then e.action() end
        end)
      end
    end

    -- Full reset from any depth
    hl.bind("SHIFT + escape", function()
      hide_overlay()
      hl.dispatch(hl.dsp.submap("reset"))
    end)

    -- One level back (or full exit, if this is the top level)
    if parent_name then
      hl.bind("escape", function()
        show_overlay(parent_name, parent_entries)
        hl.dispatch(hl.dsp.submap(parent_name))
      end)
    else
      hl.bind("escape", function()
        hide_overlay()
        hl.dispatch(hl.dsp.submap("reset"))
      end)
    end
  end)

  return function()
    show_overlay(name, entries)
  end
end

-- ── Define your menu tree ────────────────────────────────────
local browsers_entries = {
  { key = "f", label = "Firefox",  action = function() hl.exec_cmd("firefox") end },
  { key = "c", label = "Chromium", action = function() hl.exec_cmd("chromium") end },
}




local apps_entries = {
  { key = "t", label = "Terminal",     action = function() hl.exec_cmd(C.terminal) end },
  { key = "b", label = "+Browsers",    submap = "browsers",                               entries = browsers_entries },
  { key = "e", label = "File Manager", action = function() hl.exec_cmd(C.fileManager) end },
  -- { key = "s", label = "+Special workspaces", submap = "special_workspaces",                     entries = special_workspaces_entries },
  {
    key = "a",
    label = "Launcher",
    action = function()
      hl.dispatch(hl.dsp.exec_cmd(noctaliaIPC ..
        "panel-toggle launcher"))
    end
  },
  {
    key = "k",
    label = "Noctalia CC",
    action = function()
      hl.dispatch(hl.dsp.exec_cmd(noctaliaIPC ..
        "panel-toggle control-center"))
    end
  },
  {
    key = "s",
    label = "Noctalia Settings",
    action = function()
      hl.dispatch(hl.dsp.exec_cmd(noctaliaIPC ..
        "settings-toggle"))
    end
  },
}

local show_apps = make_submap("apps", apps_entries)

local window_action_entries = {
  {
    key = "f",
    label = "Fullscreen",
    action = function()
      hl.dispatch(hl.dsp.window.fullscreen({ action = "toggle", mode = "fullscreen" }))
    end
  },

  {
    key = "c",
    label = "Close window",
    action = function()
      hl.dispatch(hl.dsp.window.close())
    end
  }
}

local show_win_actions = make_submap("window_actions", window_action_entries)

local special_workspaces_entries = {
  {
    key = "d",
    label = "Discord",
    action = function() toggle_special_app("discord", "vesktop", "vesktop") end
  },
  {
    key = "g",
    label = "GSM",
    action = function() toggle_special_app("gsm", "com.beangate.gamesentenceminer", home .. "/.local/bin/gsm") end
  },
  {
    key = "t",
    label = "Steam",
    action = function() toggle_special_app("steam", "steam", "steam") end
  },
  {
    key = "m",
    label = "Magic",
    action = function() hl.dispatch(hl.dsp.workspace.toggle_special("magic")) end
  }
}

-- Example special workspace (scratchpad)
-- hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))
local show_special_workspaces = make_submap("special_workspaces", special_workspaces_entries)
hl.bind(mainMod .. " + S", function()
  show_special_workspaces()
  hl.dispatch(hl.dsp.submap("special_workspaces"))
end)

hl.bind("SUPER + W", function()
  show_win_actions()
  hl.dispatch(hl.dsp.submap("window_actions"))
end)

hl.bind("SUPER + T", function()
  show_apps()
  hl.dispatch(hl.dsp.submap("apps"))
end)

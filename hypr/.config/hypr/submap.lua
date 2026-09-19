local home = os.getenv("HOME")
local eww_bin = home .. "/.local/bin/eww"
local whichkey_window = "whichkey-bottom-right"

hl.on("hyprland.start", function()
  hl.exec_cmd(eww_bin .. " daemon")
end)

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
  { key = "x", label = "Terminal",  action = function() hl.exec_cmd("foot") end },
  { key = "b", label = "+Browsers", submap = "browsers",                                                          entries = browsers_entries },
  { key = "n", label = "Notes",     action = function() hl.exec_cmd(home .. "/.config/hypr/scripts/notes.sh") end },
  { key = "t", label = "Telegram",  action = function() hl.exec_cmd("telegram-desktop") end },
  { key = "c", label = "Code",      action = function() hl.exec_cmd("code") end },
}

local show_apps = make_submap("apps", apps_entries)

hl.bind("SUPER + X", function()
  show_apps()
  hl.dispatch(hl.dsp.submap("apps"))
end)

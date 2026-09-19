# Adding Submaps

This config uses a `make_submap` factory so every submap — and any nested
sub-menu inside it — is built from one plain Lua table. You never wire up
keybinds and the eww overlay separately; they're generated together.

## The entries table

Each submap is described by an array of entries. Every entry is either a
**leaf** (does something) or a **branch** (opens a nested sub-menu):

```lua
-- Leaf: runs an action, then fully exits the submap
{ key = "x", label = "Terminal", action = function() hl.exec_cmd("kitty") end }

-- Branch: opens a nested sub-menu
{ key = "b", label = "+Browsers", submap = "browsers", entries = browsers_entries }
```

By convention, prefix a branch's label with `+` so it's visually obvious in
the overlay which keys go deeper vs. which run an action right away.

## Adding a new top-level submap

Say you want a `SUPER + S` submap for screenshots. Just write the table and
call `make_submap` — no manual `hl.define_submap`, no hand-written JSON:

```lua
local screenshot_entries = {
    { key = "s", label = "Screen",  action = function() hl.exec_cmd("grimblast copy screen") end },
    { key = "r", label = "Region",  action = function() hl.exec_cmd("grimblast copy area") end },
    { key = "w", label = "Window",  action = function() hl.exec_cmd("grimblast copy active") end },
}

local show_screenshots = make_submap("screenshots", screenshot_entries)

hl.bind("SUPER + S", function()
    show_screenshots()
    hl.dispatch(hl.dsp.submap("screenshots"))
end)
```

That's the whole addition. `make_submap` handles:
- binding every leaf key to run its `action`, close the overlay, and reset
- binding `escape` and `SHIFT + escape` for you automatically
- building the eww overlay JSON straight from the entries table

## Nesting a sub-menu inside another submap

Just add a branch entry pointing at a child table — nesting is a property
of the *data*, not something you wire by hand:

```lua
local browsers_entries = {
    { key = "f", label = "Firefox",  action = function() hl.exec_cmd("firefox") end },
    { key = "c", label = "Chromium", action = function() hl.exec_cmd("chromium") end },
}

local apps_entries = {
    { key = "x", label = "Terminal", action = function() hl.exec_cmd("kitty") end },
    { key = "b", label = "+Browsers", submap = "browsers", entries = browsers_entries },
    -- ... more entries ...
}

local show_apps = make_submap("apps", apps_entries)

hl.bind("SUPER SHIFT + X", function()
    show_apps()
    hl.dispatch(hl.dsp.submap("apps"))
end)
```

`make_submap` recurses into every branch it finds, so nesting a third level
inside `browsers` is exactly the same move: give that entry a `submap` name
and its own `entries` table. There's no depth limit and nothing extra to
wire up — `escape` at each level automatically goes back exactly one level
(re-showing the parent's overlay and switching to the parent's submap name),
and `SHIFT + escape` always fully resets, regardless of how deep you are.

## Checklist for every new entry

**Leaf** (`action` set):
- [ ] `key` and `label` set
- [ ] `action` is a function that does the actual work (`hl.exec_cmd(...)`,
      a dispatcher, etc.) — you don't need to call `hide_overlay()` or
      `hl.dispatch(hl.dsp.submap("reset"))` yourself, `make_submap` already
      does that around every leaf action

**Branch** (`submap` + `entries` set):
- [ ] `key` and `label` set (label prefixed with `+` by convention)
- [ ] `submap` is a unique name not used anywhere else in the tree
- [ ] `entries` is a normal entries table (can itself contain more branches)

## Quick reference: the shared helpers

These live near the top of `hyprland.lua` and don't need to be touched when
adding new submaps — only read this if something's not behaving as expected.

| Helper | What it does |
|---|---|
| `hide_overlay()` | Closes the eww `whichkey-bottom-right` window |
| `items_json_from(entries)` | Turns an entries table into the JSON string eww expects |
| `show_overlay(title, entries)` | Updates eww's vars and opens the window on the currently focused monitor |
| `make_submap(name, entries, parent_name, parent_entries)` | The factory: recursively builds a submap (and any nested branches) from an entries table, wiring keybinds, `escape`/`SHIFT + escape`, and the eww overlay together. Returns a `show()` function — call it before dispatching into that submap for the first time (e.g. from a top-level `hl.bind`). The `parent_name`/`parent_entries` params are set automatically during recursion; you never pass them yourself when defining a top-level submap. |

**Note on redefinition:** because nested submaps are defined via recursive
calls inside the parent's `hl.define_submap` callback, a child submap gets
redefined every time its parent's callback runs. This matches Hyprland's own
lexical-nesting idiom and works correctly, but if you build out a very large,
deeply nested tree, it's worth keeping an eye on config reload performance —
this hasn't been tested at scale.

## Testing without reloading Hyprland

```bash
hyprctl reload
```

If the overlay doesn't behave as expected, tail eww's own log in a spare
terminal while you trigger the submap:

```bash
tail -f ~/.cache/eww/eww.log
```

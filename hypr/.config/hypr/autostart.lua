local C = require("config")
local terminal = C.terminal

hl.on("hyprland.start", function()
  hl.exec_cmd(terminal)
  hl.exec_cmd("firefox")
  hl.exec_cmd("nm-applet")
  hl.exec_cmd("waybar & hyprpaper & firefox")
  hl.exec_cmd("noctalia")
  hl.exec_cmd("systemctl --user enable --now hyprpolkitagent.service")
end)

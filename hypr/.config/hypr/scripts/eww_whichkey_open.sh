#!/bin/bash
EWW_BIN="$HOME/.local/bin/eww"
WINDOW="whichkey-bottom-right"

monitor_id=$(hyprctl monitors -j | jq '[.[] | select(.focused==true)][0].id')

# Close first in case it's lingering open on a different monitor
"$EWW_BIN" close "$WINDOW" 2>/dev/null
"$EWW_BIN" open "$WINDOW" --screen "$monitor_id"

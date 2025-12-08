#!/usr/bin/env sh
set -eux

terminal="foot"
flags='--dmenu --placeholder Repository  --lines 7  -B 3 -w 45'

configs="$(ls -1d "$HOME"/repos/*/ 2>/dev/null | xargs -n1 basename)"

[ -n "$configs" ] || exit 0
chosen="$(printf '%s\n' $configs | fuzzel $flags)"
[ -n "$chosen"  ] || exit 0
dir="$HOME/repos/$chosen"

pkill -f $terminal 2>/dev/null || true
sleep 0.1

exec $terminal tmux new-session -As "$chosen" -c "$dir"


#!/usr/bin/env sh
set -eu



TMUX_BIN=tmux
# List existing tmux sessions (just names)
sessions="$(tmux list-sessions -F '#{session_name}' 2>/dev/null || true)"


# Show the menu with fuzzel
choice="$(tmux list-sessions -F '#{session_name}' | fzf --tmux)"
[ -n "$choice" ] || exit 0


# Inside tmux
if [ -n "${TMUX-}" ]; then
    if ! "$TMUX_BIN" has-session -t "$choice" 2>/dev/null; then
        "$TMUX_BIN" new-session -ds "$choice"
        exit 0
    fi
    exec "$TMUX_BIN" switch-client -t "$choice"
    exit 0
fi

tmux new-session -As "$choice" 


#!/usr/bin/env sh
set -eu

# Check required binaries
TMUX_BIN="$(command -v tmux || { echo 'tmux not found'; exit 1; })"
FOOT_BIN="$(command -v foot || { echo 'foot not found'; exit 1; })"
FUZZEL_BIN="$(command -v fuzzel || { echo 'fuzzel not found'; exit 1; })"
term=foot

# Fuzzel options (dmenu mode)
FUZZEL_OPTS='--dmenu --placeholder "Session" --lines 7  -B 3 -w 120'
NEW_SESSION_OPTS='--dmenu --lines 7  -B 3 -w 120'

# List existing tmux sessions (just names)
sessions="$("$TMUX_BIN" list-sessions -F '#{session_name}' 2>/dev/null || true)"

# Add a "create new" entry at the top
menu="Create new session…\n$sessions"

# Show the menu with fuzzel
choice="$(printf '%b' "$menu" | eval "$FUZZEL_BIN $FUZZEL_OPTS" || true)"
[ -n "$choice" ] || exit 0

# If creating new session, ask for the session name
if [ "$choice" = "Create new session…" ]; then
    
    new_name="$(printf '' | eval "$FUZZEL_BIN $NEW_SESSION_OPTS --prompt-only 'New session name:'" || true)"
    [ -n "$new_name" ] || exit 0
    session="$new_name"
    create=1
else
    session="$choice"
    create=0
fi

# Inside tmux
if [ -n "${TMUX-}" ]; then
    if [ "$create" -eq 1 ] && ! "$TMUX_BIN" has-session -t "$session" 2>/dev/null; then
        "$TMUX_BIN" new-session -ds "$session"
    fi
    exec "$TMUX_BIN" switch-client -t "$session"
fi

# Outside tmux
pkill -f foot
sleep 0.1

if [ "$create" -eq 1 ]; then
    exec "$FOOT_BIN"  "$TMUX_BIN" new-session -s "$session" 
else
    exec "$FOOT_BIN"  "$TMUX_BIN" attach -t "$session"
fi


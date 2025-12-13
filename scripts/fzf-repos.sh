#!/usr/bin/env sh

set -eu

repo="$(ls "$HOME/repos" | fzf --tmux)"
[ -n "$repo" ] || exit 0
dir="$HOME/repos/$repo"
session="$(printf '%s' "$repo" | tr '.' '-')"
if [ -n "${TMUX-}" ]; then
    # Already inside tmux → switch or create silently
    if tmux has-session -t "$session" 2>/dev/null; then
        tmux switch-client -t "$session"
    else
        tmux new-session -ds "$session" -c "$dir"
        tmux switch-client -t "$session"
    fi
else
    # Not inside tmux → attach or create
    tmux new-session -As "$session" -c "$dir"
fi

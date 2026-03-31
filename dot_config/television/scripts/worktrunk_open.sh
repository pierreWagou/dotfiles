#!/bin/sh
# wt-open: ensure worktree exists then open a tmux window with 3-pane layout
#
# Usage: wt-open <branch> [--create]
#
# Layout (nvim zoomed on entry):
#   ┌──────────┬─────────────┐
#   │          │             │
#   │   nvim   │  opencode   │
#   │ (zoomed) │             │
#   ├──────────┤             │
#   │ terminal │             │
#   └──────────┴─────────────┘

B="$1"
CREATE="$2"

if [ -z "$B" ]; then
  echo "Usage: wt-open <branch> [--create]" >&2
  exit 1
fi

# Ensure worktree exists
if [ "$CREATE" = "--create" ]; then
  wt switch --create --no-cd "$B" || exit 1
else
  wt switch --no-cd "$B" || exit 1
fi

# Get the worktree path
P=$(wt list --format=json | jq -r --arg b "$B" '.[] | select(.branch == $b) | .path')
if [ -z "$P" ]; then
  echo "Could not determine worktree path for branch: $B" >&2
  exit 1
fi

# Create window and capture its unique ID for reliable targeting
W=$(tmux new-window -n "$B" -c "$P" -P -F '#{window_id}')
tmux set-option -t "$W" -w automatic-rename off
tmux split-window -h -t "$W" -c "$P" -l 40%
tmux split-window -v -t "$W.1" -c "$P" -l 25%
tmux send-keys -t "$W.1" 'nvim' Enter
tmux send-keys -t "$W.3" 'opencode' Enter
tmux select-pane -t "$W.1"
tmux resize-pane -Z -t "$W.1"

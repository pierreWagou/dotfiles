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

# Build layout:
#   1. new-window → pane 0 (full width, becomes left column)
#   2. split-window -h → pane 1 on the right (40% width), pane 0 shrinks to left
#   3. split-window -v on left (pane 0) → pane 0 top (nvim), pane 2 bottom (terminal)
#   Right pane (1) spans full height → opencode

W=$(tmux new-window -n "$B" -c "$P" -P -F '#{window_id}')
tmux set-option -t "$W" -w automatic-rename off

# Split right: pane 1 gets 40% width, spans full height
tmux split-window -h -t "$W.0" -c "$P" -l 40%

# Split left column: pane 2 gets bottom 25% of left column (terminal)
tmux split-window -v -t "$W.0" -c "$P" -l 25%

# Start processes: pane 0 = nvim (top-left), pane 1 = opencode (right), pane 2 = terminal (bottom-left)
tmux send-keys -t "$W.0" 'nvim' Enter
tmux send-keys -t "$W.1" 'opencode' Enter

# Focus nvim and zoom it
tmux select-pane -t "$W.0"
tmux resize-pane -Z -t "$W.0"

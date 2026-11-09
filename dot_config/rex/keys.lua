-- Keybindings. Binds reference actions by string name, so this file is
-- order-free relative to the feature modules.
rex.mode("repeat", { exclusive = true })
rex.bind("ctrl+space>ctrl+r", "client.mode.enter", { name = "repeat" })
rex.bind("repeat/enter", "client.mode.exit")
rex.bind("repeat/escape", "client.mode.exit")
rex.bind("ctrl+space>ctrl+space", "pane.send_key", { key = "ctrl+space" })
rex.bind("ctrl+space>r", "client.config.reload")
rex.bind("ctrl+space>b", "pane.split", { direction = "right" })
rex.bind("ctrl+space>v", "pane.split", { direction = "down" })
rex.bind("ctrl+space>j", "pane.resize", { amount = 5, direction = "down" })
rex.bind("repeat/j", "pane.resize", { amount = 5, direction = "down" })
rex.bind("ctrl+space>k", "pane.resize", { amount = 5, direction = "up" })
rex.bind("repeat/k", "pane.resize", { amount = 5, direction = "up" })
rex.bind("ctrl+space>l", "pane.resize", { amount = 5, direction = "right" })
rex.bind("repeat/l", "pane.resize", { amount = 5, direction = "right" })
rex.bind("ctrl+space>h", "pane.resize", { amount = 5, direction = "left" })
rex.bind("repeat/h", "pane.resize", { amount = 5, direction = "left" })
rex.bind("ctrl+z", "pane.zoom")
rex.bind("ctrl+space>x", "pane.close")
rex.bind("ctrl+space>ctrl+h", "client.tab.previous")
rex.bind("repeat/ctrl+h", "client.tab.previous")
rex.bind("ctrl+space>ctrl+l", "client.tab.next")
rex.bind("repeat/ctrl+l", "client.tab.next")

-- Project workflows: native Rex equivalents of the tmux prefix+f/g/o
-- pickers and the tmuxinator workspace layouts. Layouts are built in Lua
-- with session.create (see workspace.lua build_workspace); the pickers are
-- tv, wt, or plain commands hosted in a native window.
rex.bind("ctrl+space>f", "cockpit")
rex.bind("ctrl+space>g", "worktree_picker")
rex.bind("ctrl+space>o", "opencode_picker")
rex.bind("ctrl+space>w", "workspace_here")

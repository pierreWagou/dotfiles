-- Rex config loader. One module per concern, required in dependency
-- order (requires run top to bottom; binds are string references and
-- order-free, loaded last for readability).
require("util") -- constants, io/path/shell helpers, session + picker infra
require("workspace") -- tmuxinator-equivalent workspace builder + actions
require("sessions") -- tv rex-sessions picker backend + cockpit actions
require("worktrees") -- tv rex-worktrees picker backend
require("opencode") -- tv opencode picker
require("keys") -- repeat mode + all keybindings

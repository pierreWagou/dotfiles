-- OpenCode session picker. Depends on util.
local util = require("util")

rex.action{
  name = "opencode_picker",
  title = "Pick OpenCode Session",
  description = "Resume or create an OpenCode session with tv, in a new window.",
  category = "Rex",
  keywords = "opencode session attach",
  run = function(ctx, args)
    util.picker_window({ "tv", "opencode" }, util.block_cwd(ctx.block_id))
  end,
}

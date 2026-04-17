-- Fix dashboard-nvim issues when nvim starts inside tmux with pane splits:
-- 1. "E21: Cannot make changes, 'modifiable' is off" from stray resize escapes
-- 2. "man.lua: no manual entry for <word>" from K landing on dashboard text
return {
  -- Suppress E21 error messages on the dashboard buffer.
  -- Stray escape sequences from tmux pane splits arrive as keystrokes during
  -- nvim startup and trigger E21 on the nomodifiable dashboard buffer.
  -- The buffer is protected (no actual changes happen), so we just hide the error.
  {
    "folke/noice.nvim",
    opts = {
      routes = {
        {
          filter = {
            event = "msg_show",
            find = "E21: Cannot make changes",
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = "msg_show",
            find = "no manual entry for",
          },
          opts = { skip = true },
        },
      },
    },
  },
  -- Disable K on dashboard to prevent man page lookups on dashboard text
  {
    "nvimdev/dashboard-nvim",
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "dashboard",
        callback = function(event)
          vim.keymap.set("n", "K", "<Nop>", { buffer = event.buf, silent = true })
        end,
      })
    end,
  },
}

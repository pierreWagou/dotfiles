-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Set background early to prevent neovim 0.12's automatic OSC 11 query.
-- Without this, nvim sends a terminal color query via tmux passthrough that
-- causes response leaks as visible text (tmux/tmux#4846, neovim/neovim#32609).
vim.o.background = "dark"

-- Re-enable the Python3 provider (Nix wrapper disables it via --cmd)
vim.g.loaded_python3_provider = nil
vim.g.python3_host_prog = vim.fn.expand("~/.virtualenvs/neovim/bin/python")

-- Use ty (Astral) for Python type checking instead of pyright/basedpyright.
-- Setting this to a non-LazyVim LSP name disables the built-in pyright setup.
-- ty is configured manually in plugins/python-lsp.lua.
vim.g.lazyvim_python_lsp = "ty"

-- Add neovim venv bin to PATH so jupytext CLI is available
vim.env.PATH = vim.fn.expand("~/.virtualenvs/neovim/bin") .. ":" .. vim.env.PATH

vim.opt.clipboard = ""
vim.opt.swapfile = false

if vim.fn.has("wsl") == 1 and not vim.fn.has("mac") then
  vim.g.clipboard = {
    name = "win_clipboard",
    copy = {
      ["+"] = "clip.exe",
      ["*"] = "clip.exe",
    },
    paste = {
      ["+"] = "powershell.exe Get-Clipboard",
      ["*"] = "powershell.exe Get-Clipboard",
    },
    cache_enabled = 0,
  }
end

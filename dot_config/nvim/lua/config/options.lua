-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Re-enable the Python3 provider (Nix wrapper disables it via --cmd)
vim.g.loaded_python3_provider = nil
vim.g.python3_host_prog = vim.fn.expand("~/.virtualenvs/neovim/bin/python")

-- Add neovim venv bin to PATH so jupytext CLI is available
vim.env.PATH = vim.fn.expand("~/.virtualenvs/neovim/bin") .. ":" .. vim.env.PATH

vim.opt.clipboard = ""

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

-- Python LSP: ty (Astral) for type checking, ruff for lint/format.
-- ty isn't in nvim-lspconfig's server list yet, so we use vim.lsp.config
-- (Neovim 0.11+ native LSP config) instead of lspconfig's opts.servers.
return {
  -- Disable pyright/basedpyright via lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = { enabled = false },
        basedpyright = { enabled = false },
      },
    },
  },

  -- Configure ty via native vim.lsp API (no lspconfig registration needed)
  {
    "neovim/nvim-lspconfig",
    init = function()
      vim.lsp.config("ty", {
        cmd = { "ty", "server" },
        filetypes = { "python" },
        root_markers = { "ty.toml", "pyproject.toml" },
      })
      vim.lsp.enable("ty")
    end,
  },
}

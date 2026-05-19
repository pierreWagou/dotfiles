return {
  "catppuccin/nvim",
  opts = function(_, opts)
    opts.custom_highlights = function(colors)
      return {
        TelescopeBorder = { fg = colors.crust, bg = colors.crust },
        TelescopePromptBorder = { fg = colors.surface0, bg = colors.surface0 },
        TelescopePromptPrefix = { fg = colors.flamingo, bg = colors.surface0 },
        TelescopePromptNormal = { fg = colors.text, bg = colors.surface0 },
        TelescopeNormal = { bg = colors.crust },
        TelescopePreviewNormal = { bg = colors.mantle },
        TelescopePreviewBorder = { fg = colors.mantle, bg = colors.mantle },
        TelescopePreviewTitle = { fg = colors.crust, bg = colors.green },
        TelescopePromptTitle = { fg = colors.crust, bg = colors.peach },
        TelescopeResultsTitle = { fg = colors.crust, bg = colors.crust },
        TelescopeSelection = { bg = colors.surface0 },
      }
    end
  end,
}

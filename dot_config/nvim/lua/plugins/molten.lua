return {
  {
    "benlubas/molten-nvim",
    version = "^1.0.0",
    dependencies = {
      "3rd/image.nvim",
    },
    build = ":UpdateRemotePlugins",
    init = function()
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_text_max_lines = 20
      vim.g.molten_auto_open_output = true
      vim.g.molten_use_border_highlights = true

      -- Molten output highlights
      vim.api.nvim_set_hl(0, "MoltenVirtualText", { fg = "#89b4fa", italic = true })
      vim.api.nvim_set_hl(0, "MoltenCell", { bg = "#1e1e2e" })
      vim.api.nvim_set_hl(0, "MoltenOutputBorderSuccess", { fg = "#a6e3a1" })
      vim.api.nvim_set_hl(0, "MoltenOutputBorderFail", { fg = "#f38ba8" })
    end,
    keys = {
      { "<leader>mi", "<cmd>MoltenInit<cr>", desc = "Molten Init Kernel" },
      { "<leader>ml", "<cmd>MoltenEvaluateLine<cr>", desc = "Molten Evaluate Line" },
      { "<leader>mr", "<cmd>MoltenReevaluateCell<cr>", desc = "Molten Re-evaluate Cell" },
      { "<leader>md", "<cmd>MoltenDelete<cr>", desc = "Molten Delete Cell" },
      { "<leader>mo", "<cmd>MoltenShowOutput<cr>", desc = "Molten Show Output" },
      { "<leader>mh", "<cmd>MoltenHideOutput<cr>", desc = "Molten Hide Output" },
      {
        "<leader>mv",
        ":<C-u>MoltenEvaluateVisual<cr>gv",
        mode = "v",
        desc = "Molten Evaluate Visual",
      },
      {
        "<leader>me",
        function()
          local start_line = vim.fn.search("^# %%", "bnW")
          local end_line = vim.fn.search("^# %%", "nW")
          -- If no marker above, start from line 1
          if start_line == 0 then
            start_line = 1
          else
            start_line = start_line + 1
          end
          -- If no marker below, go to end of file
          if end_line == 0 then
            end_line = vim.fn.line("$")
          else
            end_line = end_line - 1
          end
          vim.fn.MoltenEvaluateRange(start_line, end_line)
          -- Poll until output is ready, then show floating window
          local attempts = 0
          local timer = vim.uv.new_timer()
          timer:start(500, 200, vim.schedule_wrap(function()
            attempts = attempts + 1
            if pcall(vim.cmd, "MoltenShowOutput") or attempts >= 25 then
              timer:stop()
              timer:close()
            end
          end))
        end,
        desc = "Molten Run Cell",
      },
      {
        "<leader>ma",
        function()
          local total_lines = vim.fn.line("$")
          local cells = {}
          local pos = 1
          -- Find all code cells (skip markdown cells)
          while pos <= total_lines do
            local line = vim.fn.getline(pos)
            if line:match("^# %%%%$") or line:match("^# %%%% [^[]") then
              -- Code cell: find its end
              local cell_start = pos + 1
              local cell_end = total_lines
              for i = cell_start, total_lines do
                if vim.fn.getline(i):match("^# %%%%") then
                  cell_end = i - 1
                  pos = i
                  break
                end
                if i == total_lines then
                  pos = total_lines + 1
                end
              end
              if cell_start <= cell_end then
                table.insert(cells, { cell_start, cell_end })
              end
            elseif pos == 1 and not line:match("^# %%%%") then
              -- Content before first marker
              local cell_end = total_lines
              for i = 2, total_lines do
                if vim.fn.getline(i):match("^# %%%%") then
                  cell_end = i - 1
                  pos = i
                  break
                end
              end
              table.insert(cells, { 1, cell_end })
            else
              pos = pos + 1
            end
          end
          for _, cell in ipairs(cells) do
            vim.fn.MoltenEvaluateRange(cell[1], cell[2])
          end
          vim.notify("Molten: running " .. #cells .. " cells", vim.log.levels.INFO)
        end,
        desc = "Molten Run All Cells",
      },
    },
  },
  {
    "3rd/image.nvim",
    opts = {
      backend = "kitty",
      max_width = 100,
      max_height = 12,
      max_height_window_percentage = math.huge,
      max_width_window_percentage = math.huge,
      window_overlap_clear_enabled = true,
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    },
  },
  {
    "GCBallesteros/jupytext.nvim",
    lazy = false,
    opts = {
      style = "percent",
      output_extension = "auto",
    },
  },
}

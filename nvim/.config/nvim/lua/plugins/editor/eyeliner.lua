return {
  -- Lightning fast left-right movement.
  {
    "jinh0/eyeliner.nvim",
    keys = {
      "f",
      "F",
      "t",
      "T",
    },
    opts = {
      highlight_on_key = true,
      dim = true,
      max_length = 120,
      disabled_buftypes = { "terminal", "nofile" },
      disabled_filetypes = { "alpha", "dashboard", "startify" },
    },
    config = function(_, opts)
      require("eyeliner").setup(opts)

      local function set_hl()
        local primary   = vim.api.nvim_get_hl(0, { name = "EyelinerPrimary",   link = false })
        local secondary = vim.api.nvim_get_hl(0, { name = "EyelinerSecondary", link = false })
        vim.api.nvim_set_hl(0, "EyelinerPrimary",   { fg = primary.fg,   bold = true, underline = true })
        vim.api.nvim_set_hl(0, "EyelinerSecondary", { fg = secondary.fg, underline = true })
      end

      vim.api.nvim_create_autocmd("ColorScheme", { pattern = "*", callback = set_hl })
      set_hl()
    end,
  },
}

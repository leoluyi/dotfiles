return {
  -- < https://github.com/johmsalas/text-case.nvim >
  {
    "johmsalas/text-case.nvim",
    dependencies = {
      { "nvim-telescope/telescope.nvim" },
      {
        -- which key integration.
        "folke/which-key.nvim",
        optional = true,
        opts = function(_, opts)
          if require("helpers.util").has("text-case.nvim") then
            if opts.defaults == nil then opts.defaults = {} end
            opts.defaults["gC"] = { name = "+Text-Case" }
          end
        end,
      },
    },
    keys = {
      { "gC", desc = "+Text-Case" }, -- Default invocation prefix
      { "gC.", "<cmd>TextCaseOpenTelescope<CR>", mode = { "n", "v" }, desc = "Telescope Text Case" },
    },
    opts = {
      prefix = "gC",
    },
    config = function (_, opts)
      require('textcase').setup(opts)
      local telescope_ok, _ = pcall(require, "telescope")
      if telescope_ok then
        require('telescope').load_extension('textcase')
      end
    end
  },
}

return {
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {},
  },

  {
    "linux-cultist/venv-selector.nvim",
    enabled = false,
    dependencies = {
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-dap",
      { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
    },
    lazy = false,
    cmd = "VenvSelect",
    branch = "regexp", -- This is the regexp branch, use this for the new version
    config = function()
      require("venv-selector").setup()
    end,
    keys = {
      { "<leader>v", "<cmd>VenvSelect<cr>", desc = "Select Virtualenv" },
    },
    opts = {
      name = {
        "venv",
        ".venv",
        "env",
        ".env",
      },
    },
  },
}

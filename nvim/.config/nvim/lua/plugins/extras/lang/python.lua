return {
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      {
        "mfussenegger/nvim-dap-python",
        dependencies = {
          -- which key integration
          "folke/which-key.nvim",
          optional = true,
          opts = {
            defaults = {
              ["<leader>dP"] = { name = "+(dap) Python" },
            },
          },
        },
        -- stylua: ignore
        keys = {
          { "<leader>dPt", function() require('dap-python').test_method() end, desc = "(dap-python) Debug Method" },
          { "<leader>dPc", function() require('dap-python').test_class() end, desc = "(dap-python) Debug Class" },
        },
        config = function()
          local path = require("mason-registry").get_package("debugpy"):get_install_path()
          require("dap-python").setup(path .. "/venv/bin/python")
        end,
      },
    },
  },
  {
    "linux-cultist/venv-selector.nvim",
    cmd = "VenvSelect",
    opts = {
      name = {
        "venv",
        ".venv",
        "env",
        ".env",
      },
    },
    keys = { { "<leader>vs", "<cmd>:VenvSelect<cr>", desc = "Select VirtualEnv" } },
  },
}

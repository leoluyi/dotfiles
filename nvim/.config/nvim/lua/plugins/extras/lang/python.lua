return {
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        python = {
          -- "ruff",
          "flake8",
        },
      },
      linters = {
        flake8 = {
          args = {
            "--format=%(path)s:%(row)d:%(col)d:%(code)s:%(text)s",
            "--no-show-source",
            "--extend-ignore",
            "E309,E402,E501,E702,W291,W293,W391,W503",
            "-",
          },
        },

        -- ruff = {
        --   args = {
        --     "check",
        --     "--force-exclude",
        --     "--quiet",
        --     "--stdin-filename",
        --     "--ignore=E309,E402,E501,E702,W291,W293,W391,W503",
        --     vim.api.nvim_buf_get_name(0),
        --     "--no-fix",
        --     "--output-format",
        --     "json",
        --     "-",
        --   },
        -- },
      },
    },
  },

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
    dependencies = {
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-dap",
      "mfussenegger/nvim-dap-python", --optional
      { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
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

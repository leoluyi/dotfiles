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
          if vim.fn.has("win32") == 1 then
            require("dap-python").setup(require("helpers.util").get_pkg_path("debugpy", "/venv/Scripts/pythonw.exe"))
          else
            require("dap-python").setup(require("helpers.util").get_pkg_path("debugpy", "/venv/bin/python"))
          end
        end,
      },
    },
  },
  {
    "linux-cultist/venv-selector.nvim",
    enabled = false,
    dependencies = {
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-dap",
      "mfussenegger/nvim-dap-python", --optional
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

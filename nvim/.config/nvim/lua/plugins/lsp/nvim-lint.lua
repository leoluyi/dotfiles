return {

  -- < https://github.com/mfussenegger/nvim-lint >
  {
    "mfussenegger/nvim-lint",
    enabled = true,
    events = { "BufWritePost", "BufReadPost", "InsertLeave" },
    config = function()
      local lint = require("lint")
      local linters = lint.linters
      local function get_file_name()
        return vim.api.nvim_buf_get_name(0)
      end

      -- Linters.
      lint.linters_by_ft = {
        python = { "ruff" }
      }

      -- Linger configs.
      -- < https://github.com/mfussenegger/nvim-lint/tree/master/lua/lint/linters >
      -- linters.ruff.args = {
      --   "check",
      --   "--force-exclude",
      --   "--quiet",
      --   "--stdin-filename",
      --   "--ignore=E309,E402,E501,E702,W291,W293,W391,W503",
      --   get_file_name,
      --   "--no-fix",
      --   "--output-format",
      --   "json",
      --   "-",
      -- }

      -- linters.flake8.args = {
      --   "--format=%(path)s:%(row)d:%(col)d:%(code)s:%(text)s",
      --   "--no-show-source",
      --   "--extend-ignore",
      --   "E309,E402,E501,E702,W291,W293,W391,W503",
      --   "-",
      -- }

    end,
  }
}

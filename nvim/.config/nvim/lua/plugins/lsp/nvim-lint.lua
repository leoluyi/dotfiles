return {

  -- < https://github.com/mfussenegger/nvim-lint >
  {
    "mfussenegger/nvim-lint",
    enabled = true,
    config = function()
      local lint = require("lint")
      local linters = lint.linters

      -- Linters.
      lint.linters_by_ft = {
        python = { "flake8" }
      }

      -- Linger configs.
      -- < https://github.com/mfussenegger/nvim-lint/tree/master/lua/lint/linters >
      linters.flake8.args = {
        "--format=%(path)s:%(row)d:%(col)d:%(code)s:%(text)s",
        "--no-show-source",
        "--extend-ignore",
        "E309,E402,E501,E702,W291,W293,W391,W503",
        "-",
      }

    end,
  }
}

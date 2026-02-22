return {
  {
    -- < https://github.com/stevearc/conform.nvim >
    -- Lightweight yet powerful formatter plugin for Neovim
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      {
        "<localleader>f",
        function()
          require("conform").format({
            lsp_fallback = true,
            async = false,
            timeout_ms = 1000,
          })
        end,
        mode = { "n", "x" },
        desc = "(conform) [F]ormat file or range",
      },
    },
    opts = {
      format_on_save = function(bufnr)
        local ft = vim.bo[bufnr].filetype
        if
          vim.tbl_contains({
            "python",
            "lua",
            "java",
            "javascript",
          }, ft)
        then
          return {
            -- I recommend these options. See :help conform.format for details.
            lsp_format = "fallback",
            timeout_ms = 500,
          }
        else
          return nil
        end
      end,

      formatters_by_ft = {
        lua = { "stylua" },
        svelte = { { "prettierd", "prettier" } },
        python = function(bufnr)
          if require("conform").get_formatter_info("ruff_format", bufnr).available then
            return { "ruff_fix", "ruff_format" }
          else
            return { "isort", "black" }
          end
        end,
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        graphql = { "prettierd", "prettier", stop_after_first = true },
        java = { "google-java-format" },
        kotlin = { "ktlint" },
        ruby = { "standardrb" },
        makefile = { "checkmake" },
        markdown = { "markdownlint-cli2", "prettierd", "prettier", stop_after_first = true },
        erb = { "htmlbeautifier" },
        html = { "htmlbeautifier" },
        bash = { "beautysh" },
        proto = { "buf" },
        rust = { "rustfmt" },
        yaml = { "yamlfix" },
        toml = { "taplo" },
        css = { "prettierd", "prettier", stop_after_first = true },
        scss = { "prettierd", "prettier", stop_after_first = true },
        sh = { "shfmt" },
      },

      formatters = {
        stylua = {
          prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
        },
        ruff_fix = {
          -- isort using ruff < https://stackoverflow.com/a/78156861 >
          args = {
            "check",
            "--select",
            "I,RUF022",
            "--fix",
            "--force-exclude",
            "--exit-zero",
            "--no-cache",
            "--stdin-filename",
            "$FILENAME",
            "-",
          },
        },
        black = {
          args = {
            "--quiet",
            "--line-length",
            "120",
            "--fast",
            "-",
          },
        },
        shfmt = {
          prepend_args = { "-i", "2" },
        },
      },
    },
  },
}

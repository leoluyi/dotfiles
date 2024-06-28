return {
  {
    -- Lightweight yet powerful formatter plugin for Neovim
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      { "<localleader>f", function()
        require("conform").format({
          lsp_fallback = true,
          async = false,
          timeout_ms = 1000,
        })
      end, mode = { "n", "x" }, desc = "Format file or range (in visual mode)" },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        svelte = { { "prettierd", "prettier" } },
        python = function(bufnr)
          if require("conform").get_formatter_info("ruff_format", bufnr).available then
            return { "ruff_format" }
          else
            return { "isort", "black" }
          end
        end,
        javascript = { { "prettierd", "prettier" } },
        typescript = { { "prettierd", "prettier" } },
        javascriptreact = { { "prettierd", "prettier" } },
        typescriptreact = { { "prettierd", "prettier" } },
        json = { { "prettierd", "prettier" } },
        graphql = { { "prettierd", "prettier" } },
        java = { "google-java-format" },
        kotlin = { "ktlint" },
        ruby = { "standardrb" },
        markdown = { { "prettierd", "prettier" } },
        erb = { "htmlbeautifier" },
        html = { "htmlbeautifier" },
        bash = { "beautysh" },
        proto = { "buf" },
        rust = { "rustfmt" },
        yaml = { "yamlfix" },
        toml = { "taplo" },
        css = { { "prettierd", "prettier" } },
        scss = { { "prettierd", "prettier" } },
        sh = { { "shfmt" } },
      },

      formatters = {
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
        }
      },

    },
  },
}

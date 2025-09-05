return {
  -- < https://github.com/jakub-kozlowicz/LazyVim/blob/main/lua/lazyvim/plugins/lsp/init.lua#L241C1-L259C5 >
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    opts = {
      -- https://mason-registry.dev/registry/list
      -- https://github.com/williamboman/mason-lspconfig.nvim/blob/main/doc/server-mapping.md
      ensure_installed = {
        -- Tools.
        "tree-sitter-cli",

        -- LSP.
        "bash-language-server",
        "golangci-lint-langserver",
        "gopls",
        "json-lsp",
        "lua-language-server",
        "pyright",
        "sqlls",
        "tailwindcss-language-server",
        "typescript-language-server",
        "vim-language-server",
        "yaml-language-server",

        -- Linters, Formatters.
        "checkmake",
        "flake8",
        "markdownlint-cli2",
        "ruff",
        "taplo", -- TOML
      },
    },
    ---@param opts MasonSettings | {ensure_installed: string[]}
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },
}

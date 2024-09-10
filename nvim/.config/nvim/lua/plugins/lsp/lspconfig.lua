-- vim: fdm=marker:fdl=2
-- < https://github.com/neovim/nvim-lspconfig >
-- < https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md >
-- < https://github.com/VonHeikemen/lsp-zero.nvim >

local capabilities = require("helpers.lsp_util").capabilities

return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    keys = {
      -- LspInfo.
      { "<leader>li", ":LspInfo<cr>", desc = "LspInfo" },
    },
    dependencies = {
      { "folke/neoconf.nvim", cmd = "Neoconf" },
      { "folke/neodev.nvim" },
      { "folke/lsp-colors.nvim" },
      { "mason.nvim" },
      {
        "hrsh7th/cmp-nvim-lsp",
        cond = function()
          return require("helpers.util").has("nvim-cmp")
        end,
        config = function()
          -- nvim-cmp completion settings
          require("cmp_nvim_lsp").default_capabilities(capabilities)
        end,
      },
    },
    config = function()
      local lspconfig = require("lspconfig")
      local util = require("lspconfig.util")
      local lsp_util = require("helpers.lsp_util")
      local lsp_attach = lsp_util.lsp_attach
      local signs = require("helpers.icons").diagnostics

      -- User commands ------------------------------------------------------------{{{2

      local function print_lsp_capabilities()
        print(vim.inspect(vim.lsp.get_active_clients()))
      end

      vim.api.nvim_create_user_command('LspServerCapabilities', print_lsp_capabilities, {})

      -- Diagnostics: linting and formatting --------------------------------------{{{2
      -- < https://github.com/neovim/nvim-lspconfig/wiki/UI-customization >

      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, {text = icon, texthl = hl, numhl = ""})
      end

      local border = {
        {"╭", "LspFloatWinBorder"},
        {"─", "LspFloatWinBorder"},
        {"╮", "LspFloatWinBorder"},
        {"│", "LspFloatWinBorder"},
        {"╯", "LspFloatWinBorder"},
        {"─", "LspFloatWinBorder"},
        {"╰", "LspFloatWinBorder"},
        {"│", "LspFloatWinBorder"},
      }

      -- options for vim.diagnostic.config()
      -- :h lsp-diagnostic
      local global_diagnostic_config = {
        update_in_insert = true,
        underline = true,

        -- Enable virtual text, override spacing to 2
        virtual_text = {
          spacing = 2,
          source = "if_many",
          severity = { min = vim.diagnostic.severity.WARN },
          prefix = '■', -- Could be '●', '▎', 'x'
        },
        severity_sort = true,

        -- Use a function to dynamically turn signs off and on, using buffer local variables
        signs = function(bufnr, _)
          local ok, result = pcall(vim.api.nvim_buf_get_var, bufnr, 'show_signs')
          -- No buffer local variable set, so just enable by default
          if not ok then
            return { severity = { min = vim.diagnostic.severity.INFO } }
          end

          return result
        end,

        float = {
          header = "■ Diagnostics:",
          source = true, -- Show source in diagnostics, not inline but as a floating popup.
          scope = "cursor",
          border = border,
          focus = false,
        },
      }

      vim.diagnostic.config(global_diagnostic_config)

      -- :help vim.lsp.diagnostic.on_publish_diagnostics
      vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics,
        global_diagnostic_config
      )

      -- Configuration of the individual language servers -------------------------{{{2

      -- < https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md>

      lspconfig.bashls.setup({
        on_attach = lsp_attach,
        capabilities = capabilities,
        cmd_env = { GLOB_PATTERN = "*@(.sh|.inc|.bash|.command)" },
        filetypes = { "sh", "bash" },
      })

      lspconfig.eslint.setup({
        on_attach = lsp_attach,
        capabilities = capabilities,
        settings = {
          format = {
            enable = true,
          },
        },
      })

      lspconfig.golangci_lint_ls.setup{
        -- < https://github.com/nametake/golangci-lint-langserver#configuration-for-nvim-lspconfig >
        -- < https://golangci-lint.run/usage/linters/ >
        on_attach = lsp_attach,
        capabilities = capabilities,
        init_options = {
          command = { "golangci-lint", "run", '-E', 'revive', "-E", "govet", "--out-format", "json" }
        },
      }

      lspconfig.gopls.setup({
        -- < https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#gopls >
        -- < https://github.com/golang/tools/blob/master/gopls/doc/settings.md >
        on_attach = lsp_attach,
        capabilities = capabilities,
        settings = {
          gopls = {
            analyses = {
              unusedparams = false,
              fieldalignment = false,
              shadow = true,
              nilness = true,
              simplifyrange = true,
            },
            ["build.directoryFilters"] = { "-node_modules", "-vendor" },
            ["formatting.gofumpt"] = true,
            ["ui.staticcheck"] = true,
            ["ui.verboseOutput"] = true,
          },
        }
      })

      -- INFO: https://github.com/folke/neodev.nvim
      local neodev_ok, neodev = pcall(require, "neodev")
      if neodev_ok then
        neodev.setup()
      end

      lspconfig.lua_ls.setup({
        -- INFO: fix global vim < https://www.reddit.com/r/neovim/comments/khk335/comment/hy1775w/ >
        on_attach = lsp_attach,
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = {  'vim' } },
            completion = {
              callSnippet = "Replace"
            }
          },
        },
      })

      lspconfig.pyright.setup({
        on_attach = lsp_attach,
        capabilities = capabilities,
        root_dir = util.root_pattern(".git", "setup.py", "Pipfile", "Pipfile.lock", "pyproject.toml"),
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "workspace",
              useLibraryCodeForTypes = true,
              typeCheckingMode = false,
            }
          }
        },
        on_init = function(client)
          client.config.settings.python.pythonPath = lsp_util.get_python_path(client.config.root_dir)
        end,
      })

      lspconfig.jsonls.setup({
        on_attach = lsp_attach,
        capabilities = capabilities,
      })

      lspconfig.sqlls.setup({
        on_attach = lsp_attach,
        capabilities = capabilities,
      })

      lspconfig.taplo.setup({
        on_attach = lsp_attach,
        capabilities = capabilities,
      })

      lspconfig.ts_ls.setup({
        on_attach = lsp_attach,
        capabilities = capabilities,
      })

      lspconfig.vimls.setup({
        on_attach = lsp_attach,
        capabilities = capabilities,
      })

      lspconfig.yamlls.setup({
        on_attach = lsp_attach,
        capabilities = capabilities,
      })

    end,
  },
}

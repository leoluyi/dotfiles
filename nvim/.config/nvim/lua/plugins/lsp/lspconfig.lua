-- vim: fdm=marker:fdl=2
-- < https://github.com/neovim/nvim-lspconfig >
-- < https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md >

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
      { "folke/neodev.nvim",  opts = {} },
      { "folke/lsp-colors.nvim" },
      { "mason.nvim" },
      {
        "hrsh7th/cmp-nvim-lsp",
        cond = function()
          return require("util").has("nvim-cmp")
        end,
      },
    },
    config = function()
      local lsp_util = require("util.lsp")
      local lsp_attach = lsp_util.lsp_attach
      local signs = require("util.icons").diagnostics

      -- Extend capabilities with nvim-cmp completions if available.
      local capabilities = lsp_util.capabilities
      local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      if ok then
        capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())
      end

      -- User commands ------------------------------------------------------------{{{2

      local function print_lsp_capabilities()
        print(vim.inspect(vim.lsp.get_clients()))
      end

      vim.api.nvim_create_user_command("LspServerCapabilities", print_lsp_capabilities, {})

      -- Diagnostics: linting and formatting --------------------------------------{{{2
      -- < https://github.com/neovim/nvim-lspconfig/wiki/UI-customization >

      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      local border = {
        { "╭", "LspFloatWinBorder" },
        { "─", "LspFloatWinBorder" },
        { "╮", "LspFloatWinBorder" },
        { "│", "LspFloatWinBorder" },
        { "╯", "LspFloatWinBorder" },
        { "─", "LspFloatWinBorder" },
        { "╰", "LspFloatWinBorder" },
        { "│", "LspFloatWinBorder" },
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
          prefix = "■", -- Could be '●', '▎', 'x'
        },
        severity_sort = true,

        -- Use a function to dynamically turn signs off and on, using buffer local variables
        signs = function(bufnr, _)
          local ok, result = pcall(vim.api.nvim_buf_get_var, bufnr, "show_signs")
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

      -- Configuration of the individual language servers -------------------------{{{2

      -- < https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md>

      vim.lsp.config.bashls = {
        cmd = { "bash-language-server", "start" },
        filetypes = { "sh", "bash" },
        root_markers = { ".git" },
        on_attach = lsp_attach,
        capabilities = capabilities,
        cmd_env = { GLOB_PATTERN = "*@(.sh|.inc|.bash|.command)" },
      }

      vim.lsp.config.eslint = {
        cmd = { "vscode-eslint-language-server", "--stdio" },
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
        root_markers = { ".eslintrc.js", ".eslintrc.json", "package.json", ".git" },
        on_attach = lsp_attach,
        capabilities = capabilities,
        settings = {
          format = {
            enable = true,
          },
        },
      }

      vim.lsp.config.golangci_lint_ls = {
        -- < https://github.com/nametake/golangci-lint-langserver#configuration-for-nvim-lspconfig >
        -- < https://golangci-lint.run/usage/linters/ >
        cmd = { "golangci-lint-langserver" },
        filetypes = { "go", "gomod" },
        root_markers = { "go.work", "go.mod", ".git" },
        on_attach = lsp_attach,
        capabilities = capabilities,
        init_options = {
          command = { "golangci-lint", "run", "-E", "revive", "-E", "govet", "--out-format", "json" },
        },
      }

      vim.lsp.config.gopls = {
        -- < https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#gopls >
        -- < https://github.com/golang/tools/blob/master/gopls/doc/settings.md >
        cmd = { "gopls" },
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        root_markers = { "go.work", "go.mod", ".git" },
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
        },
      }

      vim.lsp.config.lua_ls = {
        -- INFO: fix global vim < https://www.reddit.com/r/neovim/comments/khk335/comment/hy1775w/ >
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" },
        on_attach = lsp_attach,
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            completion = {
              callSnippet = "Replace",
            },
          },
        },
      }

      -- < https://docs.astral.sh/ruff/editors/setup/ >
      vim.lsp.config.ruff = {
        cmd = { "ruff", "server", "--preview" },
        filetypes = { "python" },
        root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", "pyrightconfig.json", ".git" },
        on_attach = lsp_attach,
        capabilities = capabilities,
      }

      vim.lsp.config.pyright = {
        cmd = { "pyright-langserver", "--stdio" },
        filetypes = { "python" },
        root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", "pyrightconfig.json", ".git" },
        on_attach = lsp_attach,
        capabilities = capabilities,
        settings = {
          pyright = {
            -- Using Ruff's import organizer
            disableOrganizeImports = true,
          },
          python = {
            analysis = {
              -- Ignore all files for analysis to exclusively use Ruff for linting
              ignore = { "*" },
            },
          },
        },
        on_init = function(client)
          client.config.settings.python.pythonPath = lsp_util.get_python_path(client.config.root_dir)
        end,
      }

      vim.lsp.config.jsonls = {
        cmd = { "vscode-json-language-server", "--stdio" },
        filetypes = { "json", "jsonc" },
        root_markers = { "package.json", ".git" },
        on_attach = lsp_attach,
        capabilities = capabilities,
      }

      vim.lsp.config.sqlls = {
        cmd = { "sql-language-server", "up", "--method", "stdio" },
        filetypes = { "sql", "mysql" },
        root_markers = { ".sqllsrc.json", ".git" },
        on_attach = lsp_attach,
        capabilities = capabilities,
      }

      vim.lsp.config.taplo = {
        cmd = { "taplo", "lsp", "stdio" },
        filetypes = { "toml" },
        root_markers = { "*.toml", ".git" },
        on_attach = lsp_attach,
        capabilities = capabilities,
      }

      vim.lsp.config.ts_ls = {
        cmd = { "typescript-language-server", "--stdio" },
        filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
        root_markers = { "tsconfig.json", "package.json", "jsconfig.json", ".git" },
        on_attach = lsp_attach,
        capabilities = capabilities,
      }

      vim.lsp.config.vimls = {
        cmd = { "vim-language-server", "--stdio" },
        filetypes = { "vim" },
        root_markers = { "strange.vim", ".vim", ".git" },
        on_attach = lsp_attach,
        capabilities = capabilities,
      }

      vim.lsp.config.yamlls = {
        cmd = { "yaml-language-server", "--stdio" },
        filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
        root_markers = { ".git" },
        on_attach = lsp_attach,
        capabilities = capabilities,
      }
    end,
  },
}

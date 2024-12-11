return {
  "nvimtools/none-ls.nvim",
  enable = false,
  dependencies = {
    { "mason.nvim" },
    {
      "jay-babu/mason-null-ls.nvim",
      event = { "BufReadPre", "BufNewFile" },
      dependencies = {
        "williamboman/mason.nvim",
      },
      opts = {
        ensure_installed = {
          -- formatters.
          "stylua",
          "prettier",
          "shfmt",
          -- linters.
          "ruff",
          "flake8",
          "yamllint",
        }
      },
      config = function(_, opts)
        require("mason-null-ls").setup(opts)
      end,
    },
  },

  opts = function()
    local nls = require("null-ls")

    -- < https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md >
    -- < https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md >
    -- register any number of sources simultaneously
    return {
      sources = {
        -- Yaml.
        nls.builtins.diagnostics.yamllint.with({
          args = {
            "--format", "parsable",
            "-d", "{extends: relaxed, rules: {line-length: {max: 120}, indentation: {spaces: 2, indent-sequences: whatever}}}", "-" },
        }),

      },
    }
  end,

  config = function (_, opts)
    local nls = require("null-ls")
    local formatting_keymaps = require('helpers.lsp_keymaps').formatting_keymaps
    local lsp_keymaps = require('helpers.lsp_keymaps').keymaps

    -- Formatting on save.
    -- local lsp_formatting = function(bufnr)
    --   -- < https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Avoiding-LSP-formatting-conflicts >
    --   -- < https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Formatting-on-save >
    --   -- < https://github.com/neovim/nvim-lspconfig/wiki/Multiple-language-servers-FAQ >
    --
    --   -- nvim-0.8.
    --   vim.lsp.buf.format({
    --     filter = function(client)
    --       -- (Apply whatever logic you want.)
    --       -- only use null-ls for formatting instead of lsp server
    --       return client.name == "null-ls"
    --     end,
    --     bufnr = bufnr,
    --   })
    -- end

    nls.setup({
      sources = opts.sources,
      debug = true,
      -- FIX: seems that "on_attach" does not working?
      on_attach = function(current_client, bufnr)
        print("[LSP] Attaching to client: " .. current_client.name)
        -- Avoiding LSP formatting conflicts. Formatting is handled by null-ls.
        if current_client.name ~= "null-ls" then
          if vim.fn.has('nvim-0.8') then
            current_client.server_capabilities.documentFormattingProvider = false -- 0.8 and later
          else
            current_client.server_capabilities.document_formatting = false -- 0.7 and earlier
          end
        end

        lsp_keymaps(current_client, bufnr)

        -- [Avoiding LSP formatting conflicts](https://github.com/nvimtools/none-ls.nvim/wiki/Avoiding-LSP-formatting-conflicts)
        -- if current_client.supports_method("textDocument/formatting") then
        --   formatting_keymaps(current_client, bufnr)
        --
        --   local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
        --   local ft = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
        --   if ft ~= 'json' and ft ~= 'sh' then
        --     vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        --     vim.api.nvim_create_autocmd("BufWritePre", {
        --       group = augroup,
        --       buffer = bufnr,
        --       callback = function()
        --         lsp_formatting(bufnr)
        --       end,
        --     })
        --   end
        -- end

      end,
    })
  end,

}

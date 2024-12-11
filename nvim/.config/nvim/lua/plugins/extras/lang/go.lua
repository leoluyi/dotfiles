return {
  -- < https://github.com/ray-x/go.nvim >
  {
    "ray-x/go.nvim",
    dependencies = { -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
    opts = {
      disable_defaults = false, -- true|false when true set false to all boolean settings and replace all table settings with {}
      go = "go", -- go command, can be go[default] or go1.18beta1
      goimporta = "gopls", -- goimport command, can be gopls[default] or goimport
      fillstruct = "gopls", -- can be nil (use fillstruct, slower) and gopls
      gofmt = "gofumpt", --gofmt cmd,
      -- max_line_len = 120, -- max line length in goline format
      tag_transform = false, -- tag_transfer  check gomodifytags for details
      test_template = "", -- g:go_nvim_tests_template  check gotests for details
      test_template_dir = "", -- default to nil if not set; g:go_nvim_tests_template_dir  check gotests for details
      comment_placeholder = "", -- comment_placeholder your cool placeholder e.g. ﳑ       
      icons = { breakpoint = "🧘", currentpos = "🏃" },
      verbose = false, -- output loginf in messages
      lsp_cfg = false, -- { capabilities = require('helpers.lsp_util').capabilities },
      -- true: use non-default gopls setup specified in go/lsp.lua
      -- false: do nothing
      -- if lsp_cfg is a table, merge table with with non-default gopls setup in go/lsp.lua, e.g.
      --   lsp_cfg = {settings={gopls={matcher='CaseInsensitive', ['local'] = 'your_local_module_path', gofumpt = true }}}
      lsp_gofumpt = true, -- true: set default gofmt in gopls format to gofumpt
      lsp_on_attach = nil, -- nil: use on_attach function defined in go/lsp.lua,
      --      when lsp_cfg is true
      -- if lsp_on_attach is a function: use this function as on_attach function for gopls
      lsp_keymaps = false, -- set to false to disable gopls/lsp keymap
      lsp_codelens = true, -- set to false to disable codelens, true by default, you can use a function
      diagnostic = { -- set diagnostic to false to disable vim.diagnostic setup
        hdlr = true, -- hook lsp diag handler
        underline = true,
        -- virtual text setup
        virtual_text = { space = 0, prefix = "■" },
        signs = true,
        update_in_insert = false,
      },
      lsp_document_formatting = true,
      -- set to true: use gopls to format
      -- false if you want to use other formatter tool(e.g. efm, nulls)
      gopls_cmd = nil, -- if you need to specify gopls path and cmd, e.g {"/home/user/lsp/gopls", "-logfile","/var/log/gopls.log" }
      gopls_remote_auto = true, -- add -remote=auto to gopls
      gocoverage_sign = "█",
      dap_debug = true, -- set to false to disable dap
      dap_debug_keymap = true, -- true: use keymap for debugger defined in go/dap.lua
      -- false: do not use keymap in go/dap.lua.  you must define your own.
      dap_debug_gui = true, -- set to true to enable dap gui, highly recommand
      dap_debug_vt = true, -- set to true to enable dap virtual text
      build_tags = "tag1,tag2", -- set default build tags
      textobjects = true, -- enable default text jobects through treesittter-text-objects
      test_runner = "go", -- richgo, go test, richgo, dlv, ginkgo
      run_in_floaterm = true, -- set to true to run in float window. :GoTermClose closes the floatterm
      -- float term recommand if you use richgo/ginkgo with terminal color
      trouble = true, -- true: use trouble to open quickfix
      test_efm = false, -- errorfomat for quickfix, default mix mode, set to true will be efm only
      luasnip = false, -- enable included luasnip snippets. you can also disable while add lua/snips folder to luasnip load
      --  Do not enable this if you already added the path, that will duplicate the entries
    },
    config = function(_, opts)
      require("go").setup(opts)

      -- Run gofmt + goimports on save
      local format_sync_grp = vim.api.nvim_create_augroup("goimports", {})
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function()
          require("go.format").goimports()
        end,
        group = format_sync_grp,
      })

      vim.cmd([[
      augroup GoMapping
      autocmd!
      " buffer-local mappings
      autocmd FileType go nnoremap <buffer> <Leader>gr      :GoRun<space><C-r>=expand("%")<CR>
      autocmd FileType go nnoremap <buffer> <Leader>gR      :GoRun<space>
      autocmd FileType go nnoremap <buffer> <Localleader>gc :lua require('go.comment').gen()<CR>
      augroup END

      augroup GoCodelenses
      autocmd!
      autocmd BufEnter,CursorHold,InsertLeave *.go lua require("go.codelens").refresh()
      augroup END
      ]])
    end,
  },
}

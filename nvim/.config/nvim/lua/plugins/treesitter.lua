-- < https://github.com/nvim-treesitter/nvim-treesitter >
-- < https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/treesitter.lua >

local is_nvim_012 = vim.fn.has("nvim-0.12") == 1
local load_textobjects = false
local parsers = {
  "bash",
  "cpp",
  "css",
  "dockerfile",
  "go",
  "gomod",
  "html",
  "java",
  "javascript",
  "json",
  "json5",
  "latex",
  "lua",
  "make",
  "markdown",
  "markdown_inline",
  "python",
  "query",
  "regex",
  "rst",
  "rust",
  "scss",
  "toml",
  "vim",
  "vimdoc",
  "yaml",
}

local legacy_opts = {
  auto_install = true,
  ensure_installed = parsers,

  ignore_install = {
    -- Don't install comment!! It's too laggy < https://github.com/nvim-treesitter/nvim-treesitter/issues/5057#issuecomment-1617844020 >
    "comment"
  },

  incremental_selection = {
    enable = true,
    disable = require("util.treesitter").disable_file_handle,
    keymaps = {
      init_selection = "<C-space>",
      node_incremental = "<C-space>",
      scope_incremental = false,
      node_decremental = "<bs>",
    },
  },

  indent = {
    enable = true,
    disable = require("util.treesitter").disable_file_handle,
  },

  highlight = {
    enable = true,
    disable = require("util.treesitter").disable_file_handle,
    additional_vim_regex_highlighting = false,
  },
}

return {

  {
    "nvim-treesitter/nvim-treesitter",
    branch = is_nvim_012 and "main" or "master",
    build = ":TSUpdate",
    lazy = is_nvim_012 and false or nil,
    event = is_nvim_012 and nil or { "BufReadPost", "BufNewFile" },
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = is_nvim_012 and "main" or "master",
        config = function()
          if is_nvim_012 then
            local ok, textobjects = pcall(require, "nvim-treesitter-textobjects")
            if ok and textobjects.setup then
              textobjects.setup({
                select = { lookahead = true },
                move = { set_jumps = true },
              })
            end
          end
        end,
        init = function()
          if not is_nvim_012 then
            -- disable rtp plugin, as we only need its queries for mini.ai
            -- In case other textobject modules are enabled, we will load them
            -- once nvim-treesitter is loaded
            require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
            load_textobjects = true
          end
        end,
      },
    },

    keys = is_nvim_012 and {} or {
      { "<c-space>", desc = "(TS) Increment selection" },
      { "<bs>", desc = "(TS) Decrement selection", mode = "x" },
    },

    opts = is_nvim_012 and { ensure_installed = parsers } or legacy_opts,

    config = function(_, opts)

      if is_nvim_012 then
        local treesitter = require("nvim-treesitter")
        treesitter.setup({
          install_dir = vim.fn.stdpath("data") .. "/site",
        })
        treesitter.install(opts.ensure_installed)

        vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

        local group = vim.api.nvim_create_augroup("UserTreesitter", {})
        vim.api.nvim_create_autocmd("FileType", {
          group = group,
          pattern = "*",
          callback = function(args)
            local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
            if not lang or not pcall(vim.treesitter.start, args.buf, lang) then
              return
            end

            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            vim.wo[0][0].foldmethod = "expr"
            vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
          end,
        })
        return
      end

      if type(opts.ensure_installed) == "table" then
        ---@type table<string, boolean>
        local added = {}
        opts.ensure_installed = vim.tbl_filter(function(lang)
          if added[lang] then
            return false
          end
          added[lang] = true
          return true
        end, opts.ensure_installed)
      end
      require'nvim-treesitter.configs'.setup(opts)

      if load_textobjects then
        -- PERF: no need to load the plugin, if we only need its queries for mini.ai
        if opts.textobjects then
          for _, mod in ipairs({ "move", "select", "swap", "lsp_interop" }) do
            if opts.textobjects[mod] and opts.textobjects[mod].enable then
              local Loader = require("lazy.core.loader")
              Loader.disabled_rtp_plugins["nvim-treesitter-textobjects"] = nil
              local plugin = require("lazy.core.config").plugins["nvim-treesitter-textobjects"]
              require("lazy.core.loader").source_runtime(plugin.dir, "plugin")
              break
            end
          end
        end
      end

      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

      -- Customize folding to fold only certain blocks.
      -- < https://github.com/nvim-treesitter/nvim-treesitter/issues/1564#issuecomment-931000867 >
      vim.treesitter.query.set( "python", "folds", [[
        (function_definition) @fold
        (class_definition) @fold
        (dictionary) @fold
        (list) @fold
        (for_statement (block) @fold)
        (if_statement (block) @fold)
        (if_statement (block)
          (elif_clause (block) @fold))
        (if_statement (block)
          (else_clause (block) @fold))
        ]])

    end,
  },

}

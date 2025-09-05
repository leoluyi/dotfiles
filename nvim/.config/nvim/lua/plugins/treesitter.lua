-- < https://github.com/nvim-treesitter/nvim-treesitter >
-- < https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/treesitter.lua >

local load_textobjects = false

return {

  {
    "nvim-treesitter/nvim-treesitter",
    -- enabled = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-refactor",
        "nvim-treesitter/playground",
        {
          "nvim-treesitter/nvim-treesitter-textobjects",
          init = function()
            -- disable rtp plugin, as we only need its queries for mini.ai
            -- In case other textobject modules are enabled, we will load them
            -- once nvim-treesitter is loaded
            require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
            load_textobjects = true
          end,
        },
      },
    },

    keys = {
      { "<c-space>", desc = "(TS) Increment selection" },
      { "<bs>", desc = "(TS) Decrement selection", mode = "x" },
    },

    -- @type TSConfig
    opts = {
      auto_install = true,
      ensure_installed = {
        "bash",
        "c_sharp",
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
        "jsonc",
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
        "scala",
        "scss",
        "toml",
        "vim",
        "vimdoc",
        "yaml",
      },

      ignore_install = {
        -- Don't install comment!! It's too laggy < https://github.com/nvim-treesitter/nvim-treesitter/issues/5057#issuecomment-1617844020 >
        "comment"
      },

      incremental_selection = {
        enable = true,
        disable = require("helpers.treesitter").disable_file_handle,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },

      indent = {
        enable = true,
        disable = require("helpers.treesitter").disable_file_handle,
      },

      highlight = {
        -- false will disable the whole extension
        enable = true,

        -- disable treesitter for large files
        disable = require("helpers.treesitter").disable_file_handle,

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
      },

      -- https://github.com/nvim-treesitter/nvim-treesitter-refactor
      refactor = {
        -- the illuminate plugin is better than this
        highlight_definitions = {
          enable = false,
          disable = require("helpers.treesitter").disable_file_handle,
          -- Set to false if you have an `updatetime` of ~100.
          clear_on_cursor_move = true,
        },
        highlight_current_scope = {
          enable = false,
          disable = require("helpers.treesitter").disable_file_handle,
        },
        smart_rename = {
          enable = true,
          disable = require("helpers.treesitter").disable_file_handle,
          keymaps = {
            smart_rename = "<localleader>ra",
          },
        },
      },

      playground = {
        enable = true,
        disable = require("helpers.treesitter").disable_file_handle,
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false, -- Whether the query persists across vim sessions
        keybindings = {
          toggle_query_editor = 'o',
          toggle_hl_groups = 'i',
          toggle_injected_languages = 't',
          toggle_anonymous_nodes = 'a',
          toggle_language_display = 'I',
          focus_language = 'f',
          unfocus_language = 'F',
          update = 'R',
          goto_node = '<cr>',
          show_help = '?',
        },
      },
    },

    config = function(_, opts)

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

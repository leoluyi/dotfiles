-- vim: fdm=marker:fdl=2
-- < https://github.com/nvim-neo-tree/neo-tree.nvim >
return {
  -- File browser.
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      -- which-key integration.
      {
        "folke/which-key.nvim",
        optional = true,
        opts = {
          mode = { "n", "x" },
          spec = {
            { "<leader>k", group = "Neotree" }
          },
        },
      },
    },
    keys = {
      { '<Leader>kk', ':Neotree focus filesystem reveal_force_cwd<cr>', desc = "Neotree fucus" },
      { '<Leader>kb', ':Neotree show filesystem toggle<cr>', desc = "Neotree show" },
      { '<Leader>kf', ':Neotree show filesystem reveal_force_cwd<cr>', desc = "Neotree reveal file" },
      -- { '<Leader>gs', ':Neotree float git_status<cr>', desc = "Neotree git_status" },
    },
    opts = {
      use_default_mappings = true,
      window = {
        position = "right",
        width = 37,
        mapping_options = {
          noremap = true,
          nowait = true,
        },
        mappings = {
          ["<space>"] = {
            "toggle_node",
            nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
          },
          ["<2-LeftMouse>"] = "open",
          ["<cr>"] = "open",
          ["o"] = "open",
          ["<esc>"] = "revert_preview",
          ["P"] = { "toggle_preview", config = { use_float = true } },
          ["l"] = "focus_preview",
          ["<C-x>"] = "open_split",
          ["<C-v>"] = "open_vsplit",
          -- ["S"] = "split_with_window_picker",
          -- ["s"] = "vsplit_with_window_picker",
          -- ["<cr>"] = "open_drop",
          ["w"] = "open_with_window_picker",
          --["P"] = "toggle_preview", -- enter preview mode, which shows the current node without focusing
          ['C'] = 'close_all_subnodes',
          -- ["z"] = "close_node",
          ["Z"] = nil,
          ["a"] = {
            "add",
            -- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
            -- some commands may take optional config options, see `:h neo-tree-mappings` for details
            config = {
              show_path = "none" -- "none", "relative", "absolute"
            }
          },
          ["A"] = "add_directory", -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
          ["d"] = "delete",
          ["r"] = "rename",
          ["y"] = "copy_to_clipboard",
          ["x"] = "cut_to_clipboard",
          ["p"] = "paste_from_clipboard",
          -- ["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
          ["c"] = {
            "copy",
            config = {
              show_path = "absolute" -- "none", "relative", "absolute"
            }
          },
          ["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
          ["q"] = "close_window",
          ["R"] = "refresh",
          ["?"] = "show_help",
          ["<"] = "prev_source",
          [">"] = "next_source",
        }
      },

      filesystem = {
        bind_to_cwd = true,
        follow_current_file = true,
        hijack_netrw_behavior = "open_default",
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = true,
          hide_by_name = {
            ".github",
            "node_modules", ".venv", ".vscode", ".idea",
            ".pytest_cache", "__pycache__", ".runner", "runner.egg-info",
            ".git",
          },
          always_show = { ".gitignored", },
          never_show = { ".DS_Store", "thumbs.db", },
        },
        window = {
          mappings = {
            ["o"] = "system_open",
          },
        },
        commands = {
          system_open = function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            -- macOs: open file in default application in the background.
            vim.fn.jobstart({ "open", "-g", path }, { detach = true })
            -- Linux: open file in default application
            -- vim.fn.jobstart({ "xdg-open", path }, { detach = true })
          end,
        },
      },

      buffers = {
        follow_current_file = true, -- This will find and focus the file in the active buffer every
        -- time the current file is changed while the tree is open.
        group_empty_dirs = true, -- when true, empty folders will be grouped together
        show_unloaded = true,
        window = {
          mappings = {
            ["bd"] = "buffer_delete",
            ["<bs>"] = "navigate_up",
            ["."] = "set_root",
          }
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
        icon = {
          folder_closed = "",
          folder_open = "",
          folder_empty = "",
          -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
          -- then these will never be used.
          default = "*",
          highlight = "NeoTreeFileIcon"
        },
        git_status = {
          symbols = {
            -- Change type.
            added     = "", -- or "✚ ", but this is redundant info if you use git_status_colors on the name
            modified  = "", -- or " ", but this is redundant info if you use git_status_colors on the name
            deleted   = "✘ ",-- this can only be used in the git_status source
            renamed   = " ",-- this can only be used in the git_status source

            -- Status type.
            untracked = " ",
            ignored = "◌ ",
            unstaged  = "󰄗 ",
            staged    = " ",
            conflict  = " ",
          }
        },
      },
    },
  },
}

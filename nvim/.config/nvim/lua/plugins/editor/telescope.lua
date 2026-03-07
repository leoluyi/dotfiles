-- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes
-- https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua

local default_vimgrep_arguments = {
  "rg",
  "--color=never",
  "--no-heading",
  "--with-filename",
  "--line-number",
  "--column",
  "--smart-case",
  -- "-u" -- not to respect .gitignore
  "--hidden",
  "--glob",
  "!**/.git/*",
}

return {
  -- Telescope.
  {
    "nvim-telescope/telescope.nvim",
    lazy = true,
    cmd = "Telescope",
    version = false, -- telescope did only one release, so use HEAD for now
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- telescope extensions.
      { "nvim-telescope/telescope-fzy-native.nvim" },
      { "ahmedkhalf/project.nvim" },
    },
    keys = {
        { "<leader>T", ":Telescope<Space>", desc = "Telescope..." },
        { "<leader>sp", "<cmd>Telescope projects<cr>", desc = "Search Projects" },
        { "<leader>st", "<cmd>Telescope filetypes<cr>", desc = "Search Filetypes" },
    },

    opts = function()
      local actions = require("telescope.actions")
      -- Mappings for opening multiple files from find_files, etc.
      -- < https://github.com/nvim-telescope/telescope.nvim/issues/1048 >
      local multi_open_mappings = require("util.telescope-multiopen")

      return {
        defaults = {
          vimgrep_arguments = default_vimgrep_arguments,
          prompt_prefix = ">> ",
          selection_caret = ">> ",
          color_devicons = true,

          preview = {
            timeout = 300,

            ---@diagnostic disable-next-line: unused-local
            timeout_hook = function(filepath, bufnr, opts)
              local cmd = { "echo", "timeout" }
              require("telescope.previewers.utils").job_maker(cmd, bufnr, opts)
            end,

            filesize_hook = function(filepath, bufnr, opts)
              local max_bytes = 10000
              local cmd = { "head", "-c", max_bytes, filepath }
              require("telescope.previewers.utils").job_maker(cmd, bufnr, opts)
            end,
          },
          dynamic_preview_title = true,

          layout_config = {
            prompt_position = "top",
          },
          sorting_strategy = "ascending",

          file_sorter = require("telescope.sorters").get_fzy_sorter,
          file_previewer = require("telescope.previewers").vim_buffer_cat.new,
          grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
          qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,

          path_display = { "truncate" },

          file_ignore_patterns = {
            "%.plist",
            "%.png",
            "%.jpg",
            "%.gif",
            "%.data",
            "node_modules",
            ".DS_Store",
            "%.git/.*",
          },

          mappings = {
            n = {
              ["n"] = "which_key",
              ["<C-c>"] = actions.close,
              ["<Esc>"] = actions.close,
              ["q"] = actions.close,
              ["<TAB>"] = actions.toggle_selection,
              ["<C-TAB>"] = actions.toggle_selection + actions.move_selection_next,
              ["<S-TAB>"] = actions.toggle_selection + actions.move_selection_previous,
              ["d"] = actions.delete_buffer,
            },
            i = {
              ["<C-/>"] = "which_key",
              ["<C-c>"] = actions.close,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-q>"] = actions.send_to_qflist,
              ["<TAB>"] = actions.toggle_selection,
              ["<C-TAB>"] = actions.toggle_selection + actions.move_selection_next,
              ["<S-TAB>"] = actions.toggle_selection + actions.move_selection_previous,
            },
          },
        },

        pickers = {
          find_files = { mappings = multi_open_mappings },
          git_files = { mappings = multi_open_mappings },
          oldfiles = { mappings = multi_open_mappings },
          buffers = {
            sort_lastused = true,
            ignore_current_buffer = true,
          },
          live_grep = {
            -- https://github.com/nvim-telescope/telescope.nvim/issues/855#issuecomment-1032325327
            additional_args = function(_)
              return {
                "--hidden",
                "--glob",
                "!**/.git/*",
              }
            end,
          },
          colorscheme = {
            enable_preview = true,
          },
        },

        extensions = {
          fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true,
          },

        },
      }
    end,

    config = function(_, opts)
      require("telescope").setup(opts)

      -- ====== Extensions =====
      local load_extensions = function()
        require("telescope").load_extension("fzy_native")
        require("telescope").load_extension("yank_history")
        require("telescope").load_extension("projects")
      end

      local status_ok, _ = pcall(load_extensions)
      if not status_ok then
        return
      end
    end,
  },
}

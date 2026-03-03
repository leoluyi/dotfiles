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
      { "nvim-telescope/telescope-live-grep-args.nvim" },
      { "ahmedkhalf/project.nvim" },
    },
    keys = function()
      local ok, telescope = pcall(require, "telescope")
      if not ok then
        return
      end

      local util = require("util.telescope")
      return {
        { "<leader>T", ":Telescope<Space>", desc = "Telescope..." },

        -- Find files.
        { "<leader>cc", util.search_dotfiles, desc = "Neovim config files" },
        { "<c-p>", util.builtin("files"), desc = "[F]ind [F]iles (root dir)" },
        { "<leader>ff", util.all_files, desc = "[F]ind [F]iles (all in cwd)" },
        { "<leader>fF", util.builtin("files", { cwd = false }), desc = "[F]ind [F]iles (cwd)" },
        { "<leader>fm", "<cmd>Telescope oldfiles<cr>", desc = "[M]ost Recent" },
        { "<leader>m", util.builtin("oldfiles", { cwd = vim.uv.cwd() }), desc = "Recent (root dir)" },
        { "<leader><space>", util.buffers, desc = "[F]ind [B]uffers" },
        {
          "<leader>fb",
          util.builtin("buffers", {
            prompt_title = "  Buffers",
            results_title = false,
            winblend = 10,
            path_display = { "truncate" },
            layout_strategy = "vertical",
            layout_config = { width = 0.60, height = 0.55 },
          }),
          desc = "[F]ind [B]uffers (root dir)",
        },

        -- Git.
        { "<leader>gb", "Telescope git_branches", desc = "Telescope git_branches" },
        -- Search.
        { "<leader>sb", util.buffer_dir, desc = "Search [B]uffer dir" },
        { "<leader>sc", "<cmd>Telescope colorscheme<cr>", desc = "Search [C]olorscheme" },
        -- Diagnostics.
        {
          "<leader>se",
          util.builtin(
            "diagnostics",
            { severity_limit = "WARN", initial_mode = "normal", layout_config = { preview_width = 0.50 } }
          ),
          desc = "Lsp Diagnostics [E]rrors (workspace)",
        },

        {
          "<leader>sg",
          function()
            local get_root = require("util.telescope").get_root
            telescope.extensions.live_grep_args.live_grep_args({
              prompt_title = "  Live Grep (args)",
              layout_strategy = "vertical",
              layout_config = { height = 0.95, preview_cutoff = 1, mirror = true },
              cwd = get_root(),
            })
          end,
          desc = "[G]rep (args)",
        },

        {
          "<leader>sG",
          util.builtin("live_grep", {
            prompt_title = "  Live Grep (cwd)",
            layout_strategy = "vertical",
            layout_config = { height = 0.95, preview_cutoff = 1, mirror = true },
            cwd = false,
          }),
          desc = "[G]rep (cwd)",
        },

        { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Search [H]elp" },
        { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Search [K]eymaps" },
        { "<leader>sld", "<cmd>Telescope lsp_definitions<cr>", desc = "Search Lsp [D]efinitions" },
        { "<leader>slr", "<cmd>Telescope lsp_refereces<cr>", desc = "Search Lsp [R]eferences" },
        { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Search [M]arks" },
        { "<leader>sn", util.nvim_config, desc = "Search [N]vim Config" },
        { "<leader>so", "<cmd>Telescope resume<cr>", desc = "Search Resume" },
        { "<leader>sr", "<cmd>Telescope registers<cr>", desc = "Search [R]egisters" },
        {
          "<leader>ss",
          util.builtin("treesitter", { layout_config = { preview_width = 0.55 } }),
          desc = "Search [S]ymbols",
        },
        { "<leader>sp", "<cmd>Telescope projects<cr>", desc = "Search [P]rojects" },
        { "<leader>st", "<cmd>Telescope filetypes<cr>", desc = "Search File[T]ypes" },
        {
          "<leader>sw",
          util.builtin("grep_string", {
            path_display = { "truncate" },
            layout_strategy = "vertical",
            layout_config = { height = 0.95, preview_cutoff = 1, mirror = true },
          }),
          desc = "Search current [W]ord (root dir)",
        },
        {
          "<leader>sw",
          function()
            local text = vim.getVisualSelection()
            util.builtin("live_grep", {
              prompt_title = "  Live Grep (root dir)",
              layout_strategy = "vertical",
              layout_config = { height = 0.95, preview_cutoff = 1, mirror = true },
              default_text = text,
            })()
          end,
          mode = { "v", "x" },
          desc = "Search current [W]ord (root dir)",
        },

        -- https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua#L271
        {
          "<leader>/",
          function()
            require("telescope.builtin").current_buffer_fuzzy_find(util.finders.center_list)
          end,
          desc = "[/] Fuzzily search in current buffer",
        },
      }
    end,

    opts = function()
      local actions = require("telescope.actions")
      local lga_actions = require("telescope-live-grep-args.actions")

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

          live_grep_args = {
            auto_quoting = true, -- enable/disable auto-quoting
            -- define mappings, e.g.
            mappings = { -- extend mappings
              i = {
                ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
              },
            },
            vimgrep_arguments = default_vimgrep_arguments,
          },
        },
      }
    end,

    config = function(_, opts)
      require("telescope").setup(opts)

      -- ====== Extensions =====
      local load_extensions = function()
        require("telescope").load_extension("fzy_native")
        require("telescope").load_extension("live_grep_args")
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

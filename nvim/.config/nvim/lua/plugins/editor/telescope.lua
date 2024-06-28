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
  "--hidden", "--glob", "!**/.git/*",
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
      { "ThePrimeagen/harpoon" },
      { "ahmedkhalf/project.nvim" },
      { "jemag/telescope-diff.nvim" },
      { "nvim-telescope/telescope-file-browser.nvim" },
      { "nvim-telescope/telescope-fzy-native.nvim" },
      { "nvim-telescope/telescope-live-grep-args.nvim" },
      { "echasnovski/mini.fuzzy", version = false },
      { "fdschmidt93/telescope-egrepify.nvim" }
    },
    keys = function ()
      local ok, telescope = pcall(require, "telescope")
      if not ok then return end

      local util = require("helpers.telescope")
      return {
        { '<leader>T', ':Telescope<Space>', desc = "Telescope..." },

        -- Find files.
        { "<leader>cc", util.search_dotfiles, desc = "Neovim config files" },
        { "<c-p>",      util.builtin("files"), desc = "[F]ind [F]iles (root dir)" },
        { "<leader>ff", util.all_files, desc = "[F]ind [F]iles (all in cwd)" },
        { "<leader>fF", util.builtin("files", { cwd = false }), desc = "[F]ind [F]iles (cwd)" },
        { "<leader>fm", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
        { "<leader>m",  util.builtin("oldfiles", { cwd = vim.loop.cwd() }), desc = "Recent (root dir)" },
        { "<leader><space>", util.buffers, desc = "[F]ind [B]uffers" },
        {
          "<leader>fb", util.builtin("buffers", {
            prompt_title = "  Buffers", results_title=false, winblend = 10, path_display={ "truncate" },
            layout_strategy = "vertical", layout_config = { width = 0.60, height = 0.55 }}),
          desc = "[F]ind [B]uffers (root dir)"
        },

        -- Git.
        { "<leader>gb", "Telescope git_branches", desc = "Telescope git_branches" },
        -- Git worktree.
        { "<leader>gm", telescope.extensions.git_worktree.create_git_worktree, desc = "Git Make worktrees" },
        { "<leader>gw", telescope.extensions.git_worktree.git_worktrees, desc = "Git Worktrees"  },
        -- Search.
        { "<leader>sb", util.buffer_dir, desc = "Search [B]uffer dir" },
        { "<leader>sf", "<cmd>Telescope filetypes<cr>", desc = "Search [F]iletype" },
        { "<leader>sc", "<cmd>Telescope colorscheme<cr>", desc = "Search [C]olorscheme" },
        -- { "<leader>sD", function() telescope.extensions.diff.diff_files({ hidden = true }) end, desc = "Search [D]iff 2 files" },
        { "<leader>sD", function() telescope.extensions.diff.diff_current({ hidden = true }) end, desc = "Search [D]iff current file" },
        -- Diagnostics.
        {
          "<leader>se",
          util.builtin("diagnostics", { severity_limit="WARN", initial_mode="normal", layout_config = { preview_width = 0.50 } }),
          desc = "✨Lsp Diagnostics [E]rrors (workspace)"
        },
        -- {
        --   "<leader>sg",
        --   util.builtin("live_grep", {
        --     prompt_title = '  Live Grep (root dir)',
        --     layout_strategy = "vertical",
        --     layout_config = { height = 0.95, preview_cutoff = 1, mirror = true, },
        --   }),
        --   desc = "[G]rep (root dir)"
        -- },

        -- {
        --   "<leader>sg",
        --   function()
        --     local get_root = require("helpers.telescope").get_root
        --     telescope.extensions.live_grep_args.live_grep_args({
        --       prompt_title = '  Live Grep (args)',
        --       layout_strategy = "vertical",
        --       layout_config = { height = 0.95, preview_cutoff = 1, mirror = true, },
        --       cwd = get_root(),
        --     })
        --   end,
        --   desc = "[G]rep (args)"
        -- },

        {
          "<leader>sg",
          function()
            local get_root = require("helpers.telescope").get_root
            telescope.extensions.egrepify.egrepify({
              prompt_title = '  Live Grep (args)',
              layout_strategy = "vertical",
              layout_config = { height = 0.95, preview_cutoff = 1, mirror = true, },
              cwd = get_root(),
            })
          end,
          desc = "[G]rep (args)"
        },

        {
          "<leader>sG",
          util.builtin("live_grep", {
            prompt_title = '  Live Grep (cwd)',
            layout_strategy = "vertical",
            layout_config = { height = 0.95, preview_cutoff = 1, mirror = true, },
            cwd = false,
          }),
          desc = "[G]rep (cwd)"
        },

        { "<leader>sh",  "<cmd>Telescope help_tags<cr>", desc = "Search [H]elp" },
        { "<leader>sk",  "<cmd>Telescope keymaps<cr>", desc = "Search [K]eymaps" },
        { "<leader>sld", "<cmd>Telescope lsp_definitions<cr>", desc = "Search Lsp [D]efinitions" },
        { "<leader>slr", "<cmd>Telescope lsp_refereces<cr>", desc = "Search Lsp [R]eferences" },
        { "<leader>sm",  "<cmd>Telescope marks<cr>", desc = "Search [M]arks" },
        { "<leader>sn",  util.nvim_config, desc = "Search [N]vim Config" },
        { "<leader>so",  "<cmd>Telescope resume<cr>", desc = "Search Resume" },
        { "<leader>sp",  "<cmd>Telescope projects<cr>", desc = "Search [P]rojects" },
        { "<leader>sr",  "<cmd>Telescope registers<cr>", desc = "Search [R]egisters" },
        { "<leader>ss",  util.builtin("treesitter", { layout_config = { preview_width = 0.55 }}), desc = "Search [S]ymbols" },
        { "<leader>st",  "<cmd>Telescope filetypes<cr>", desc = "Search [F]iletypes" },
        {
          "<leader>sw",
          util.builtin("grep_string", {
            path_display={ "truncate" },
            layout_strategy = "vertical",
            layout_config = { height = 0.95, preview_cutoff = 1, mirror = true, },
          }),
          desc = 'Search current [W]ord (root dir)'
        },
        {
          "<leader>sw",
          function ()
            local text = vim.getVisualSelection()
            util.builtin("live_grep", {
              prompt_title = '  Live Grep (root dir)',
              layout_strategy = "vertical",
              layout_config = { height = 0.95, preview_cutoff = 1, mirror = true, },
              default_text = text,
            })()
          end,
          mode = { "v", "x" },
          desc = 'Search current [W]ord (root dir)'
        },
        {
          "<leader>sd", function ()
            require("telescope").extensions.file_browser.file_browser({
              cwd_to_path = false, grouped = true, files = false, depth = false, initial_mode="normal",
              select_buffer = true, respect_gitignore = true })
          end,
          desc = "Search Working [D]irectory"
        },

        -- https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua#L271
        {
          "<leader>/",
          function() require("telescope.builtin").current_buffer_fuzzy_find(util.finders.center_list) end,
          desc = "[/] Fuzzily search in current buffer"
        },
      }
    end,

    opts = function ()
      local actions = require("telescope.actions")
      local fb_actions = require("telescope").extensions.file_browser.actions
      local lga_actions = require("telescope-live-grep-args.actions")

      -- Mappings for opening multiple files from find_files, etc.
      -- < https://github.com/nvim-telescope/telescope.nvim/issues/1048 >
      local multi_open_mappings = require("helpers.telescope-multiopen")

      return {
        defaults = {
          vimgrep_arguments = default_vimgrep_arguments,
          prompt_prefix = "❯ ",
          selection_caret = "❯ ",
          color_devicons = true,

          preview = {
            timeout = 300,

            ---@diagnostic disable-next-line: unused-local
            timeout_hook = function(filepath, bufnr, opts)
              local cmd = {"echo", "timeout"}
              require("telescope.previewers.utils").job_maker(cmd, bufnr, opts)
            end,

            filesize_hook = function(filepath, bufnr, opts)
              local max_bytes = 10000
              local cmd = {"head", "-c", max_bytes, filepath}
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

          path_display={ "truncate" },
          -- path_display={ "smart" },

          file_ignore_patterns = {
            "%.plist",
            "%.png", "%.jpg", "%.gif",
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
          oldfiles   = { mappings = multi_open_mappings },
          buffers = {
            sort_lastused = true,
            ignore_current_buffer = true,
          },
          live_grep = {
            -- https://github.com/nvim-telescope/telescope.nvim/issues/855#issuecomment-1032325327
            additional_args = function(_) return {
              "--hidden",
              "--glob", "!**/.git/*",
            } end,
          },
          colorscheme = {
            enable_preview = true,
          },
        },

        generic_sorter = require("mini.fuzzy").get_telescope_sorter,

        extensions = {
          fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true,
          },

          file_browser = {
            theme = "ivy",
            mappings = {
              ["n"] = {
                ["a"] = fb_actions.create,
                ["h"] = fb_actions.goto_parent_dir,
              },
            },
          },

          live_grep_args = {
            auto_quoting = true, -- enable/disable auto-quoting
            -- define mappings, e.g.
            mappings = { -- extend mappings
              i = {
                -- ["<C-q>"] = lga_actions.quote_prompt(),
                ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
              },
            },
            vimgrep_arguments = default_vimgrep_arguments,
            -- theme = "dropdown", -- use dropdown theme
            -- layout_config = { mirror=true }, -- mirror preview pane
          },

          egrepify = {
            vimgrep_arguments = default_vimgrep_arguments,
            prefixes = {
              -- ADDED ! to invert matches
              -- example prompt: ! sorter
              -- matches all lines that do not comprise sorter
              -- rg --invert-match -- sorter
              ["!"] = {
                flag = "invert-match",
              },
              -- HOW TO OPT OUT OF PREFIX
              -- ^ is not a default prefix and safe example
              ["^"] = false,
              ["#"] = {
                -- #$REMAINDER
                -- # is caught prefix
                -- `input` becomes $REMAINDER
                -- in the above example #lua,md -> input: lua,md
                flag = "glob",
                cb = function(input)
                  return string.format([[*.{%s}]], input)
                end,
              },
              -- filter for (partial) folder names
              -- example prompt: >conf $MY_PROMPT
              -- searches with ripgrep prompt $MY_PROMPT in paths that have "conf" in folder
              -- i.e. rg --glob="**/conf*/**" -- $MY_PROMPT
              [">"] = {
                flag = "glob",
                cb = function(input)
                  return string.format([[**/{%s}*/**]], input)
                end,
              },
              -- filter for (partial) file names
              -- example prompt: &egrep $MY_PROMPT
              -- searches with ripgrep prompt $MY_PROMPT in paths that have "egrep" in file name
              -- i.e. rg --glob="*egrep*" -- $MY_PROMPT
              ["&"] = {
                flag = "glob",
                cb = function(input)
                  return string.format([[*{%s}*]], input)
                end,
              },
            },
          },

        },
      }
    end,

    config = function(_, opts)
      require('telescope').setup(opts)

      -- ====== 🔭 Extensions =====
      local load_extensions = function()
        require("telescope").load_extension("diff")
        require("telescope").load_extension("egrepify")
        require("telescope").load_extension("file_browser")
        require("telescope").load_extension("fzy_native")
        require("telescope").load_extension("git_worktree")
        require("telescope").load_extension("harpoon")
        require("telescope").load_extension("live_grep_args")
        require("telescope").load_extension("projects")
        require("telescope").load_extension("yank_history")
      end

      local status_ok, _ = pcall(load_extensions)
      if not status_ok then
        return
      end
    end,
  },

}

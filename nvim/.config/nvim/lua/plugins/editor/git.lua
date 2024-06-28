return {

  {
    -- < https://github.com/NeogitOrg/neogit >
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "sindrets/diffview.nvim",        -- optional - Diff integration

      -- Only one of these is needed, not both.
      "nvim-telescope/telescope.nvim", -- optional
      "ibhagwan/fzf-lua",              -- optional
    },
    config = true,
    keys = {
      { "<leader>gs", function () require('neogit').open() end, desc = "Neogit" },
      { "<leader>gc", ":Neogit commit<cr>", desc = "Neogit commit" },
      { "<leader>gp", ":Neogit push<cr>", desc = "Neogit push" },
      { "<leader>gP", ":Neogit pull<cr>", desc = "Neogit pull" },
      -- { "<leader>gR", ":Neogit rebase", desc = "Neogit rebase" },
      -- { "<leader>gS", ":Neogit stash", desc = "Neogit stash" },
      -- { "<leader>gT", ":Neogit stash-pop", desc = "Neogit stash-pop" },
      -- { "<leader>gU", ":Neogit pull-unmerged", desc = "Neogit pull-unmerged" },
      -- { "<leader>gW", ":Neogit worktree", desc = "Neogit worktree" },
      -- { "<leader>g?", ":Neogit help", desc = "Neogit help" },
    }
  },

  {
    "tpope/vim-fugitive",
    lazy = false,
    keys = {
      { "<leader>ga", "<cmd>Git add %<cr>", desc = "Git add" },
      -- { "<leader>gf", "<cmd>diffget //2<cr>", desc = "Git diffget //2" },
      -- { "<leader>gs", "<cmd>Git<cr>", desc = "Git" },
      -- { "<leader>gj", "<cmd>diffget //3<cr>", desc = "Git diffget //3" },
      -- { "<leader>gp", "<cmd>Git push<cr>", desc = "Git push" },
      { "<localleader>gR", "<cmd>Git restore -- %<cr>", desc = "Git restore -- %" },
    }
  },

  {
    -- < https://github.com/lewis6991/gitsigns.nvim#keymaps >
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      {
        -- which key integration
        "folke/which-key.nvim",
        optional = true,
        opts = {
          defaults = {
            ["<leader>ug"] = { name = "+Toggle Gitsigns" },
          },
        },
      },
    },
    opts = {
      signs = {
        -- delete = { text = "" },
        -- topdelete = { text = "" },
        -- changedelete = { text = "▎" },
        add          = { text = '▎' },
        change       = { text = '▎' },
        delete       = { text = '▁' },
        topdelete    = { text = '⤒' },
        changedelete = { text = '~' },
        untracked    = { text = "▎" },
      },
      signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
      numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
      linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
      word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
      watch_gitdir = {
        interval = 1000,
        follow_files = true
      },
      attach_to_untracked = true,
      current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil, -- Use default
      max_file_length = 40000, -- Disable if file is longer than this (in lines)
      preview_config = {
        -- Options passed to nvim_open_win
        border = 'single',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1
      },

      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, lhs, rhs, opts)
          opts = vim.tbl_extend('force', { buffer = buffer, noremap = true, silent = true}, opts or {})
          vim.keymap.set(mode, lhs, rhs, opts)
        end

        -- Navigation.
        -- map('n', ']h', "&diff ? ']h' : '<cmd>Gitsigns next_hunk<CR>'", { expr=true, desc="Gitsigns next_hunk"})
        -- map('n', '[h', "&diff ? '[h' : '<cmd>Gitsigns prev_hunk<CR>'", { expr=true, desc="Gitsigns prev_hunk"})
        map('n', ']h', "<cmd>Gitsigns next_hunk<cr>", { desc = "Gitsigns next_hunk" })
        map('n', '[h', "<cmd>Gitsigns prev_hunk<cr>", { desc = "Gitsigns prev_hunk" })

        -- Hunk.
        -- map('n', '<leader>ghR', '<cmd>Gitsigns reset_buffer<CR>', { desc = "Gitsigns reset_buffer" })
        -- map('n', '<leader>ghS', '<cmd>Gitsigns stage_buffer<CR>', { desc = "Gitsigns stage_buffer" })
        map('n', '<leader>ghb', function() gs.blame_line({ full = true }) end, { desc = "Gitsigns Hunk Blame line" })
        map('n', '<leader>ghh', '<cmd>Gitsigns preview_hunk<CR>', { desc = "Gitsigns preview_hunk" })
        map('n', '<localleader>gr', '<cmd>Gitsigns reset_hunk<CR>', { desc = "Gitsigns reset_hunk" })
        map('n', '<leader>ghr', '<cmd>Gitsigns reset_hunk<CR>', { desc = "Gitsigns reset_hunk" })
        map('n', '<leader>ghs', '<cmd>Gitsigns stage_hunk<CR>', { desc = "Gitsigns stage_hunk" })
        map('n', '<leader>ghu', '<cmd>Gitsigns undo_stage_hunk<CR>', { desc = "Gitsigns undo_stage_hunk" })
        map('x', '<leader>ghr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = "Gitsigns reset_hunk" })
        map('x', '<leader>ghs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = "Gitsigns stage_hunk" })

        -- Toggle.
        map('n', '<leader>ugb', '<cmd>Gitsigns toggle_current_line_blame<CR>', { desc = "Gitsigns toggle_current_line_blame" })
        map('n', '<leader>ugd', '<cmd>Gitsigns toggle_deleted<CR>', { desc = "Gitsigns toggle_deleted" })

        -- Git diff.
        -- map('n', '<leader>gD',  function() gs.diffthis("~") end, { desc = "Git Diff this(~)" })
        -- map('n', '<leader>gd', gs.diffthis, { desc = "Git Diff this" })

        -- Text object
        map('o', 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = "Gitsigns select_hunk" })
        map('x', 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = "Gitsigns select_hunk" })
      end,
    },
    config = function(_, opts)
      require('gitsigns').setup(opts)

      -- Commands.
      local config = require('gitsigns.config').config
      local actions = require('gitsigns.actions')

      local disable_signs = function()
        config.signcolumn = false
        actions.refresh()
      end

      local enable_signs = function()
        config.signcolumn = true
        actions.refresh()
      end

      vim.api.nvim_create_user_command('GitsignsDisable', disable_signs, {})
      vim.api.nvim_create_user_command('GitsignsEnable', enable_signs, {})
    end,
  },

  { 'ThePrimeagen/git-worktree.nvim' },

}

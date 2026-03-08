return {

  {
    -- < https://github.com/NeogitOrg/neogit >
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required

      -- Only one of these is needed, not both.
      "nvim-telescope/telescope.nvim", -- optional
    },
    config = true,
    keys = {
      {
        "<leader>gs",
        function()
          require("neogit").open()
        end,
        desc = "Neogit",
      },
      { "<leader>gc", ":Neogit commit<cr>", desc = "Neogit commit" },
      { "<leader>gp", ":Neogit push<cr>", desc = "Neogit push" },
      { "<leader>gP", ":Neogit pull<cr>", desc = "Neogit pull" },
    },
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
          spec = {
            { "<leader>ug", group = "Toggle Gitsigns" },
          },
        },
      },
    },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "▁" },
        topdelete = { text = "⤒" },
        changedelete = { text = "~" },
        untracked = { text = "▎" },
      },
      signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
      numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
      linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
      word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
      watch_gitdir = {
        interval = 1000,
        follow_files = true,
      },
      attach_to_untracked = true,
      current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil, -- Use default
      max_file_length = 40000, -- Disable if file is longer than this (in lines)
      preview_config = {
        -- Options passed to nvim_open_win
        border = "single",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },

      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, lhs, rhs, opts)
          opts = vim.tbl_extend("force", { buffer = buffer, noremap = true, silent = true }, opts or {})
          vim.keymap.set(mode, lhs, rhs, opts)
        end

        -- Navigation.
        map("n", "]h", "<cmd>Gitsigns next_hunk<cr>", { desc = "Gitsigns next_hunk" })
        map("n", "[h", "<cmd>Gitsigns prev_hunk<cr>", { desc = "Gitsigns prev_hunk" })

        -- Buffer-level operations (replaces vim-fugitive).
        map("n", "<leader>ga", gs.stage_buffer, { desc = "Git stage buffer" })
        map("n", "<leader>gR", gs.reset_buffer, { desc = "Git reset buffer" })

        -- Hunk.
        map("n", "<leader>hb", function()
          gs.blame_line({ full = true })
        end, { desc = "Gitsigns Hunk Blame line" })
        map("n", "<leader>hh", "<cmd>Gitsigns preview_hunk<CR>", { desc = "Gitsigns preview_hunk" })
        map("n", "<leader>hr", "<cmd>Gitsigns reset_hunk<CR>", { desc = "Gitsigns reset_hunk" })
        map("n", "<leader>hs", "<cmd>Gitsigns stage_hunk<CR>", { desc = "Gitsigns stage_hunk" })
        map("n", "<leader>hu", "<cmd>Gitsigns undo_stage_hunk<CR>", { desc = "Gitsigns undo_stage_hunk" })
        map("x", "<leader>hr", function()
          gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "Gitsigns reset_hunk" })
        map("x", "<leader>hs", function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "Gitsigns stage_hunk" })

        -- Toggle.
        map(
          "n",
          "<leader>hB",
          "<cmd>Gitsigns toggle_current_line_blame<CR>",
          { desc = "Gitsigns toggle_current_line_blame" }
        )
        map("n", "<leader>hD", "<cmd>Gitsigns toggle_deleted<CR>", { desc = "Gitsigns toggle_deleted" })

        -- Text object
        map("o", "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Gitsigns select_hunk" })
        map("x", "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Gitsigns select_hunk" })
      end,
    },
    config = function(_, opts)
      require("gitsigns").setup(opts)

      -- Commands.
      local config = require("gitsigns.config").config
      local actions = require("gitsigns.actions")

      local disable_signs = function()
        config.signcolumn = false
        actions.refresh()
      end

      local enable_signs = function()
        config.signcolumn = true
        actions.refresh()
      end

      vim.api.nvim_create_user_command("GitsignsDisable", disable_signs, {})
      vim.api.nvim_create_user_command("GitsignsEnable", enable_signs, {})
    end,
  },
}

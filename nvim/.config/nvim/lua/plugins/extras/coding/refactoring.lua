return {
  -- < https://github.com/ThePrimeagen/refactoring.nvim >
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {'nvim-lua/plenary.nvim', 'nvim-treesitter/nvim-treesitter'},
    keys = function ()
      return {
        { "<localleader>rs", require('refactoring').select_refactor, mode = "v", desc = "[R]efactor [S]elect Prompt" },
        { "<localleader>re", function() require('refactoring').refactor('Extract Function') end, mode = "v", desc = "[R]efactor [E]xtract Function" },
        { "<localleader>rf", function() require('refactoring').refactor('Extract Function To File') end, mode = "v", desc = "[R]efactor Extract Function To [F]ile" },
        { "<localleader>rv", function() require('refactoring').refactor('Extract Variable') end, mode = "v", desc = "[R]efactor Extract [V]ariable" },
        { "<localleader>ri", function() require('refactoring').refactor('Inline Variable') end, mode = "v", desc = "[R]efactor [I]nline Variable" },

        { "<localleader>rbb", function() require('refactoring').refactor('Refactor Extract Block') end, mode = "n", desc = "[R]efactor Extract [B]lock" },
        { "<localleader>rbf", function() require('refactoring').refactor('Extract Block To File') end, mode = "n", desc = "[R]efactor Extract [B]lock To [F]ile" },
        { "<localleader>ri", function() require('refactoring').refactor('Inline Variable') end, mode = "n", desc = "[R]efactor [I]nline Variable" },
      }
    end,
    opts = {
      -- prompt for return type
      prompt_func_return_type = {
        go = true,
        cpp = true,
        c = true,
        java = true,
        python = true,
      },

      -- prompt for function parameters
      prompt_func_param_type = {
        go = true,
        cpp = true,
        c = true,
        java = true,
        python = true,
      },
    }
  },
}

return {
  {
    "PedramNavid/dbtpal",
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      {'nvim-telescope/telescope.nvim'},
    },
    keys = {
      -- { "<leader>dr", function() require("dbtpal").run() end, desc = "dbt run (current model)" },
      -- { "<leader>dR", function() require("dbtpal").run_all() end, desc = "dbt run (all)" },
      -- { "<leader>dt", function() require("dbtpal").test() end, desc = "dbt test (current model)" },
      -- { "<leader>dT", function() require("dbtpal").test_all() end, desc = "dbt test (all)" },
      -- { "<leader>dm", function() require("dbtpal.telescope").dbt_picker() end, desc = "dbt Telescope" },
    },
    opts = {
      -- Path to the dbt executable
      path_to_dbt = "dbt",

      -- Path to the dbt project, if blank, will auto-detect
      -- using currently open buffer for all sql,yml, and md files
      path_to_dbt_project = "",

      -- Path to dbt profiles directory
      path_to_dbt_profiles_dir = vim.fn.expand("~/.config/dbt"),

      -- Search for ref/source files in macros and models folders
      extended_path_search = true,

      -- Prevent modifying sql files in target/(compiled|run) folders
      protect_compiled_files = true
    },
    config = function(_, opts)
      require("dbtpal").setup(opts)

      vim.cmd [[
        augroup dbt
          autocmd!
          autocmd FileType sql setlocal filetype=sql.dbt
          autocmd FileType yml setlocal filetype=yaml.dbt
          autocmd FileType md setlocal filetype=markdown.dbt
        augroup END
      ]]

      -- Enable Telescope Extension
      require'telescope'.load_extension('dbtpal')
    end,
  },
}

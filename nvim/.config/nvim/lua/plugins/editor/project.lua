return {
  -- Project.
  -- < https://github.com/ahmedkhalf/project.nvim >
  {
    "ahmedkhalf/project.nvim",
    main = 'project_nvim',
    -- enabled = false,
    keys = {
      { "<leader>cd", "<cmd>ProjectRoot<cr>", desc = "cd to project root" },
    },
    opts = {
      -- Manual mode doesn't automatically change your root directory, so you have
      -- the option to manually do so using `:ProjectRoot` command.
      manual_mode = false,

      -- Here order matters: if one is not detected, the other is used as fallback.
      detection_methods = { "lsp", "pattern" },
      patterns = { ".git", ".github", "!.git/worktrees", "Makefile", "package.json" },
      silent_chdir = false,
      ignore_lsp = { "lua_ls" },

      -- Don't calculate root dir on specific directories
      -- Ex: { "~/.cargo/*", ... }
      exclude_dirs = {},

      -- Show hidden files in telescope
      show_hidden = false,

      -- What scope to change the directory, valid options are
      -- * global (default)
      -- * tab
      -- * win
      scope_chdir = 'global',
    },
  },
}

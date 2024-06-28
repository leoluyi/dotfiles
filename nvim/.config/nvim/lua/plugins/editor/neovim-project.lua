return {
  {
    "coffebar/neovim-project",
    enabled = false,
    opts = {
      projects = { -- define project roots
        "~/_repos/*",
        "~/projects/*",
        "~/.config/*",
      },
      -- Load the most recent session on startup if not in the project directory
      last_session_on_startup = false,
    },
    init = function()
      -- enable saving the state of plugins in the session
      vim.opt.sessionoptions:append("globals") -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
    end,
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope.nvim", tag = "0.1.4" },
      { "Shatur/neovim-session-manager" },
    },
    lazy = false,
    priority = 100,
    keys = {
      { "<leader>sP", ":Telescope neovim-project discover<cr>", mode = { "n", "x" }, desc = "Discover project in defined roots", silent = false },
      -- { "<leader>sa", ":Telescope neovim-project history<cr>", mode = { "n", "x" }, desc = "Recent Projects", silent = false },
    },
  },
}

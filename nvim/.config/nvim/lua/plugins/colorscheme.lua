return {
  -- COLORSCHEME. ================================================================={{{3

  {
    "neanias/everforest-nvim",
    name = "everforest",
    lazy = false,
    priority = 1000,
    opts = {
      transparent_background_level = 0,
    },
  },
  { "catppuccin/nvim", name = "catppuccin", lazy = false },
  { "dracula/vim", name = 'dracula', lazy = false },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    config = function ()
      vim.g.tokyonight_style = "night"
      vim.g.tokyonight_italic_functions = true
      vim.g.tokyonight_transparent = true
      vim.g.tokyonight_transparent_sidebar = true
    end
  },
  { "ishan9299/nvim-solarized-lua", lazy = false },
  { "ellisonleao/gruvbox.nvim", lazy = false },
  { "mhartington/oceanic-next", lazy = false },
  { "NLKNguyen/papercolor-theme", lazy = false },
  { "rakr/vim-one", lazy = false },
  { "ribru17/bamboo.nvim", lazy = false, priority = 1000, config = function() require("bamboo").setup {} require("bamboo").load() end, },
  { "rose-pine/neovim", name = "rose-pine", lazy = false, opts = { dark_variant = "moon" }},

}

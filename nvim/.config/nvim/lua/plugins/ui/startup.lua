return {
  {
    "goolord/alpha-nvim",
    lazy = false,
    dependencies = { "echasnovski/mini.icons" },
    config = function()
      -- require("alpha").setup(require("alpha.themes.startify").config)
      require("alpha").setup(require("alpha.themes.dashboard").config)
    end,
  },
}

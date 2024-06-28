return {

  {
    "sindrets/diffview.nvim",
    keys = {
      { "<leader>gdo", "<cmd>DiffviewOpen -uno<cr>",   desc = "Diffview open" },
      { "<leader>gdc", "<cmd>DiffviewClose<cr>",       desc = "Diffview close" },
      { "<leader>gdp", "<cmd>DiffviewToggleFiles<cr>", desc = "Diffview toggle file panel" },
    },
    cmd = {
      "DiffviewClose",
      "DiffviewFileHistory",
      "DiffviewFocusFiles",
      "DiffviewOpen",
      "DiffviewToggleFiles",
    },
    opts = {
    },
  },

}

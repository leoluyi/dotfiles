return {

  {
    "Zeioth/compiler.nvim",
    cmd = {"CompilerOpen", "CompilerToggleResults"},
    dependencies = { "stevearc/overseer.nvim" },
    keys = {
      { "<leader>bb", "<cmd>CompilerOpen<cr>", desc = "[C]ompiler Open - [B]uild " },
      { "<leader>kc", "<cmd>CompilerToggleResults<cr>", desc = "Toggle Build Results" },
    },
    config = function(_, opts)
      require("compiler").setup(opts)
    end,
  },

  { -- The task runner we use
    "stevearc/overseer.nvim",
    commit = "68a2d344cea4a2e11acfb5690dc8ecd1a1ec0ce0",
    cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
    opts = {
      task_list = {
        direction = "bottom",
        min_height = 25,
        max_height = 25,
        default_detail = 1
      },
    },
  }
}

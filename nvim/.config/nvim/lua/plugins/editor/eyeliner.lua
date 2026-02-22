return {
  -- Lightning fast left-right movement.
  {
    "jinh0/eyeliner.nvim",
    keys = {
      "f",
      "F",
      "t",
      "T",
    },
    opts = {
      highlight_on_key = true,
      dim = false,
      max_length = 120,
      disabled_buftypes = { "terminal", "nofile" },
      disabled_filetypes = { "alpha", "dashboard", "startify" },
    },
  },
}

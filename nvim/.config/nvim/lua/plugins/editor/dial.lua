return {
  "monaqa/dial.nvim",
  enabled = false,
  keys = {
    { "n", "<C-a>", "<Plug>(dial-increment)" },
    { "n", "<C-x>", "<Plug>(dial-decrement)" },
    { "n", "g<C-a>", "g<Plug>(dial-increment)" },
    { "n", "g<C-x>", "g<Plug>(dial-decrement)" },
    { "v", "<C-a>", "<Plug>(dial-increment)" },
    { "v", "<C-x>", "<Plug>(dial-decrement)" },
    { "v", "g<C-a>", "g<Plug>(dial-increment)" },
    { "v", "g<C-x>", "g<Plug>(dial-decrement)" },
  }
}

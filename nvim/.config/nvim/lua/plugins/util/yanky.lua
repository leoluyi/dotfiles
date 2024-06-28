return {
  "gbprod/yanky.nvim",
  dependencies = {
    { "nvim-telescope/telescope.nvim" },
  },
  keys = {
    {
      "<leader>sy",
      function () require("telescope").extensions.yank_history.yank_history({initial_mode = "normal"}) end,
      mode = {"n", "x"},
      desc = "[Y]ank History",
    },
    { "p", "<Plug>(YankyPutAfter)`]",  mode = {"n", "x"}, desc = "YankyPutAfter" },
    { "P", "<Plug>(YankyPutBefore)", mode = {"n", "x"}, desc = "YankyPutBefore" },
    { "gp", "<Plug>(YankyGPutAfter)`]", mode = {"n", "x"}, desc = "Put (cursor after new text)" },
    { "gP", "<Plug>(YankyGPutBefore)", mode = {"n", "x"}, desc = "Put (cursor after new text)" },
  },
  config = function ()
    local utils = require("yanky.utils")
    local mapping = require("yanky.telescope.mapping")

    require("yanky").setup({
      ring = {
        history_length = 20,
        storage = "shada",
        sync_with_numbered_registers = true,
        cancel_event = "update",
      },
      picker = {
        select = {
          action = nil, -- nil to use default put action
        },
        telescope = {
          mappings = {
            default = mapping.put("p"),
            i = {
              ["<c-p>"] = mapping.put("p"),
              -- ["<c-k>"] = mapping.put("P"),
              -- ["<c-x>"] = mapping.delete(),
              -- ["<c-r>"] = mapping.set_register(utils.get_default_register()),
            },
            n = {
              p = mapping.put("p"),
              P = mapping.put("P"),
              d = mapping.delete(),
              r = mapping.set_register(utils.get_default_register())
            },
          }
        },
      },
      system_clipboard = {
        sync_with_ring = false,
      },
      highlight = {
        on_put = true,
        on_yank = false,
        timer = 300,
      },
      preserve_cursor_position = {
        enabled = true,
      },
    })
  end,
}

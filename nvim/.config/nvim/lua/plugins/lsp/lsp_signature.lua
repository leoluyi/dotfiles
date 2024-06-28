-- LSP signature hint as you type.
-- < https://github.com/ray-x/lsp_signature.nvim >
return {
  {
    "ray-x/lsp_signature.nvim",
    opts = {
      debug = false,
      bind = true, -- This is mandatory, otherwise border config won't get registered.
      doc_lines = 3, -- will show two lines of comment/doc(if there are more than two lines in doc, will be truncated);
      max_height = 12, -- max height of signature floating_window
      max_width = 80, -- max_width of signature floating_window
      handler_opts = {
        border = "rounded"
      },
      hi_parameter = "IncSearch",
      cursorhold_update = false,
    },
  },
}


-- < https://github.com/akinsho/bufferline.nvim >

return {
  {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    keys = {
      { "<leader>bs", "<cmd>BufferLineSortByRelativeDirectory<cr>", { desc = "BufferLine SortByRelativeDirectory", mode = "n" } },
    },
    opts = {
      options = {
        mode = "buffers",
        separator_style = "thick",
        always_show_bufferline = true,
        show_buffer_close_icons = true,
        show_close_icon = false,
        max_name_length = 25,
        max_prefix_length = 18, -- prefix used when a buffer is de-duplicated
        tab_size = 25,
        color_icons = true,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
        },
        custom_filter = function(buffer)
          -- Only show current buffer.
          return vim.api.nvim_get_current_buf() == buffer
        end,
      },

      highlights = {
        buffer_selected = {
          bold = true,
          italic = false,
          underline = false,
        },
      },
    },

    config = function(_, opts)
      require("bufferline").setup(opts)

      vim.cmd([[
        autocmd ColorScheme * highlight BufferLineFill guibg=none
        autocmd ColorScheme * highlight BufferLineBackground guifg=#7a7c9e
        autocmd ColorScheme * highlight BufferLineBufferSelected guifg=white gui=none
      ]])
    end
  }
}

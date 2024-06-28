return {
  {
    "xiyaowong/nvim-transparent",
    lazy = false,
    cmd = {
      "TransparentToggle",
      "TransparentEnable",
      "TransparentDisable",
    },
    keys = {
      { "<leader>ut", ":TransparentToggle<cr>", mode = { "n", "x" }, desc = "Toggle [T]ransparent", silent = false },
    },
    opts = {
      extra_groups = { -- table/string: additional groups that should be cleared
        -- In particular, when you set it to 'all', that means all available groups

        -- example of akinsho/nvim-bufferline.lua
        "BufferLineTabClose",
        "BufferlineBufferSelected",
        "BufferLineFill",
        "BufferLineBackground",
        "BufferLineSeparator",
        "BufferLineIndicatorSelected",

        -- make floating windows transparent.
        -- "LspFloatWinNormal",
        -- "Normal",
        -- "NormalFloat",
        -- "FloatBorder",
        -- "TelescopeNormal",
        -- "TelescopeBorder",
        -- "TelescopePromptBorder",
        -- "SagaBorder",
        -- "SagaNormal",
      },
      exclude_groups = {}, -- table: groups you don't want to clear
    },
    config = function (_, opts)
      vim.g.transparent_enabled = false
      require('transparent').setup(opts)
    end
  },
}

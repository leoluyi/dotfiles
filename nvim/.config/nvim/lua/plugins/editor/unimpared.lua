return {
  {
    -- unimpaired.nvim is a collection of useful keymaps for (neo)vim.
    "tummetott/unimpaired.nvim",
    opts = {
      -- Disable the default mappings if you prefer to define your own mappings
      default_keymaps = false,
      keymaps = {
        previous_file = {
            mapping = '[f',
            description = 'Previous file in directory. :colder in qflist',
            dot_repeat = true,
        },
        next_file = {
            mapping = ']f',
            description = 'Next file in directory. :cnewer in qflist',
            dot_repeat = true,
        },
        blank_above = {
          mapping = '[<Space>',
          description = 'Add [count] blank lines above',
          dot_repeat = true,
        },
        blank_below = {
          mapping = ']<Space>',
          description = 'Add [count] blank lines below',
          dot_repeat = true,
        },
      },
    }
  }
}

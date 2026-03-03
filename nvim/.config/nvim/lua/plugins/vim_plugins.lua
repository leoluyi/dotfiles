-- vim: fdm=marker:fdl=3
return {
  -- Vim plugins. -----------------------------------------------------------------{{{3

  {
    "junegunn/vim-easy-align",
    keys = function()
      return {
        -- " Start interactive EasyAlign in visual mode (e.g. vipga).
        { "ga", "<Plug>(EasyAlign)", mode = "x", desc = "EasyAlign interactive" },
        -- " Start interactive EasyAlign for a motion/text object (e.g. gaip).
        { "ga", "<Plug>(EasyAlign)", mode = "n", desc = "EasyAlign interactive" },

        -- " Align all <char>.
        { "gaa", "<Plug>(EasyAlign)*", mode = "x", desc = "EasyAlign all" },
        { "gaa", "<Plug>(EasyAlign)*", mode = "n", desc = "EasyAlign all" },
      }
    end,
    config = function()
      -- https://github.com/junegunn/vim-easy-align/issues/155
      vim.cmd([[
        let g:easy_align_delimiters = {
        \ 'l': { 'pattern': '--\+', 'delimiter_align': 'l', 'ignore_groups': ['Comment'] }
        \ }
        ]])
    end,
  }, -- A Vim alignment plugin
  {
    "mbbill/undotree",
    keys = {
      { "<leader>uu", ":UndotreeToggle<CR>", desc = "Undotree toggle" },
    },
  },
  -- }}}
}

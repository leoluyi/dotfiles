-- vim: fdm=marker:fdl=3
return {
  -- Vim plugins. -----------------------------------------------------------------{{{3

  -- tpope.
  { 'tpope/vim-eunuch' },   -- Helpers for UNIX
  { 'tpope/vim-fugitive' }, -- A Git wrapper so awesome
  { 'tpope/vim-repeat' },   -- enable repeating supported plugin maps with '.'
  { 'tpope/vim-sensible' }, -- Defaults everyone can agree on
  { 'tpope/vim-surround' }, -- cs.., ds., ys.. . Provides mappings to easily delete, change and add such surroundings in pairs.
  -- { "tpope/vim-unimpaired" },  -- Pairs of handy bracket mappings

  { 'Asheq/close-buffers.vim' },  -- Quickly close (bdelete) several buffers at once
  { 'dalance/vseq.vim' },  -- Generating sequential number vertically
  { 'danro/rename.vim', lazy = false },  -- Rename the current file in the vim buffer + retain relative path
  {
    -- Instant table creation
    'dhruvasagar/vim-table-mode',
    keys = function ()
      return {
        { "<Leader>um", ":TableModeToggle<CR>", mode = { "n", "x" }, desc = "Toggle [M]arkdown table mode" },
      }
    end,
    configs = function ()
      vim.g.table_mode_disable_mappings = 0
    end,
  },
  { 'dhruvasagar/vim-zoom' },  -- Toggle zoom in / out individual windows (splits)
  { 'dkarter/bullets.vim', lazy = false },  -- automated bullet lists
  { 'junegunn/gv.vim' },  -- A git commit browser in Vim
  {
    'junegunn/vim-easy-align',
    keys = function ()
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
    config = function ()
      -- https://github.com/junegunn/vim-easy-align/issues/155
      vim.cmd([[
        let g:easy_align_delimiters = {
        \ 'l': { 'pattern': '--\+', 'delimiter_align': 'l', 'ignore_groups': ['Comment'] }
        \ }
        ]])
    end,
  },  -- A Vim alignment plugin
  {
    'lambdalisue/suda.vim',
    config = function ()
      if vim.fn.exists(':SudaWrite') > 0 then
        vim.api.nvim_create_user_command("W", "w suda://%", {})
      else
        vim.api.nvim_create_user_command("W", "w !sudo tee > /dev/null %", {})
      end
    end,
  },  -- Read or write files with sudo command
  {
    'mbbill/undotree',
    keys = {
      { "<leader>U", ":UndotreeToggle<CR>", desc = "Undotree toggle" },
    },
  },
  { 'mg979/vim-visual-multi', branch = 'master' },  -- Multiple cursors plugin for vim/neovim
  { 'rhysd/conflict-marker.vim' },  -- Highlight, Jump and Resolve Conflict Markers Quickly in Vim

  -- Language specific plugins.
  { 'PieterjanMontens/vim-pipenv', dependencies = {'jmcantrell/vim-virtualenv', ft = {'python'}}, ft = {'python'} },  -- Pipenv support
  { 'plasticboy/vim-markdown', ft = {'markdown'} },  -- Syntax highlighting, matching rules and mappings for the original Markdown and extensions
  { 'mzlogin/vim-markdown-toc', ft = {'markdown'} },  -- Generate table of contents for Markdown files
  -- }}}
}

-- vim: fdm=marker:fdl=1
-- local _, _ = pcall(require, "impatient")
if vim.loader then
  vim.loader.enable()
end

-- Define leader key before any key mappings.
vim.g.mapleader = ","
vim.g.maplocalleader = " "
vim.api.nvim_set_keymap("n", "<localleader><Space>", "<Space>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>,", ",", { noremap = true })

require("core.lazy") -- Plugin manager.
require("core.options") -- Options.
require("core.autocmds") -- Autocmd.
require("config.keymaps") -- Keymaps.
require("config.vimrc") -- Other vim settings.
require("config.global_statusline")
require("config.colorscheme")

-- netrw.
vim.g.netrw_altfile = 1
vim.g.netrw_banner = 1
vim.g.netrw_browse_split = 0
vim.g.netrw_fastbrowse = 0
vim.g.netrw_winsize = 25
vim.g.netrw_list_hide = [[\~$,\.swp$,\.DS_Store,\.so,\.zip,\.git,^\.\=/\=$]]

-- References. ------------------------------------------------------------------- {{{2
-- https://github.com/tokiory/neovim-boilerplate - Starter boilerplate for making new configurations.
-- https://github.com/frans-johansson/lazy-nvim-starter - Starter boilerplate with lazy plugin manager.
-- https://github.com/LazyVim/starter
-- https://www.lazyvim.org/

-- https://dotfyle.com/
-- https://github.com/craftzdog/dotfiles-public
-- https://github.com/ThePrimeagen/init.lua
-- https://github.com/nvim-lua/kickstart.nvim
-- https://github.com/NvChad/NvChad
-- https://github.com/glepnir/nvim

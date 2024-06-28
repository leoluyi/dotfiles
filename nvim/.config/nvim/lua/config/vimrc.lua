local config_home = require("config.rtp").config_home

vim.opt.rtp:append(config_home)
vim.cmd('source ' .. config_home .. '/vimrcs/basic.vim')
vim.cmd('source ' .. config_home .. '/vimrcs/filetypes.vim')

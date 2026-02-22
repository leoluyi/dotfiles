vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2

-- Fix slow syntax highlighting in large HTML files
vim.opt_local.synmaxcol = 128
vim.opt.lazyredraw = true
vim.opt_local.cursorline = false
vim.cmd("syntax sync minlines=256")

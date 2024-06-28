-- Set runtimepath for vim.
local M = {}

M.config_home = vim.fn.expand('~/.config/nvim/')
M.data_dir    = vim.fn.stdpath("data")
M.site_dir    = vim.fn.stdpath("data") .. "/site"
M.undodir     = vim.fn.stdpath("data") .. "/site/temp_dirs/undodir"

return M

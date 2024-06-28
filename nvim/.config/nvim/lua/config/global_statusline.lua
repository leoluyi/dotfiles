-- Global statusline. < https://www.youtube.com/watch?v=jH5PNvJIa6o >
-- vim.opt.laststatus = 3
-- vim.api.nvim_set_hl(0, "WinSeparator", { bg="NONE" })

local global_statusline = vim.api.nvim_create_augroup("global_statusline", { clear = true })
vim.api.nvim_create_autocmd(
  "VimEnter",
  {
    pattern = "*",
    callback = function ()
      vim.opt.laststatus = 3
      vim.api.nvim_set_hl(0, "WinSeparator", { bg="NONE" })
    end,
    group = global_statusline,
  }
)

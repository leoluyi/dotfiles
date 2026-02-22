-- vim: fdm=marker:fdl=2

local map = require("util").map

local function augroup(name)
  return vim.api.nvim_create_augroup("core_" .. name, { clear = true })
end

-- My Autocmds =================================================================== {{{2

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("EscapeVim"),
  pattern = "*",
  callback = function(event)
    if vim.bo.filetype == "lazy" then
      return
    end
    map({ "i", "x" }, "<C-c>", "<esc>", { buffer = event.buf, silent = true, desc = "Escape" })
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("TrimLastLinesWhitespace"),
  pattern = {
    "*.lua", "*.py", "*.sh", "*.java", "*.go", "*.js", "*.ts", "*.jsx", "*.tsx", "*.c", "*.h", "*.cpp", "*.hpp",
    "*.sql", "*.yaml", "*.yml", "*.toml", "*.json", "*.html", "*.css", "*.scss", "*.xml", "*.php",
    "*.rst", "*.txt", "*.conf", "*.vim", "*.vimrc", "*.lua", "*.zsh", "*.bash", "*.fish",
  },
  callback = function()
    -- Check if lua function is defined: MiniTrailspace.trim
    if type(_G.MiniTrailspace.trim) == "function" then
      MiniTrailspace.trim()
      MiniTrailspace.trim_last_lines()
    end
  end,
})

-- FIX < https://github.com/nvim-telescope/telescope.nvim/issues/2027#issuecomment-1561836585 >
vim.api.nvim_create_autocmd("WinLeave", {
  group = augroup("FixTelescopeOpenFileInInsertMode"),
  callback = function()
    if vim.bo.ft == "TelescopePrompt" and vim.fn.mode() == "i" then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "i", false)
    end
  end,
})

-- FIX weird inverted column color < https://github.com/lifepillar/vim-gruvbox8/issues/43 >
vim.api.nvim_create_autocmd("ColorScheme", {
  group = augroup("FixGruvbox8"),
  pattern = { "gruvbox8" },
  callback = function()
    vim.cmd([[
    hi DiffAdd cterm=NONE gui=NONE
    hi DiffChange cterm=NONE gui=NONE
    hi DiffDelete cterm=NONE gui=NONE
    hi DiffChangeDelete cterm=NONE gui=NONE
    hi SignColumn ctermbg=NONE guibg=NONE
    ]])
  end,
})

-- Miscellaneous ================================================================= {{{2

-- Reload file if changed on disk.
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  group = augroup("AutoCheckTime"),
  callback = function()
    vim.cmd("silent! checktime")
  end,
})

-- Restore cursor to last known position when opening a buffer.
-- < https://github.com/neovim/neovim/issues/16339#issuecomment-1457394370 >
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("RestoreCursorPosition"),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Automatic toggling between absolute and relative line number modes.
-- < https://jeffkreeftmeijer.com/vim-number/ >
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave" }, {
  group = augroup("NumberToggle"),
  callback = function()
    if vim.wo.number and vim.fn.mode() ~= "i" then
      vim.wo.relativenumber = true
    end
  end,
})
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter" }, {
  group = augroup("NumberToggle"),
  callback = function()
    if vim.wo.number then
      vim.wo.relativenumber = false
    end
  end,
})

-- Make sure <CR> is not overridden in the quickfix window.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("FixKeyCr"),
  pattern = "qf",
  callback = function(ev)
    vim.keymap.set("n", "<CR>", "<CR>", { buffer = ev.buf, noremap = true })
  end,
})

-- < https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua > {{{2
-- < https://www.lazyvim.org/configuration/general#auto-commands >

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_zz"),
  pattern = {
    "neo-tree",
  },
  callback = function(event)
    -- not to list neo-tree in buflist.
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "ZZ", "<cmd>qa<cr>", { noremap = true, buffer = event.buf, silent = true })
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
  },
  callback = function(event)
    -- not to list the above file types in buflist.
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Global statusline. < https://www.youtube.com/watch?v=jH5PNvJIa6o >
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("global_statusline", { clear = true }),
  pattern = "*",
  callback = function()
    vim.opt.laststatus = 3
    vim.api.nvim_set_hl(0, "WinSeparator", { bg = "NONE" })
  end,
})

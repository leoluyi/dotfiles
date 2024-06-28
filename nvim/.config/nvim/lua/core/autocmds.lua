-- vim: fdm=marker:fdl=2

local nvim_create_augroups  = require("helpers.util").nvim_create_augroups
local map  = require("helpers.util").map

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

-- < https://github.com/norcalli/nvim_utils > ====================================={{{2

-- Usage:
--
-- local autocmds = {
--     open_folds = {
--         {"BufReadPost,FileReadPost", "*", "normal zR"}
--     }
-- }

local autocmds = {
  AutoCheckTime = {
    { "FocusGained,BufEnter", "*", "silent! checktime" }
  },
  RestoreCursorPosition = {
    -- < https://github.com/neovim/neovim/issues/16339#issuecomment-1457394370 >
    { "BufReadPost", "*", [[if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif]] }
  },
  NumberToggle = {
    --  Automatic toggling between line number modes
    --  < https://jeffkreeftmeijer.com/vim-number/ >
    --  < https://github.com/jeffkreeftmeijer/vim-numbertoggle >
    { "BufEnter,FocusGained,InsertLeave", "*", "if &nu && mode() != 'i' | set rnu   | endif" },
    { "BufLeave,FocusLost,InsertEnter"  , "*", "if &nu                  | set nornu | endif" },
  },
  FoldColumnToggle = {
    { "BufEnter, FocusGained,InsertLeave", "*", "if &fcl && mode() != 'i' | set fcl   | endif" },
    { "BufLeave, FocusLost,InsertEnter"  , "*", "if &fcl                  | set nofcl | endif" },
  },
  FixKeyCr = {
    -- " Make sure that enter is never overriden in the quickfix window
    { "BufReadPost", "quickfix", "nnoremap <buffer> <CR> <CR>" }
  },
}

nvim_create_augroups(autocmds)

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

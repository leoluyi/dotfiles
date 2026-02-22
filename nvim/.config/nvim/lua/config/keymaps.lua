-- vim: fdm=marker:fdl=2
-- < https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua >

local map = require("util").map

-- General ========================================================================{{{2

-- Excape vim (use autocmds instead to exclude certain filetypes.)
-- map({ "i", "x" }, "<C-c>", "<esc>", { desc = "Escape" })

-- Switch between buffers.
map({ "n", "x" }, "<leader><tab>", "<c-^>", { desc = "Alternate buffer" })
map({ "n", "x" }, "<c-6>", "<c-^>", { desc = "Alternate buffer" })

-- Quit all.
map({ "n", "x" }, "<leader>qq", ":qa!", { desc = "Quit all", silent = false })
map({ "n", "x" }, "<leader>ww", ":wa", { desc = "Save all", silent = false })

-- Allow gf to open non-existent file.
map({ "n", "x" }, "gf", "<cmd>e <cfile><cr>", { desc = "Open file" })

-- New buffer.
map({ "n", "x" }, "<leader>bn", "<cmd>enew<cr>", { desc = "New buffer" })

-- Add new file in the directory of the open file.
map({ "n", "x" }, "<leader>A", ":e <C-r>=expand('%:p:h')<cr>/", { desc = "Add new file (sibling)", silent = false })

-- Add new file in the working directory.
map({ "n", "x" }, "<leader>AA", ":e <C-r>=getcwd()<cr>/", { desc = "Add new file (pwd)", silent = false })

-- Change CWD to the directory of the opened buffer.
-- map({ "n", "x" }, "<leader>cd", ":cd %:p:h<cr>:pwd<cr>", { desc = "Change cwd to buffer", silent = false })

-- Keeping it centered.
map("n", "n", "nzzzv", { desc = "Search next" })
map("n", "N", "Nzzzv", { desc = "Search prev" })
map("n", "J", "mzJ`z", { desc = "Join lines" })

-- Toggle number and relativenumber for cursor copy-paste.
map(
  { "n", "x" },
  "<leader>n",
  ":set nonumber nolinebreak norelativenumber<CR>"
    .. ":set nolist<CR>"
    .. ":setlocal foldcolumn=0<CR> :set signcolumn=no<CR> :set statuscolumn=<CR>"
    .. ":silent! IBLDisable<CR>"
    .. ":lua vim.g.miniindentscope_disable = true<CR>",
  { desc = "Toggle on statuscol", silent = true }
)
map(
  { "n", "x" },
  "<leader>N",
  ":set number linebreak relativenumber<CR>"
    .. ":setlocal foldcolumn=auto<CR> :set signcolumn=auto<CR>"
    .. ":set list<CR>"
    .. ":if luaeval('StatusCol')->type() == v:t_func <bar> set statuscolumn=%!v:lua.StatusCol() <bar> else <bar>"
    .. "set statuscolumn& <bar> endif<CR>"
    .. ":silent! IBLEnable<CR>"
    .. ":lua vim.g.miniindentscope_disable = false<CR>",
  { desc = "Toggle off statuscol", silent = true }
)

-- Editing ========================================================================{{{2

-- better up/down.
-- Make <C-u> / <C-d> / <count>j / <count>k added to the jump list mark.
map({ "n", "x" }, "<c-d>", "m'<c-d>", { desc = "Move down", silent = true })
map({ "n", "x" }, "<c-u>", "m'<c-u>", { desc = "Move up", silent = true })
map({ "n", "x" }, "j", "v:count <= 1 ? 'gj' : 'm''' . v:count . 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count <= 1 ? 'gk' : 'm''' . v:count . 'k'", { desc = "Up", expr = true, silent = true })

-- save file
-- map({ "n", "x" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file", silent = false })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Add undo break-points
-- < https://youtu.be/hSHATqh8svM >
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")
map("i", "=", "=<c-g>u")

-- Remap VIM -1 to first non-blank character
map("n", "0", "col('.') == 1 ? '^': '0'", { expr = true, silent = true })

-- Mark current position to 's' before search, so that you can jump back by hitting <'s>
map({ "n", "v" }, "/", "ms/", { desc = "Search", silent = false })
map({ "n", "v" }, "?", "ms?", { desc = "Search", silent = false })

-- Clear search with <esc>
-- map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Move lines using ALT+[jk] or Command+Opt+[jk] on mac
-- < https://youtu.be/QN4fuSsWTbA?t=664 >
-- < https://github.com/matze/vim-move >
map("n", "<M-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<M-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<M-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<M-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<M-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<M-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- """ Insert new line without automatic commenting
map("n", "<localleader>o", "o<Esc>^Da", { desc = "Insert line below no comment" })
map("n", "<localleader>O", "O<Esc>^Da", { desc = "Insert line above no comment" })

-- """ Visually select the text that was last edited/pasted (Vimcast#26).
-- " https://vim.fandom.com/wiki/Selecting_your_pasted_text
map("n", "gV", "`[v`]", { desc = "Select last changed" })

-- Copy and paste stuffs =========================================================={{{2

map(
  "n",
  "<leader>yf",
  '<cmd>let @"=expand("%:t")<cr>:echo "(filename copied) <C-R>=expand("%:t")<cr>"<cr>',
  { desc = "Copy filename", silent = false }
)
map(
  "n",
  "<leader>yc",
  '<cmd>let @+=expand("%:p:h")<cr>:echo "(cwd copied) <C-R>=expand("%:p:h")<CR>"<CR>',
  { desc = "(clipboard) Copy cwd", silent = false }
)
map(
  "n",
  "<leader>yp",
  '<cmd>let @+=expand("%:p")<cr>:echo "(abs-path copied to clipboard) <C-R>=expand("%:p")<CR>"<CR>',
  { desc = "(clipboard) Copy absolute path", silent = false }
)
map(
  "n",
  "<leader>y.",
  '<cmd>let @+=expand("%:p")<cr>:echo "(rel-path copied to clipboard) <C-R>=expand("%:p")<CR>"<CR>',
  { desc = "(clipboard) Copy relative path", silent = false }
)

-- """ Automatically jump to the end of the text you paste.
-- " paste multiple lines of text as many times as I want, just type ppppp.
-- " < https://www.programmersought.com/article/32934915377/ >
-- " < https://zean.be/articles/vim-registers/ >
map("v", "y", "y`]", { desc = "Yank" })
map({ "n", "x" }, "p", "p`]", { desc = "Paste after" })

map("n", "Y", "y$", { desc = "Yank to end of line" })

map({ "n", "x" }, "x", '"_x', { desc = "(black hole) Delete" })
map({ "n", "x" }, "X", '"_X', { desc = "(black hole) Delete" })

-- """ Cut to yanked register
map({ "n", "x" }, "<localleader>C", '"0C', { desc = "(yanked) Cut" })
map({ "n", "x" }, "<localleader>D", '"0D', { desc = "(yanked) Delete to the end" })
map({ "n", "x" }, "<localleader>d", '"0d', { desc = "(yanked) Delete" })
map({ "n", "x" }, "<localleader>dd", '"0dd', { desc = "(yanked) Delete line" })
map({ "n", "x" }, "<localleader>x", '"0x', { desc = "(yanked) Delete" })
map({ "n", "x" }, "<localleader>cc", '"0cc', { desc = "(yanked) Change" })

-- """ Paste from yanked register
map({ "n", "x" }, "<localleader>p", '"0p', { desc = "Paste from yacked register" })
map({ "n", "x" }, "<localleader>P", '"0P', { desc = "Paste from yacked register" })

-- """ Yank to clipboard
map({ "n", "x" }, "<localleader>y", '"+y', { desc = "(clipboard) Yank" })
map({ "n", "x" }, "<localleader>yy", '"+yy', { desc = "(clipboard) Yank line" })
map({ "n", "x" }, "<localleader>Y", '"+y$', { desc = "(clipboard) Yank to the end" })

-- Code editing stuffs ============================================================{{{2

-- Parenthesis/bracket/quotes ====================================================={{{2

map("n", "<localleader>'", "viw<esc>`>a'<esc>mm`<i'<esc>`ml", { desc = "(surround) Single quote" })
map("n", '<localleader>"', 'viw<esc>`>a"<esc>mm`<i"<esc>`ml', { desc = "(surround) Double quote" })
map("n", "<localleader>`", "viw<esc>`>a`<esc>mm`<i`<esc>`ml", { desc = "(surround) Backtick" })
map("n", "<localleader>(", "viw<esc>`>a)<esc>`<i(<esc>%", { desc = "(surround) Parenthesis" })
map("n", "<localleader>)", "viw<esc>`>a)<esc>`<i(<esc>%", { desc = "(surround) Parenthesis" })
map("n", "<localleader>[", "viw<esc>`>a<space>]<esc>`<i[<space><esc>h%", { desc = "(surround) Square bracket" })
map("n", "<localleader>]", "viw<esc>`>a]<esc>`<i[<esc>%", { desc = "(surround) Square bracket" })
map("n", "<localleader>{", "viw<esc>`>a<space>}<esc>`<i{<space><esc>h%", { desc = "(surround) Curly bracket" })
map("n", "<localleader>}", "viw<esc>`>a}<esc>`<i{<esc>%", { desc = "(surround) Curly bracket" })
map("n", "<localleader><", "viw<esc>`>a<space>><esc>`<i<<space><esc>f>", { desc = "(surround) Angle bracket" })
map("n", "<localleader>>", "viw<esc>`>a><esc>`<i<<esc>f>", { desc = "(surround) Angle bracket" })
map("v", "<localleader>'", ":<C-u>norm!`>a'<esc>mm`<i'<esc>`ml", { desc = "(surround) Single quote" })
map("v", '<localleader>"', ':<C-u>norm!`>a"<esc>mm`<i"<esc>`ml', { desc = "(surround) Double quote" })
map("v", "<localleader>`", ":<C-u>norm!`>a`<esc>mm`<i`<esc>`ml", { desc = "(surround) Backtick" })
map("v", "<localleader>(", ":<C-u>norm!`>a)<esc>`<i(<esc>%", { desc = "(surround) Parenthesis" })
map("v", "<localleader>)", ":<C-u>norm!`>a)<esc>`<i(<esc>%", { desc = "(surround) Parenthesis" })
map("v", "<localleader>[", ":<C-u>norm!`>a<space>]<esc>`<i[<space><esc>h%", { desc = "(surround) Square bracket" })
map("v", "<localleader>]", ":<C-u>norm!`>a]<esc>`<i[<esc>%", { desc = "(surround) Square bracket" })
map("v", "<localleader>{", ":<C-u>norm!`>a<space>}<esc>`<i{<space><esc>h%", { desc = "(surround) Curly bracket" })
map("v", "<localleader>}", ":<C-u>norm!`>a}<esc>`<i{<esc>%", { desc = "(surround) Curly bracket" })
map("v", "<localleader><", ":<C-u>norm!`>a<space>><esc>`<i<<space><esc>f>", { desc = "(surround) Angle bracket" })
map("v", "<localleader>>", ":<C-u>norm!`>a><esc>`<i<<esc>f>", { desc = "(surround) Angle bracket" })

-- windows, tabs, buffers ========================================================={{{2

-- Make adjusing split sizes a bit more friendly.
map("n", "<c-s-left>", "<cmd>vertical resize -2<cr>", { desc = "window increase width" })
map("n", "<c-s-right>", "<cmd>vertical resize +2<cr>", { desc = "window decrease width" })
map("n", "<c-s-up>", "<cmd>resize   +2<cr>", { desc = "window increase hight" })
map("n", "<c-s-down>", "<cmd>resize   -2<cr>", { desc = "window decrease hight" })

map("n", "<leader>w<left>", "<cmd>vertical resize -2<cr>", { desc = "window increase width" })
map("n", "<leader>w<right>", "<cmd>vertical resize +2<cr>", { desc = "window decrease width" })
map("n", "<leader>w<up>", "<cmd>resize   +2<cr>", { desc = "window increase hight" })
map("n", "<leader>w<down>", "<cmd>resize   -2<cr>", { desc = "window decrease hight" })

-- Move between windows.
map("n", "<c-h>", "<c-w>h", { desc = "window move left" })
map("n", "<c-l>", "<c-w>l", { desc = "window move right" })
-- map("n", "<c-j>", "<c-w>j", { desc = "Move down" })
-- map("n", "<c-k>", "<c-w>k", { desc = "Move up" })

-- Rotate windows.
map("n", "<leader>wh", "<c-w>t<c-w>H", { desc = "window [H]orizontal rotate" })
map("n", "<leader>wk", "<c-w>t<c-w>K", { desc = "window Vertical rotate" })
map("n", "<leader>ws", "<c-w>r", { desc = "window [S]wap" })

-- Resize windows.
map("n", "<leader>w=", "<c-w>=", { desc = "window even size" })

-- Zoom a window in and out.
map("n", "<leader>zz", "<c-w>_ | <c-w>|", { desc = "Zoom window in" })
map("n", "<leader>zo", "<c-w>=", { desc = "Zoom window out" })

-- Search and replace =========================================================={{{2

-- """ Search and replace in a visual selection.
-- " https://vim.fandom.com/wiki/Search_and_replace_in_a_visual_selection
-- " Search within a visual selection
map("v", "g/", "<esc>/\\%V", { desc = "(selected) Search", silent = false })

-- " Replace (substitute) in a visual selection.
map("v", "<localleader>s", ":s/\\%V", { desc = "(selected) Replace with...", silent = false })

-- " Replace current selection with ...
-- < https://stackoverflow.com/a/676619/3744499 >
map(
  "v",
  "<localleader>S",
  "\"my:%s/\\V<c-r>=escape(@m,'/\\')<cr>/<c-r>=escape(@m,'/\\')<cr>/g<left><left>",
  { desc = "(global) Replace selected with...", silent = false }
)

-- Folding ========================================================================{{{2

map({ "n", "x" }, "z0", ":setlocal foldlevel=0<CR>", { desc = "Fold level 0", silent = false })
map({ "n", "x" }, "z1", ":setlocal foldlevel=1<CR>", { desc = "Fold level 1", silent = false })
map({ "n", "x" }, "z2", ":setlocal foldlevel=2<CR>", { desc = "Fold level 2", silent = false })
map({ "n", "x" }, "z3", ":setlocal foldlevel=3<CR>", { desc = "Fold level 3", silent = false })
map({ "n", "x" }, "z4", ":setlocal foldlevel=4<CR>", { desc = "Fold level 4", silent = false })
map({ "n", "x" }, "z9", ":setlocal foldlevel=999<CR>", { desc = "Fold level ∞", silent = false })

map("i", "<F9>", "<c-o>za", { desc = "Toggle fold" })
map("n", "<F9>", "za", { desc = "Toggle fold" })
map("o", "<F9>", "<c-c>za", { desc = "Toggle fold" })
map("x", "<F9>", "zf", { desc = "Toggle fold" })

function ToggleLineWrap()
  if vim.wo.wrap then
    vim.wo.wrap = false
    vim.wo.linebreak = false
    vim.wo.list = false
  else
    vim.wo.wrap = true
    vim.wo.linebreak = true
    vim.wo.list = true
  end
end

map("n", "<F10>", ToggleLineWrap, { desc = "Toggle line wrap" })
vim.cmd("command! ToggleLineWrap lua ToggleLineWrap()")

-- Misc ==========================================================================={{{2

map("n", "<localleader>n", 'a<c-r>=expand("%:t")<cr><esc>', { desc = "Insert current filename" })
map("n", "<localleader>M", "mmHmt:%s/<C-v><cr>//ge<cr>'tzt'm", { desc = "Remove the Windows ^M", noremap = true }) -- < https://stackoverflow.com/q/71081529/3744499 >
map("n", "<leader>up", "<cmd>setlocal paste!<cr>", { desc = "Toggle [P]aste mode", silent = false })

-- Shell readline-style insert mode bindings (from tpope/vim-rsi) ================={{{2
-- < https://github.com/tpope/vim-rsi/blob/master/plugin/rsi.vim >

map("i", "<C-a>", "<C-o>^", { desc = "Beginning of line" })
map("i", "<C-b>", "<Left>", { desc = "Move left" })
vim.keymap.set("i", "<C-d>", function()
  return vim.fn.col(".") > #vim.fn.getline(".") and "<C-D>" or "<Del>"
end, { expr = true, desc = "Delete char" })
vim.keymap.set("i", "<C-e>", function()
  return (vim.fn.col(".") > #vim.fn.getline(".") or vim.fn.pumvisible() == 1) and "<C-E>" or "<End>"
end, { expr = true, desc = "End of line" })
map("i", "<C-f>", "<Right>", { desc = "Move right" })

-- Bash-like command line bindings
map("c", "<C-a>", "<Home>", { desc = "Beginning of line" })
map("c", "<C-e>", "<End>", { desc = "End of line" })
map("c", "<C-p>", "<Up>", { desc = "Previous history" })
map("c", "<C-n>", "<Down>", { desc = "Next history" })
map("c", "<C-b>", "<Left>", { desc = "Move left" })
map("c", "<C-f>", "<Right>", { desc = "Move right" })

-- Fix Ctrl+@ in some terminals
vim.keymap.set("i", "<C-@>", "<Esc>", { noremap = true, silent = true, desc = "Escape" })

-- Buffer management =============================================================={{{2

map("n", "<leader>ba", "<cmd>bufdo bd<cr>", { desc = "Close all buffers" })
map("n", "<leader>bd", "<cmd>bd | close<cr>", { desc = "Close buffer and window" })
map("n", "<leader>bc", "<cmd>b#|bd#<cr>", { desc = "Close buffer keep window" })

-- Re-indent entire buffer ========================================================{{{2

vim.api.nvim_create_user_command("ReindentAll", function()
  local view = vim.fn.winsaveview()
  vim.cmd("normal! gg=G")
  vim.fn.winrestview(view)
end, { desc = "Re-indent entire buffer" })

map("n", "<localleader>R", "<cmd>ReindentAll<cr>", { desc = "Re-indent buffer" })

-- AI pipe ========================================================================{{{2

map("n", "<leader>ai", function()
  local line = vim.fn.line(".")
  require("util.llm").query_replace(vim.api.nvim_get_current_buf(), line, line)
end, { desc = "AI: ask (replace line)" })

map("x", "<leader>ai", function()
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")
  require("util.llm").query_replace(vim.api.nvim_get_current_buf(), start_line, end_line)
end, { desc = "AI: ask (replace selection)" })

map("n", "<leader>ac", function()
  local line = vim.fn.line(".")
  require("util.llm").query_replace(vim.api.nvim_get_current_buf(), line, line, { system = require("util.llm").SYSTEM_CODE })
end, { desc = "AI: code only (replace line)" })

map("x", "<leader>ac", function()
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")
  require("util.llm").query_replace(vim.api.nvim_get_current_buf(), start_line, end_line, { system = require("util.llm").SYSTEM_CODE })
end, { desc = "AI: code only (replace selection)" })

-- vim: fdm=marker:fdl=2
-- < https://www.lazyvim.org/configuration/general#options >

local config_home = require("config.rtp").config_home

local opt = vim.opt
local o = vim.o

--- Colors {{{2
-- Set extra options and enable 256 colors palette when running in GUI mode
if vim.fn.has("gui_running") == 1 or vim.env.COLORTERM == "gnome-terminal" then
  opt.termguicolors = true
  opt.t_Co = "256"
  opt.guioptions:remove("T")
  opt.guioptions:remove("e")
  opt.guitablabel = "%M %t"
end

-- Tab, Shift and Indent {{{2

opt.tabstop = 4        -- Show existing tab with 4 spaces width
opt.softtabstop = 0    -- Disable mixed tabs and spaces
opt.shiftwidth = 2     -- When indenting with '>', use 2 spaces width
opt.expandtab = true   -- On pressing tab, insert 4 spaces
opt.smarttab = true    -- Be smart when using tabs ;)
opt.autoindent = true  -- Auto indent
opt.smartindent = true -- Smart indent
opt.nrformats:append({'alpha', 'octal'})  -- Increasing or decreasing alphabets with Ctrl-A and Ctrl-X

-- Mouse {{{2

opt.mouse = {}            -- Disable all mouse stuff

-- Backups - Turn backup off, since most stuff is in SVN, git etc {{{2

opt.hidden = true       -- Hide buffers instead of asking if to save them
opt.history = 500       -- Keep lines of command line history
opt.backup = false      -- No *~ backup files
opt.writebackup = false -- Do not make a backup before overwriting a file
opt.wrapscan = false    -- Do not searche wrap around the end of the file
opt.swapfile = false    -- Do not use a swapfile for the buffer
opt.updatetime = 500    -- Faster completion and avoid issues with coc.nvim

-- Display. {{{2

o.listchars = 'tab:▶ ,nbsp:␣,trail:•,precedes:«,extends:»'
o.fillchars = "foldopen:▾,foldclose:▸,foldsep: "

--- Folding {{{2
-- < https://www.jmaguire.tech/posts/treesitter_folding/ >

if vim.fn.has('nvim-0.10') == 1 then
	opt.smoothscroll = true
	vim.opt.foldmethod = 'expr'
	vim.opt.foldtext = ''
else
	vim.opt.foldmethod = 'indent'
end

opt.foldlevel = 999              -- Expand all fold levels
opt.foldnestmax = 3              -- Sets the maximum nesting of folds
opt.foldenable  = true           -- Code folding
opt.foldcolumn = "auto"          -- Add a bit extra margin to the left

-- Editing {{{2
opt.formatoptions = "jcroqlnt"   -- jcroql
opt.formatoptions:remove("t")    -- When textwidth is set, keeps the visual textwidth but doesn't add new line in insert mode
-- o.formatoptions = o.formatoptions:gsub("[cro]", "") -- Disables automatic commenting on newline. https://stackoverflow.com/q/2280030/3744499

-- Searching {{{2
opt.ignorecase = true            -- Ignore case when searching
opt.smartcase = true             -- When searching try to be smart about cases
opt.hlsearch = true              -- Highlight search results
opt.incsearch = true             -- Makes search act like search in modern browsers
opt.magic = true                 -- For regular expressions turn magic on
opt.showmatch = true             -- Show matching brackets when text indicator is over them
opt.mat = 2                      -- How many tenths of a second to blink when matching brackets

-- Display & Word Wrap {{{2

opt.wrap = false
opt.cursorline = true
opt.number = true                 -- Show line number
opt.relativenumber = true         -- Show relative line number
opt.ruler = true                  -- Always show current position
opt.colorcolumn = "88"            -- Display a ruler at a specific column
opt.list = true                   -- Display whitespace
opt.cmdheight = 1                 -- Height of the command bar
opt.display:append("lastline")    -- When wrap is on, display last line even if it doesn't fit
opt.textwidth = 9999              -- Never wrap lines
opt.linebreak = true              -- Make Vim break lines without breaking words

-- Encoding {{{2
opt.encoding = "utf-8"                   -- Used internally, always utf-8
opt.fileencodings = { "utf-8" }               -- File-content encoding for the current buffer
opt.fileformats = { "unix","dos","mac" } -- Use Unix as the standard file type
opt.ttyfast = true                       -- Faster redraw speed in terminals

if vim.fn.has("multi_byte") == 1 then
  -- Multi-byte support is available
  o.fileencodings = "utf-8,utf-16,cp950,big5,gb2312,gbk,gb18030,euc-jp,euc-kr,latin1"
else
  -- Multi-byte support is not available
  print("If +multi_byte is not included, you should compile Vim with big features.")
end

-- Avoid garbled characters in Chinese language Windows OS
vim.env.LANG = "en"
opt.langmenu = "en"

-- Turn on the wildmenu {{{2
opt.wildmenu = true

-- Fix backspace indent {{{2
opt.backspace = { "indent", "eol", "start" }
o.whichwrap = o.whichwrap .. "<,>,h,l"

-- Files and Buffers
opt.autoread = true

-- Files and Buffers {{{2
-- Specify the behavior when switching between buffers.
-- Buffers
opt.switchbuf = { "useopen", "usetab", "newtab" }

-- Splits and Tabs {{{2
opt.splitbelow = true
opt.splitright = true

-- Warnings and Errors {{{2
opt.errorbells = false
opt.timeoutlen = 500

-- Set 7 lines to the cursor - when moving vertically using j/k
opt.scroll = 7
opt.scrolloff = 7
opt.sidescrolloff = 8 -- Columns of context

-- Disable scrollbars
-- vim.o.guioptions = vim.o.guioptions:gsub("r", "")
-- vim.o.guioptions = vim.o.guioptions:gsub("R", "")
-- vim.o.guioptions = vim.o.guioptions:gsub("l", "")
-- vim.o.guioptions = vim.o.guioptions:gsub("L", "")

-- Ignore compiled files
o.wildignore = o.wildignore .. "*.o,*.out,*.obj,.git,*.rbc,*.rbo,*.class,.svn,*.gem,*.pyc,*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz,*.jpg,*.jpeg,*.png,*.gif,*.pdf,*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/**,**/tmp/**,*.DS_Store,**/node_modules/**,**/bower_modules/**,*.swp,*~,._*"

if vim.fn.has("win16") == 1 or vim.fn.has("win32") == 1 then
  vim.o.wildignore = vim.o.wildignore .. ",.git\\*,.hg\\*,.svn\\*"
else
  vim.o.wildignore = vim.o.wildignore .. ",*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store"
end

-- Auto-completion {{{2
opt.completeopt = { "noinsert" ,"menuone", "noselect" }
opt.shortmess:append("c")
opt.belloff:append("ctrlg")

-- Statusline & Tabline {{{2
opt.showtabline = 2  -- Always show the tab line

-- Others. {{{2
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.grepprg = "rg --vimgrep"
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.wildmode = "longest:full,full" -- Command-line completion mode
o.shada = o.shada .. ",r/tmp/,r/private/,rfugitive:,rzipfile:,rterm:,rhealth:,rshada:,rjournal:,rjournal"  -- skip common junk in 'shada' oldfiles

if vim.fn.has("nvim-0.9.0") == 1 then
  opt.splitkeep = "screen"
  opt.shortmess:append({ C = true })
end

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

-- Disable OMNI SQL Completion mappings.
vim.g.omni_sql_no_default_maps = true

-- Filetype detection {{{2

vim.filetype.add({
  filename = {
    Brewfile = 'ruby',
    justfile = 'just',
    Justfile = 'just',
    ['.buckconfig'] = 'toml',
    ['.flowconfig'] = 'ini',
    ['.jsbeautifyrc'] = 'json',
    ['.jscsrc'] = 'json',
    ['.watchmanconfig'] = 'json',
    ['todo.txt'] = 'todotxt',
  },
  pattern = {
    ['.*%.js%.map'] = 'json',
    ['.*%.postman_collection'] = 'json',
    ['Jenkinsfile.*'] = 'groovy',
    ['%.config/git/*'] = 'gitconfig',
  },
})

--------------------------------------------------------------------

--  options from table
-- for opt, val in pairs(opt) do
--   vim.o[opt] = val
-- end

-- Ref. ==========================================================================={{{2
-- https://github.com/frans-johansson/lazy-nvim-starter/blob/main/.config/nvim/lua/core/options.lua
-- https://neovim.io/doc/user/lua.html#lua-vimscript
-- https://github.com/rafi/vim-config

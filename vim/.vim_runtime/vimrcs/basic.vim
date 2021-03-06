"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Maintainer:
"       Lu Yi - @leoluyi
"
" Sections:
" => Check pynvim
" => Some basics sets
" => Status line
" => My Shortcut Keys
" => General abbreviations
" => Omni complete functions
" => Custom commands
" => Helper functions
" => References
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Some basics sets
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""" auto source when writing to init.vm alternatively you can run :source $MYVIMRC
autocmd! BufWritePost $MYVIMRC source %
autocmd! BufWritePost ~/.vim_runtime/vimrcs/basic.vim,~/.vimrc.local
      \ source $MYVIMRC
      \ | if exists('*lightline#colorscheme')
      \ | call lightline#colorscheme()
      \ | echo "$MYVIMRC sourced."
      \ | endif

""" Leader key
let mapleader = ","
let maplocalleader = "\<space>"
nnoremap <leader>, ,
nnoremap <localleader><Space> <Space>

set updatetime=500                  " Faster completion and avoid issues with coc.nvim

""" Backups - Turn backup off, since most stuff is in SVN, git etc. anyway...
set hidden                          " Hide buffers instead of asking if to save them
set history=500                     " Keep lines of command line history
set nobackup                        " No *~ backup files
set nowritebackup                   " Do not make a backup before overwriting a file
set nowrapscan                      " Do not searche wrap around the end of the file
set noswapfile                      " Do not use a swapfile for the buffer

""" Terminal colors
if has("termguicolors")
  if !has('nvim')
    " fix bug for vim
    set t_8f=[38;2;%lu;%lu;%lum
    set t_8b=[48;2;%lu;%lu;%lum
  endif

  " enable true color
  set termguicolors
endif

""" Colors
set background=dark

if $COLORTERM == 'gnome-terminal'
  set t_Co=256                " Enable 256 colors palette in Gnome Terminal
endif

" Enable default theme if some other is not set
if !exists("g:colors_name")
  colorscheme default
endif

try
  colorscheme gruvbox
catch
endtry


if has("gui_running")
  " Set extra options when running in GUI mode
  set guioptions-=T
  set guioptions-=e
  set t_Co=256
  set guitablabel=%M\ %t
endif

if has('nvim')
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1   " Enable true color
endif

""" Editing - Text, tab and indent related
" set clipboard=unnamedplus         " Yank to the system register (*) by default
set tabstop=4                       " Show existing tab with 4 spaces width
set softtabstop=0                   " Disable mixed tabs and spaces
set shiftwidth=2                    " When indenting with '>', use 2 spaces width
set expandtab                       " On pressing tab, insert 4 spaces
set nrformats+=alpha                " Increasing or decreasing alphabets with Ctrl-A and Ctrl-X
set smarttab " Be smart when using tabs ;)

set autoindent                      " Auto indent
set smartindent                     " Smart indent

""" Word Wrap
set linebreak                       " Make Vim break lines without breaking words
set wrap                            " Wrap lines
set formatoptions-=t                " When textwidth is set, keeps the visual textwidth but doesn't add new line in insert mode
" autocmd FileType * setlocal formatoptions-=cro  " Disables automatic commenting on newline. https://stackoverflow.com/q/2280030/3744499

""" Delete comment character when joining commented lines
if v:version > 703 || v:version == 703 && has("patch541")
  set formatoptions+=j
endif

""" Searching
set ignorecase                      " Ignore case when searching
set smartcase                       " When searching try to be smart about cases
set hlsearch                        " Highlight search results
set incsearch                       " Makes search act like search in modern browsers
set lazyredraw                      " Don't redraw while executing macros (good performance config)
set magic                           " For regular expressions turn magic on
set showmatch                       " Show matching brackets when text indicator is over them
set mat=2                           " How many tenths of a second to blink when matching brackets

" """ yank to clipboard
" " https://stackoverflow.com/a/3961954
" " https://www.markcampbell.me/2016/04/12/setting-up-yank-to-clipboard-on-a-mac-with-vim.html
" if has("clipboard")
"   set clipboard=unnamed " copy to the system clipboard

"   if has("unnamedplus") " X11 support
"     set clipboard+=unnamedplus
"   endif
" endif

""" Folding
set foldlevel=999                   " Expand all fold levels
set foldnestmax=3                   " Sets the maximum nesting of folds
set foldmethod=syntax               " The kind of folding
set foldenable                      " Code folding
set foldcolumn=1                    " Add a bit extra margin to the left

""" Display
set number relativenumber
set ruler                           " Always show current position
set colorcolumn=80                  " Display a ruler at a specific line
set cursorline
set fillchars+=vert:│               " Split separator
set listchars=tab:→\ ,eol:↲,space:·,nbsp:␣,trail:•,precedes:«,extends:»  " Set default whitespace characters when using `:set list`
set cmdheight=1                     " Height of the command bar
set display+=lastline               " When 'wrap' is on, display last line even if it doesn't fit.
set textwidth=500                   " A longer line will be broken after white space to get this width
" set colorcolumn=+1  " highlight column after 'textwidth'
" let &colorcolumn=join(range(81,999),",")  " set colorcolumn for the whole screen after 81
" highlight ColorColumn ctermbg=235 guibg=#2c2d27

""" Encoding
set encoding=utf-8                  " Used internally, always utf-8
set fileencoding=utf-8              " File-content encoding for the current buffle
set fileformats=unix,dos,mac        " Use Unix as the standard file type
set ttyfast

" Avoid garbled characters in Chinese language windows OS
let $LANG='en'
set langmenu=en

try
  source $VIMRUNTIME/delmenu.vim
  source $VIMRUNTIME/menu.vim
catch
endtry

if has("multi_byte")
  " A list of character encodings considered when starting to edit an existing file
  set fileencodings=utf-8,utf-16,cp950,big5,gb2312,gbk,gb18030,euc-jp,euc-kr,latin1
else
  echoerr "If +multi_byte is not included, you should compile Vim with big features."
endif

""" Turn on the Wild menu
set wildmenu

""" Number formats
set nrformats-=octal

""" Fix backspace indent
set backspace=indent,eol,start
set whichwrap+=<,>,h,l

""" Files and Buffers
syntax on                           " Enable syntax highlighting
filetype plugin indent on           " Enable filetype plugins

" Set to auto read when a file is changed from the outside
set autoread
au FocusGained,BufEnter * silent! checktime

" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

""" Splits and Tabs
set splitbelow splitright             " Splits open at the bottom and right, which is non-retarded, unlike vim defaults.

""" Warnings
set noerrorbells                      " No annoying sound on errors
set tm=500
" set t_vb=                             " No beep or flash
" set novisualbell                      " No visual bell

if has("gui_macvim")
  " Properly disable sound on errors on MacVim
  autocmd GUIEnter * set vb t_vb=
endif

""" Turn persistent undo on.
"   means that you can undo even when you close a buffer/VIM.
try
    set undodir=~/.vim_runtime/temp_dirs/undodir
    set undofile
catch
endtry

" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

""" Disable scrollbars (real hackers don't use scrollbars for navigation!)
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L

""" Ignore compiled files
" Disable output, vcs, archive, rails, temp and backup files.
set wildignore+=*.o,*.out,*.obj,.git,*.rbc,*.rbo,*.class,.svn,*.gem
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz
set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/*
set wildignore+=*.swp,*~,._*
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
  set wildignore+=.git\*,.hg\*,.svn\*
else
  set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

""" Fix mouse issue using Alacritty terminal
" set ttymouse=sgr

"----------------------------
" -> Misc
"----------------------------
""" Automatic toggling between line number modes
" https://jeffkreeftmeijer.com/vim-number/
" https://github.com/jeffkreeftmeijer/vim-numbertoggle
augroup numbertoggle
  autocmd!
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu | set norelativenumber | endif
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu | set relativenumber   | endif
augroup END

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Status line
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

" Format the status line
" set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c

" https://shapeshed.com/vim-statuslines/

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => My Shortcut Keys
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"----------------------------
" -> General
"----------------------------

""" Escape
inoremap <C-c> <Esc>

""" Better tabbing
vnoremap < <gv
vnoremap > >gv

""" Alternate way to save
nmap <leader>w :w!<cr>
nnoremap <C-s> :w<CR>
" :W sudo saves the file
" (useful for handling the permission-denied error)
" trick does not work on neovim (https://github.com/neovim/neovim/issues/1716)
if !has('nvim')
  command! W execute 'w !sudo tee % > /dev/null' <bar> edit!
endif

""" Add new file in the directory of the open file
nmap <leader>a :e <C-r>=expand("%:p:h")<CR>/
""" Add new file in the working directory
nmap <leader>A :e <C-r>=getcwd()<CR>/

""" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

""" Quit all withou savings
nmap <leader>qq :qa!

""" Allow for easy copying and pasting
vnoremap <silent> y y`]
nnoremap <silent> p p`]

""" Make sure pasting in visual mode doesn't replace paste buffer
function! RestoreRegister()
  let @" = s:restore_reg
  return ''
endfunction
function! s:Repl()
  let s:restore_reg = @"
  return "p@=RestoreRegister()\<cr>"
endfunction
vmap <silent> <expr> p <sid>Repl()

""" Auto center on matched string.
noremap n nzz
noremap N Nzz

"----------------------------
" -> Editing mappings
"----------------------------

" Remap VIM 0 to first non-blank character
map 0 ^
noremap <leader>0 0

" Move a line of text using ALT+[jk] or Command+[jk] on mac
" https://youtu.be/QN4fuSsWTbA?t=664
nnoremap <M-j> mz:m+<cr>`z
nnoremap <M-k> mz:m-2<cr>`z
vnoremap <M-j> :m'>+<cr>`<my`>mzgv`yo`z=gv
vnoremap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z=gv

if has("mac") || has("macunix")
  nmap <D-j> <M-j>
  nmap <D-k> <M-k>
  vmap <D-j> <M-j>
  vmap <D-k> <M-k>
endif

""" Fast editing and reloading of vimrc configs.
map <leader>e :e! ~/.vimrc.local<cr>
nnoremap <leader>rc :source $MYVIMRC<CR>

""" Mark current position to 's' before search, so that you can jump back by hitting <'s>
nnoremap / ms/
nnoremap ? ms?

""" Clear highlight search
nnoremap <Esc><Esc> :<C-u>nohlsearch<CR>
" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

""" Insert new line without automatic commenting
nnoremap <localleader>o o<Esc>^Da
nnoremap <localleader>O O<Esc>^Da

""" Visually select the text that was last edited/pasted (Vimcast#26).
" https://vim.fandom.com/wiki/Selecting_your_pasted_text
noremap gV `[v`]

""" Quickfix
" open quickfix window
nnoremap <leader>co :botright copen<cr>
" close quickfix window
nnoremap <leader>cc :cclose<cr>
" open quickfix window if exists
nnoremap <leader>cw :cw 10<cr>
" next error
nnoremap <leader>cn :cnext<cr>
nnoremap <localleader>] :cnext<CR>
" previous error
nnoremap <leader>cp :cprevious<cr>
nnoremap <localleader>[ :cprevious<CR>
" list all errors
nnoremap <leader>cl :cl<cr>

""" Expand %% to file name of current buffer in command mode.
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:t') : '%%'
""" Expand $$ to path of current buffer in command mode.
cnoremap <expr> $$ getcmdtype() == ':' ? expand('%:h').'/' : '$$'

"----------------------------
" -> Moving around, tabs, windows and buffers
"----------------------------

""" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
map <leader>t<leader> :tabnext

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <C-r>=expand("%:p:h")<cr>/

" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

""" Splits and tabbed files
" Make adjusting split sizes a bit more friendly
noremap <silent> <C-Left> :vert resize +3<CR>
noremap <silent> <C-Right> :vert resize -3<CR>
noremap <silent> <C-Up> :resize +3<CR>
noremap <silent> <C-Down> :resize -3<CR>

""" Rotate between vert and horiz windows
map <leader>th <C-w>t<C-w>H
map <leader>tk <C-w>t<C-w>K

""" Zoom a window in and out
noremap Zz <c-w>_ \| <c-w>\|
noremap Zo <c-w>=

""" TAB in general mode will move to text buffer
nnoremap <M-TAB> :bnext<CR>
vnoremap <M-TAB> :<C-u>bnext<CR>
""" SHIFT-TAB will go back
nnoremap <S-TAB> :bprevious<CR>
vnoremap <S-TAB> :<C-u>bprevious<CR>

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Close all the buffers
map <leader>ba :bufdo bd<cr>

""" Close a buffer without closing the window?
" https://stackoverflow.com/a/19619038/3744499
" (Close the current buffer and move to the alternative one)
autocmd VimEnter *
  \ if exists(':Bclose')
  \ | execute "nnoremap <leader>bd :Bclose<CR>"
  \ | else
  \ | execute "nnoremap <leader>bd :b#<bar>bd#<CR>"
  \ | endif

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

"----------------------------
" -> Splits and Tabbed Files
"----------------------------
""" Better window navigation
nnoremap <silent> <C-h> :wincmd h<CR>
nnoremap <silent> <C-j> :wincmd j<CR>
nnoremap <silent> <C-k> :wincmd k<CR>
nnoremap <silent> <C-l> :wincmd l<CR>

""" Make adjusing split sizes a bit more friendly
noremap <silent> <C-S-Left> :vertical resize -3<CR>
noremap <silent> <C-S-Right> :vertical resize +3<CR>
noremap <silent> <C-S-Up> :resize +3<CR>
noremap <silent> <C-S-Down> :resize -3<CR>
nnoremap <silent> <leader>rp :resize 100<CR>

""" Change 2 split windows from vert to horiz or horiz to vert
map <Leader>th <C-w>t<C-w>H
map <Leader>tk <C-w>t<C-w>K

"----------------------------
" -> Visual mode related
"----------------------------
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

"----------------------------
" -> Code editing stuffs
"----------------------------

""" <F5> -  Remove all trailing whitespace. https://vim.fandom.com/wiki/Remove_unwanted_spaces
" nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>:echo 'Remove trailing whitespace'<CR>

""" <F6> -  Absolute numbers
map <F6> :set relativenumber!<CR>

""" Search and replace selected text.
" https://stackoverflow.com/a/676619
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

""" Re-indent current buffer
function! ReindentAll()
  let l:save = winsaveview()
  execute 'normal gg=G'
  call winrestview(l:save)
endfunction

command! ReindentAll :call ReindentAll()
nmap <leader>R :<C-u>ReindentAll<CR>

""" :W   -  Force write. Allow saving of files as sudo
if !has('nvim')
  command! W w !sudo tee % > /dev/null
else
  command! W w suda://%  " lambdalisue/suda.vim
endif

""" Toggle number and relativenumber for cursor copy-paste
"nnoremap <leader>n :set number! relativenumber!<CR> :FoldColumnToggle<CR> :IndentLinesToggle<CR> :ALEToggleBuffer<CR> :GitGutterToggle<CR>
nnoremap <silent> <leader>n :set nonumber nolinebreak norelativenumber<CR> :setlocal foldcolumn=0<CR> :IndentLinesDisable<CR> :ALEDisableBuffer<CR> :GitGutterDisable<CR>
vnoremap <silent> <leader>n :set nonumber nolinebreak norelativenumber<CR> :setlocal foldcolumn=0<CR> :IndentLinesDisable<CR> :ALEDisableBuffer<CR> :GitGutterDisable<CR>
nnoremap <silent> <leader>N :set number linebreak relativenumber<CR> :setlocal foldcolumn=1<CR> :IndentLinesEnable<CR> :ALEEnableBuffer<CR> :GitGutterEnable<CR>
vnoremap <silent> <leader>N :set number linebreak relativenumber<CR> :setlocal foldcolumn=1<CR> :IndentLinesEnable<CR> :ALEEnableBuffer<CR> :GitGutterEnable<CR>

"----------------------------
" -> Parenthesis/bracket
"----------------------------
inoremap $) ()<esc>i
inoremap $] []<esc>i
inoremap $} {}<esc>i
inoremap $4 {<esc>o}<esc>O<space><space>
inoremap $' ''<esc>i
inoremap $" ""<esc>i
nnoremap <localleader>' viw<esc>`>a'<esc>`<i'<esc>
nnoremap <localleader>" viw<esc>`>a"<esc>`<i"<esc>

"----------------------------
" -> Copy and paste stuffs
"----------------------------
" https://zean.be/articles/vim-registers/
" map paste, yank and delete to named register so the content
" will not be overwritten (I know I should just remember...)

" `_` register, the black hole
nnoremap x "_x
vnoremap x "_x

""" Cut to yanked register
nnoremap <localleader>C "0C
vnoremap <localleader>C "0C
nnoremap <localleader>D "0D
nnoremap <localleader>S "0S
nnoremap <localleader>d "0d
vnoremap <localleader>d "0d
nnoremap <localleader>dd "0dd
nnoremap <localleader>x "0x
vnoremap <localleader>x "0x
nnoremap cc "0cc
vnoremap cc "0cc

""" Paste from yanked register
nnoremap <localleader>P "0P
nnoremap <localleader>p "0p
vnoremap <localleader>P "0P
vnoremap <localleader>p "0p

""" Yank to clipboard
nnoremap <localleader>Y  "+y$
nnoremap <localleader>y  "+y
nnoremap <localleader>yy "+yy
vnoremap <localleader>Y  "+y$
vnoremap <localleader>y  "+y
vnoremap <localleader>yy "+yy

"--------------------------
" -> Map normal mode commands to insert mode
"--------------------------
" Delete to the end of line
imap <C-k> <C-o>D

"--------------------------
" -> Command mode related
"--------------------------

" Smart mappings on the command line
cno $h e ~/
cno $d e ~/Desktop/
cno $j e ./
cno $c e <C-\>eCurrentFileDir("e")<cr>

" $q is super useful when browsing on the command line
" it deletes everything until the last slash
cno $q <C-\>eDeleteTillSlash()<cr>

" Bash like keys for the command line
cnoremap <C-A>		<Home>
cnoremap <C-E>		<End>
cnoremap <C-K>		<C-U>

cnoremap <C-P> <Up>
cnoremap <C-N> <Down>

" Map ½ to something useful
map ½ $
cmap ½ $
imap ½ $

"--------------------------
" -> Spell checking
"--------------------------
" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=

"--------------------------
" -> Misc mappings
"--------------------------

" Remove the Windows ^M - when the encodings gets messed up
noremap <leader>mm mmHmt:%s/<C-v><CR>//ge<CR>'tzt'm

""" Spellcheck
nnoremap <leader>sc setlocal spell!

""" Show marks list and goto
nnoremap <leader>gm :<C-u>marks<CR>:normal! `

""" Copy the entire content to new buffer.
map <leader>cop ggVGy:tabnew<cr>:set syntax=qf<cr>pgg

" Quickly open a buffer for scribble
map <leader>ob :e /tmp/buffer<cr>

" Quickly open a markdown buffer for scribble
map <leader>om :e /tmp/buffer.md<cr>

" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>

"--------------------------
" -> Fix unwanted key map
"--------------------------

" Make sure that enter is never overriden in the quickfix window
autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>

try
  " unmap <C-Space>
  " unmap <leader>f
  inoremap <C-@> <Esc>
  unmap <leader>q
catch
endtry

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General abbreviations
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
iabbrev xdate <C-r>=strftime("%Y-%m-%d %H:%M:%S")<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Omni complete functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd FileType css set omnifunc=csscomplete#CompleteCSS

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Custom commands
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

command! -range Reverse <line1>,<line2>call Reverse()
command! -nargs=0 FoldColumnToggle :call FoldColumnToggle()
command! -nargs=1 -complete=file -bang Rename :call Rename("<args>", "<bang>")
command! -nargs=1 Highlight :call Highlight(<q-args>)
command! -nargs=0 HighlightClear :call Highlight('')
command! WhitespaceTrailingRemove :call WhitespaceTrailingRemove()
command! TrimWhitespace :call TrimWhitespace()
command! EmptyRegisters :call EmptyRegisters()
command! ColorToggle call ColorToggle()
command! ToggleTransparentBackground call ToggleTransparent()
nnoremap <leader>tb :ToggleTransparentBackground<CR>

" Delete trailing white space on save, useful for some filetypes ;)
if has("autocmd") && exists('#WhitespaceTrailingRemove')
  autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call WhitespaceTrailingRemove()
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"--------------------------
" Toggle transparent background
"--------------------------
" https://jnrowe.github.io/articles/tips/Toggling_settings_in_vim.html
" https://stackoverflow.com/a/37720708/3744499
let g:is_transparent = 0
function! ToggleTransparent()
  if g:is_transparent == 0
    hi Normal ctermbg=NONE guibg=NONE
    let g:is_transparent = 1
  else
    hi Normal ctermbg=235 guibg=#282828
    set background=dark
    let l:scheme = 'gruvbox'
    exe "silent! colorscheme " . l:scheme
    exe "silent! LightlineColorscheme " . l:scheme
    let g:is_transparent = 0
  endif
endfunction

"--------------------------
" Toggle colorscheme
"--------------------------
function! ColorToggle()
  if &background ==? 'dark'
    set background=light
    let l:scheme = 'gruvbox'
    exe "silent! colorscheme " . l:scheme
    exe "silent! LightlineColorscheme " . l:scheme
  else
    set background=dark
    let l:scheme = 'gruvbox'
    exe "silent! colorscheme " . l:scheme
    exe "silent! LightlineColorscheme " . "gruvbox_material"
  endif
endfunction

"--------------------------
" FoldColumnToggle
"--------------------------
function! FoldColumnToggle()
  " https://www.kawabangga.com/posts/1990
  if &foldcolumn
    setlocal foldcolumn=0
  else
    setlocal foldcolumn=1
  endif
endfunction

" https://stackoverflow.com/a/51146449
" a highlight color must be set up for the function to work
function! Highlight(text)
  :execute "match IncSearch /" . a:text . "/"
endfunction

"--------------------------
" Rename3
"--------------------------
" Rename3.vim  -  Rename a buffer within Vim and on disk.
"
" https://github.com/aehlke/vim-rename3/blob/master/rename3.vim
"
" Copyright July 2013 by Alex Ehlke <alex.ehlke at gmail.com>
"
" based on Rename2.vim (which couldn't handle spaces in paths)
" Copyright July 2009 by Manni Heumann <vim at lxxi.org>
"
" which is based on Rename.vim
" Copyright June 2007 by Christian J. Robinson <infynity@onewest.net>
"
" Distributed under the terms of the Vim license.  See ":help license".
"
" Usage:
"
" :Rename[!] {newname}

function! Rename(name, bang)
  let l:curfile = expand("%:p")
  let l:curfilepath = expand("%:p:h")
  let l:newname = l:curfilepath . "/" . a:name
  let v:errmsg = ""
  silent! exec "saveas" . a:bang . " " . fnameescape(l:newname)
  if v:errmsg =~# '^$\|^E329'
    if expand("%:p") !=# l:curfile && filewritable(expand("%:p"))
      silent exec "bwipe! " . fnameescape(l:curfile)
      if delete(l:curfile)
        echoerr "Could not delete " . l:curfile
      endif
    endif
  else
    echoerr v:errmsg
  endif
endfunction

"--------------------------
" TrimWhitespace
"--------------------------
function! TrimWhitespace()
  let l:save = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:save)
endfun

fun! WhitespaceTrailingRemove()
  let save_cursor = getpos(".")
  let old_query = getreg('/')
  silent! %s/\s\+$//e
  call setpos('.', save_cursor)
  call setreg('/', old_query)
endfun

"--------------------------
" EmptyRegisters
"--------------------------
function! EmptyRegisters()
  let regs=split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '\zs')
  for r in regs
    call setreg(r, [])
  endfor
endfun

"--------------------------
" DeleteTillSlash
"--------------------------
func! DeleteTillSlash()
    let g:cmd = getcmdline()

    if has("win16") || has("win32")
        let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\]\\).*", "\\1", "")
    else
        let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*", "\\1", "")
    endif

    if g:cmd == g:cmd_edited
        if has("win16") || has("win32")
            let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\\]\\).*\[\\\\\]", "\\1", "")
        else
            let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*/", "\\1", "")
        endif
    endif

    return g:cmd_edited
endfunc

func! CurrentFileDir(cmd)
    return a:cmd . " " . expand("%:p:h") . "/"
endfunc

"--------------------------
" VisualSelection
"--------------------------
function! CmdLine(str)
    call feedkeys(":" . a:str)
endfunction

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

"--------------------------
" for statusbar
"--------------------------
" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction


"--------------------------
" Reverse selected range
"--------------------------
function! Reverse() range
  let l:search = @/
  call feedkeys(":" . a:firstline . "," . a:lastline . "g/^/m " . (a:firstline-1) . "|nohl" . "\<CR>")
  let @/ = l:search
endfunction
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => References
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" https://hackmd.io/@AlexSu/ryLuYmwYm?type=view

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Check pynvim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if has("nvim") && !has("python3")
  echo "[python3] Installing pynvim (required for ncm2) ...\n"
  silent !python3 -m pip --disable-pip-version-check -q install --no-cache-dir --user -U pynvim
endif

" See :help g:python3_host_prog
" See https://github.com/deoplete-plugins/deoplete-jedi/wiki/Setting-up-Python-for-Neovim#using-virtual-environments
" If you plan to use per-project virtualenvs often, you should assign one
"  virtualenv for Neovim and hard-code the interpreter path via
"  g:python3_host_prog (or g:python_host_prog) so that the "pynvim" package
"  is not required for each virtualenv.
" 
"  Example using pyenv:
"    ¦ pyenv install 3.4.4
"    ¦ pyenv virtualenv 3.4.4 py3nvim
"    ¦ pyenv activate py3nvim
"    ¦ pip install pynvim
"    ¦ pyenv which python  # Note the path
"  The last command reports the interpreter path, add it to your init.vim:
"    ¦ let g:python3_host_prog = '/path/to/py3nvim/bin/python'
let s:user_home = expand('~/')
let g:python3_host_prog = s:user_home . '.pyenv/versions/py3nvim/bin/python'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Some basics
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let mapleader = ","
let maplocalleader = "\\"
nnoremap <leader>, ,

set updatetime=500                    " Faster completion

""" Backups
set hidden                            " Opening a new file when the current buffer has unsaved changes causes files to be hidden instead of closed
set history=50                        " Keep 50 lines of command line history
set nobackup                          " No *~ backup files
set nowritebackup                     " Do not make a backup before overwriting a file
set nowrapscan                        " Do not searche wrap around the end of the file
set noswapfile                        " Do not use a swapfile for the buffer

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
try
  colorscheme gruvbox
catch
endtry
set background=dark

""" Editing
" set clipboard=unnamedplus           " Yank to the system register (*) by default
set tabstop=4                         " Show existing tab with 4 spaces width
set softtabstop=0                     " Disable mixed tabs and spaces
set shiftwidth=2                      " When indenting with '>', use 2 spaces width
set expandtab                         " On pressing tab, insert 4 spaces
set nrformats+=alpha                  " Increasing or decreasing alphabets with Ctrl-A and Ctrl-X

" " yank to clipboard
" " https://stackoverflow.com/a/3961954
" " https://www.markcampbell.me/2016/04/12/setting-up-yank-to-clipboard-on-a-mac-with-vim.html
" if has("clipboard")
"   set clipboard=unnamed " copy to the system clipboard

"   if has("unnamedplus") " X11 support
"     set clipboard+=unnamedplus
"   endif
" endif

""" Folding
set foldlevel=999                     " Expand all fold levels
set foldnestmax=3                     " Sets the maximum nesting of folds
set foldmethod=syntax                 " The kind of folding
set foldenable                        " Code folding
set foldcolumn=1                      " Add a bit extra margin to the left

""" Display
set number relativenumber
set colorcolumn=80                    " Display a ruler at a specific line
set cursorline
set fillchars+=vert:│                 " Split separator
set listchars=tab:→\ ,eol:↲,space:·,nbsp:␣,trail:•,precedes:«,extends:»
" set textwidth=80
" set colorcolumn=+1  " highlight column after 'textwidth'
" let &colorcolumn=join(range(81,999),",")  " set colorcolumn for the whole screen after 81
" highlight ColorColumn ctermbg=235 guibg=#2c2d27

""" Encoding
set encoding=utf-8                    " Used internally, always utf-8
set fileencoding=utf-8                " File-content encoding for the current buffle
set fileencodings=utf-8,cp950         " A list of character encodings considered when starting to edit an existing file
set fileformats=unix,dos,mac
set ttyfast

""" Number formats
set nrformats-=octal

""" Fix backspace indent
set backspace=indent,eol,start

""" Files
syntax on
filetype plugin indent on

""" Word Wrap
set linebreak                         " Make Vim break lines without breaking words
set wrap                              " Line wrapping
set formatoptions-=t                  " When textwidth is set, keeps the visual textwidth but doesn't add new line in insert mode
" autocmd FileType * setlocal formatoptions-=cro  " Disables automatic commenting on newline. https://stackoverflow.com/q/2280030/3744499

""" Splits and Tabs
set splitbelow splitright             " Splits open at the bottom and right, which is non-retarded, unlike vim defaults.

""" Warnings
set noerrorbells                      " No annoying sound on errors
" set t_vb=                             " No beep or flash
" set novisualbell                      " No visual bell

""" Fix mouse issue using Alacritty terminal
" set ttymouse=sgr

""" Automatic toggling between line number modes
" https://jeffkreeftmeijer.com/vim-number/
" https://github.com/jeffkreeftmeijer/vim-numbertoggle
augroup numbertoggle
  autocmd!
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu | set norelativenumber | endif
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu | set relativenumber   | endif
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => My Shortcut Keys
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""" Edit and source vimrc
map <leader>e :e! ~/.vim_runtime/my_configs.vim<cr>
nnoremap <leader>rc :source $MYVIMRC<CR>
""" auto source when writing to init.vm alternatively you can run :source $MYVIMRC
au! BufWritePost $MYVIMRC source %

""" No highlight search
nnoremap <Esc><Esc> :<C-u>nohlsearch<CR>

""" Close a buffer without closing the window?
" https://stackoverflow.com/a/19619038/3744499
nmap ,bd :b#<bar>bd#<CR>

""" Add new file in the directory of the open file
nmap ,a :e %:h/

""" Splits and tabbed files
" Make adjusting split sizes a bit more friendly
noremap <silent> <C-Left> :vert resize +3<CR>
noremap <silent> <C-Right> :vert resize -3<CR>
noremap <silent> <C-Up> :resize +3<CR>
noremap <silent> <C-Down> :resize -3<CR>

""" Change 2 split windows from vert to horiz or horiz to vert
map <leader>th <C-w>t<C-w>H
map <leader>tk <C-w>t<C-w>K

""" Zoom a window in and out
noremap Zz <c-w>_ \| <c-w>\|
noremap Zo <c-w>=

""" Better tabbing
vnoremap < <gv
vnoremap > >gv

""" TAB in general mode will move to text buffer
nnoremap <TAB> :bnext<CR>
""" SHIFT-TAB will go back
nnoremap <S-TAB> :bprevious<CR>

""" Alternate way to save
nnoremap <C-s> :w<CR>

""" Insert new line without automatic commenting
nnoremap <Leader>o o<Esc>^Da
nnoremap <Leader>O O<Esc>^Da

""" Spellcheck
nnoremap <leader>sc setlocal spell!

"----------------------------
" => Splits and Tabbed Files
"----------------------------
""" Better window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

""" Make adjusing split sizes a bit more friendly
noremap <silent> <C-S-Left> :vertical resize +3<CR>
noremap <silent> <C-S-Right> :vertical resize -3<CR>
noremap <silent> <C-S-Up> :resize +3<CR>
noremap <silent> <C-S-Down> :resize -3<CR>

""" Change 2 split windows from vert to horiz or horiz to vert
map <Leader>th <C-w>t<C-w>H
map <Leader>tk <C-w>t<C-w>K

"----------------------------
" => Code editing stuffs
"----------------------------

""" <F6> -  Absolute numbers
map <F6> :set relativenumber!<CR>

""" <F5> -  Remove all trailing whitespace. https://vim.fandom.com/wiki/Remove_unwanted_spaces
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>
command! WhitespateTrailingRemove :%s/\s\+$//e

""" :W   -  Force write. Allow saving of files as sudo
if !has('nvim')
  command! W w !sudo tee % > /dev/null
else
  command! W w suda://%  " lambdalisue/suda.vim
endif

""" Toggle number and relativenumber for cursor copy-paste
"nnoremap <leader>n :set number! relativenumber!<CR> :FoldColumnToggle<CR> :IndentLinesToggle<CR> :ALEToggleBuffer<CR> :GitGutterToggle<CR>
nnoremap <leader>n :set nonumber nolinebreak norelativenumber<CR> :setlocal foldcolumn=0<CR> :IndentLinesDisable<CR> :ALEDisableBuffer<CR> :GitGutterDisable<CR>
vnoremap <leader>n :set nonumber nolinebreak norelativenumber<CR> :setlocal foldcolumn=0<CR> :IndentLinesDisable<CR> :ALEDisableBuffer<CR> :GitGutterDisable<CR>
nnoremap <leader>N :set number linebreak relativenumber<CR> :setlocal foldcolumn=1<CR> :IndentLinesEnable<CR> :ALEEnableBuffer<CR> :GitGutterEnable<CR>
vnoremap <leader>N :set number linebreak relativenumber<CR> :setlocal foldcolumn=1<CR> :IndentLinesEnable<CR> :ALEEnableBuffer<CR> :GitGutterEnable<CR>

"----------------------------
" => Copy and paste stuffs
"----------------------------

" map paste, yank and delete to named register so the content
" will not be overwritten (I know I should just remember...)
nnoremap x "0x
vnoremap x "0x
nnoremap cc "0cc

""" Cut to yanked register
nnoremap <leader>x "0x
vnoremap <leader>x "0x

""" Paste from yanked register
nnoremap <leader>P "0P
nnoremap <leader>p "0p
vnoremap <leader>P "0P
vnoremap <leader>p "0p

""" Yank to clipboard
nnoremap <leader>Y  "+y$
nnoremap <leader>y  "+y
nnoremap <leader>yy "+yy
vnoremap <leader>Y  "+y$
vnoremap <leader>y  "+y
vnoremap <leader>yy "+yy

"--------------------------
" => Map normal mode commands to insert mode
"--------------------------
" Delete to the end of line
imap <C-k> <C-o>D  

"--------------------------
" => Toggle transparent background
"--------------------------
" https://jnrowe.github.io/articles/tips/Toggling_settings_in_vim.html
" https://stackoverflow.com/a/37720708/3744499
let t:is_transparent = 0
function! ToggleTransparent()
  if t:is_transparent == 0
    hi Normal ctermbg=NONE guibg=NONE
    let t:is_transparent = 1
  else
    hi Normal ctermbg=235 guibg=#282828
    set background=dark
    let t:is_transparent = 0
  endif
endfunction
command! ToggleTransparent call ToggleTransparent()
nnoremap <leader>t : call ToggleTransparent()<CR>

"--------------------------
" => Toggle colorscheme
"--------------------------
function! ColorToggle()
  if &background ==? 'dark'
    set background=light
    let l:scheme = 'PaperColor'
    exe "silent! colorscheme " . l:scheme
    exe "silent! LightlineColorscheme " . l:scheme
  else
    set background=dark
    let l:scheme = 'gruvbox'
    exe "silent! colorscheme " . l:scheme
    exe "silent! LightlineColorscheme " . l:scheme
  endif
endfunction

command! ColorToggle call ColorToggle()

"--------------------------
" => Misc
"--------------------------

" Remove the Windows ^M - when the encodings gets messed up
noremap <leader>mm mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

"--------------------------
" => Fix unwanted key map
"--------------------------
try
  ":unmap <C-Space>
  inoremap <C-@> <Esc>
  unmap <leader>f
  unmap <leader>q
catch
endtry

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Global functions.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! FoldColumnToggle()
  " https://www.kawabangga.com/posts/1990
  if &foldcolumn
    setlocal foldcolumn=0
  else
    setlocal foldcolumn=1
  endif
endfunction

command! -nargs=0 FoldColumnToggle :call FoldColumnToggle()

function! Highlight(text)
  :execute "match blue /" . a:text . "/"
endfunction

command! -nargs=1 Highlight :call Highlight(<q-args>)

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

command! -nargs=* -complete=file -bang Rename :call Rename("<args>", "<bang>")

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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => References
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" https://hackmd.io/@AlexSu/ryLuYmwYm?type=view

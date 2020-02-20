" Some basics ---------------------------------------------------------
let mapleader = ","
let maplocalleader = "\\"
nnoremap <leader>, ,

""" Backups
set history=50                        " Keep 50 lines of command line history
set nobackup                          " No *~ backup files
set nowritebackup                     " Do not make a backup before overwriting a file
set nowrapscan                        " Do not searche wrap around the end of the file
set noswapfile                        " Do not use a swapfile for the buffer

""" Colors
try
  colorscheme desert
  colorscheme peaksea
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
" autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o  " Disables automatic commenting on newline
" https://stackoverflow.com/q/2280030/3744499

""" Window and Tabs
set splitbelow splitright             " Splits open at the bottom and right, which is non-retarded, unlike vim defaults.

""" Warnings
set noerrorbells                      " No annoying sound on errors
" set novisualbell                      " No visual bell
" set t_vb=                             " No beep or flash

" Automatic toggling between line number modes
" https://jeffkreeftmeijer.com/vim-number/
" https://github.com/jeffkreeftmeijer/vim-numbertoggle
augroup numbertoggle
  autocmd!
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu | set nornu | endif
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu | set rnu   | endif
augroup END

" My Shortcut Keys -----------------------------------------------------

" Shortcutting for yank and paste
nnoremap <leader>P "0P
nnoremap <leader>p "0p
vnoremap <leader>P "0P
vnoremap <leader>p "0p

" Remove all trailing whitespace by pressing F5
" https://vim.fandom.com/wiki/Remove_unwanted_spaces
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>
command! WhitespateTrailingRemove :%s/\s\+$//e

" vim-move config - workaround alt key mappings
nmap zj <Plug>MoveLineDown
vmap zj <Plug>MoveBlockDown
nmap zk <Plug>MoveLineUp
vmap zk <Plug>MoveBlockUp

" :W Force write: Allow saving of files as sudo
" (useful for handling the permission-denied error)
if !has('nvim')
  command! W w !sudo tee % > /dev/null
else
  command! W w suda://%  " lambdalisue/suda.vim
endif

" Toggle number and relativenumber for copy-paste
nnoremap <leader>n :FoldColumnToggle<CR> :set number! relativenumber!<CR> :IndentLinesToggle<CR> :ALEToggleBuffer<CR>
vnoremap <leader>n :FoldColumnToggle<CR> :set number! relativenumber!<CR> :IndentLinesToggle<CR> :ALEToggleBuffer<CR>

" Cut and paste
nnoremap <leader>x "0x
vnoremap <leader>x "0x

" Yank to clipboard
nnoremap <leader>Y  "+y$
nnoremap <leader>y  "+y
nnoremap <leader>yy "+yy
vnoremap <leader>Y  "+y$
vnoremap <leader>y  "+y
vnoremap <leader>yy "+yy

" Fix unwanted key map
" :unmap <C-Space>
inoremap <C-@> <Esc>

" Zooming vim window splits
noremap Zz <c-w>_ \| <c-w>\|
noremap Zo <c-w>=

" vim-multiple-cursors - default mapping -------------------------------
let g:multi_cursor_start_word_key      = '<C-n>'
let g:multi_cursor_select_all_word_key = '<A-n>'
let g:multi_cursor_select_all_word_key = '<Esc>n'
let g:multi_cursor_start_key           = 'g<C-n>'
let g:multi_cursor_select_all_key      = 'g<A-n>'
let g:multi_cursor_select_all_key      = 'g<Esc>n'
let g:multi_cursor_next_key            = '<C-n>'
let g:multi_cursor_prev_key            = '<C-p>'
let g:multi_cursor_skip_key            = '<C-x>'
let g:multi_cursor_quit_key            = '<Esc>'

" == Utilities for vimrc == -------------------------------------------

" https://gist.github.com/thinca/1518874

" == Naming convention. ==
" Command name
"  - CamelCase
" Global function name
"  - CamelCase
" Local function name
"  - s:split_by_underbar
" Group name for autocmd
"  - split-by-dash
"   In vimrc, start with "vimrc"
"    - vimrc-{unique-name}
"   In vim plugin, start with "plugin"
"    - plugin-{plugin-name}
"    - plugin-{plugin-name}-{unique-name}
"   In other custom files, start with "custom"
"    - custom-{unique-name}

function! s:has_plugin(name)
  return globpath(&runtimepath, 'plugin/' . a:name . '.vim') !=# ''
        \   || globpath(&runtimepath, 'autoload/' . a:name . '.vim') !=# ''
        \   || globpath(&runtimepath, 'plugged/' . a:name) !=# ''
        \   || globpath(&runtimepath, 'my_plugins/' . a:name) !=# ''
        \   || globpath(&runtimepath, 'sources_forked/' . a:name) !=# ''
        \   || globpath(&runtimepath, 'sources_non_forked/' . a:name) !=# ''
endfunction

function! s:plug_loaded(name)
  " https://vi.stackexchange.com/a/14143
  " for vim-plug
  return has_key(g:plugs, a:name)
        \   && isdirectory(g:plugs[a:name].dir)
  " \   && stridx(&runtimepath, g:plugs[a:name].dir) >= 0
endfunction

" Global functions.
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
" Check pynvim ---------------------------------------------------------

if has("nvim") && !has("python3")
  echo "[python3] Installing pynvim (required for ncm2) ...\n"
  silent !python3 -m pip --disable-pip-version-check -q install --no-cache-dir --user -U pynvim
endif

" NERDTree -------------------------------------------------------------
let g:NERDTreeWinPos = "left"

" comfortable-motion.vim -----------------------------------------------
" Disable comfortable_motion.
let g:loaded_comfortable_motion = 0
" let g:comfortable_motion_interval = 1000.0 / 60
" let g:comfortable_motion_friction = 80.0
" let g:comfortable_motion_air_drag = 2.0

" vim-indent-guides ----------------------------------------------------
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1

" indentLine -----------------------------------------------------------


" vim-markdown ---------------------------------------------------------
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_conceal_code_blocks = 0
let g:vim_markdown_conceal = 0
let g:vim_markdown_math = 1

" NCM2 -----------------------------------------------------------------
" https://yufanlu.net/2018/09/03/neovim-python/
if has('nvim') && has('python3') && s:has_plugin('ncm2') && s:has_plugin('ncm2-ultisnips')
  augroup NCM2
    autocmd!
    " enable ncm2 for all buffers
    autocmd BufEnter * call ncm2#enable_for_buffer()
    " IMPORTANT: :help Ncm2PopupOpen for more information
    set completeopt=noinsert,menuone,noselect

    " When the <Enter> key is pressed while the popup menu is visible, it only
    " hides the menu. Use this mapping to close the menu and also start a new line:
    inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")

    " Press enter key to trigger snippet expansion
    " The parameters are the same as `:help feedkeys()`
    inoremap <silent> <expr> <CR> ncm2_ultisnips#expand_or("\<CR>", 'n')

    " Use <TAB> to select the popup menu:
    inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
    inoremap <expr> <C-Space> pumvisible() ? "\<C-n>" : "\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
    " uncomment this block if you use vimtex for LaTex:
    " autocmd Filetype tex call ncm2#register_source({
    "           \ 'name': 'vimtex',
    "           \ 'priority': 8,
    "           \ 'scope': ['tex'],
    "           \ 'mark': 'tex',
    "           \ 'word_pattern': '\w+',
    "           \ 'complete_pattern': g:vimtex#re#ncm2,
    "           \ 'on_complete': ['ncm2#on_complete#omni', 'vimtex#complete#omnifunc'],
    "           \ })
  augroup END
endif

" vim-autoformat -------------------------------------------
if s:has_plugin('vim-autoformat')
  noremap <F3> :Autoformat<CR>
endif

let g:autoformat_verbosemode=1
let g:formatter_yapf_style = 'pep8'
let g:formatdef_black = '"black -qS - "'
let g:formatters_python = ['black', 'yapf']

" braceless.vim  -------------------------------------------------------
if s:has_plugin('braceless.vim')
  autocmd FileType python BracelessEnable +indent
endif

" vim-easy-align  ------------------------------------------------------
if s:has_plugin('vim-easy-align')
  " Start interactive EasyAlign in visual mode (e.g. vipga).
  xmap ga <Plug>(EasyAlign)
  " Start interactive EasyAlign for a motion/text object (e.g. gaip).
  nmap ga <Plug>(EasyAlign)
endif

" fzf.vim --------------------------------------------------------------
" https://stackoverflow.com/a/5010399/3744499
" Plugins are only loaded after vim has finished processing your .vimrc.
" Also, pathogen doesn't actually load your plugins, it merely adds their
" containing folders to the runtimepath option so they will be loaded after your .vimrc

" You could create a VimEnter autocmd to set up your mapping after vim has finished loading:
autocmd VimEnter * if exists(':Buffers') | exe "map <leader>b :Buffers<cr>" | endif

" ctrlp.vim ------------------------------------------------------------
let g:ctrlp_map = '<c-f>'
let g:ctrlp_working_path_mode = 'ra'

" close-buffers.vim ----------------------------------------------------
autocmd VimEnter *
      \ if exists(':Bdelete') |
      \   nnoremap <silent> Q     :Bdelete menu<CR> |
      \   nnoremap <silent> <C-q> :Bdelete menu<CR> |
      \ endif

" lightline.vim --------------------------------------------------------
let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ 'active': {
      \   'left': [ ['mode', 'paste'],
      \             ['fugitive', 'readonly', 'filename', 'modified'],
      \             ['zoomstatus'] ],
      \   'right': [ [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ],
      \              [ 'percent', 'lineinfo' ],
      \              [ 'fileformat', 'fileencoding', 'filetype'] ],
      \ },
      \ 'component': {
      \   'readonly': '%{&filetype=="help"?"":&readonly?"🔒":""}',
      \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
      \   'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}',
      \   'zoomstatus': '%{exists("*zoom#statusline")?zoom#statusline():""}'
      \ },
      \ 'component_visible_condition': {
      \   'readonly': '(&filetype!="help"&& &readonly)',
      \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
      \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
      \ },
      \ 'separator': { 'left': ' ', 'right': ' ' },
      \ 'subseparator': { 'left': ' ', 'right': '|' }
      \ }

let g:lightline.component_expand = {
      \   'linter_checking': 'lightline#ale#checking',
      \   'linter_warnings': 'lightline#ale#warnings',
      \   'linter_errors': 'lightline#ale#errors',
      \   'linter_ok': 'lightline#ale#ok',
      \ }

let g:lightline.component_type = {
      \   'linter_checking': 'right',
      \   'linter_warnings': 'warning',
      \   'linter_errors': 'error',
      \   'linter_ok': 'left',
      \ }

" Changing colorscheme on the fly
" https://github.com/itchyny/lightline.vim/issues/258
function! s:setLightlineColorscheme(name)
  let g:lightline.colorscheme = a:name
  call lightline#init()
  call lightline#colorscheme()
  call lightline#update()
endfun

function! s:lightlineColorschemes(...)
  return join(map(
        \ globpath(&rtp,"autoload/lightline/colorscheme/*.vim",1,1),
        \ "fnamemodify(v:val,':t:r')"),
        \ "\n")
endfun

command! -nargs=1 -complete=custom,s:lightlineColorschemes LightlineColorscheme
      \ call s:setLightlineColorscheme(<q-args>)

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

" lightline-ale ---------------------------------------------------------
" let g:lightline#ale#indicator_checking = "\uf110"
let g:lightline#ale#indicator_checking = "◌"
" let g:lightline#ale#indicator_warnings = "\uf071"
let g:lightline#ale#indicator_errors = "✖"
let g:lightline#ale#indicator_ok = "✔"

" dense-analysis/ale ---------------------------------------------------
let g:ale_completion_enabled = 0
let g:ale_lint_on_enter = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 1
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %code - %%s [%severity%]'
let g:ale_linters = {
      \   'python': ['flake8']
      \ }
let g:ale_python_flake8_options= '--ignore=E309,E402,E501,E702,W291,W293,W391'
let b:ale_fixers = {'python': ['black', 'isort']}

nmap <silent> <C-p> <Plug>(ale_next_wrap)

" vim-highlightedyank --------------------------------------------------
if s:has_plugin('vim-highlightedyank')
  let g:highlightedyank_highlight_duration = 400
  " highlight HighlightedyankRegion cterm=reverse gui=reverse
endif

" tagbar ---------------------------------------------------------------
if s:has_plugin('tagbar')
  nmap <F8> :TagbarToggle<CR>
endif

" Nvim-R ---------------------------------------------------------------
" https://raw.githubusercontent.com/jalvesaq/Nvim-R/master/doc/Nvim-R.txt
let R_rconsole_width = 75    " Let window always split vertically
let R_min_editor_width = 18  " Disable underscore mapping
let R_assign = 0

" auto-pairs -----------------------------------------------------------
let g:AutoPairsFlyMode = 0
let g:AutoPairsShortcutBackInsert = '<M-b>'
let g:AutoPairsShortcutFastWrap = '<M-e>'
let g:AutoPairsShortcutToggle = '<M-p>'

" vim-move -------------------------------------------------------------
" https://github.com/matze/vim-move
let g:move_key_modifier = 'M'  " don't know but somehow that <opt + cmd> works for macos

" vim-jedi -------------------------------------------------------------
let g:jedi#goto_command = "<leader>d"
let g:jedi#goto_assignments_command = "<leader>g"
let g:jedi#goto_definitions_command = ""
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<leader>u"
let g:jedi#completions_command = "<C-Space>"
let g:jedi#rename_command = "<leader>r"

" vim-isort ------------------------------------------------------------
let g:vim_isort_map = '<C-i>'

" ctrlp-funky ----------------------------------------------------------
let g:ctrlp_funky_matchtype = 'path'
let g:ctrlp_funky_syntax_highlight = 1
if s:has_plugin('ctrlp-funky')
  nnoremap <Leader>fu :CtrlPFunky<Cr>
  nnoremap <Leader>fU :execute 'CtrlPFunky ' . expand('<cword>')<Cr>
endif

" vim-esearch ----------------------------------------------------------
highlight ESearchMatch ctermfg=white ctermbg=204 guifg=#ffffff guibg=#FF3E7B

" incsearch.vim --------------------------------------------------------
" https://github.com/haya14busa/incsearch.vim/issues/79
if has('nvim')
  set inccommand=nosplit
endif

" vim-plug =============================================================
" https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation

if empty(glob('~/.vim_runtime/autoload/plug.vim'))
  echo "Downloading junegunn/vim-plug to manage plugins..."
  silent !curl -fsSLo ~/.vim_runtime/autoload/plug.vim --create-dirs --insecure
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim_runtime/plugged')

" Plugins already in awesome vimrc:
" Plug 'ctrlpvim/ctrlp.vim'         " fuzzy search files
" Plug 'dense-analysis/ale'         " asynchronous linters engine
" Plug 'jiangmiao/auto-pairs'       " insert or delete brackets, parens, quotes in pair
" Plug 'terryma/vim-expand-region'  " Press + to expand the visual selection and _ to shrink it.
" Plug 'tpope/vim-commentary'       " comment-out by gc
" Plug 'mileszs/ack.vim'            " Run your favorite full-text search tool from Vim, with an enhanced results list

" nvim/vim8/vim7 compatible:

Plug 'airblade/vim-gitgutter'  " show git changes to files in gutter
Plug 'ap/vim-css-color'  " Preview colours in source code
Plug 'Asheq/close-buffers.vim'
Plug 'cespare/vim-toml'  " Vim syntax for TOML
Plug 'Chiel92/vim-autoformat'  " formatters
Plug 'davidhalter/jedi-vim'  " Python IDE
Plug 'dhruvasagar/vim-zoom'  " Toggle zoom in / out individual windows (splits)
Plug 'eugen0329/vim-esearch'  " project-wide async search and replace, similar to SublimeText
Plug 'fisadev/vim-isort'  " sort python imports
Plug 'haya14busa/incsearch.vim'  " incrementally highlights ALL pattern matches
Plug 'jeetsukumaran/vim-pythonsense'  " provides text objects and motions for Python classes, methods, functions, and doc strings
Plug 'junegunn/vim-easy-align'
Plug 'lambdalisue/suda.vim'  " to read or write files with sudo command
Plug 'liuchengxu/vim-clap'  " Modern generic interactive finder and dispatcher for Vim and NeoVim
Plug 'machakann/vim-highlightedyank'
Plug 'majutsushi/tagbar'  " show tags in a bar (functions etc) for easy browsing
Plug 'matze/vim-move'   " move lines and selections up and down
Plug 'maximbaz/lightline-ale'  " make linter in statusline awesome
Plug 'raimon49/requirements.txt.vim', {'for': 'requirements'}
Plug 'rhysd/conflict-marker.vim'  " highlight, Jump and Resolve Conflict Markers Quickly in Vim
Plug 'ryanoasis/vim-devicons'  " adds file type icons to Vim plugins
Plug 'scrooloose/nerdtree'  " file list
Plug 'tacahiroy/ctrlp-funky'  " function navigator for ctrlp.vim
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'tpope/vim-surround'
Plug 'tweekmonster/braceless.vim'
Plug 'tweekmonster/impsort.vim'  " color and sort python imports
Plug 'Vimjas/vim-python-pep8-indent'  "better indenting for python
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'Yggdroot/indentLine'  " show indent guide

" fzf
if isdirectory('/usr/local/opt/fzf')
  Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
else
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
  Plug 'junegunn/fzf.vim'
endif

" Theme
Plug 'morhetz/gruvbox'
Plug 'NLKNguyen/papercolor-theme'
Plug 'rakr/vim-colors-rakr'
Plug 'rakr/vim-one'
Plug 'sonph/onehalf', {'rtp': 'vim/'}

" Neovim/Vim8 compatible
if has('nvim') || v:version >= 800

  " NCM2 plugins
  if has("python3")
    " NCM base
    Plug 'ncm2/ncm2'  " awesome autocomplete plugin
    Plug 'roxma/nvim-yarp'  " dependency of ncm2

    " Autocomplete
    Plug 'ncm2/ncm2-bufword'
    Plug 'ncm2/ncm2-jedi'  " fast python completion (use ncm2 if you want type info or snippet support)
    Plug 'ncm2/ncm2-path'
    Plug 'ncm2/ncm2-tmux'

    " R support
    " https://github.com/gaalcaras/ncm-R
    Plug 'gaalcaras/ncm-R'
    Plug 'jalvesaq/Nvim-R'

    " Optional: for snippet support
    " based on ultisnips
    Plug 'ncm2/ncm2-ultisnips'
    Plug 'SirVer/ultisnips'
  endif

  " Others
  " https://github.com/roxma/vim-hug-neovim-rpc
  " Plug 'roxma/vim-hug-neovim-rpc'
endif

" Neovim only
if has('nvim')
  " Disable jedi-vim
  Plug 'davidhalter/jedi-vim', { 'on': [] }
  " Plug 'roxma/vim-hug-neovim-rpc', { 'on': [] }
endif

" Vim only
if !has('nvim')
  let g:ncm2_enable = 0
  Plug 'ncm2/ncm2', { 'on': [] }  " awesome autocomplete plugin
  Plug 'roxma/nvim-yarp', { 'on': [] }  " dependency of ncm2

  " Disable ncm2-jedi
  Plug 'ncm2/ncm2-jedi', { 'on': [] }  " fast python completion (use ncm2 if you want type info or snippet support)
endif

" Older Vim only
if v:version >= 730 && v:version < 800
  " highlightedyank
  if !exists('##TextYankPost')
    map y <Plug>(highlightedyank)
  endif
endif

call plug#end()

"" References
" https://hackmd.io/@AlexSu/ryLuYmwYm?type=view

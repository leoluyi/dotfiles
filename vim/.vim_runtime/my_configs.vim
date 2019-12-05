" Some basics ---------------------------------------------------------
let mapleader = ","
let maplocalleader = "\\"

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
set tabstop=4                         " show existing tab with 4 spaces width
set shiftwidth=4                      " when indenting with '>', use 2 spaces width
set expandtab                         " On pressing tab, insert 4 spaces
set softtabstop=0
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
set foldlevel=999
set foldnestmax=3                     " Sets the maximum nesting of folds
set foldmethod=syntax                 " The kind of folding
set foldenable                        " Code folding
set foldcolumn=1                      " Add a bit extra margin to the left

""" Display
set number relativenumber
set colorcolumn=80                    " Display a ruler at a specific line
" highlight ColorColumn ctermbg=Black guibg=Black
" highlight ColorColumn ctermbg=235 guibg=#2c2d27
" let &colorcolumn=join(range(81,999),",")
" set colorcolumn=+1  " highlight column after 'textwidth'
" set textwidth=80

""" Encoding
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8
set ttyfast
set fileformats=unix,dos,mac

"" Fix backspace indent
set backspace=indent,eol,start

""" Files
syntax on
filetype plugin indent on

""" Word Wrap
set linebreak                         " Make Vim break lines without breaking words
set wrap                              " Line wrapping
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o  " Disables automatic commenting on newline
" https://stackoverflow.com/q/2280030/3744499
" set formatoptions-=t    " Keeps the visual textwidth but doesn't add new line in insert mode

""" Window and Tabs
set splitbelow splitright   " Splits open at the bottom and right, which is non-retarded, unlike vim defaults.

""" 1.15 Warnings
set noerrorbells                      " No annoying sound on errors
" set novisualbell                      " No visual bell
" set t_vb=                             " No beep or flash

" Automatic toggling between line number modes
" https://jeffkreeftmeijer.com/vim-number/
augroup numbertoggle
  autocmd!
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
  autocmd BufEnter,FocusGained,InsertLeave * set number relativenumber
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
nnoremap <leader>n :set foldcolumn=0<CR> :set number! relativenumber!<CR> :IndentLinesToggle<CR>
vnoremap <leader>n :set foldcolumn=0<CR> :set number! relativenumber!<CR> :IndentLinesToggle<CR>

" Cut and paste
nnoremap <leader>x "0x
vnoremap <leader>x "0x

" Yank to clipboard
nnoremap  <leader>Y  "+y$
nnoremap  <leader>y  "+y
nnoremap  <leader>yy "+yy
vnoremap  <leader>Y  "+y$
vnoremap  <leader>y  "+y
vnoremap  <leader>yy "+yy

" Fix unwanted key map
" :unmap <C-Space>
inoremap <C-@> <Esc>

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

" == Utilities for vimrc. == -------------------------------------------

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

" NCM2 -----------------------------------------------------------------
" https://yufanlu.net/2018/09/03/neovim-python/
if has('nvim') && has('python3') && s:has_plugin('ncm2')
  augroup NCM2
    autocmd!
    " enable ncm2 for all buffers
    autocmd BufEnter * call ncm2#enable_for_buffer()
    " IMPORTANT: :help Ncm2PopupOpen for more information
    set completeopt=noinsert,menuone,noselect

    " When the <Enter> key is pressed while the popup menu is visible, it only
    " hides the menu. Use this mapping to close the menu and also start a new line:
    inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")

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
let g:formatters_python = ['black', 'yapf']
" https://medium.com/3yourmind/auto-formatters-for-python-8925065f9505

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
if s:has_plugin('ctrlp_map')
  let g:ctrlp_map = '<c-f>'
endif

" close-buffers.vim ----------------------------------------------------
autocmd VimEnter *
      \ if exists(':Bdelete') |
      \   nnoremap <silent> Q     :Bdelete menu<CR> |
      \   nnoremap <silent> <C-q> :Bdelete menu<CR> |
      \ endif

" lightline.vim --------------------------------------------------------
let g:lightline = {
      \ 'colorscheme': 'default',
      \ 'active': {
      \   'left': [ ['mode', 'paste'],
      \             ['fugitive', 'readonly', 'filename', 'modified'] ],
      \   'right': [ [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ],
      \              [ 'percent', 'lineinfo' ],
      \              [ 'fileformat', 'fileencoding', 'filetype'] ],
      \ },
      \ 'component': {
      \   'readonly': '%{&filetype=="help"?"":&readonly?"🔒":""}',
      \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
      \   'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}'
      \ },
      \ 'component_visible_condition': {
      \   'readonly': '(&filetype!="help"&& &readonly)',
      \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
      \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
      \ },
      \ 'separator': { 'left': ' ', 'right': ' ' },
      \ 'subseparator': { 'left': ' ', 'right': '|' }
      \ }

" lightline-ale ---------------------------------------------------------
let g:lightline.component_expand = {
      \  'linter_checking': 'lightline#ale#checking',
      \  'linter_warnings': 'lightline#ale#warnings',
      \  'linter_errors': 'lightline#ale#errors',
      \  'linter_ok': 'lightline#ale#ok',
      \ }

let g:lightline.component_type = {
      \     'linter_checking': 'right',
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error',
      \     'linter_ok': 'left',
      \ }

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
let b:ale_fixers = {'python': ['black']}

nmap <silent> <C-S-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-S-j> <Plug>(ale_next_wrap)

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
" prefer the window is always split vertically
let R_rconsole_width = 65
let R_min_editor_width = 18

" auto-pairs -----------------------------------------------------------
let g:AutoPairsShortcutToggle = '<M-p>'

" vim-plug -------------------------------------------------------------
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

" My Plugins - nvim/vim8/vim7 compatible:
" Plug 'valloric/vim-indent-guides'
Plug 'airblade/vim-gitgutter'  " show git changes to files in gutter
Plug 'ap/vim-css-color'  " Preview colours in source code
Plug 'Asheq/close-buffers.vim'
Plug 'Chiel92/vim-autoformat'  " formater
Plug 'davidhalter/jedi-vim'
Plug 'haya14busa/incsearch.vim'  " Incrementally highlights ALL pattern matches
Plug 'junegunn/vim-easy-align'
Plug 'lambdalisue/suda.vim'  " to read or write files with sudo command
Plug 'machakann/vim-highlightedyank'
Plug 'majutsushi/tagbar'  " show tags in a bar (functions etc) for easy browsing
Plug 'matze/vim-move'
Plug 'maximbaz/lightline-ale'  " make linter in statusline awesome
Plug 'raimon49/requirements.txt.vim', {'for': 'requirements'}
Plug 'ryanoasis/vim-devicons'  " adds file type icons to Vim plugins
Plug 'scrooloose/nerdtree'  " file list
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'tpope/vim-surround'
Plug 'tweekmonster/braceless.vim'
Plug 'tweekmonster/impsort.vim'  " color and sort imports
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
Plug 'sonph/onehalf', {'rtp': 'vim/'}
Plug 'rakr/vim-one'
Plug 'NLKNguyen/papercolor-theme'

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

""" References """
" https://hackmd.io/@AlexSu/ryLuYmwYm?type=view

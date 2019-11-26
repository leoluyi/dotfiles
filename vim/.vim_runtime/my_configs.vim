" Some basics ---------------------------------------------------------
let mapleader = ","

" Color scheme
try
  colorscheme desert
  colorscheme peaksea
  colorscheme gruvbox
catch
endtry
set background=dark

" Encoding
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8
set ttyfast
set fileformats=unix,dos,mac

"" Fix backspace indent
set backspace=indent,eol,start

syntax on
filetype plugin indent on

" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 2 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab
set softtabstop=0

set foldlevel=999
set number relativenumber

" Color column
set colorcolumn=80
set cc=+1  " highlight column after 'textwidth'
highlight ColorColumn ctermbg=Black guibg=lightgrey

" Splits open at the bottom and right, which is non-retarded, unlike vim defaults.
set splitbelow splitright

" Automatic toggling between line number modes
" https://jeffkreeftmeijer.com/vim-number/
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set number relativenumber 
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

" Disables automatic commenting on newline
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

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
command! W w !sudo tee % > /dev/null

" Toggle number and relativenumber for copy-paste
nnoremap <leader>n :set number! relativenumber!<CR> :IndentLinesToggle<CR>
vnoremap <leader>n :set number! relativenumber!<CR> :IndentLinesToggle<CR>

" Cut and paste
nnoremap <leader>x "0x
vnoremap <leader>x "0x

" " yank to clipboard
" " https://stackoverflow.com/a/3961954
" " https://www.markcampbell.me/2016/04/12/setting-up-yank-to-clipboard-on-a-mac-with-vim.html
" if has("clipboard")
"   set clipboard=unnamed " copy to the system clipboard

"   if has("unnamedplus") " X11 support
"     set clipboard+=unnamedplus
"   endif
" endif

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
endfunction

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


" NCM2 -----------------------------------------------------------------
" https://yufanlu.net/2018/09/03/neovim-python/
augroup NCM2
  autocmd!
  if s:has_plugin('ncm2')
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
  endif
augroup END

" vim-autoformat -------------------------------------------
if s:has_plugin('vim-autoformat')
  noremap <F3> :Autoformat<CR>
endif

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

" close-buffers.vim ----------------------------------------------------
autocmd VimEnter * |
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
let g:ale_lint_on_enter = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 1
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %code - %%s [%severity%]'
let g:ale_linters = {
  \   'python': ['flake8']
  \ }
let g:ale_python_flake8_options= '--ignore=E309,E402,E501,E702,W291,W293,W391'

" vim-highlightedyank --------------------------------------------------
let g:highlightedyank_highlight_duration = 400
highlight HighlightedyankRegion cterm=reverse gui=reverse

" tagbar ---------------------------------------------------------------
if s:has_plugin('tagbar')
  nmap <F8> :TagbarToggle<CR>
endif

" vim-plug -------------------------------------------------------------
" https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation

if empty(glob('~/.vim_runtime/autoload/plug.vim'))
  echo "Downloading junegunn/vim-plug to manage plugins..."
  silent !curl -fsSLo ~/.vim_runtime/autoload/plug.vim --create-dirs --insecure
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

" Plugins that already in awesome vimrc:
"Plug 'ctrlpvim/ctrlp.vim'  " fuzzy search files
"Plug 'dense-analysis/ale'  " asynchronous linters engine
"Plug 'tpope/vim-commentary'  "comment-out by gc

" My Plugins - nvim/vim8/vim7 compatible:
" Plug 'vifm/vifm.vim'
" Plug 'valloric/vim-indent-guides'
Plug 'airblade/vim-gitgutter'  " show git changes to files in gutter
Plug 'Asheq/close-buffers.vim'
Plug 'Chiel92/vim-autoformat'  " formater
Plug 'davidhalter/jedi-vim'
Plug 'junegunn/vim-easy-align'
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

" Neovim/Vim8 compatible
if has('nvim') || v:version >= 800
  " NCM base
  Plug 'ncm2/ncm2'  " awesome autocomplete plugin
  Plug 'roxma/nvim-yarp'  " dependency of ncm2

  " Autocomplete
  Plug 'ncm2/ncm2-bufword'
  Plug 'ncm2/ncm2-jedi'  " fast python completion (use ncm2 if you want type info or snippet support)
  Plug 'ncm2/ncm2-path'
  Plug 'ncm2/ncm2-tmux'

  " Disable jedi-vim
  Plug 'davidhalter/jedi-vim', { 'on': [] }

  " R support
  " https://github.com/gaalcaras/ncm-R
  Plug 'gaalcaras/ncm-R'
  Plug 'jalvesaq/Nvim-R'

  " Optional: for snippet support
  " based on ultisnips
  Plug 'ncm2/ncm2-ultisnips'
  Plug 'SirVer/ultisnips'

  " Optional: better Rnoweb support (LaTeX completion)
  Plug 'lervag/vimtex'

  " Others
  " https://github.com/roxma/vim-hug-neovim-rpc
  Plug 'roxma/vim-hug-neovim-rpc'

" Neovim only
if has('nvim')
  Plug 'davidhalter/jedi-vim', { 'on': [] }
  Plug 'roxma/vim-hug-neovim-rpc', { 'on': [] }
endif

" Older Vim only
if v:version >= 730 && v:version < 800
  " highlightedyank
  if !exists('##TextYankPost')
    map y <Plug>(highlightedyank)
  endif
endif

call plug#end()

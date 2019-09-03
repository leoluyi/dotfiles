" Some basics
let mapleader = ","

set number relativenumber
set encoding=utf-8
set foldlevel=999
syntax on
filetype plugin indent on

" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 2 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab

" Splits open at the bottom and right, which is non-retarded, unlike vim defaults.
set splitbelow splitright

" Shortcutting for yank and paste
nnoremap <leader>P "0P
nnoremap <leader>p "0p
vnoremap <leader>P "0P
vnoremap <leader>p "0p

" Disables automatic commenting on newline:
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" vim-move config - workaround alt key mappings
nmap zj <Plug>MoveLineDown
vmap zj <Plug>MoveBlockDown
nmap zk <Plug>MoveLineUp
vmap zk <Plug>MoveBlockUp

" Automatic toggling between line number modes  ------------------------
" https://jeffkreeftmeijer.com/vim-number/
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

" Allow saving of files as sudo ----------------------------------------
" When I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %

" multi_cursor - default mapping ---------------------------------------
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

" NERDTree -------------------------------------------------------------
let g:NERDTreeWinPos = "right"

" comfortable_motion ---------------------------------------------------
" Disable comfortable_motion.
let g:loaded_comfortable_motion = 0
" let g:comfortable_motion_interval = 1000.0 / 60
" let g:comfortable_motion_friction = 80.0
" let g:comfortable_motion_air_drag = 2.0

" vim-indent-guides ----------------------------------------------------
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1

" braceless.vim  -------------------------------------------------------
autocmd FileType python if exists(':BracelessEnable') | exe "BracelessEnable +indent" | endif 

" vim-easy-align  ------------------------------------------------------
" Start interactive EasyAlign in visual mode (e.g. vipga).
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip).
nmap ga <Plug>(EasyAlign)

" fzf.vim --------------------------------------------------------------
autocmd VimEnter * if exists(':Buffers') | exe "map <leader>b :Buffers<cr>" | endif

" ctrlp.vim ------------------------------------------------------------
let g:ctrlp_map = '<c-f>'

" vim-plug -------------------------------------------------------------
" https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation

if empty(glob('~/.vim_runtime/autoload/plug.vim'))
  echo "Downloading junegunn/vim-plug to manage plugins..."
  silent !curl -fsSLo ~/.vim_runtime/autoload/plug.vim --create-dirs --insecure
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
" Plug 'ncm2/ncm2-jedi'

" https://github.com/gaalcaras/ncm-R
Plug 'gaalcaras/ncm-R'
Plug 'jalvesaq/Nvim-R'
Plug 'ncm2/ncm2'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
" Vim 8 only
if !has('nvim')
    Plug 'roxma/vim-hug-neovim-rpc'
endif

Plug 'asheq/close-buffers.vim'
"Plug 'ctrlpvim/ctrlp.vim'
Plug 'davidhalter/jedi-vim'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'matze/vim-move'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-surround'
Plug 'tweekmonster/braceless.vim'
Plug 'valloric/vim-indent-guides'
Plug 'vifm/vifm.vim'

" Optional: for snippet support
" Further configuration might be required, read below
Plug 'sirver/UltiSnips'
Plug 'ncm2/ncm2-ultisnips'

" Optional: better Rnoweb support (LaTeX completion)
Plug 'lervag/vimtex'
call plug#end()

" Some basics ---------------------------------------------------------
let mapleader = ","

set number relativenumber
set encoding=utf-8
set foldlevel=999
set background=dark
syntax on
filetype plugin indent on

" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 2 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab
" Ruler
set colorcolumn=80
highlight ColorColumn ctermbg=0 guibg=lightgrey

" Splits open at the bottom and right, which is non-retarded, unlike vim defaults.
set splitbelow splitright

" Toggle number and relativenumber for copy-paste
nnoremap <leader>n :set number! relativenumber!<CR>
vnoremap <leader>n :set number! relativenumber!<CR>

" Automatic toggling between line number modes
" https://jeffkreeftmeijer.com/vim-number/
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
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

" Force write: Allow saving of files as sudo
" When I forgot to start vim using sudo.
command W w !sudo tee "%" > /dev/null

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

" close-buffers.vim ----------------------------------------------------
autocmd VimEnter * if exists(':Bdelete') | exe "nnoremap <silent> Q     :Bdelete menu<CR>" | endif
autocmd VimEnter * if exists(':Bdelete') | exe "nnoremap <silent> <C-q> :Bdelete menu<CR>" | endif

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

"Plug 'ctrlpvim/ctrlp.vim'
Plug 'airblade/vim-gitgutter'
Plug 'Asheq/close-buffers.vim'
Plug 'davidhalter/jedi-vim'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'matze/vim-move'
Plug 'ryanoasis/vim-devicons'
Plug 'scrooloose/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'tpope/vim-surround'
Plug 'tweekmonster/braceless.vim'
Plug 'valloric/vim-indent-guides'
Plug 'vifm/vifm.vim'
Plug 'Xuyuanp/nerdtree-git-plugin'

" Optional: for snippet support
" Further configuration might be required, read below
Plug 'sirver/UltiSnips'
Plug 'ncm2/ncm2-ultisnips'

" Optional: better Rnoweb support (LaTeX completion)
Plug 'lervag/vimtex'
call plug#end()

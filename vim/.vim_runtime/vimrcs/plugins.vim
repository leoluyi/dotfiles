"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-plug
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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

Plug 'dense-analysis/ale'           " asynchronous linters engine
Plug 'garbas/vim-snipmate'          " Aims to be a concise vim script that implements some of TextMate's snippets features in Vim
Plug 'honza/vim-snippets'           " Snippets are separated from the engine
Plug 'itchyny/lightline.vim'        " A light and configurable statusline/tabline plugin for Vim
Plug 'jiangmiao/auto-pairs'         " insert or delete brackets, parens, quotes in pair
Plug 'MarcWeber/vim-addon-mw-utils' " Required by 'vim-snipmate'
Plug 'terryma/vim-expand-region'    " Press + to expand the visual selection and _ to shrink it.
Plug 'tomtom/tlib_vim'              " Required by 'vim-snipmate'
Plug 'tpope/vim-commentary'         " comment-out by gc
Plug 'tpope/vim-fugitive'           " A Git wrapper so awesome
Plug 'tpope/vim-sensible'           " Defaults everyone can agree on


" nvim/vim8/vim7 compatible:

Plug 'airblade/vim-gitgutter'  " Show git changes to files in gutter
Plug 'airblade/vim-rooter'  " Changes Vim working directory to project root
Plug 'ap/vim-css-color'  " Preview colours in source code
Plug 'Asheq/close-buffers.vim'  " Quickly close (bdelete) several buffers at once
Plug 'cespare/vim-toml'  " Vim syntax for TOML
Plug 'Chiel92/vim-autoformat'  " Formatters (pip install --user black)
Plug 'dalance/vseq.vim'  " Generating sequential number vertically
Plug 'danro/rename.vim'  " Rename the current file in the vim buffer + retain relative path
Plug 'davidhalter/jedi-vim'  " Python IDE (pip install --user jedi)
Plug 'dbeniamine/cheat.sh-vim'  " A vim plugin to access cheat.sh sheets
Plug 'dhruvasagar/vim-zoom'  " Toggle zoom in / out individual windows (splits)
Plug 'drzel/vim-line-no-indicator'  " Simple and expressive line number indicator
Plug 'ervandew/supertab'  " Perform all your vim insert mode completions with Tab
Plug 'eugen0329/vim-esearch'  " Easy async search and replace across multiple files.
Plug 'fisadev/vim-isort'  " Sort python imports (pip install --user isort)
Plug 'Glench/Vim-Jinja2-Syntax'  " An up-to-date jinja2 syntax file
Plug 'godlygeek/tabular' | Plug 'plasticboy/vim-markdown'  " Syntax highlighting, matching rules and mappings for the original Markdown and extensions
Plug 'haya14busa/incsearch.vim'  " Incrementally highlights ALL pattern matches
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'jeetsukumaran/vim-pythonsense'  " Provides text objects and motions for Python classes, methods, functions, and doc strings
Plug 'jmcantrell/vim-virtualenv'  " Virtualenv support
Plug 'junegunn/gv.vim'  " A git commit browser in Vim
Plug 'junegunn/vim-easy-align'  " Preview markdown on your modern browser with synchronised scrolling and flexible configuration
Plug 'kana/vim-textobj-line'  " Text objects for the current line
Plug 'kana/vim-textobj-user'  " Depencency of reedes/vim-textobj-quote
Plug 'lambdalisue/suda.vim'  " Read or write files with sudo command
Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }  " Shows keybindings in popup
Plug 'liuchengxu/vista.vim'  " Viewer & Finder for LSP symbols and tags like tagbar
Plug 'machakann/vim-highlightedyank'
Plug 'matze/vim-move'   " Move lines and selections up and down
Plug 'maximbaz/lightline-ale'  " Make linter in statusline awesome (pip install --user flake8)
Plug 'mbbill/undotree'  " The undo history visualizer for VIM
Plug 'mengelbrecht/lightline-bufferline'  " Display the list of buffers in the lightline vim plugin
Plug 'mg979/vim-visual-multi', {'branch': 'master'}  " Multiple cursors plugin for vim/neovim
Plug 'mhinz/vim-startify'  " The fancy start screen for Vim
Plug 'ntpeters/vim-better-whitespace'  " Better whitespace highlighting for Vim
Plug 'pangloss/vim-javascript'  " Vastly improved Javascript indentation and syntax support in Vim
Plug 'PieterjanMontens/vim-pipenv'  " Pipenv support (depends on 'jmcantrell/vim-virtualenv')
Plug 'preservim/tagbar'  " Show tags in a bar (functions etc) for easy browsing
Plug 'psf/black'  " The uncompromising Python code formatter
Plug 'raimon49/requirements.txt.vim', {'for': 'requirements'}
Plug 'reedes/vim-textobj-quote'  " Extending Vim to better support typographic ('curly') quote characters
Plug 'rhysd/conflict-marker.vim'  " Highlight, Jump and Resolve Conflict Markers Quickly in Vim
Plug 'romainl/vim-cool'  " About A very simple plugin that makes hlsearch more useful
Plug 'ryanoasis/vim-devicons'  " Adds file type icons to Vim plugins
Plug 'sbdchd/neoformat'  " A (Neo)vim plugin for formatting code.
Plug 'scrooloose/nerdtree'  " File list
Plug 'sheerun/vim-polyglot'  " A solid language pack for Vim
Plug 'SirVer/ultisnips'  " The ultimate snippet solution for Vim
Plug 'stsewd/fzf-checkout.vim'  " Manage branches and tags with fzf
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'tpope/vim-repeat'  " enable repeating supported plugin maps with '.'
Plug 'tpope/vim-surround'  "cs.., ds., ys.. . Provides mappings to easily delete, change and add such surroundings in pairs.
Plug 'tweekmonster/braceless.vim'  " Text objects, folding, and more for Python and other indented languages
Plug 'uarun/vim-protobuf' " Syntax highlighting for Google's Protocol Buffers
Plug 'unblevable/quick-scope'  " Lightning fast left-right movement in Vim
Plug 'vim-python/python-syntax'  " Python syntax highlighting for Vim
Plug 'vim-test/vim-test'  " Run your tests at the speed of thought
Plug 'Vimjas/vim-python-pep8-indent'  " Better indenting for python
Plug 'Xuyuanp/nerdtree-git-plugin'  " A plugin of NERDTree showing git status flags.
Plug 'Yggdroot/indentLine'  " Show indent guide
Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }  " An efficient fuzzy finder that helps to locate files, buffers, mrus, gtags, etc. on the fly.
Plug 'zivyangll/git-blame.vim'  " See Git Blame information in the status bar for the currently selected line

" poet-v
if has('python3')
  Plug 'petobens/poet-v'  " Detects and activates virtual environments in your python poetry or pipenv project
endif

" fzf
if isdirectory('/usr/local/opt/fzf')
  Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
else
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
  Plug 'junegunn/fzf.vim'
endif

""" Deprecated plugins.

" Plug 'ctrlpvim/ctrlp.vim'  " fuzzy search files
" Plug 'jremmen/vim-ripgrep'  " Use RipGrep in Vim and display results in a quickfix list
" Plug 'maxbrunsfeld/vim-yankstack'   " A lightweight implementation of emacs's kill-ring
" Plug 'mileszs/ack.vim'            " Run your favorite full-text search tool from Vim, with an enhanced results list
" Plug 'tacahiroy/ctrlp-funky'  " Function navigator for ctrlp.vim
" Plug 'terryma/vim-multiple-cursors'  " ctrl+n, ctrl+p, ctrl+x, Esc. True Sublime Text style multiple selections for Vim
" Plug 'tweekmonster/impsort.vim'  " Color and sort python imports
" Plug 'wincent/ferret'  " Find and Replace in Multiple Files

""" Color Scheme

" Plug 'gruvbox-community/gruvbox'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'jonathanfilip/vim-lucius'
Plug 'mhartington/oceanic-next'
Plug 'morhetz/gruvbox'
Plug 'NLKNguyen/papercolor-theme'
Plug 'rakr/vim-colors-rakr'
Plug 'rakr/vim-one'
Plug 'sainnhe/gruvbox-material'
Plug 'sonph/onehalf', {'rtp': 'vim/'}
Plug 'jacoborus/tender.vim'

" Neovim/Vim8 compatible
if has('nvim') || has('patch-8.2.0')

  if has("python3")
    " NCM base
    Plug 'ncm2/ncm2'  " awesome autocomplete plugin
    Plug 'roxma/nvim-yarp'  " required by ncm2

    " Autocomplete - NCM2
    " Plug 'ncm2/ncm2-tmux'
    Plug 'filipekiss/ncm2-look.vim'  " Look.vim completion plugin
    Plug 'ncm2/ncm2-bufword'
    Plug 'ncm2/ncm2-jedi'  " fast python completion (use ncm2 if you want type info or snippet support)
    Plug 'ncm2/ncm2-path'

    " R support - NCM2
    " https://github.com/gaalcaras/ncm-R
    Plug 'gaalcaras/ncm-R'
    Plug 'jalvesaq/Nvim-R'

    " NCM2 - for snippet support
    Plug 'ncm2/ncm2-ultisnips'  " based on ultisnips

    " File browser.
    Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }  " Requires pynvim
    Plug 'kristijanhusak/defx-git'  " defx git plugin
    Plug 'kristijanhusak/defx-icons'  " Icons for defx

    " Python syntax highlighting
    Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}  " Semantic Highlighting for Python in Neovim
  endif

  " Autocomplete - Asyncomplete
  " Plug 'prabirshrestha/async.vim'
  " Plug 'prabirshrestha/asyncomplete.vim'
  " Plug 'prabirshrestha/asyncomplete-ultisnips.vim'
  " Plug 'prabirshrestha/asyncomplete-lsp.vim'
  " Plug 'prabirshrestha/vim-lsp'

  " Floaterm
  Plug 'voldikss/vim-floaterm'  " Use (neo)vim terminal in the floating/popup window.

  " telescope requirements...
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'

  " Others
  Plug 'ThePrimeagen/vim-be-good'  " nvim plugin designed to make you better at Vim Movements
endif

" Neovim only
if has('nvim')
  " Disable plugins.
  Plug 'scrooloose/nerdtree', { 'on': [] }  " File list
  Plug 'tiagofumo/vim-nerdtree-syntax-highlight', { 'on': [] }
  Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': [] }  " A plugin of NERDTree showing git status flags.
endif

if has('nvim-0.4.2') || has('patch-8.1.2114')
  " Plug 'liuchengxu/vim-clap'  " Modern generic interactive finder and dispatcher for Vim and NeoVim

  " FZF - Popup window
  let g:fzf_layout = { 'down':'~30%', 'window': { 'width': 0.8, 'height': 0.8, 'yoffset':0.5, 'xoffset': 0.5, 'highlight': 'Todo', 'border': 'sharp' } }
endif

" Vim7/8 only
if !has('nvim')
  let g:ncm2_enable = 0
  Plug 'ncm2/ncm2', { 'on': [] }  " awesome autocomplete plugin
  Plug 'roxma/nvim-yarp', { 'on': [] }  " required by ncm2
  " Plug 'roxma/vim-hug-neovim-rpc'  " trying to build a compatibility layer for neovim rpc client working on vim8. https://github.com/roxma/vim-hug-neovim-rpc

  " Disable ncm2-jedi.
  Plug 'ncm2/ncm2-jedi', { 'on': [] }  " fast python completion (use ncm2 if you want type info or snippet support)
endif

" Vim7 only
if !has('nvim') && v:version >= 730 && v:version < 800
  " highlightedyank
  if !exists('##TextYankPost')
    map y <Plug>(highlightedyank)
  endif
endif

call plug#end()

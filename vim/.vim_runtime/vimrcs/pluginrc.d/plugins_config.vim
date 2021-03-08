"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" https://stackoverflow.com/a/5010399/3744499
" Plugins are only loaded after vim has finished processing your .vimrc.
" Also, vim-plug doesn't actually load your plugins, it merely adds their
" containing folders to the runtimepath option so they will be loaded after your .vimrc

" Load paths
let s:vim_runtime = expand('<sfile>:p:h')."/.."
" Load utils
runtime vimrcs/utils.vim

" morhetz/gruvbox -------------------------------------------------------------

" Most terminals don't handle italics right so gruvbox disables italics for terminals by default
" https://github.com/gruvbox-community/gruvbox/wiki/Terminal-specific#1-italics-is-disabled
if has('nvim')
  let g:gruvbox_italic=1
endif

let g:gruvbox_inverse=0
let g:gruvbox_contrast_light='soft'

" sainnhe/gruvbox-material ----------------------------------------------------
if has('nvim')
  let g:gruvbox_material_enable_italic = 1
endif

let g:gruvbox_material_better_performance = 1
let g:gruvbox_material_palette = 'mix'

" terryma/vim-multiple-cursors ------------------------------------------------
" default mapping
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

" mg979/vim-visual-multi ------------------------------------------------------
" https://github.com/mg979/vim-visual-multi/wiki/Mappings
let g:VM_default_mappings = 1
let g:VM_maps = {}

let g:VM_maps["Add Cursor Down"]             = '<M-C-Down>'
let g:VM_maps["Add Cursor Up"]               = '<M-C-Up>'

let g:VM_maps["Select Cursor Down"] = '<M-C-Down>'      " start selecting down
let g:VM_maps["Select Cursor Up"]   = '<M-C-Up>'        " start selecting up

" Enable undo/redo changes made in VM
let g:VM_maps["Undo"] = 'u'
let g:VM_maps["Redo"] = '<C-r>'

" vim-move --------------------------------------------------------------------
" workaround alt key mappings
nmap zj <Plug>MoveLineDown
vmap zj <Plug>MoveBlockDown
nmap zk <Plug>MoveLineUp
vmap zk <Plug>MoveBlockUp

" NERDTree --------------------------------------------------------------------
let g:NERDTreeWinPos = "left"
let g:NERDTreeWinSize=35
let NERDTreeIgnore = ['\.pyc$', '__pycache__']
let NERDTreeMinimalUI = 1
let NERDTreeShowHidden = 1

autocmd VimEnter *
      \ if exists(':NERDTreeToggle')
      \ | execute "map <leader>nn :NERDTreeToggle<cr>"
      \ | execute "map <leader>nb :NERDTreeFromBookmark<Space>"
      \ | execute "map <leader>nf :NERDTreeFind<cr>"
      \ | endif

" Nerdtree config for wildignore
set wildignore+=*.pyc,*.o,*.obj,*.svn,*.swp,*.class,*.hg,*.DS_Store,*.min.*
let NERDTreeRespectWildIgnore=1

"Close automatically when NERDTree is the only remaining window
autocmd VimEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" after a re-source, fix syntax matching issues (concealing brackets):
if exists('g:loaded_webdevicons')
  call webdevicons#refresh()
endif

" nerdtree-git-plugin ---------------------------------------------------------
let g:NERDTreeGitStatusIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✚",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : '☒',
    \ "Unknown"   : "?"
    \ }

" comfortable-motion.vim ------------------------------------------------------
" Disable comfortable_motion.
let g:loaded_comfortable_motion = 0
" let g:comfortable_motion_interval = 1000.0 / 60
" let g:comfortable_motion_friction = 80.0
" let g:comfortable_motion_air_drag = 2.0

" vim-indent-guides -----------------------------------------------------------
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1

" Yggdroot/indentLine ---------------------------------------------------------

" haya14busa/incsearch.vim ----------------------------------------------------
set hlsearch
let g:incsearch#auto_nohlsearch = 1  " This feature turns 'hlsearch' off automatically after searching-related motions.

" Fix: https://github.com/haya14busa/incsearch.vim/issues/79
" https://github.com/neovim/neovim/issues/3688#issuecomment-574544618
if has('nvim')
  set inccommand=nosplit
  hi Cursor blend=100
  set guicursor+=a:Cursor/lCursor
endif

autocmd VimEnter *
  \ if exists(':IncSearchMap')
  \ | execute "map /  <Plug>(incsearch-forward)"
  \ | execute "map ?  <Plug>(incsearch-backward)"
  \ | execute "map g/ <Plug>(incsearch-stay)"
  \ | execute "map n  <Plug>(incsearch-nohl-n)"
  \ | execute "map N  <Plug>(incsearch-nohl-N)"
  \ | execute "map *  <Plug>(incsearch-nohl-*)"
  \ | execute "map #  <Plug>(incsearch-nohl-#)"
  \ | execute "map g* <Plug>(incsearch-nohl-g*)"
  \ | execute "map g# <Plug>(incsearch-nohl-g#)"
  \ | execute 'nnoremap / ms/'
  \ | execute 'nnoremap ? ms?'
  \ | execute 'vnoremap / ms/'
  \ | execute 'vnoremap ? ms?'
  \ | endif

" vim-markdown ----------------------------------------------------------------
let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_math = 1
let g:vim_markdown_new_list_item_indent = 0

" NCM2 ------------------------------------------------------------------------
" https://github.com/ncm2/ncm2
if has('nvim') && has('python3') && Has_plugin('ncm2') && Has_plugin('ncm2-ultisnips')
  augroup NCM2
    autocmd!
    " enable ncm2 for all buffers
    autocmd BufEnter * call ncm2#enable_for_buffer()
    " IMPORTANT: :help Ncm2PopupOpen / :help ncm2-autocmd for more information
    " set completeopt=noinsert,menuone,noselect
    au User Ncm2PopupOpen set completeopt=noinsert,menuone,noselect
    au User Ncm2PopupClose set completeopt=menuone

    " wrap existing omnifunc
    " Note that omnifunc does not run in background and may probably block the
    " editor. If you don't want to be blocked by omnifunc too often, you could
    " add 180ms delay before the omni wrapper:
    "  'on_complete': ['ncm2#on_complete#delay', 180,
    "               \ 'ncm2#on_complete#omni', 'csscomplete#CompleteCSS'],
    autocmd User Ncm2Plugin call ncm2#register_source({
            \ 'name' : 'css',
            \ 'priority': 9,
            \ 'subscope_enable': 1,
            \ 'scope': ['css','scss'],
            \ 'mark': 'css',
            \ 'word_pattern': '[\w\-]+',
            \ 'complete_pattern': ':\s*',
            \ 'on_complete': ['ncm2#on_complete#omni', 'csscomplete#CompleteCSS'],
            \ })

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

" suppress the annoying 'match x of y', 'The only match', and 'Pattern not found' messages
set shortmess+=c

" CTRL-C doesn't trigger the InsertLeave autocmd . map to <ESC> instead.
inoremap <c-c> <ESC>

try
  " make it fast
  let ncm2#popup_delay = 5
  let ncm2#complete_length = [[1, 1]]
  " Use new fuzzy based matches
  let g:ncm2#matcher = 'substrfuzzy'
catch
endtry

" When the <Enter> key is pressed while the popup menu is visible, it only
" hides the menu. Use this mapping to close the menu and also start a new line:
inoremap <expr> <CR> (pumvisible() ? "\<C-y>\<CR>" : "\<CR>")

" Use <Tab> or <C-Space> to select the popup menu:
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <C-Space> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" ncm2-ultisnips --------------------------------------------------------------
" Press enter key to trigger snippet expansion
" The parameters are the same as `:help feedkeys()`
inoremap <silent> <expr> <CR> ncm2_ultisnips#expand_or("\<CR>", 'n')

" SirVer/ultisnips ------------------------------------------------------------
" Trigger configuration. You need to change this to something other than <tab> if you use one of the following:
" - https://github.com/Valloric/YouCompleteMe
" - https://github.com/nvim-lua/completion-nvim
" let g:UltiSnipsExpandTrigger="<CR>"
let g:UltiSnipsJumpForwardTrigger="<c-n>"
let g:UltiSnipsJumpBackwardTrigger="<c-p>"

let g:UltiSnipsUsePythonVersion=3

" ncm2-look.vim ---------------------------------------------------------------
autocmd FileType markdown :let b:ncm2_look_enabled = 1
let g:ncm2_look_mark = '📖'

" wim-autoformat --------------------------------------------------------------
" <F3>
if Has_plugin('vim-autoformat')
  noremap <F3> :Autoformat<CR>
endif

let g:autoformat_autoindent = 0
let g:autoformat_retab = 1
let g:autoformat_verbosemode=1
let g:formatter_yapf_style = 'pep8'
let g:formatdef_black = '"black -qS - "'
let g:formatters_python = ['black', 'yapf']

" braceless.vim  --------------------------------------------------------------
if Has_plugin('braceless.vim')
  autocmd FileType python BracelessEnable +indent
endif

" vim-easy-align  -------------------------------------------------------------
if Has_plugin('vim-easy-align')
  " Start interactive EasyAlign in visual mode (e.g. vipga).
  xmap ga <Plug>(EasyAlign)
  " Start interactive EasyAlign for a motion/text object (e.g. gaip).
  nmap ga <Plug>(EasyAlign)
endif

" fzf.vim ---------------------------------------------------------------------

if executable('rg')
  let $FZF_DEFAULT_COMMAND="rg --files --hidden -g '!.git'"
elseif executable('find')
  let $FZF_DEFAULT_COMMAND="find . -type f -not -path '*/\.git/*' -not -regex '.*\(\.pyc\|\.o\|\.obj\|\.svn\|\.swp\|\.class\|\.hg\|\.DS_Store\|\.min\..*\)'"
endif

let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
let $FZF_DEFAULT_OPTS = '--layout=reverse --info=inline'

" You could create a VimEnter / BufEnter autocmd to set up your mapping after vim has finished loading:
autocmd VimEnter * if exists(':Files')   | execute "nnoremap <leader>f :Files<CR>"   | endif
autocmd VimEnter * if exists(':Buffers') | execute "nnoremap <leader>bb :Buffers<CR>" | endif
autocmd VimEnter * if exists(':History') | execute "nnoremap <leader>m :History<CR>" | endif
" autocmd VimEnter * if exists(':BTags')   | execute "noremap <Leader>t :BTags<CR>"    | endif
" autocmd VimEnter * if exists(':Tags')    | execute "noremap <Leader>T :Tags<CR>"     | endif

" This is the default extra key bindings
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" " ctrlp.vim -------------------------------------------------------------------
" " https://github.com/kien/ctrlp.vim
"
" " Quickly find and open a file in the current working directory
" let g:ctrlp_map = '<C-f>'
" let g:ctrlp_working_path_mode = 'ra'
"
" " Quickly find and open a recently opened file
" noremap <leader>m :CtrlPMRU<CR>
"
" let g:ctrlp_max_height = 20
" let g:ctrlp_custom_ignore = 'node_modules\|^\.DS_Store\|^\.git\|^\.coffee'

" close-buffers.vim -----------------------------------------------------------
autocmd VimEnter *
  \ if exists(':Bdelete')
  \ | execute "nnoremap <silent> Q     :Bdelete menu<CR>"
  \ | execute "nnoremap <silent> <C-q> :Bdelete menu<CR>"
  \ | execute "nnoremap <leader>bo :Bdelete hidden<CR>"
  \ | execute "nnoremap <leader>bd :Bclose<CR>"
  \ | endif

" lightline.vim ---------------------------------------------------------------
let g:lightline = {
      \ 'colorscheme': 'gruvbox_material',
      \ 'active': {
      \   'left': [ ['mode', 'paste', 'zoomstatus'],
      \             ['readonly', 'filename', 'modified', 'fugitive', 'githunks'],
      \             ['venv'] ],
      \   'right': [ [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ],
      \              [ 'indicator', 'percent', 'lineinfo' ],
      \              [ 'fileformat', 'fileencoding', 'filetype'] ],
      \ },
      \ 'inactive': {
      \   'left': [ ['readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ],
      \              [ 'indicator', 'lineinfo' ] ],
      \ },
      \ 'component': {
      \   'readonly': '%{&filetype=="help"?"":&readonly?"🔒":""}',
      \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
      \   'fugitive': '%{exists("*fugitive#head")?" ".fugitive#head():""}',
      \   'zoomstatus': '%{exists("*zoom#statusline")&&(zoom#statusline()=="zoomed")?"ZOOMED":""}',
      \   'indicator': '%{exists("*LineNoIndicator")?LineNoIndicator():""}',
      \   'venv': '%{exists("*virtualenv#statusline")&&(""!=virtualenv#statusline())?" ".virtualenv#statusline():""}',
      \ },
      \ 'component_visible_condition': {
      \   'readonly': '(&filetype!="help"&& &readonly)',
      \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
      \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())',
      \   'zoomstatus': '(exists("*zoom#statusline") && (zoom#statusline()!="zoomed"))',
      \   'indicator': '(exists("*LineNoIndicator") && ""!=virtualenv#statusline())',
      \ },
      \ 'component_function': {
      \   'githunks': 'LightlineGitGutter',
      \   'filename': 'LightlineFilename',
      \ },
      \ 'separator': { 'left': ' ', 'right': ' ' },
      \ 'subseparator': { 'left': '', 'right': '|' }
      \ }

let g:lightline.component_expand = {
      \   'linter_checking': 'lightline#ale#checking',
      \   'linter_warnings': 'lightline#ale#warnings',
      \   'linter_errors': 'lightline#ale#errors',
      \   'linter_ok': 'lightline#ale#ok',
      \   'buffers': 'lightline#bufferline#buffers',
      \ }

let g:lightline.component_type = {
      \   'linter_checking': 'right',
      \   'linter_warnings': 'warning',
      \   'linter_errors': 'error',
      \   'linter_ok': 'left',
      \   'buffers': 'tabsel',
      \ }

" Changing lightline colorscheme on the fly
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

function! LightlineGitGutter()
  if !get(g:, 'gitgutter_enabled', 0) || empty(FugitiveHead())
    return ''
  endif
  let [ l:added, l:modified, l:removed ] = GitGutterGetHunkSummary()
  return printf('+%d ~%d -%d', l:added, l:modified, l:removed)
endfunction

function! LightlineFilename()
  " which expands the name of the current file, but prevents the expansion of
  " the tilde (:~), and makes the path relative to the current working directory (:.).
  return &filetype ==# 'vimfiler' ? vimfiler#get_status_string() :
        \ &filetype ==# 'unite' ? unite#get_status_string() :
        \ &filetype ==# 'vimshell' ? vimshell#get_status_string() :
        \ expand('%:~:.') !=# '' ? expand('%:~:.') : '[No Name]'
endfunction

" display the plugin information
" https://github.com/itchyny/lightline.vim#can-i-display-the-plugin-information-at-the-filename-component
let g:unite_force_overwrite_statusline = 0
let g:vimfiler_force_overwrite_statusline = 0
let g:vimshell_force_overwrite_statusline = 0

" lightline-bufferline --------------------------------------------------------
if Has_plugin('lightline-bufferline')
  let g:lightline.tabline = {
        \   'left': [ ['buffers'] ],
        \   'right': [ ['close'] ]
        \ }

  let g:lightline#bufferline#show_number = 2
  let g:lightline#bufferline#unnamed     = '[No Name]'
  let g:lightline#bufferline#filename_modifier = ':t'  " Only show filename
  let g:lightline#bufferline#enable_devicons = 1
  let g:lightline#bufferline#modified = ' [+]'
  let g:lightline#bufferline#read_only = ' [ro]'
endif

autocmd VimEnter *
      \ if exists('*lightline#bufferline#go')
      \ |   execute('nmap <Leader>1 <Plug>lightline#bufferline#go(1)')
      \ |   execute('nmap <Leader>2 <Plug>lightline#bufferline#go(2)')
      \ |   execute('nmap <Leader>3 <Plug>lightline#bufferline#go(3)')
      \ |   execute('nmap <Leader>4 <Plug>lightline#bufferline#go(4)')
      \ |   execute('nmap <Leader>5 <Plug>lightline#bufferline#go(5)')
      \ |   execute('nmap <Leader>6 <Plug>lightline#bufferline#go(6)')
      \ |   execute('nmap <Leader>7 <Plug>lightline#bufferline#go(7)')
      \ |   execute('nmap <Leader>8 <Plug>lightline#bufferline#go(8)')
      \ |   execute('nmap <Leader>9 <Plug>lightline#bufferline#go(9)')
      \ |   execute('nmap <Leader>0 <Plug>lightline#bufferline#go(10)')
      \ | endif

if has('gui_running')
  set guioptions-=e
endif

" lightline-ale ---------------------------------------------------------------
" let g:lightline#ale#indicator_checking = "\uf110"
let g:lightline#ale#indicator_checking = "◌"
" let g:lightline#ale#indicator_warnings = "\uf071"
let g:lightline#ale#indicator_errors = "✖"
let g:lightline#ale#indicator_ok = "✔"

" dense-analysis/ale ----------------------------------------------------------
let g:ale_completion_enabled = 0
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_format = '[%linter%] %code - %%s [%severity%]'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_lint_on_enter = 1
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_text_changed = 'never'  " Only run linting when saving the file
let g:ale_linters = {
      \   'python': ['flake8']
      \ }
let g:ale_python_flake8_options= '--ignore=E309,E402,E501,E702,W291,W293,W391'
let g:ale_set_highlights = 0  " Disabling highlighting
let b:ale_fixers = {'python': ['black', 'isort']}

let s:isort_bin = $HOME . "/.pyenv/versions/py3nvim/bin/flake8"
let s:black_bin = $HOME . "/.pyenv/versions/py3nvim/bin/black"

" if executable(s:isort_bin)
"   let g:ale_python_isort_executable = s:isort_bin
"   let g:ale_python_isort_use_global = 1
" endif

if executable(s:black_bin)
  let g:ale_python_black_executable = s:black_bin
endif

" Navigate between errors quickly with key bindings
" https://github.com/dense-analysis/ale#5xi-how-can-i-navigate-between-errors-quickly
autocmd VimEnter *
      \ if Has_plugin('ale')
      \ | execute "nmap <silent> <localleader>k <Plug>(ale_previous_wrap)"
      \ | execute "nmap <silent> <localleader>j <Plug>(ale_next_wrap)"
      \ | endif

" vim-highlightedyank ---------------------------------------------------------
if Has_plugin('vim-highlightedyank')
  let g:highlightedyank_highlight_duration = 400
  " highlight HighlightedyankRegion cterm=reverse gui=reverse
endif

" tagbar ----------------------------------------------------------------------
autocmd VimEnter *
      \ if exists(':TagbarToggle') && executable('ctags')
      \ | execute "nmap <F8> :TagbarToggle<CR>"
      \ | endif

" Nvim-R ----------------------------------------------------------------------
" https://raw.githubusercontent.com/jalvesaq/Nvim-R/master/doc/Nvim-R.txt
autocmd VimEnter *
      \ if Has_plugin('Nvim-R')
      \ |   execute "vmap <localleader><CR> <Plug>RDSendSelection"
      \ |   execute "nmap <localleader><CR> <Plug>RDSendLine"
      \ | endif

let R_rconsole_width = 75    " Let window always split vertically
let R_min_editor_width = 18
let R_assign = 0  " Disable underscore mapping to assign
let vimrplugin_applescript=0
let vimrplugin_vsplit=1
let vimrplugin_assign = 0

" auto-pairs ------------------------------------------------------------------
" Disable in vim scripts
autocmd FileType vim let b:autopairs_enabled = 0
let g:AutoPairsFlyMode = 0
let g:AutoPairsShortcutBackInsert = '<M-b>'
let g:AutoPairsShortcutFastWrap = '<M-e>'
let g:AutoPairsShortcutToggle = '<M-p>'

" vim-move --------------------------------------------------------------------
" https://github.com/matze/vim-move
let g:move_key_modifier = 'M'  " don't know but somehow that <opt + cmd> works for macos

" jedi-vim --------------------------------------------------------------------

if has('nvim')
  " Disable Jedi-vim autocompletion and enable call-signatures options since we have NCM2 for autocompletion.
  let g:jedi#completions_command = ""
  let g:jedi#completions_enabled = 0
else
  let g:jedi#completions_command = "<C-Space>"
  let g:jedi#completions_enabled = 1
endif

let g:jedi#popup_on_dot = 1
let g:jedi#auto_initialization = 1
let g:jedi#auto_vim_configuration = 0
let g:jedi#smart_auto_mappings = 0
let g:jedi#show_call_signatures = "1"

let g:jedi#goto_command = "<leader>gd"
let g:jedi#goto_assignments_command = "<leader>ga"
" let g:jedi#goto_definitions_command = "<leader>gd"
let g:jedi#usages_command = "<leader>gr"
let g:jedi#documentation_command = "K"
let g:jedi#rename_command = "<leader>r"

" vim-isort -------------------------------------------------------------------
let g:vim_isort_map = '<C-i>'
let g:vim_isort_python_version = 'python3'

" ctrlp-funky -----------------------------------------------------------------
let g:ctrlp_funky_matchtype = 'path'
let g:ctrlp_funky_syntax_highlight = 1
if Has_plugin('ctrlp-funky')
  nnoremap <Leader>fu :CtrlPFunky<Cr>
  nnoremap <Leader>fU :execute 'CtrlPFunky ' . expand('<cword>')<Cr>
endif

" vim-esearch -----------------------------------------------------------------

let g:esearch = {}

" Use regex matching with the smart case mode by default and avoid matching text-objects.
let g:esearch.regex   = 0
let g:esearch.textobj = 0
let g:esearch.case    = 'smart'

" Override the default files and directories to determine your project root. Set it
" to blank to always use the current working directory.
let g:esearch.root_markers = ['.git', 'Makefile', 'node_modules']

" Set to 0 to prevent esearch from adding any default keymaps.
let g:esearch.default_mappings = 1

if Has_plugin('vim-esearch')
  " Open the search window in a vertical split and reuse it for all further searches.
  let g:esearch.name = '[esearch]'
  let g:esearch.win_new = {esearch -> esearch#buf#goto_or_open(esearch.name, 'vnew')}

  " " Use a popup-like floating window to render search results.
  " " Try to jump into the opened floating window or open a new one.
  " let g:esearch.win_new = {esearch ->
  "   \ esearch#buf#goto_or_open(esearch.name, {name ->
  "   \   nvim_open_win(bufadd(name), v:true, {
  "   \     'relative': 'editor',
  "   \     'row': &lines / 10,
  "   \     'col': &columns / 10,
  "   \     'width': &columns * 8 / 10,
  "   \     'height': &lines * 8 / 10
  "   \   })
  "   \ })
  "   \}
  " " Close the floating window when opening an entry.
  " autocmd User esearch_win_config autocmd BufLeave <buffer> quit

  " " Automatically update the preview for the entry under the cursor.
  " " NOTE It'll internally wrap CursorMoved autocommand to collect garbage on reloads, so no augroup around is required.
  " autocmd User esearch_win_config
  "   \  let b:autopreview = esearch#async#debounce(b:esearch.preview_open, 100)
  "   \| autocmd CursorMoved <buffer> call b:autopreview.apply({'align': 'right'})
endif

" Redefine the default highlights (see :help highlight and :help esearch-appearance)
" Implement autocmd to reload highlights on colorscheme change
autocmd VimEnter *
      \ highlight esearchMatch ctermfg=white ctermbg=204 guifg=#ffffff guibg=#FF3E7B

" airblade/vim-gitgutter ------------------------------------------------------
let g:gitgutter_enabled=1
autocmd VimEnter *
  \ if exists(':GitGutterToggle')
  \ | execute "nnoremap <silent> <leader>tg :GitGutterToggle<cr>"
  \ | execute "nmap ]h <Plug>(GitGutterNextHunk)"
  \ | execute "nmap [h <Plug>(GitGutterPrevHunk)"
  \ | endif

" git-blame -------------------------------------------------------------------
autocmd VimEnter *
  \ if exists('*gitblame#echo')
  \ | execute "nnoremap <leader>gb :<C-u>call gitblame#echo()<CR>"
  \ | endif

" quick-scope -----------------------------------------------------------------
" Trigger a highlight in the appropriate direction when pressing these keys:
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

augroup qs_colors
  autocmd!
  autocmd ColorScheme * highlight QuickScopePrimary guifg=#00C7DF gui=underline ctermfg=155 cterm=underline
  autocmd ColorScheme * highlight QuickScopeSecondary guifg=#EF5F70 gui=underline ctermfg=81 cterm=underline
augroup END

let g:qs_max_chars=150
let g:qs_buftype_blacklist = ['terminal', 'nofile']

" vim-yankstack ---------------------------------------------------------------
" load yankstack without the default key mappings
let g:yankstack_map_keys = 0

" reedes/vim-textobj-quote ----------------------------------------------------
filetype plugin on       " may already be in your .vimrc

if Has_plugin('vim-textobj-quote')
  augroup textobj_quote
    autocmd!
    autocmd FileType markdown call textobj#quote#init()
    autocmd FileType textile call textobj#quote#init()
    autocmd FileType text call textobj#quote#init({'educate': 0})
  augroup END

  " You can replace straight quotes in existing text with curly quotes, and visa versa
  map <silent> <leader>qc <Plug>ReplaceWithCurly
  map <silent> <leader>qs <Plug>ReplaceWithStraight
endif

" LeaderF ---------------------------------------------------------------------
let g:Lf_UseCache = 0
let g:Lf_UseVersionControlTool = 0
let g:Lf_IgnoreCurrentBufferName = 1

let g:Lf_WindowPosition = 'popup'
let g:Lf_PopupHeight = 0.6
let g:Lf_PreviewInPopup = 1

let g:Lf_StlSeparator = { 'left': "\ue0b0", 'right': "\ue0b2" }
let g:Lf_PreviewResult = {'Function': 0, 'BufTag': 0 }

let g:Lf_ShortcutF = "<leader>FF"

if Has_plugin('gruvbox_material')
  let g:Lf_PopupColorscheme = "gruvbox_material"
endif

autocmd VimEnter *
  \ if exists(':Leaderf')
  \ | noremap <leader>FB :<C-U><C-R>=printf("Leaderf buffer %s", "")<CR><CR>
  \ | noremap <leader>FM :<C-U><C-R>=printf("Leaderf mru %s", "")<CR><CR>
  \ | noremap <leader>FT :<C-U><C-R>=printf("Leaderf bufTag %s", "")<CR><CR>
  \ | noremap <leader>FL :<C-U><C-R>=printf("Leaderf line %s", "")<CR><CR>
  \ | endif

" noremap <C-B> :<C-U><C-R>=printf("Leaderf! rg --current-buffer -e %s ", expand("<cword>"))<CR>
" noremap <C-F> :<C-U><C-R>=printf("Leaderf! rg -e %s ", expand("<cword>"))<CR>

" Defx ------------------------------------------------------------------------
" https://github.com/Shougo/defx.nvim/blob/master/doc/defx.txt
if Has_plugin('defx.nvim')
  autocmd FileType defx call s:defx_mappings()

  autocmd VimEnter *
        \ if exists(':Defx')
        \ | execute "nmap <silent> <Leader>nn :Defx `escape(getcwd(), ' :')` -columns=mark:indent:icons:filename:type:size:time<cr>"
        \ | endif

  autocmd VimEnter *
        \ if exists(':Defx')
        \ | call defx#custom#option('_', {
              \ 'winwidth': 40,
              \ 'split': 'vertical',
              \ 'direction': 'topleft',
              \ 'show_ignored_files': 0,
              \ 'buffer_name': '',
              \ 'toggle': 1,
              \ 'resume': 1
              \ })
        \ | endif

  " defx-git - very slow
  autocmd VimEnter *
        \ if exists(':Defx')
        \ | call defx#custom#column('git', 'indicators', {
          \ 'Modified'  : '✹',
          \ 'Staged'    : '✚',
          \ 'Untracked' : '✭',
          \ 'Renamed'   : '➜',
          \ 'Unmerged'  : '═',
          \ 'Ignored'   : '☒',
          \ 'Deleted'   : '✖',
          \ 'Unknown'   : '?'
          \ })
        \ | endif

  hi Defx_git_Untracked guifg=#FF0000

  function! s:defx_mappings() abort
    " Define mappings
    nnoremap <silent><buffer><expr> <CR>
    \ defx#do_action('drop')
    nnoremap <silent><buffer><expr> <2-LeftMouse>
    \ defx#do_action('drop')
    nnoremap <silent><buffer><expr> c
    \ defx#do_action('copy')
    nnoremap <silent><buffer><expr> m
    \ defx#do_action('move')
    nnoremap <silent><buffer><expr> p
    \ defx#do_action('paste')
    nnoremap <silent><buffer><expr> l
    \ defx#do_action('open')
    nnoremap <silent><buffer><expr> v
    \ defx#do_action('open', 'vsplit')
    nnoremap <silent><buffer><expr> P
    \ defx#do_action('preview')
    nnoremap <silent><buffer><expr> o
    \ defx#do_action('open_tree', 'toggle')
    nnoremap <silent><buffer><expr> K
    \ defx#do_action('new_directory')
    nnoremap <silent><buffer><expr> N
    \ defx#do_action('new_file')
    nnoremap <silent><buffer><expr> M
    \ defx#do_action('new_multiple_files')
    nnoremap <silent><buffer><expr> C
    \ defx#do_action('toggle_columns',
    \                'mark:indent:icon:filename:type:size:time')
    nnoremap <silent><buffer><expr> S
    \ defx#do_action('toggle_sort', 'time')
    nnoremap <silent><buffer><expr> d
    \ defx#do_action('remove')
    nnoremap <silent><buffer><expr> r
    \ defx#do_action('rename')
    nnoremap <silent><buffer><expr> !
    \ defx#do_action('execute_command')
    nnoremap <silent><buffer><expr> x
    \ defx#do_action('execute_system')
    nnoremap <silent><buffer><expr> yy
    \ defx#do_action('yank_path')
    nnoremap <silent><buffer><expr> .
    \ defx#do_action('toggle_ignored_files')
    nnoremap <silent><buffer><expr> ;
    \ defx#do_action('repeat')
    nnoremap <silent><buffer><expr> h
    \ defx#do_action('cd', ['..'])
    nnoremap <silent><buffer><expr> ~
    \ defx#do_action('cd')
    nnoremap <silent><buffer><expr> q
    \ defx#do_action('quit')
    nnoremap <silent><buffer><expr> <Space>
    \ defx#do_action('toggle_select') . 'j'
    nnoremap <silent><buffer><expr> *
    \ defx#do_action('toggle_select_all')
    nnoremap <silent><buffer><expr> j
    \ line('.') == line('$') ? 'gg' : 'j'
    nnoremap <silent><buffer><expr> k
    \ line('.') == 1 ? 'G' : 'k'
    nnoremap <silent><buffer><expr> <C-r>
    \ defx#do_action('redraw')
    nnoremap <silent><buffer><expr> <C-g>
    \ defx#do_action('print')
    nnoremap <silent><buffer><expr> cd
    \ defx#do_action('change_vim_cwd')
    nnoremap <silent><buffer><expr> > defx#do_action('resize',
    \ defx#get_context().winwidth + 10)
    nnoremap <silent><buffer><expr> < defx#do_action('resize',
    \ defx#get_context().winwidth - 10)
  endfunction

  function! s:defx_toggle_tree() abort
      " Open current file, or toggle directory expand/collapse
      if defx#is_directory()
          return defx#do_action('open_or_close_tree')
      endif
      return defx#do_action('multi', ['drop'])
  endfunction
endif

" sbdchd/neoformat ------------------------------------------------------------
let g:neoformat_enabled_python = ['black', 'yapf']

" petobens/poet-v -------------------------------------------------------------
if executable('poetry') || executable('pipenv')
  let g:poetv_executables = ['poetry', 'pipenv']
  let g:poetv_auto_activate = 1
  let g:poetv_statusline_symbol = ''
  let g:poetv_set_environment = 1
endif

" jremmen/vim-rigpgrep --------------------------------------------------------
if executable('rg')
  let g:rg_derive_root='true'
  let g:rg_root_types=['.git']
endif

" tpope/vim-fugitive ----------------------------------------------------------
" https://www.youtube.com/watch?v=PO6DxfGPQvw

" git status
autocmd VimEnter *
  \ if exists(':G')
  \ | execute "nnoremap <leader>gs :G<CR>"
  \ | execute "nnoremap <leader>gf :diffget //2"
  \ | execute "nnoremap <leader>gj :diffget //3"
  \ | endif

" tpope/vim-commentary --------------------------------------------------------
autocmd VimEnter *
  \ if exists(':Commentary')
  \ | execute "nnoremap <localleader>/ :Commentary<CR>"
  \ | execute "vnoremap <localleader>/ :Commentary<CR>"
  \ | endif

" mbbill/undotree -------------------------------------------------------------
autocmd VimEnter *
  \ if exists(':UndotreeToggle')
  \ | execute "nmap <silent> <leader>u :UndotreeToggle<CR>"
  \ | endif

" garbas/vim-snipmate ---------------------------------------------------------
let g:snipMate = { 'snippet_version' : 1 }

" voldikss/vim-floaterm -------------------------------------------------------
let g:floaterm_keymap_new    = ''
let g:floaterm_keymap_prev   = ''
let g:floaterm_keymap_next   = ''
let g:floaterm_keymap_toggle = '<leader>tt'
let g:floaterm_keymap_kill = '<leader>tk'

let g:floaterm_autoclose=2
let g:floaterm_autohide=1

" airblade/vim-rooter ---------------------------------------------------------
let g:rooter_silent_chdir = 0

" Vimroom ---------------------------------------------------------------------
let g:goyo_width=100
let g:goyo_margin_top = 2
let g:goyo_margin_bottom = 2

autocmd VimEnter *
  \ if exists(':UndotreeToggle')
  \ | execute "nnoremap <silent> <leader>z :Goyo<cr>"
  \ | endif

" romainl/vim-cool ------------------------------------------------------------
let g:CoolTotalMatches = 1

" garbas/vim-snipmate ---------------------------------------------------------
" inoremap <C-j> <C-r>=snipMate#TriggerSnippet()<cr>
" snoremap <C-j> <esc>i<right><C-r>=snipMate#TriggerSnippet()<cr>

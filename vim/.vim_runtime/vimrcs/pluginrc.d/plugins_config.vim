"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Load utils
runtime vimrcs/utils.vim

" Colorscheme -----------------------------------------------------------------
try
  colorscheme gruvbox
catch
endtry

" vim-multiple-cursors --------------------------------------------------------
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

" vim-move --------------------------------------------------------------------
" workaround alt key mappings
nmap zj <Plug>MoveLineDown
vmap zj <Plug>MoveBlockDown
nmap zk <Plug>MoveLineUp
vmap zk <Plug>MoveBlockUp

" NERDTree --------------------------------------------------------------------
let g:NERDTreeWinPos = "left"
let NERDTreeShowHidden = 1
let NERDTreeMinimalUI = 1

" Nerdtree config for wildignore
set wildignore+=*.pyc,*.o,*.obj,*.svn,*.swp,*.class,*.hg,*.DS_Store,*.min.*
let NERDTreeRespectWildIgnore=1

"Close automatically when NERDTree is the only remaining window
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

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
let g:incsearch#auto_nohlsearch = 1
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)

" vim-markdown ----------------------------------------------------------------
let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_math = 1
let g:vim_markdown_new_list_item_indent = 0

" NCM2 ------------------------------------------------------------------------
" https://yufanlu.net/2018/09/03/neovim-python/
if has('nvim') && has('python3') && Has_plugin('ncm2') && Has_plugin('ncm2-ultisnips')
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

" set completeopt=menuone,noselect,noinsert
set shortmess+=c
inoremap <C-c> <ESC>
" make it fast
let ncm2#popup_delay = 5
let ncm2#complete_length = [[1, 1]]
" Use new fuzzy based matches
let g:ncm2#matcher = 'substrfuzzy'

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
" https://stackoverflow.com/a/5010399/3744499
" Plugins are only loaded after vim has finished processing your .vimrc.
" Also, pathogen doesn't actually load your plugins, it merely adds their
" containing folders to the runtimepath option so they will be loaded after your .vimrc

let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
let $FZF_DEFAULT_OPTS = '--layout=reverse --info=inline'

" You could create a VimEnter autocmd to set up your mapping after vim has finished loading:
autocmd VimEnter * if exists(':Files') | exe "map <leader>f :Files<CR>" | endif
autocmd VimEnter * if exists(':Buffers') | exe "map <leader>b :Buffers<CR>" | endif
autocmd VimEnter * if exists(':History') | exe "map <leader>m :History<CR>" | endif

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
  \ if exists(':Bdelete') |
  \   nnoremap <silent> Q     :Bdelete menu<CR> |
  \   nnoremap <silent> <C-q> :Bdelete menu<CR> |
  \   nnoremap <leader>bo :Bdelete hidden<CR> |
  \ endif

" lightline.vim ---------------------------------------------------------------
let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ 'active': {
      \   'left': [ ['mode', 'paste'],
      \             ['readonly', 'filename', 'fugitive', 'modified'],
      \             ['zoomstatus', 'githunks', 'venv'] ],
      \   'right': [ [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ],
      \              [ 'percent', 'lineinfo' ],
      \              [ 'fileformat', 'fileencoding', 'filetype'] ],
      \ },
      \ 'component': {
      \   'readonly': '%{&filetype=="help"?"":&readonly?"🔒":""}',
      \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
      \   'fugitive': '%{exists("*fugitive#head")?" ".fugitive#head():""}',
      \   'zoomstatus': '%{exists("*zoom#statusline")?zoom#statusline():""}'
      \ },
      \ 'component_visible_condition': {
      \   'readonly': '(&filetype!="help"&& &readonly)',
      \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
      \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
      \ },
      \ 'component_function': {
      \   'githunks': 'LightlineGitGutter',
      \   'venv': 'virtualenv#statusline',
      \ },
      \ 'separator': { 'left': ' ', 'right': ' ' },
      \ 'subseparator': { 'left': ' ', 'right': '|' }
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

" lightline-bufferline --------------------------------------------------------
if Has_plugin('lightline-bufferline')
  let g:lightline.tabline = {
        \   'left': [ ['buffers'] ],
        \   'right': [ ['close'] ]
        \ }

  let g:lightline#bufferline#show_number = 1
  let g:lightline#bufferline#unnamed     = '[No Name]'
  let g:lightline#bufferline#filename_modifier = ':t'  " Only show filename
  let g:lightline#bufferline#enable_devicons = 1

  nmap <Leader>1 <Plug>lightline#bufferline#go(1)
  nmap <Leader>2 <Plug>lightline#bufferline#go(2)
  nmap <Leader>3 <Plug>lightline#bufferline#go(3)
  nmap <Leader>4 <Plug>lightline#bufferline#go(4)
  nmap <Leader>5 <Plug>lightline#bufferline#go(5)
  nmap <Leader>6 <Plug>lightline#bufferline#go(6)
  nmap <Leader>7 <Plug>lightline#bufferline#go(7)
  nmap <Leader>8 <Plug>lightline#bufferline#go(8)
  nmap <Leader>9 <Plug>lightline#bufferline#go(9)
  nmap <Leader>0 <Plug>lightline#bufferline#go(10)
endif

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

" https://github.com/dense-analysis/ale#5xi-how-can-i-navigate-between-errors-quickly
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" vim-highlightedyank ---------------------------------------------------------
if Has_plugin('vim-highlightedyank')
  let g:highlightedyank_highlight_duration = 400
  " highlight HighlightedyankRegion cterm=reverse gui=reverse
endif

" tagbar ----------------------------------------------------------------------
if Has_plugin('tagbar')
  nmap <F8> :TagbarToggle<CR>
endif

" Nvim-R ----------------------------------------------------------------------
" https://raw.githubusercontent.com/jalvesaq/Nvim-R/master/doc/Nvim-R.txt
let R_rconsole_width = 75    " Let window always split vertically
let R_min_editor_width = 18  " Disable underscore mapping
let R_assign = 0

" auto-pairs ------------------------------------------------------------------
autocmd BufEnter * let b:autopairs_enabled = 0  " Disable by default
let g:AutoPairsFlyMode = 0
let g:AutoPairsShortcutBackInsert = '<M-b>'
let g:AutoPairsShortcutFastWrap = '<M-e>'
let g:AutoPairsShortcutToggle = '<M-p>'

" vim-move --------------------------------------------------------------------
" https://github.com/matze/vim-move
let g:move_key_modifier = 'M'  " don't know but somehow that <opt + cmd> works for macos

" jedi-vim --------------------------------------------------------------------
" Disable Jedi-vim autocompletion and enable call-signatures options since we have NCM2 for autocompletion.
let g:jedi#auto_initialization = 1
let g:jedi#completions_enabled = 0
let g:jedi#auto_vim_configuration = 0
let g:jedi#smart_auto_mappings = 0
let g:jedi#popup_on_dot = 0
let g:jedi#completions_command = ""
let g:jedi#show_call_signatures = "1"

let g:jedi#goto_command = "<leader>gg"
let g:jedi#goto_assignments_command = "<leader>ga"
let g:jedi#goto_definitions_command = "<leader>gd"
let g:jedi#documentation_command = "K"
let g:jedi#rename_command = "<leader>r"

" vim-isort -------------------------------------------------------------------
let g:vim_isort_map = '<C-i>'

" ctrlp-funky -----------------------------------------------------------------
let g:ctrlp_funky_matchtype = 'path'
let g:ctrlp_funky_syntax_highlight = 1
if Has_plugin('ctrlp-funky')
  nnoremap <Leader>fu :CtrlPFunky<Cr>
  nnoremap <Leader>fU :execute 'CtrlPFunky ' . expand('<cword>')<Cr>
endif

" vim-esearch -----------------------------------------------------------------
highlight ESearchMatch ctermfg=white ctermbg=204 guifg=#ffffff guibg=#FF3E7B

" incsearch.vim ---------------------------------------------------------------
" https://github.com/haya14busa/incsearch.vim/issues/79
if has('nvim')
  set inccommand=nosplit
endif

" vim-gitgutter ---------------------------------------------------------------
let g:gitgutter_enabled=1

" git-blame -------------------------------------------------------------------
nnoremap <Leader>s :<C-u>call gitblame#echo()<CR>

" quick-scope -----------------------------------------------------------------
" Trigger a highlight in the appropriate direction when pressing these keys:
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

highlight QuickScopePrimary guifg='#00C7DF' gui=underline ctermfg=155 cterm=underline
highlight QuickScopeSecondary guifg='#EF5F70' gui=underline ctermfg=81 cterm=underline

let g:qs_max_chars=150

" vim-yankstack ---------------------------------------------------------------
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
endif

" You can replace straight quotes in existing text with curly quotes, and visa versa
map <silent> <leader>qc <Plug>ReplaceWithCurly
map <silent> <leader>qs <Plug>ReplaceWithStraight

" LeaderF ---------------------------------------------------------------------
" don't show the help in normal mode
let g:Lf_HideHelp = 1
let g:Lf_UseCache = 0
let g:Lf_UseVersionControlTool = 0
let g:Lf_IgnoreCurrentBufferName = 1
" popup mode
let g:Lf_WindowPosition = 'popup'
let g:Lf_PreviewInPopup = 1
let g:Lf_StlSeparator = { 'left': "\ue0b0", 'right': "\ue0b2", 'font': "DejaVu Sans Mono for Powerline" }
let g:Lf_PreviewResult = {'Function': 0, 'BufTag': 0 }

let g:Lf_ShortcutF = "<leader>FF"
noremap <leader>fb :<C-U><C-R>=printf("Leaderf buffer %s", "")<CR><CR>
noremap <leader>fm :<C-U><C-R>=printf("Leaderf mru %s", "")<CR><CR>
noremap <leader>ft :<C-U><C-R>=printf("Leaderf bufTag %s", "")<CR><CR>
noremap <leader>fl :<C-U><C-R>=printf("Leaderf line %s", "")<CR><CR>

" noremap <C-B> :<C-U><C-R>=printf("Leaderf! rg --current-buffer -e %s ", expand("<cword>"))<CR>
" noremap <C-F> :<C-U><C-R>=printf("Leaderf! rg -e %s ", expand("<cword>"))<CR>

" Defx ------------------------------------------------------------------------

if Has_plugin('defx.nvim')
  autocmd FileType defx call s:defx_mappings()

  nmap <silent> <Leader>nn :Defx -columns=mark:indent:git:icons:filename:type -floating-preview <cr>

  call defx#custom#option('_', {
        \ 'winwidth': 40,
        \ 'split': 'vertical',
        \ 'direction': 'topleft',
        \ 'show_ignored_files': 0,
        \ 'buffer_name': '',
        \ 'toggle': 1,
        \ 'resume': 1
        \ })

  " defx-git
  call defx#custom#column('git', 'indicators', {
	\ 'Modified'  : '✹',
	\ 'Staged'    : '✚',
	\ 'Untracked' : '✭',
	\ 'Renamed'   : '➜',
	\ 'Unmerged'  : '═',
	\ 'Ignored'   : '☒',
	\ 'Deleted'   : '✖',
	\ 'Unknown'   : '?'
	\ })

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
    nnoremap <silent><buffer><expr> E
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
" let g:poetv_executables = ['poetry', 'pipenv']
" let g:poetv_auto_activate = 1
" let g:poetv_statusline_symbol = ''
" let g:poetv_set_environment = 1

" jremmen/vim-rigpgrep --------------------------------------------------------
if executable('rg')
  let g:rg_derive_root='true'
  let g:rg_root_types=['.git']
endif

" tpope/vim-fugitive ----------------------------------------------------------
" https://www.youtube.com/watch?v=PO6DxfGPQvw

" git status
nnoremap <leader>gs :G<CR>
nnoremap <leader>gf :diffget //2
nnoremap <leader>gj :diffget //3

" tpope/vim-commentary --------------------------------------------------------
if exists(':Commentary')
  nmap <localleader>/ :Commentary<CR>
  vmap <localleader>/ :Commentary<CR>
endif

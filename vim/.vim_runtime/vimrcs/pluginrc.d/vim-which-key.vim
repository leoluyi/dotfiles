" To register the descriptions when using the on-demand load feature,
" use the autocmd hook to call which_key#register(), e.g., register for the Space key:
autocmd! User vim-which-key
      \   call which_key#register(',', 'g:which_key_map')
      \ | call which_key#register('<Space>', 'g:which_key_map2')
" call which_key#register(',', "g:which_key_map")
" call which_key#register('<Space>', "g:which_key_map2")

" Map leader to which_key
autocmd BufEnter *
  \ if exists(':WhichKey')
  \ | execute "nnoremap <silent> <leader>      :<c-u>WhichKey ','<CR>"
  \ | execute "vnoremap <silent> <leader>      :<c-u>WhichKeyVisual ','<CR>"
  \ | execute "nnoremap <silent> <localleader> :<c-u>WhichKey '<Space>'<CR>"
  \ | execute "vnoremap <silent> <localleader> :<c-u>WhichKeyVisual '<Space>'<CR>"
  \ | endif

" Not a fan of floating windows for this
let g:which_key_use_floating_win = 0

" Hide status line
autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 noshowmode ruler

" Define a separator
let g:which_key_sep = '→'

" leader key ------------------------------------------------------------------
" Create map to add keys to
let g:which_key_map =  {}

" Hide a mapping from the menu
let g:which_key_map.0 = 'which_key_ignore'
let g:which_key_map.1 = 'which_key_ignore'
let g:which_key_map.2 = 'which_key_ignore'
let g:which_key_map.3 = 'which_key_ignore'
let g:which_key_map.4 = 'which_key_ignore'
let g:which_key_map.5 = 'which_key_ignore'
let g:which_key_map.6 = 'which_key_ignore'
let g:which_key_map.7 = 'which_key_ignore'
let g:which_key_map.8 = 'which_key_ignore'
let g:which_key_map.9 = 'which_key_ignore'
let g:which_key_map[','] = {
      \ 'name': 'which_key_ignore' }

let g:which_key_map['n']  = [ 'Hide Linenumber',                  'linenumber-hide'  ]
let g:which_key_map['N']  = [ 'Show Linenumber',                  'linenumber-show'  ]
let g:which_key_map['mm'] = [ "mmHmt:%s/<C-v><CR>//ge<CR>'tzt'm", 'Remove Windows ^M' ]
let g:which_key_map['nn'] = [':Defx',                             'defx-open']
let g:which_key_map['pp'] = [':setlocal paste!',                  'toggle-paste']
let g:which_key_map['a']  = [':e <C-r>=getcwd()<CR>/',            'new-file-in-current-buf-dir']
let g:which_key_map['A']  = [':e %:h/',                           'new-file-in-pwd']

" FZF.
let g:which_key_map['f'] = [ ':Files',   'fzf-files'     ]
let g:which_key_map['b'] = [ ':Buffers', 'fzf-buffers'   ]
let g:which_key_map['m'] = [ ':History', 'fzf-mru'       ]

let g:which_key_map['t'] = {
      \ 'name' : '+tabs',
      \ 'h': ['<C-w>t<C-w>H',                        'tab-vert-to-horiz'],
      \ 'k': ['<C-w>t<C-w>K',                        'tab-horiz-to-vert'],
      \ 'l': [':execute "tabn ".g:lasttab<CR>',      'toggle-last-tabs'],
      \ 'e': [':tabedit <C-r>=expand("%:p:h")<cr>/', 'tab-new-in-pwd'],
      \ }

let g:which_key_map['b'] = {
      \ 'name' : '+buffers',
      \ 'd' : [':Bclose',         'buffer-delete'],
      \ 'o' : [':Bdelete hidden', 'buffer-only'],
      \ 'a' : [':bufdo bd',       'delete-all-buffers'],
      \ 'h' : ['Startify',        'home-buffer'],
      \ }

let g:which_key_map['s'] = {
      \ 'name' : '+spellcheck' ,
      \ }

let g:which_key_map['c'] = {
      \ 'name' : '+quickfix' ,
      \ }

let g:which_key_map['F'] = {
      \ 'name' : '+buffers',
      \ 'F' : ['"Leaderf file',   'Leaderf-File'],
      \ 'B' : [':Leaderf buffer', 'Leaderf-Buffer'],
      \ 'M' : [':Leaderf mru',    'Leaderf-Mru'],
      \ 'T' : [':Leaderf bufTag', 'Leaderf-bufTag:'],
      \ 'L' : [':Leaderf line',   'Leaderf-Line'],
      \ }

let g:which_key_map['g'] = {
      \ 'name': '+git',
      \ }

let g:which_key_map['w'] = {
      \ 'name' : '+windows',
      \ 'w' : ['<C-W>w',     'other-window']          ,
      \ 'd' : ['<C-W>c',     'delete-window']         ,
      \ '-' : ['<C-W>s',     'split-window-below']    ,
      \ '|' : ['<C-W>v',     'split-window-right']    ,
      \ '2' : ['<C-W>v',     'layout-double-columns'] ,
      \ 'h' : ['<C-W>h',     'window-left']           ,
      \ 'j' : ['<C-W>j',     'window-below']          ,
      \ 'l' : ['<C-W>l',     'window-right']          ,
      \ 'k' : ['<C-W>k',     'window-up']             ,
      \ 'H' : ['<C-W>5<',    'expand-window-left']    ,
      \ 'J' : [':resize +5', 'expand-window-below']   ,
      \ 'L' : ['<C-W>5>',    'expand-window-right']   ,
      \ 'K' : [':resize -5', 'expand-window-up']      ,
      \ '=' : ['<C-W>=',     'balance-window']        ,
      \ 's' : ['<C-W>s',     'split-window-below']    ,
      \ 'v' : ['<C-W>v',     'split-window-below']    ,
      \ '?' : ['Windows',    'fzf-window']            ,
      \ }

" localleader -----------------------------------------------------------------
let g:which_key_map2 =  {}
let g:which_key_map2[''''] = ["viw<esc>`>a'<esc>`<i'<esc>", 'quote-single']
let g:which_key_map2['"'] = ['viw<esc>`>a"<esc>`<i"<esc>', 'quote-double']
let g:which_key_map2['gp'] = ['`[v`]', 're-select last paste']

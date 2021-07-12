" Load paths
let s:vim_runtime = expand('<sfile>:p:h')."/.."
" Load utils
runtime vimrcs/utils.vim

augroup VIM_WHICH_KEY
  " To register the descriptions when using the on-demand load feature,
  " use the autocmd hook to call which_key#register(), e.g., register for the Space key:
  autocmd! User vim-which-key
    \ if exists(':WhichKey') && !has('nvim')
    \ | call which_key#register(',', 'g:which_key_map')
    \ | call which_key#register('<Space>', 'g:which_key_map2')
  " call which_key#register(',', 'g:which_key_map')
  " call which_key#register('<Space>', 'g:which_key_map2')

  " Map leader to which_key
  autocmd! BufEnter *
    \ if exists(':WhichKey') && !has('nvim')
    \ | execute "nnoremap <silent> <leader>      :<c-u>WhichKey ','<CR>"
    \ | execute "vnoremap <silent> <leader>      :<c-u>WhichKeyVisual ','<CR>"
    \ | execute "nnoremap <silent> <localleader> :<c-u>WhichKey '<Space>'<CR>"
    \ | execute "vnoremap <silent> <localleader> :<c-u>WhichKeyVisual '<Space>'<CR>"
    \ | endif

  " Hide status line
  autocmd! FileType which_key
  autocmd  FileType which_key set laststatus=0 noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 noshowmode ruler
augroup END

" Not a fan of floating windows for this
let g:which_key_use_floating_win = 0

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

let g:which_key_map['n']  = [ '\<ESC>\<ESC>,n',  'linenumber-hide'  ]
let g:which_key_map['N']  = [ '\<ESC>\<ESC>,N',  'linenumber-show'  ]
let g:which_key_map['mm'] = [ '\<ESC>\<ESC>,mm',  'Remove Windows ^M' ]
let g:which_key_map['nn'] = [ '\<ESC>\<ESC>,nn',  'defx-open']
let g:which_key_map['pp'] = { 'name':  'toggle-paste'}
let g:which_key_map['a']  = { 'name':  'new-file-in-current-buf-dir'}
let g:which_key_map['A']  = { 'name':  'new-file-in-pwd'}

" FZF.
let g:which_key_map['f'] = { 'name':  'fzf-files'     }
let g:which_key_map['b'] = { 'name':  'fzf-buffers'   }
let g:which_key_map['m'] = { 'name':  'fzf-mru'       }

let g:which_key_map['t'] = {
      \ 'name' : '+tabs',
      \ 'h': { 'name': 'tab-vert-to-horiz' },
      \ 'k': { 'name': 'tab-horiz-to-vert' },
      \ 'l': { 'name': 'toggle-last-tabs' },
      \ 'e': { 'name': 'tab-new-in-pwd' },
      \ }

let g:which_key_map['b'] = {
      \ 'name' : '+buffers',
      \ 'c' : { 'name': 'buffer-delete'},
      \ 'd' : { 'name': 'close-current-buffer-window-split'},
      \ 'o' : { 'name': 'buffer-only'},
      \ 'a' : { 'name': 'delete-all-buffers'},
      \ 'h' : { 'name': 'home-buffer'},
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
      \ 'w' : { 'name': 'other-window' },
      \ 'd' : { 'name': 'delete-window' },
      \ '-' : { 'name': 'split-window-below' },
      \ '|' : { 'name': 'split-window-right' },
      \ '2' : { 'name': 'layout-double-columns' },
      \ 'h' : { 'name': 'window-left' },
      \ 'j' : { 'name': 'window-below' },
      \ 'l' : { 'name': 'window-right' },
      \ 'k' : { 'name': 'window-up' },
      \ 'H' : { 'name': 'expand-window-left' },
      \ 'J' : { 'name': 'expand-window-below' },
      \ 'L' : { 'name': 'expand-window-right' },
      \ 'K' : { 'name': 'expand-window-up' },
      \ '=' : { 'name': 'balance-window' },
      \ 's' : { 'name': 'split-window-below' },
      \ 'v' : { 'name': 'split-window-below' },
      \ '?' : { 'name': 'fzf-window' },
      \ }

" localleader -----------------------------------------------------------------
let g:which_key_map2 =  {}
let g:which_key_map2[''''] = { 'name':  'quote-single' }
let g:which_key_map2['"']  = { 'name':  'quote-double' }
let g:which_key_map2['gp'] = { 'name':  're-select last paste' }

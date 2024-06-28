" Load paths
let s:vim_runtime = expand('<sfile>:p:h')."/.."
" Load utils
runtime vimrcs/utils.vim

" mg979/vim-visual-multi --------------------------------------------------{{{2
" https://github.com/mg979/vim-visual-multi/wiki/Mappings
let g:VM_default_mappings = 0
let g:VM_maps = {}

let g:VM_maps['Find Under']                  = '<C-n>'
let g:VM_maps['Find Subword Under']          = '<C-n>'
let g:VM_maps['Select All']                  = '\\A'
let g:VM_maps['Start Regex Search']          = '\\/'

let g:VM_maps['Skip Region']                 = 'q'
let g:VM_maps['Remove Region']               = '<backspace>'
let g:VM_maps['Invert Direction']            = 'o'

let g:VM_maps['Add Cursor Down']             = '<C-Down>'
let g:VM_maps['Add Cursor Up']               = '<C-Up>'
let g:VM_maps['Add Cursor At Pos']           = '\\\'
let g:VM_maps['Select Cursor Down']          = '<C-Down>'      " start selecting down
let g:VM_maps['Select Cursor Up']            = '<C-Up>'        " start selecting up

let g:VM_maps['Visual Regex']                = '\\/'
let g:VM_maps['Visual All']                  = '\\A'
let g:VM_maps['Visual Add']                  = '\\a'
let g:VM_maps['Visual Find']                 = '\\f'
let g:VM_maps['Visual Cursors']              = '\\c'

let g:VM_maps['Switch Mode']                 = '<Tab>'

" Enable undo/redo changes made in VM
let g:VM_maps['Undo'] = 'u'
let g:VM_maps['Redo'] = '<C-r>'

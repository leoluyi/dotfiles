""""""""""""""""""""""""""""""
" => Python section
""""""""""""""""""""""""""""""
let python_highlight_all = 1
syntax keyword pythonDecorator True None False self

inoremap <buffer> $f # --- <esc>a
map <buffer> <leader>C ?class<Space>
map <buffer> <leader>D ?def<Space>
set cindent
set cinkeys-=0#
set indentkeys-=0#
setlocal shiftwidth=4


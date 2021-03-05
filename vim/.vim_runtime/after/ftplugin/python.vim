""""""""""""""""""""""""""""""
" => Python section
""""""""""""""""""""""""""""""
let python_highlight_all = 1
syntax keyword pythonDecorator True None False self

inoremap <buffer> $f # --- <esc>a
map <buffer> <leader>C /class<Space>
map <buffer> <leader>D /def<Space>

set cindent
set cinkeys-=0#
set indentkeys-=0#
setlocal nowrap
setlocal shiftwidth=4

" Use the below highlight group when displaying bad whitespace is desired.
highlight BadWhitespace ctermbg=cyan guibg=cyan
" Display tabs at the beginning of a line in Python mode as bad.
autocmd BufRead,BufNewFile *.py,*.pyw match BadWhitespace /^\t\+/
" Make trailing whitespace be flagged as bad.
autocmd BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/
augroup END

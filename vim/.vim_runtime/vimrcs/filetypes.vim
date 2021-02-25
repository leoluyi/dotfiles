""""""""""""""""""""""""""""""
" => sh section
""""""""""""""""""""""""""""""
au FileType sh setlocal shiftwidth=2

""""""""""""""""""""""""""""""
" => vim section
""""""""""""""""""""""""""""""
au FileType vim setlocal shiftwidth=2

""""""""""""""""""""""""""""""
" => markdown section
""""""""""""""""""""""""""""""
au FileType markdown setlocal shiftwidth=4

""""""""""""""""""""""""""""""
" => R section
""""""""""""""""""""""""""""""
let r_indent_align_args = 0
au FileType r setlocal shiftwidth=2

""""""""""""""""""""""""""""""
" => Python section
""""""""""""""""""""""""""""""
let python_highlight_all = 1
au FileType python syn keyword pythonDecorator True None False self

au BufNewFile,BufRead *.jinja set syntax=htmljinja
au BufNewFile,BufRead *.mako set ft=mako

" automatic fold based on the indentation
au FileType python map <buffer> <leader>F :set foldmethod=indent<cr>

au FileType python inoremap <buffer> $r return<Space>
au FileType python inoremap <buffer> $i import<Space>
au FileType python inoremap <buffer> $p print<Space>
au FileType python inoremap <buffer> $f # --- <esc>a
au FileType python map <buffer> <leader>1 /class<Space>
au FileType python map <buffer> <leader>2 /def<Space>
au FileType python map <buffer> <leader>C ?class<Space>
au FileType python map <buffer> <leader>D ?def<Space>
au FileType python set cindent
au FileType python set cinkeys-=0#
au FileType python set indentkeys-=0#
au FileType python setlocal shiftwidth=4

""""""""""""""""""""""""""""""
" => sql section
"""""""""""""""""""""""""""""""
au FileType sql setlocal shiftwidth=2

""""""""""""""""""""""""""""""
" => JavaScript section
"""""""""""""""""""""""""""""""
au FileType javascript call JavaScriptFold()
au FileType javascript setl fen
au FileType javascript setl nocindent

au FileType javascript imap <C-t> $log();<esc>hi
au FileType javascript imap <C-a> alert();<esc>hi

au FileType javascript inoremap <buffer> $r return<Space>
au FileType javascript inoremap <buffer> $f // --- PH<esc>FP2xi

function! JavaScriptFold()
    setl foldmethod=syntax
    setl foldlevelstart=1
    syn region foldBraces start=/{/ end=/}/ transparent fold keepend extend

    function! FoldText()
        return substitute(getline(v:foldstart), '{.*', '{...}', '')
    endfunction
    setl foldtext=FoldText()
endfunction


""""""""""""""""""""""""""""""
" => CoffeeScript section
"""""""""""""""""""""""""""""""
function! CoffeeScriptFold()
    setl foldmethod=indent
    setl foldlevelstart=1
endfunction
au FileType coffee call CoffeeScriptFold()

au FileType gitcommit call setpos('.', [0, 1, 1, 0])


""""""""""""""""""""""""""""""
" => Shell section
""""""""""""""""""""""""""""""
if exists('$TMUX')
    if has('nvim')
        set termguicolors
    else
        set term=screen-256color
    endif
endif


""""""""""""""""""""""""""""""
" => Twig section
""""""""""""""""""""""""""""""
autocmd BufRead *.twig set syntax=html filetype=html


""""""""""""""""""""""""""""""
" => Markdown
""""""""""""""""""""""""""""""
let vim_markdown_folding_disabled = 1

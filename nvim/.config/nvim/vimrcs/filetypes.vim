""""""""""""""""""""""""""""""
" => shiftwidth
" < https://stackoverflow.com/a/1878983/3744499 >
""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""
" => html
""""""""""""""""""""""""""""""

augroup HtmlSetup
  autocmd!
  " Fix slow syntax highlighting.
  au FileType html set synmaxcol=128 lazyredraw nocursorline
  au FileType html syntax sync minlines=256
augroup END

""""""""""""""""""""""""""""""
" => Quickfix
""""""""""""""""""""""""""""""
au FileType qf set nobuflisted

""""""""""""""""""""""""""""""
" => Hive
""""""""""""""""""""""""""""""
au BufNewFile,BufRead *.hql set filetype=hive

""""""""""""""""""""""""""""""
" => Markdown
""""""""""""""""""""""""""""""
let vim_markdown_folding_disabled = 1

""""""""""""""""""""""""""""""
" => R section
""""""""""""""""""""""""""""""
let r_indent_align_args = 0

""""""""""""""""""""""""""""""
" => Python section
""""""""""""""""""""""""""""""
au BufNewFile,BufRead *.jinja set syntax=htmljinja

""""""""""""""""""""""""""""""
" => JavaScript section
"""""""""""""""""""""""""""""""
au FileType javascript call JavaScriptFold()
au FileType javascript setl fen
au FileType javascript setl nocindent

function! JavaScriptFold()
    setl foldmethod=syntax
    setl foldlevelstart=1
    syn region foldBraces start=/{/ end=/}/ transparent fold keepend extend

    function! FoldText()
        return substitute(getline(v:foldstart), '{.*', '{...}', '')
    endfunction
    setl foldtext=FoldText()
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => CSS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set omnifunc=syntaxcomplete#Complete
autocmd FileType css set omnifunc=csscomqlete#CompleteCSS

" Tips:
" To use omni completion, type <C-X><C-O> while open in Insert mode. If matching
" names are found, a pop-up menu opens which can be navigated using the <C-N>
" and <C-P> keys.

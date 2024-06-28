" Load paths
let s:vim_runtime = expand('<sfile>:p:h')."/.."
" Load utils
runtime vimrcs/utils.vim

" close-buffers.vim -------------------------------------------------------{{{2
augroup CloseBuffersConfig
  autocmd!
  autocmd VimEnter *
    \ if exists(':Bdelete')
    \ | execute "nnoremap <silent> Q :Bdelete menu<CR>"
    \ | execute "nnoremap <leader>bo :Bdelete other<CR>"
    \ | endif
augroup END


" Load paths
let s:vim_runtime = expand('<sfile>:p:h')."/.."
" Load utils
runtime vimrcs/utils.vim

" vim-markdown ------------------------------------------------------------{{{2
let g:vim_markdown_auto_insert_bullets = 1
let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_math = 1
let g:vim_markdown_new_list_item_indent = 0
" disable key mappings.
map <Plug> <Plug>Markdown_OpenUrlUnderCursor

augroup VimMarkdown
  autocmd!
  " autocmd FileType markdown
  "       \ setlocal formatlistpat=^\\s*\\d\\+[.\)]\\s\\+\\\|^\\s*[*+~-]\\s\\+\\\|^\\(\\\|[*#]\\)\\[^[^\\]]\\+\\]:\\s |
  "       \ setlocal formatoptions-=q
  autocmd FileType markdown setlocal comments=fb:*,fb:+,fb:-,n:> indentexpr=
  autocmd FileType markdown
      \ if exists(':HeaderDecrease')
      \ |   execute('nnoremap <Localleader>= :<C-u>.HeaderIncrease<CR>')
      \ |   execute('nnoremap <Localleader>- :<C-u>.HeaderDecrease<CR>')
      \ |   execute('vnoremap <Localleader>= :HeaderIncrease<CR>')
      \ |   execute('vnoremap <Localleader>- :HeaderDecrease<CR>')
      \ | endif
augroup END

" < https://github.com/preservim/vim-markdown/issues/232 > - Rewrapping a bullet point inserts new bullet points
" < https://github.com/preservim/vim-markdown/issues/390 > - gq wrapping is still broken

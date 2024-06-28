" Load paths
let s:vim_runtime = expand('<sfile>:p:h')."/.."
" Load utils
runtime vimrcs/utils.vim

" quick-scope -------------------------------------------------------------{{{2
" Trigger a highlight in the appropriate direction when pressing these keys:
let g:qs_lazy_highlight = 1
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
let g:qs_max_chars=120
let g:qs_buftype_blacklist = ['terminal', 'nofile', 'alpha', 'dashboard', 'startify']

augroup QuickScopeConfig
  autocmd!
  autocmd ColorScheme * highlight QuickScopePrimary guifg=#00C7DF gui=underline ctermfg=155 cterm=underline
  autocmd ColorScheme * highlight QuickScopeSecondary guifg=#EF5F70 gui=underline ctermfg=81 cterm=underline
augroup END

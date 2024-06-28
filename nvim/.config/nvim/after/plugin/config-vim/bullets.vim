" Load paths
let s:vim_runtime = expand('<sfile>:p:h')."/.."
" Load utils
runtime vimrcs/utils.vim

" dkarter/bullets.vim -----------------------------------------------------{{{2

if IsPlugged('bullets.vim')
  let g:bullets_enabled_file_types = [
      \ 'markdown',
      \ 'text',
      \ 'gitcommit',
      \ 'scratch'
      \]

  let g:bullets_enable_in_empty_buffers = 0
  let g:bullets_set_mappings = 1

  let g:bullets_outline_levels = ['num', 'std-', 'std*', 'std+']
endif


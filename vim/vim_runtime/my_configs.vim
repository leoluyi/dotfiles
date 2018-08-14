set number relativenumber

" Automatic toggling between line number modes
" https://jeffkreeftmeijer.com/vim-number/
:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

" multi_cursor - default mapping
let g:multi_cursor_start_word_key      = '<C-n>'
let g:multi_cursor_select_all_word_key = '<A-n>'
let g:multi_cursor_select_all_word_key = '<Esc>n'
let g:multi_cursor_start_key           = 'g<C-n>'
let g:multi_cursor_select_all_key      = 'g<A-n>'
let g:multi_cursor_select_all_key      = 'g<Esc>n'
let g:multi_cursor_next_key            = '<C-n>'
let g:multi_cursor_prev_key            = '<C-p>'
let g:multi_cursor_skip_key            = '<C-x>'
let g:multi_cursor_quit_key            = '<Esc>'

" Allow saving of files as sudo when I forgot to start vim using sudo
cmap w!! w !sudo tee > /dev/null %

" vim-indent-guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1

" braceless.vim
autocmd FileType python BracelessEnable +indent


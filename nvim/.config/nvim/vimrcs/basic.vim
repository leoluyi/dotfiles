" vim: fdm=marker:fdl=1
" Use zR to expand all foldings.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Maintainer:
"       Lu Yi - @leoluyi
"
" Sections:
" => Key Mappings
" => General abbreviations
" => Custom commands
" => Helper functions
" => References
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Key Mappings {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" -> Map normal mode commands to insert mode {{{2
"--------------------------
""" Shell readline key bindings borrowed from 'tpope/vim-rsi'
" https://github.com/tpope/vim-rsi/blob/master/plugin/rsi.vim
inoremap        <C-a> <C-o>^
inoremap   <C-x><C-a> <C-a>
cnoremap        <C-a> <Home>
cnoremap   <C-x><C-a> <C-A>

inoremap <expr> <C-b> getline('.')=~'^\s*$'&&col('.')>strlen(getline('.'))?"0\<Lt>C-D>\<Lt>Esc>kJs":"\<Lt>Left>"
cnoremap        <C-b> <Left>

inoremap <expr> <C-d> col('.')>strlen(getline('.'))?"\<Lt>C-D>":"\<Lt>Del>"
cnoremap <expr> <C-d> getcmdpos()>strlen(getcmdline())?"\<Lt>C-D>":"\<Lt>Del>"

inoremap <expr> <C-e> col('.')>strlen(getline('.'))<bar><bar>pumvisible()?"\<Lt>C-E>":"\<Lt>End>"

inoremap <expr> <C-f> col('.')>strlen(getline('.'))?"\<Lt>C-F>":"\<Lt>Right>"
cnoremap <expr> <C-f> getcmdpos()>strlen(getcmdline())?&cedit:"\<Lt>Right>"

""" Bash like keys for the command line
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" -> Moving around, tabs, windows and buffers {{{2
"----------------------------

""" Switch between buffers.
" nnoremap <leader>b :ls<CR>:b<Space>
nnoremap <leader><Tab> <C-^>
nnoremap <C-6> <C-^>

" Close all the buffers
nnoremap <leader>ba :bufdo bd<cr>

" Close current buffer and close the window split.
nnoremap <leader>bd :bd<CR>

""" Close a buffer without closing the window.
" < https://stackoverflow.com/a/19619038/3744499 >
" (Close the current buffer and move to the alternative one)
if exists(':Bclose')
  nnoremap <leader>bc :Bclose<CR>
else
  nnoremap <leader>bc :b#<bar>bd#<CR>
endif

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
  let l:currentBufNum = bufnr("%")
  let l:alternateBufNum = bufnr("#")

  if buflisted(l:alternateBufNum)
    buffer #
  else
    bnext
  endif

  if bufnr("%") == l:currentBufNum
    new
  endif

  if buflisted(l:currentBufNum)
    execute("bdelete! ".l:currentBufNum)
  endif
endfunction

"----------------------------
" -> Code editing stuffs {{{2
"----------------------------

" Move selection to a separate file.
" < https://superuser.com/a/540488/642743 >
" command! -bang -range -nargs=1 -complete=file MoveWrite  <line1>,<line2>write<bang> <args> | <line1>,<line2>delete _ | edit <args>
" command! -bang -range -nargs=1 -complete=file MoveAppend <line1>,<line2>write<bang> >> <args> | <line1>,<line2>delete _ | edit <args>
command! -bang -range -nargs=0 MoveNewBuffer <line1>,<line2>delete m | enew | 0put!m
command! -bang -range -nargs=1 -complete=file MoveAppendFile <line1>,<line2>delete m | edit <args> | $put!m

" < https://vim.fandom.com/wiki/Increasing_or_decreasing_numbers >
" search for the next number.
nnoremap <silent>              g<C-a> <C-a>
nnoremap <silent>              g<C-x> <C-x>
nnoremap <silent>              <C-a> :<C-u>call AddSubtract("\<C-a>", '')<CR>
nnoremap <silent> <Localleader><C-a> :<C-u>call AddSubtract("\<C-a>", 'b')<CR>
nnoremap <silent>              <C-x> :<C-u>call AddSubtract("\<C-x>", '')<CR>
nnoremap <silent> <Localleader><C-x> :<C-u>call AddSubtract("\<C-x>", 'b')<CR>

function! AddSubtract(char, back)
  " let pattern = &nrformats =~ 'alpha' ? '[[:alpha:][:digit:]]' : '[[:digit:]]'
  let pattern = '[[:digit:]]'
  call search(pattern, 'cw' . a:back)
  execute 'normal! ' . v:count1 . a:char
  silent! call repeat#set(":\<C-u>call AddSubtract('" .a:char. "', '" .a:back. "')\<CR>")
endfunction

""" <F5> -  Remove all trailing whitespace. https://vim.fandom.com/wiki/Remove_unwanted_spaces
" nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>:echo 'Remove trailing whitespace'<CR>

""" Re-indent current buffer
function! ReindentAll()
  let l:save = winsaveview()
  execute 'normal gg=G'
  call winrestview(l:save)
endfunction

command! ReindentAll :call ReindentAll()
nmap <localleader>R <cmd>ReindentAll<cr>


"--------------------------
" -> Fix unwanted key map {{{2
"--------------------------

try
  inoremap <C-@> <Esc>
catch
endtry
" }}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Custom commands {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Commands {{{2
command! -range Opencc <line1>,<line2>call Opencc()
command! -range Reverse <line1>,<line2>call Reverse()
command! EmptyRegisters call EmptyRegisters()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" OpenCC {{{2
"--------------------------
function! Opencc() range
  let l:save = winsaveview()
  let l:search = @/

  if a:firstline == a:lastline
    execute '%!opencc'
  else
    execute a:firstline . "," . a:lastline . '!opencc'
  endif

  let @/ = l:search
  call winrestview(l:save)
endfunction

" Reverse selected range {{{2
"--------------------------
function! Reverse() range
  let l:search = @/
  call feedkeys(":" . a:firstline . "," . a:lastline . "g/^/m " . (a:firstline-1) . "|nohl" . "\<CR>")
  let @/ = l:search
endfunction

" EmptyRegisters {{{2
"--------------------------
function! EmptyRegisters()
  let regs=split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '\zs')
  for r in regs
    call setreg(r, [])
  endfor
endfun
" }}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => References {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" https://hackmd.io/@AlexSu/ryLuYmwYm?type=view
" https://github.com/craftzdog/dotfiles-public
" https://www.youtube.com/watch?v=w7i4amO_zaE&t=1246s
" https://www.youtube.com/watch?v=stqUbv-5u2s

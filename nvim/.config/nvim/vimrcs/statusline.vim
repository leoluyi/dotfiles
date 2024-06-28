" https://www.nkantar.com/blog/my-vim-statusline/
" https://shapeshed.com/vim-statuslines/

" let g:currentmode={
"       \ 'n'  : 'N ',
"       \ 'v'  : 'V ',
"       \ 'V'  : 'VL ',
"       \ "\<C-V>" : 'VB ',
"       \ 'i'  : 'I ',
"       \ 'R'  : 'R ',
"       \ 'Rv' : 'VR ',
"       \ 'c'  : 'C ',
"       \}

function! StatuslineGit()
  let l:branchname = <SID>GitBranch()
  return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

function! s:GitBranch()
  return '(' . system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'") . ')'
endfunction

function! PasteForStatusline()
    let paste_status = &paste
    if paste_status == 1
        return "\ [paste]"
    else
        return ""
    endif
endfunction

function! IsBinary()
    if (&binary == 0)
        return ""
    else
        return "[Binary]"
    endif
endfunction

function! FileSize()
    let bytes = getfsize(expand("%:p"))
    if bytes <= 0
        return "[Empty]"
    endif
    if bytes < 1024
        return "[" . bytes . "B]"
    elseif bytes < 1048576
        return "[" . (bytes / 1024) . "KB]"
    else
        return "[" . (bytes / 1048576) . "MB]"
    endif
endfunction

hi StatusLineNC guifg=#3c3836 guibg=#a89984 gui=reverse cterm=reverse
hi NormalColor guifg=#7c6f64 guibg=#fbf1c7 gui=reverse cterm=reverse
hi InsertColor guifg=#076678 guibg=#fbf1c7 gui=reverse cterm=reverse
hi ReplaceColor guifg=#427b58 guibg=#fbf1c7 gui=reverse cterm=reverse
hi VisualColor guifg=#af3a03 guibg=#fbf1c7 gui=reverse cterm=reverse
hi CommandMode guifg=#8f3f71 guibg=#fbf1c7 gui=reverse cterm=reverse
hi Warnings guifg=#af3a03 guibg=#fbf1c7 gui=reverse cterm=reverse

if has('statusline')

    set statusline=

    " current mode
    set statusline+=%#NormalColor#%{(mode()=='n')?'\ \ N\ ':''}
    set statusline+=%#InsertColor#%{(mode()=='i')?'\ \ I\ ':''}
    set statusline+=%#ReplaceColor#%{(mode()=='R')?'\ \ R\ ':''}
    set statusline+=%#VisualColor#%{(mode()=='v')?'\ \ V\ ':''}
    set statusline+=%#VisualColor#%{(mode()=='\<C-v>')?'\ \ VB\ ':''}

    set statusline+=%#StatusLineNC#               " set highlighting
    set statusline+=%{PasteForStatusline()}       " paste flag
    set statusline+=%{StatuslineGit()}

    "set statusline+=%#Cursor#                     " set highlighting
    set statusline+=%#LineNr#
    set statusline+=\                             " blank space
    set statusline+=%<                            " left-align
    set statusline+=%F                            " current file path
    set statusline+=%#Question#                   " set highlighting
    set statusline+=\                             " blank space
    set statusline+=%h%m%r%w\                     " flags

    set statusline+=%=                            " right-align from now on

    set statusline+=%-7.(%l:%c\/%L%V%)\ %<%P      " cursor position/offset
    set statusline+=\                             " blank space
    set statusline+=%{FileSize()}%{IsBinary()}
    set statusline+=\                             " blank space

    set statusline+=%#CursorColumn#
    set statusline+=\ [%{strlen(&ft)?&ft:'none'}\|  " file type
    set statusline+=%{(&fenc==\"\"?&enc:&fenc)}\| " encoding
    set statusline+=%{&fileformat}%{\"\".((exists(\"+bomb\")\ &&\ &bomb)?\",BOM\":\"\").\"\"}]
    set statusline+=\                             " blank space

    set statusline+=%#warningmsg#                 " Syntastic error flag
    set statusline+=%*                            " Syntastic error flag

  " set statusline=
  " set statusline+=%1*
  " " Show current mode
  " set statusline+=%#PmenuSel#
  " set statusline+=\ %{toupper(g:currentmode[mode()])}
  " set statusline+=%{&spell?'[SPELL]':''}

  " set statusline+=%#WarningMsg#
  " set statusline+=%{&paste?'\ \ [PASTE]':''}
  " set statusline+=%#LineNr#
  " set statusline+=%{StatuslineGit()}

  " set statusline+=%2*
  " " File path, as typed or relative to current directory
  " set statusline+=%#CursorColumn#
  " set statusline+=\ %<%f

  " set statusline+=%{&modified?'\ [+]':''}
  " set statusline+=%{&readonly?'\ []':''}

  " " Truncate line here
  " set statusline+=%<

  " " Separation point between left and right aligned items.
  " set statusline+=%=

  " " Encoding & Fileformat
  " set statusline+=%0*
  " set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
  " set statusline+=\ \|\ %{&fileformat}
  " set statusline+=\ \|\ %{&filetype!=#''?&filetype.'\ ':'none\ '}

  " " Warning about byte order
  " set statusline+=%#WarningMsg#
  " set statusline+=%{&bomb?'[BOM]':''}

  " set statusline+=%0*
  " set statusline+=%#LineNr#
  " set statusline+=\ %2p%%\      " Percentage
  " set statusline+=%#PmenuSel#
  " set statusline+=\ %3l:%2c\    " Location of cursor line

endif

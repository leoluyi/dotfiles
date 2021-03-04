"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Check pynvim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" See :help g:python3_host_prog
" See https://github.com/deoplete-plugins/deoplete-jedi/wiki/Setting-up-Python-for-Neovim#using-virtual-environments
" If you plan to use per-project virtualenvs often, you should assign one
"  virtualenv for Neovim and hard-code the interpreter path via
"  g:python3_host_prog (or g:python_host_prog) so that the "pynvim" package
"  is not required for each virtualenv.
"
"  Example using pyenv:
"    ¦ pyenv install 3.4.4
"    ¦ pyenv virtualenv 3.4.4 py3nvim
"    ¦ pyenv activate py3nvim
"    ¦ pip install pynvim
"    ¦ pyenv which python  # Note the path
"  The last command reports the interpreter path, add it to your init.vim:
"    ¦ let g:python3_host_prog = '/path/to/py3nvim/bin/python'
let s:user_home = expand('~/')
let s:python3_host_prog = s:user_home . '.pyenv/versions/py3nvim/bin/python'

if executable(s:python3_host_prog)
  let g:python3_host_prog = s:python3_host_prog
endif

if has("nvim") && !has("python3")
  echo "[python3] Installing pynvim (required for ncm2) ...\n"
  silent !python3 -m pip --disable-pip-version-check -q install --no-cache-dir --user -U pynvim
endif

#!/usr/bin/env bash

# See :help g:python3_host_prog
# See https://github.com/deoplete-plugins/deoplete-jedi/wiki/Setting-up-Python-for-Neovim#using-virtual-environments
# If you plan to use per-project virtualenvs often, you should assign one
#  virtualenv for Neovim and hard-code the interpreter path via
#  g:python3_host_prog (or g:python_host_prog) so that the "pynvim" package
#  is not required for each virtualenv.

if command -v pyenv &>/dev/null && command -v pyenv-virtualenv &>/dev/null; then
  pyenv install --skip-existing 3.8.7 && pyenv virtualenv 3.8.7 py3nvim
  pyenv activate py3nvim && pip install --no-cache-dir -U neovim pynvim jedi black flake8 autopep8
  pyenv deactivate &>/dev/null

  # pyenv which python  # Note the path

  # The last command reports the interpreter path, add it to your init.vim:
  # let g:python3_host_prog = '/path/to/py3nvim/bin/python'
else
  echo -e "Command 'pyenv' or 'pyenv-virtualenv' not found. Please install 'pyenv' and run this script again."
fi

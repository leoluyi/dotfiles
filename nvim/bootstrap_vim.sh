#!/usr/bin/env bash

cat <<EOF
$(tput setaf 7)If you plan to use per-project virtualenvs often, you should assign one
virtualenv for Neovim and hard-code the interpreter path via
g:python3_host_prog (or g:python_host_prog) so that the "pynvim" package
is not required for each virtualenv.

# See --
# :help g:python3_host_prog
# https://github.com/deoplete-plugins/deoplete-jedi/wiki/Setting-up-Python-for-Neovim#using-virtual-environments
$(tput sgr0)
EOF

if command -v pyenv >/dev/null; then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"

  echo -e "$(tput setaf 2)Installing venv by pyenv for 'g:python3_host_prog' ...$(tput sgr 0)"
  pyenv install --skip-existing 3.8.7 && pyenv virtualenv 3.8.7 py3nvim
  echo -e "$(tput setaf 2)Installing python packages in venv ...$(tput sgr 0)"
  pyenv activate py3nvim && pip --disable-pip-version-check install --no-cache-dir -U neovim jedi black flake8 autopep8 isort

  echo -e "\n$(tput setaf 2)Finished. Note the python path and add it to your 'init.vim' as below: $(tput setaf 3)\nlet g:python3_host_prog = '$(pyenv which python)'\n$(tput sgr 0)"
  # The last command reports the interpreter path, add it to your init.vim:
  # let g:python3_host_prog = '/path/to/py3nvim/bin/python'

  pyenv deactivate 2>/dev/null
else
  echo -e "Command 'pyenv' or 'pyenv-virtualenv' not found. Please install them and run this script again."
fi

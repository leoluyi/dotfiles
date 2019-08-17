#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")" || exit 1;

if [ "$1" == "--force" ] || [ "$1" == "-f" ]; then
  FORCE="-f"
fi


function install_pyenv {
  echo "$(tput setaf 2)###### Install Pyenv ######$(tput sgr 0)"
  curl https://pyenv.run | bash
}


function link_virtualenv {
  echo "$(tput setaf 2)###### Link Virtualenv Path ######$(tput sgr 0)"
  mkdir -p ~/.local/share/virtualenvs
  VENV_FOLDER="${HOME}/.virtualenvs"

  [[ -L "$VENV_FOLDER" && -d "$VENV_FOLDER" ]] || ln -sf ~/.local/share/virtualenvs "$VENV_FOLDER"
}


function subl_settings {
  echo "$(tput setaf 2)###### Sublime Text Settings ######$(tput sgr 0)"
  # Fix bad Anaconda completion
  # https://github.com/DamnWidget/anaconda#auto-complete-for-import-behaves-badly

  SUBL_CONFIG_PATH=~/.config/sublime-text-3

  mkdir -p "${SUBL_CONFIG_PATH}/Packages/Python" && \
    curl -fsSL -o "${SUBL_CONFIG_PATH}/Packages/Python/Completion Rules.tmPreferences" \
      https://raw.githubusercontent.com/DamnWidget/anaconda/master/Completion%20Rules.tmPreferences

  rm -f "${SUBL_CONFIG_PATH}/Cache/Python/Completion Rules.tmPreferences.cache"
}


function install_vim_awesome {
  echo "$(tput setaf 2)###### Install Vim Awesome ######$(tput sgr 0)"

  if [ "$1" == "-f" ]; then
    echo 'Removing: ~/.vim*'
    rm -rf ~/.vim*
  fi

  if [ ! -d ~/.vim_runtime ]; then
    git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
    bash ~/.vim_runtime/install_awesome_vimrc.sh
  else
    echo "Awesome Vim is already installed."
  fi
}


function install_tmux_awesome {
  echo "$(tput setaf 2)###### Tmux Settings ######$(tput sgr 0)"

  # Install .tmux awesome
  if [ "$1" == "-f" ]; then
    echo 'Removing: ~/.tmux'
    rm -rf ~/.tmux
  fi

  if [ ! -d ~/.tmux ]; then
    git clone https://github.com/gpakosz/.tmux.git ~/.tmux
  else
    echo ".tmux awesome is already installed."
  fi

  if [ -f ~/.tmux/.tmux.conf ] && [ -f ~/.tmux/tmux.conf.local ]; then
    ln -sf ~/.tmux/.tmux.conf ~/.tmux.conf && \
      cp ~/.tmux/.tmux.conf.local ~/.tmux.conf.local
  fi

  # Install Tmux Plugin Manager
  if [ ! -d ~/.tmux/plugins/tpm ]; then
    echo "Installing tmux plugins manager ..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && \
      ~/.tmux/plugins/tpm/bin/install_plugins
  else
    ~/.tmux/plugins/tpm/bin/install_plugins
  fi
}


function _sync_dotfile {
  # rsync --exclude ".git/" \
  #   --exclude ".DS_Store" \
  #   --exclude ".osx" \
  #   --exclude "bootstrap.sh" \
  #   --exclude "README.md" \
  #   --exclude "LICENSE-MIT.txt" \
  #   -avh --no-perms macOS/bash_{profile,rc} ~;
  cp bash-git-prompt/.[!.]* ~;
  cp git/.[!.]* ~;
  cp tmux/.[!.]* ~;
  cp ubuntu/* ~;
  cp vim/vim_runtime/my_configs.vim ~/.vim_runtime/my_configs.vim
  cp vim/vim_runtime/vimrcs/* ~/.vim_runtime/vimrcs/
}


function sync_dotfile {
  echo "$(tput setaf 2)###### Update dotfiles ######$(tput sgr 0)"
  echo "Syncing dotfiles ..."

  if [ "$1" == "-f" ]; then
    _sync_dotfile;
  else
    read -rp "$(tput setaf 3)This may overwrite existing files in your home directory. Are you sure? (y/N) $(tput sgr 0)";
    echo "";
    if [[ $REPLY =~ ^[Yy](es)?$ ]]; then
      _sync_dotfile;
    fi;
  fi;
}


subl_settings
link_virtualenv
install_pyenv
install_vim_awesome $FORCE
install_tmux_awesome $FORCE
sync_dotfile $FORCE

unset \
  subl_settings \
  link_virtualenv \
  install_pyenv \
  install_vim_awesome \
  install_tmux_awesome \
  sync_dotfile


echo "$(tput setaf 2)###### Source Bash Settings ######$(tput sgr 0)"

source ~/.bash_profile;

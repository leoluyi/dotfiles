#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")" || exit 1;

os_name="$(uname -s)"
case "${os}" in
    Linux*)     machine=linux;;
    Darwin*)    machine=macos;;
    CYGWIN*)    machine=windows;;
    MINGW*)     machine=windows;;
    *)          machine="UNKNOWN:${os}"
esac

[ "$machine" = "linux" ] || exit 1;

if [ "$1" == "--force" ] || [ "$1" == "-f" ]; then
  FORCE="-f"
fi


function link_virtualenv {
  echo "$(tput setaf 2)###### Link Virtualenv Path ######$(tput sgr 0)"
  mkdir -p ~/.local/share/virtualenvs
  VENV_FOLDER="${HOME}/.virtualenvs"

  [[ -L "$VENV_FOLDER" && -d "$VENV_FOLDER" ]] || ln -sf ~/.local/share/virtualenvs "$VENV_FOLDER"
}


function subl_settings {
  echo "$(tput setaf 2)###### Sublime Text Settings ######$(tput sgr 0)"
  SUBL_CONFIG_PATH=~/.config/sublime-text-3
  SUBL_SETTINGS="${SUBL_CONFIG_PATH}/Packages/User"

  ## Sync settings
  mkdir -p $SUBL_SETTINGS
  cp ./sublime-text/package_sync_linux/* $SUBL_SETTINGS

  # Fix bad Anaconda completion
  # https://github.com/DamnWidget/anaconda#auto-complete-for-import-behaves-badly
  py_completion="${SUBL_CONFIG_PATH}/Packages/Python/Completion Rules.tmPreferences"
  if [ ! -f "$py_completion" ]; then
    mkdir -p "${SUBL_CONFIG_PATH}/Packages/Python" && \
      curl -fsSL -o $py_completion \
        https://raw.githubusercontent.com/DamnWidget/anaconda/master/Completion%20Rules.tmPreferences && \
      rm -f "${SUBL_CONFIG_PATH}/Cache/Python/Completion Rules.tmPreferences.cache"
  fi
}


function install_bash_git_prompt {
  echo "$(tput setaf 2)###### Install bash-git-prompt ######$(tput sgr 0)"

  if [ "$1" == "-f" ]; then
    echo 'Removing: ~/.bash-git-prompt/'
    rm -rf ~/.bash-git-prompt
  fi

  if [ ! -d ~/.bash-git-prompt ]; then
    git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt --depth=1
  fi
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
  echo "Syncing dotfiles ..."
  # rsync --exclude ".git/" \
  #   --exclude ".DS_Store" \
  #   --exclude ".osx" \
  #   --exclude "bootstrap.sh" \
  #   --exclude "README.md" \
  #   --exclude "LICENSE-MIT.txt" \
  #   -avh --no-perms macOS/bash_{profile,rc} ~;
  src_folders=("bash-git-prompt" "git" "tmux" "ubuntu")
  for folder in "${src_folders[@]}"; do
    find "$folder" -type f -name '.[!.]*' | tee >(xargs -I_ cp _ ~) >(xargs -I_ basename _ | xargs printf "Updated ~/%s\n") >/dev/null;
  done

  cp vim/vim_runtime/my_configs.vim ~/.vim_runtime/my_configs.vim
  cp vim/vim_runtime/vimrcs/* ~/.vim_runtime/vimrcs/
}


function sync_dotfile {
  echo "$(tput setaf 2)###### Update dotfiles ######$(tput sgr 0)"

  if [ "$1" == "-f" ]; then
    _sync_dotfile;
  else
    read -rp "$(tput setaf 3)This may overwrite existing files in your home directory. Are you sure? (Y/n) $(tput sgr 0)";
    echo "";
    if [[ $REPLY =~ ^[Yy](es)?$ ]] || [ -z "$REPLY" ]; then
      _sync_dotfile;
    fi;
  fi;
}


subl_settings
link_virtualenv
install_pyenv
install_bash_git_prompt $FORCE
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

source ~/.bashrc;

echo "$(tput setaf 2)###### Finished ######$(tput sgr 0)"

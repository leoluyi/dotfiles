#!/usr/bin/env bash

cd "$(dirname "$BASH_SOURCE")" || exit 1;

if [ "$1" == "--force" ] || [ "$1" == "-f" ]; then
  FORCE="-f"
else
  FORCE="--no-force"
fi


get_os() {
  local os=""
  local kernel_name=""
  kernel_name="$(uname -s)"

  if [ "$kernel_name" = "Darwin" ]; then
    os="macos"
  elif [ "$kernel_name" = "Linux" ] && [ -e "/etc/os-release" ]; then
    os="$(. /etc/os-release; printf "%s\n" "$ID")"
  else
    os="$kernel_name"
  fi
  printf "%s" "$os"
}


validate_os() {
  local os="$(get_os)"
  local want_os="$1"

  if [ "$os" != "$want_os" ]; then
    printf "Sorry, this script is intended only for %s. (Your os is %s)\n" "$want_os" "$os"
    exit 1
  fi
}


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
      curl -fsSL -o "$py_completion" \
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

  if [ -f ~/.tmux/.tmux.conf ] && [ -f ~/.tmux/.tmux.conf.local ]; then
    ln -sf ~/.tmux/.tmux.conf ~/.tmux.conf && \
      cp ~/.tmux/.tmux.conf.local ~/.tmux.conf.local

    if [ -f ./tmux/.tmux.conf.local ]; then
      cp ./tmux/.tmux.conf.local ~/.tmux.conf.local
    fi
  fi

  # Install Tmux Plugin Manager
  if [ ! -d ~/.tmux/plugins/tpm ]; then
    echo "Installing tmux plugins manager ..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  fi

  # Install tmux plugins
  if [ -x ~/.tmux/plugins/tpm/bin/install_plugins ] && command -v tmux >/dev/null; then
    ~/.tmux/plugins/tpm/bin/install_plugins
  fi
}


function _sync_dotfile {
  echo "Syncing dotfiles ..."

  local src_folders=("bash-git-prompt" "git" "tmux" "vim" "$1")
  for folder in "${src_folders[@]}"; do
    find "$folder" -maxdepth 1 -mindepth 1 -name '.[!.]*' -print0 \
      ! -name .git \
      ! -name .DS_Store \
      ! -name .osx | \
      tee >(xargs -0 -I_ rsync -ar --no-perms _ ~) \
          >(xargs -0 -I_ basename _ | tr '\n' '\0' | xargs -0 -n1 printf "Updated %s\n") \
          >/dev/null;
  done

  # .config
  find ./config/ -maxdepth 1 -mindepth 1 -type d -print0 | \
    xargs -0 -I_ basename _ | \
    tr '\n' '\0' | \
    tee >(xargs -0 -I_ rsync -rlpth ./config/_ ~/.config/_) \
        >(xargs -0 -n1 printf "Updated ~/.config/%s\n") \
        >/dev/null;
}


function sync_dotfile {
  echo "$(tput setaf 2)###### Update dotfiles ######$(tput sgr 0)"

  if [ "$1" == "-f" ]; then
    _sync_dotfile "$2";
  else
    read -rp "$(tput setaf 3)This may overwrite existing files in your home directory. Are you sure? (Y/n) $(tput sgr 0)";
    echo "";
    if [[ $REPLY =~ ^[Yy](es)?$ ]] || [ -z "$REPLY" ]; then
      _sync_dotfile "$2";
    fi;
  fi;
}


validate_os "$(get_os)"
subl_settings
link_virtualenv
install_bash_git_prompt $FORCE
install_vim_awesome $FORCE
install_tmux_awesome $FORCE
sync_dotfile $FORCE "$(get_os)"

unset \
  subl_settings \
  link_virtualenv \
  install_vim_awesome \
  install_tmux_awesome \
  sync_dotfile


echo "$(tput setaf 2)###### Source Bash Settings ######$(tput sgr 0)"

source ~/.bashrc;

echo "$(tput setaf 2)###### Finished ######$(tput sgr 0)"

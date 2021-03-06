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


function use_gnu_bash {
  echo "$(tput setaf 2)###### Use GNU Bash as default shell from homebrew ######$(tput sgr 0)"

  if command -v brew &>/dev/null; then
    BREW_PREFIX=$(brew --prefix)
    if ! grep -Fq "${BREW_PREFIX}/bin/bash" /etc/shells; then
      # Switch to using brew-installed bash as default shell
      echo "${BREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells;
    fi

    if [ "$SHELL" != "${BREW_PREFIX}/bin/bash" ]; then
      chsh -s "${BREW_PREFIX}/bin/bash";
    fi
  fi
}


function fix_bash_completion {
  echo "$(tput setaf 2)###### Fix Bash Completion ######$(tput sgr 0)"

  # Git completion
  # https://dwatow.github.io/2018/09-21-git-cmd-auto-complete/
  # if command -v brew >/dev/null; then
  #     BASH_COMPLETION_COMPAT_DIR="$(brew --prefix)/etc/bash_completion.d"
  #     curl -fsSLo "${BASH_COMPLETION_COMPAT_DIR}"/git-completion.bash \
  #       https://raw.github.com/git/git/master/contrib/completion/git-completion.bash
  # fi

  # Docker completion
  DOCKER_ETC=/Applications/Docker.app/Contents/Resources/etc
  if [ -w "${BASH_COMPLETION_COMPAT_DIR}" ] && [ -d "${DOCKER_ETC}" ]; then
    ln -sf "${DOCKER_ETC}/docker.bash-completion" "${BASH_COMPLETION_COMPAT_DIR}"/docker
    ln -sf "${DOCKER_ETC}/docker-machine.bash-completion" "${BASH_COMPLETION_COMPAT_DIR}"/docker-machine
    ln -sf "${DOCKER_ETC}/docker-compose.bash-completion" "${BASH_COMPLETION_COMPAT_DIR}"/docker-compose
  else
    echo "Docker is not installed."
  fi
}


function link_virtualenv {
  echo "$(tput setaf 2)###### Link Virtualenv Path ######$(tput sgr 0)"

  mkdir -p ~/.local/share/virtualenvs
  VENV_FOLDER="${HOME}/.virtualenvs"

  [[ -L "$VENV_FOLDER" && -d "$VENV_FOLDER" ]] || ln -sf ~/.local/share/virtualenvs "$VENV_FOLDER"
}


function install_tmux_awesome {
  echo "$(tput setaf 2)###### Install Tmux Awesome ######$(tput sgr 0)"

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
  if [ -x ~/.tmux/plugins/tpm/bin/install_plugins ]; then
    ~/.tmux/plugins/tpm/bin/install_plugins
  fi
}


function install_vim_awesome {
  echo "$(tput setaf 2)###### Install Vim Awesome ######$(tput sgr 0)"

  if [ "$1" == "-f" ]; then
    echo 'Removing: ~/.vim*'
    rm -rf ~/.vim*
  fi

  if [ ! -d ~/.vim_runtime ]; then
    git clone --depth=1 git@github.com:leoluyi/vimrc.git ~/.vim_runtime 2>/dev/null || \
    git clone --depth=1 https://github.com/leoluyi/vimrc.git ~/.vim_runtime
    bash ~/.vim_runtime/install_awesome_vimrc.sh
  else
    echo "Awesome Vim is already installed."
  fi

  # remove unwanted plugins
  rm -rf ~/.vim_runtime/sources_non_forked/ack.vim/ &>/dev/null
}


function subl_settings {
  echo "$(tput setaf 2)###### Sublime Text Settings ######$(tput sgr 0)"

  SUBL_CONFIG_PATH=~/"Library/Application Support/Sublime Text 3"

  # Link subl binary
  SUBL_BINARY="/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl"
  if [ -x "${SUBL_BINARY}" ]; then
    ln -sf "${SUBL_BINARY}" /usr/local/bin
  fi

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


function _sync_dotfile {
  echo "Syncing dotfiles ..."

  local src_folders=("bash-git-prompt" "git" "tmux" "vim" "common_dotfiles" "$1")
  for folder in "${src_folders[@]}"; do
    find "$folder" -maxdepth 1 -mindepth 1 \( -name '.[!.]*' -o -name '.local' -o -name '.config' \) -print0 \
      ! -name .git \
      ! -name .DS_Store \
      ! -name .osx | \
      tee >(xargs -0 -I_ rsync -ar --no-perms _ ~) \
          >(xargs -0 -I_ basename _ | tr '\n' '\0' | xargs -0 -n1 printf "Updated %s\n") \
          >/dev/null;
  done

  # Link Brewfile for synchrizing settings.
  if [ -f "$1"/.config/Brewfile ]; then
    mkdir -p "$HOME/.config"
    ln -f "$1"/.config/Brewfile "$HOME/.config/Brewfile"
  fi

  # .config
  find ./config/ -maxdepth 1 -mindepth 1 -type d -print0 | \
    xargs -0 -I_ basename _ | \
    tr '\n' '\0' | \
    tee >(xargs -0 -I_ rsync -rlpth ./config/_ ~/.config/) \
        >(xargs -0 -n1 printf "Updated ~/.config/%s\n") \
        >/dev/null;
}


function sync_dotfile {
  echo "$(tput setaf 2)###### Update dotfiles ######$(tput sgr 0)"

  if [ "$1" != "-f" ]; then
    read -rp "$(tput setaf 3)This may overwrite existing files in your home directory. Are you sure? (Y/n) $(tput sgr 0)" is_overwrite;
    echo "";
  else
    is_overwrite=Y
  fi;

  if [[ -z "$is_overwrite" ]] || [[ $is_overwrite =~ ^[Yy](es)?$ ]]; then
      _sync_dotfile "$2";
  fi;
}

validate_os "$(get_os)"
use_gnu_bash
fix_bash_completion
link_virtualenv
subl_settings
install_vim_awesome $FORCE
install_tmux_awesome $FORCE
sync_dotfile $FORCE "$(get_os)"

unset \
  use_gnu_bash \
  fix_bash_completion \
  link_virtualenv \
  subl_settings \
  install_tmux_awesome \
  install_vim_awesome \
  _sync_dotfile \
  sync_dotfile \
  &>/dev/null

echo "$(tput setaf 2)###### Source Bash Settings ######$(tput sgr 0)"

source ~/.bash_profile;

echo "$(tput setaf 2)###### Finished ######$(tput sgr 0)"
echo -e "$(tput setaf 7)Use the following command to update your vim packages:\n    vim -c PlugUpdate -c qa!$(tput sgr 0)"

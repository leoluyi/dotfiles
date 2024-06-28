#!/usr/bin/env bash
# shellcheck disable=SC1090,SC1091

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1
_SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

if [ "$1" == "--force" ] || [ "$1" == "-f" ]; then
  FORCE="-f"
else
  FORCE="--no-force"
fi

# Add brew PATH.
[ -d /opt/homebrew/bin ] && export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}"

get_os() {
  local os=""
  local kernel_name=""
  kernel_name="$(uname -s)"

  if [ "$kernel_name" = "Darwin" ]; then
    os="macos"
  elif [ "$kernel_name" = "Linux" ] && [ -e "/etc/os-release" ]; then
    os="$(
      . /etc/os-release
      printf "%s\n" "$ID"
    )"
  else
    os="$kernel_name"
  fi
  printf "%s" "$os"
}

validate_os() {
  local want_os="$1"
  local os
  os="$(get_os)"

  if [ "$os" != "$want_os" ]; then
    printf "Sorry, this script is intended only for %s. (Your os is %s)\n" "$want_os" "$os"
    exit 1
  fi
}

use_gnu_bash() {
  echo "$(tput setaf 2)###### Use GNU Bash as default shell from homebrew ######$(tput sgr 0)"

  if command -v brew >/dev/null; then
    HOMEBREW_PREFIX=$(brew --prefix)
    if ! grep -Fq "${HOMEBREW_PREFIX}/bin/bash" /etc/shells; then
      # Switch to using brew-installed bash as default shell
      echo "${HOMEBREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells
    fi

    if [ "$SHELL" != "${HOMEBREW_PREFIX}/bin/bash" ]; then
      chsh -s "${HOMEBREW_PREFIX}/bin/bash"
    fi
  fi
}

fix_bash_completion() {
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

link_virtualenv() {
  echo "$(tput setaf 2)###### Link Virtualenv Path ######$(tput sgr 0)"

  mkdir -p ~/.local/share/virtualenvs
  VENV_FOLDER="${HOME}/.virtualenvs"

  [[ -L "$VENV_FOLDER" && -d "$VENV_FOLDER" ]] || ln -sf ~/.local/share/virtualenvs "$VENV_FOLDER"
}


sync_nvim_config() {
  echo "$(tput setaf 2)###### Install Vim Awesome ######$(tput sgr 0)"
  local config_home="${XDG_CONFIG_HOME:-$HOME/.config}"

  mkdir -p "$config_home"

  if [ "$1" = "-f" ]; then
    echo -e "Removing:\n~/.vim*\n$config_home ${XDG_DATA_HOME:-$HOME/.local/share}/nvim/"
    rm -rf "$HOME"/.vim*
    [ -d "$config_home"/nvim ] && rm -rf "$config_home"/nvim
    [ -L "$config_home"/nvim ] && rm -f "$config_home"/nvim
  fi

  if command -v stow >/dev/null; then
    #stow -v -t "$HOME" -D nvim 2>&1 | grep -v '^BUG'
    stow --adopt -v -t "$HOME" --ignore='^[^.].+' --override='.' nvim 2>&1 | grep -v '^BUG'
  fi

  if [ ! -d "$config_home"/nvim ] && [ ! -L "$config_home"/nvim ]; then
    ln -sf "$_SCRIPT_DIR/nvim/.config/nvim" "$config_home"/nvim
    ln -sf "$_SCRIPT_DIR/nvim/.vimrc" "$HOME"/
  fi

  [ -f "$config_home/.vimrc" ] && ln -sf "$config_home/.vimrc" "$HOME/.vimrc"

  # echo -e "$(tput setaf 7)Use the following command to update your vim packages:$(tput sgr 0)"
  # echo -e "$(tput setaf 3)"'vim -es -u ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/init.vim -i NONE -c "PlugInstall" -c "qa"'"$(tput sgr 0)"
  # echo -e "$(tput setaf 3)""nvim -c 'autocmd User PackerComplete quitall' -c 'PackerSync'""$(tput sgr 0)"
}

sync_sublimetext_config() {
  echo "$(tput setaf 2)###### Sublime Text Settings ######$(tput sgr 0)"

  SUBL_CONFIG_PATH=~/"Library/Application Support/Sublime Text 3"

  # Link subl binary
  SUBL_BINARY="/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl"
  if [ -x "${SUBL_BINARY}" ]; then
    ln -sf "${SUBL_BINARY}" /opt/homebrew/bin/
  fi

  # Fix bad Anaconda completion
  # https://github.com/DamnWidget/anaconda#auto-complete-for-import-behaves-badly
  py_completion="${SUBL_CONFIG_PATH}/Packages/Python/Completion Rules.tmPreferences"
  if [ ! -f "$py_completion" ]; then
    mkdir -p "${SUBL_CONFIG_PATH}/Packages/Python" &&
      curl -fsSL -o "$py_completion" https://raw.githubusercontent.com/DamnWidget/anaconda/master/Completion%20Rules.tmPreferences &&
      rm -f "${SUBL_CONFIG_PATH}/Cache/Python/Completion Rules.tmPreferences.cache"
  fi
}

make_xdg_dirs() {
  local config_home=${XDG_CONFIG_HOME:-$HOME/.config}
  local cache_home=${XDG_CACHE_HOME:-$HOME/.cache}
  local date_home=${XDG_DATA_HOME:-$HOME/.data}

  mkdir -p "$cache_home"
  mkdir -p "$config_home"
  mkdir -p "$date_home"
}

link_espanso_configs() {
  echo "$(tput setaf 2)###### Link Espanso Configs ######$(tput sgr 0)"

  killall espanso || true
  local espanso_config_path="$HOME/Library/Application Support/espanso"
  [ -d "$espanso_config_path" ] && rm -rf "$espanso_config_path"
  ln -sf "${_SCRIPT_DIR}/espanso" "$HOME/Library/Application Support/"
}

_sync_dotfiles_stow() {
  echo "Syncing dotfiles ..."
  local config_home=${XDG_CONFIG_HOME:-$HOME/.config}
  local home_src_folders
  local os="$1"

  mkdir -p "$config_home"

  home_src_folders=("common_dotfiles" "$os")

  for folder in "${home_src_folders[@]}"; do
    echo "$(tput setaf 3)Stow $folder ...$(tput sgr 0)"
    #stow -vt  "$HOME" --ignore='(\.sh)|(\.keep)|(\.DS_Store)' -D "$folder" 2>&1 | grep -v '^BUG'
    stow --adopt -v --dotfiles -t "$HOME" --ignore='(\.sh)|(\.keep)|(\.DS_Store)|(\.md)|(\.xml)' --override='.' "$folder" \
      2> >(grep -v 'BUG in find_stowed_path? Absolute/relative mismatch' 1>&2) \
      >/dev/null
  done
}

_sync_dotfiles_rsync() {
  echo "Syncing dotfiles ..."
  local config_home=${XDG_CONFIG_HOME:-$HOME/.config}
  local home_src_folders
  local os="$1"

  home_src_folders=("common_dotfiles" "$os")

  for folder in "${home_src_folders[@]}"; do
    find "$folder" -maxdepth 1 -mindepth 1 \( -name '.[!.]*' -o -name '.local' -o -name '.config' \) -print0 \
      ! -name .git \
      ! -name .DS_Store \
      ! -name .osx |
      tee >(xargs -0 -I_ rsync -ar --no-perms _ "$HOME") \
        >(xargs -0 -I_ basename _ | tr '\n' '\0' | xargs -0 -n1 printf "Updated %s\n") \
        >/dev/null
  done

  # echo "Sync config ..."
  # find ./common_dotfiles/.config -maxdepth 1 -mindepth 1 -print0 | \
  #   xargs -0 -I_ basename _ | \
  #   tr '\n' '\0' | \
  #   tee >(xargs -0 -I_ rsync -rlpth ./common_dotfiles/.config/_ "$config_home") \
  #   >(xargs -0 -n1 printf "Updated $config_home/%s\n") \
  #   >/dev/null;

  # Link Brewfile for synchrizing settings.
  ln -f "$_SCRIPT_DIR/config/Brewfile" "$config_home/Brewfile"
}

sync_dotfiles() {
  echo "$(tput setaf 2)###### Update dotfiles ######$(tput sgr 0)"

  local force_write="${1:-n}"
  local os="$2"

  if [ "$force_write" != "-f" ]; then
    read -rp "$(tput setaf 3)This may overwrite existing files in your home directory. Are you sure? (Y/n) $(tput sgr 0)" is_overwrite
    echo ""
  else
    is_overwrite=Y
  fi

  if [[ -z "$is_overwrite" ]] || [[ $is_overwrite =~ ^[Yy](es)?$ ]]; then
    if command -v stow >/dev/null; then
      _sync_dotfiles_stow "$os"
    else
      # shellcheck disable=SC2016
      read -rp "$(tput setaf 3)"'Command `stow` not found. Install `(S)tow` or use `(r)sync` instead? (S/r) '"$(tput sgr 0)" stow_or_rsync
      if [ -z "$stow_or_rsync" ] || [[ $stow_or_rsync =~ ^[Ss]$ ]]; then brew install stow && _sync_dotfiles_stow "$os"; fi
      [[ $stow_or_rsync =~ ^[Rr]$ ]] && _sync_dotfiles_rsync "$os"
    fi
  fi

  [ ! -d "$HOME/.local/share/bash" ] && mkdir -p "$HOME/.local/share/bash"
}

install_scripts() {
  echo "$(tput setaf 2)###### Install Scripts ######$(tput sgr 0)"
  mkdir -p "$HOME/.local/bin"
  if command -v stow >/dev/null; then
    #stow -vt "$HOME" -D scripts 2>&1 | grep -v '^BUG'
    stow --adopt -vt "$HOME" --ignore='^[^.].+' --override='.' scripts 2>&1 | grep -v '^BUG'
  fi
}

finally() {
  [ "$_SCRIPT_DIR" != "$HOME"/.dotfiles ] && ln -sfn "$_SCRIPT_DIR" "$HOME"/.dotfiles
  [ -d "$HOME/Dropbox/_repos" ] && ln -sfn "$HOME/Dropbox/_repos" ~/_repos
  [ -d "$HOME/Dropbox/_notes-vault" ] && ln -sfn "$HOME/Dropbox/_notes-vault" ~/_notes-vault
}

validate_os "macos"
use_gnu_bash
fix_bash_completion
link_espanso_configs
link_virtualenv
sync_sublimetext_config
sync_nvim_config $FORCE
make_xdg_dirs
install_scripts
sync_nvim_config
sync_dotfiles $FORCE "$(get_os)"
finally

unset \
  use_gnu_bash \
  fix_bash_completion \
  link_espanso_configs \
  link_virtualenv \
  sync_sublimetext_config \
  sync_nvim_config \
  make_xdg_dirs \
  _sync_dotfiles_stow \
  _sync_dotfiles_rsync \
  sync_dotfiles \
  install_scripts \
  >/dev/null

echo "$(tput setaf 2)###### Source Bash Settings ######$(tput sgr 0)"

[ -f "$HOME/.bash_profile" ] && source "$HOME/.bash_profile"

echo "$(tput setaf 2)###### Finished ######$(tput sgr 0)"

#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")" || exit 1;

if [ "$1" == "--force" ] || [ "$1" == "-f" ]; then
  FORCE="-f"
fi


function install_homebrew {
  echo "$(tput setaf 2)###### Install Homebrew ######$(tput sgr 0)"

  if command -v brew >/dev/null; then
    # Make sure we're using the latest Homebrew.
    echo "Homebrew is installed. Updating Homebrew ..."
    brew update

    # Save Homebrew's installed location.
    BREW_PREFIX=$(brew --prefix)
  else
    echo "Installing Hombrew ..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
}


function brew_install_app {
  echo "$(tput setaf 2)###### Install Apps with Homebrew ######$(tput sgr 0)"

  brew tap caskroom/cask && \
  brew tap homebrew/cask-fonts && \
  brew cask install \
  firefox \
  font-meslo-for-powerline \
  font-hack-nerd-font \
  google-chrome \
  iina \
  iterm2 \
  jupyter-notebook-viewer \
  xquartz \
  qlimagesize qlcolorcode qlstephen qlmarkdown quicklook-json webpquicklook suspicious-package quicklookase qlvideo \
  2>/dev/null;
}


function brew_install_cli {
  echo "$(tput setaf 2)###### Install CLI with Homebrew ######$(tput sgr 0)"

  brew install \
  ag \
  asciinema     `# record terminal sessions` \
  atomicparsley `# setting metadata into MPEG-4` \
  bash \
  bash-completion@2 \
  bash-git-prompt \
  bat \
  bfg \
  brew install \
  cmatrix \
  coreutils `# Dont forget to add $(brew --prefix coreutils)/libexec/gnubin to $PATH` \
  czmq \
  diff-so-fancy \
  fd \
  ffmpeg \
  figlet    `# Banner-like program prints strings as ASCII art` \
  findutils `# GNU find, locate, updatedb, and xargs, g-prefixed` \
  gcc \
  gdal \
  git \
  gnu-sed --with-default-names \
  gnu-tar \
  gnupg \
  grep \
  grip \
  highlight \
  htop-osx \
  john-jumbo `# password crack` \
  libpng \
  libsvg \
  libxml2 \
  libzip \
  moreutils  `# Some other useful utilities like sponge` \
  neofetch \
  npm \
  openssl \
  p7zip \
  pdfcrack   `# pdf password crack` \
  peco       `# Simplistic interactive filtering tool` \
  pip-completion \
  pipenv \
  plowshare  `# 免空神器` \
  proj \
  pyenv \
  pyenv-virtualenv \
  ranger     `# a terminal browser for Vim` \
  rename \
  ripgrep \
  shellcheck \
  ssh-copy-id \
  terminal-notifier \
  thefuck \
  tldr \
  tmux \
  tree \
  vim --with-override-system-vi \
  wget \
  ydiff \
  youtube-dl \
  2>/dev/null

  # Install other useful binaries.
  brew tap eddieantonio/eddieantonio && brew install imgcat 2>/dev/null
  brew tap jesseduffield/lazydocker && brew install lazydocker 2>/dev/null

  # Spreadsheet Calculator Improvised
  brew tap nickolasburr/pfa
  brew install sc-im 2>/dev/null

  # Remove outdated versions from the cellar.
  brew cleanup
}


function use_gnu_bash {
  # Switch to using brew-installed bash as default shell
  if ! grep -Fq "${BREW_PREFIX}/bin/bash" /etc/shells; then
    echo "${BREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells;
    chsh -s "${BREW_PREFIX}/bin/bash";
  fi;
}


function fix_bash_completion {
  echo "$(tput setaf 2)###### Fix Bash Completion ######$(tput sgr 0)"
  # https://dwatow.github.io/2018/09-21-git-cmd-auto-complete/
  # 用 brew 安裝 git，
  # 安裝完 bash 會自動指向 brew 安裝的路徑，
  # 確定版本之後，要去 github 找 git-completion.bash，並且，找到與你的 git 匹配的 版本。

  # Git completion
  if command -v brew >/dev/null; then
      BASH_COMPLETION_COMPAT_DIR="$(brew --prefix)/etc/bash_completion.d"
      curl -fsSLo "${BASH_COMPLETION_COMPAT_DIR}"/git-completion.bash \
        https://raw.github.com/git/git/master/contrib/completion/git-completion.bash
  fi

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

  if [ -f ~/.tmux/.tmux.conf ] && [ -f ~/.tmux/tmux.conf.local ]; then
    ln -sf ~/.tmux/.tmux.conf ~/.tmux.conf && \
      cp ~/.tmux/.tmux.conf.local ~/.tmux.conf.local
  fi

  # Install Tmux Plugin Manager
  if [ ! -d ~/.tmux/plugins/tpm ]; then
    echo "Installing tmux plugins manager ..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
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


function subl_settings {
  echo "$(tput setaf 2)###### Sublime Text Settings ######$(tput sgr 0)"

  # Link subl binary
  SUBL_BINARY="/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl"

  if [ -x "${SUBL_BINARY}" ]; then
    ln -sf "${SUBL_BINARY}" /usr/local/bin
  fi

  # Fix bad Anaconda completion
  # https://github.com/DamnWidget/anaconda#auto-complete-for-import-behaves-badly
  SUBL_CONFIG_PATH=~/"Library/Application Support/Sublime Text 3"

  mkdir -p "${SUBL_CONFIG_PATH}/Packages/Python" && \
    curl -fsSL -o "${SUBL_CONFIG_PATH}/Packages/Python/Completion Rules.tmPreferences" \
      https://raw.githubusercontent.com/DamnWidget/anaconda/master/Completion%20Rules.tmPreferences

  rm -f "${SUBL_CONFIG_PATH}/Cache/Python/Completion Rules.tmPreferences.cache"
}


function _sync_dotfile {
  # rsync --exclude ".git/" \
  #   --exclude ".DS_Store" \
  #   --exclude ".osx" \
  #   --exclude "bootstrap.sh" \
  #   --exclude "README.md" \
  #   --exclude "LICENSE-MIT.txt" \
  #   -avh --no-perms macOS/bash_{profile,rc} ~;
  src_folders=("bash-git-prompt" "git" "tmux" "macOS")
  for folder in "${src_folders[@]}"; do
    find "$folder" -type f -name '.[!.]*' | tee >(xargs -I_ cp _ ~) >(xargs -I_ basename _ | xargs printf "Updated ~/%s\n") >/dev/null;
  done

  cp vim/vim_runtime/my_configs.vim ~/.vim_runtime/my_configs.vim;
  cp vim/vim_runtime/vimrcs/* ~/.vim_runtime/vimrcs/;

  # Install tmux plugins
  if [ -x ~/.tmux/plugins/tpm/bin/install_plugins ]; then
    ~/.tmux/plugins/tpm/bin/install_plugins
  fi
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


install_homebrew
brew_install_app
brew_install_cli
use_gnu_bash
fix_bash_completion
link_virtualenv
subl_settings
install_tmux_awesome $FORCE
install_vim_awesome $FORCE
sync_dotfile $FORCE

unset \
  brew_install_app \
  install_homebrew \
  brew_install_cli \
  use_gnu_bash \
  fix_bash_completion \
  link_virtualenv \
  subl_settings \
  install_tmux_awesome \
  install_vim_awesome \
  _sync_dotfile \
  sync_dotfile

echo "$(tput setaf 2)###### Source Bash Settings ######$(tput sgr 0)"

source ~/.bash_profile;

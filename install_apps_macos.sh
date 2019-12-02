#!/usr/bin/env bash

cd "$(dirname "$BASH_SOURCE")" || exit 1;

if [ "$1" == "--force" ] || [ "$1" == "-f" ]; then
  FORCE="-f"
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


function install_homebrew {
  echo "$(tput setaf 2)###### Install Homebrew ######$(tput sgr 0)"

  if command -v brew &>/dev/null; then
    # Make sure we're using the latest Homebrew.
    echo "Homebrew is installed. Updating Homebrew ..."
    brew update

  else
    echo "Installing Hombrew ..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
}


function brew_install_app {
  echo "$(tput setaf 2)###### Install Apps with Homebrew ######$(tput sgr 0)"

  brew tap homebrew/cask-cask && \
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
  autopep8 \
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
  flake8 \
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
  jq \
  libpng \
  libsvg \
  libxml2 \
  libzip \
  more \
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
  qpdf \
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
  unrar \
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


validate_os macos
install_homebrew
brew_install_app
brew_install_cli

unset \
  brew_install_app \
  install_homebrew \
  brew_install_cli \
  &>/dev/null

echo "$(tput setaf 2)###### Finished ######$(tput sgr 0)"

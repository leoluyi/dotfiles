#!/usr/bin/env bash

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


function install_xcodecli {
  echo "$(tput setaf 2)###### Install Xcode CLI ######$(tput sgr 0)"
  if [ "$(xcode-select -p)" = "/Library/Developer/CommandLineTools" ]; then
    echo "Xcode CommandLineTools is already installed."
  else
    echo "Installing Xcode CommandLineTools ..."
    xcode-select --install
  fi
}


function install_homebrew {
  echo "$(tput setaf 2)###### Install Homebrew ######$(tput sgr 0)"

  if command -v brew >/dev/null; then
    # Make sure we're using the latest Homebrew.
    echo "Homebrew is already installed. Updating Homebrew ..."
    brew update

  else
    echo "Installing Hombrew ..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
}

function brew_install_app {
  echo "$(tput setaf 2)###### Install Apps with Homebrew ######$(tput sgr 0)"

  # You don't need to install cask anymore, you just need homebrew.
  brew tap homebrew/cask-fonts && \
    brew install --cask \
    firefox \
    font-hack-nerd-font \
    font-iosevka-nerd-font \
    font-meslo-for-powerline \
    google-chrome \
    iina \
    iterm2 \
    jupyter-notebook-viewer \
    openinterminal `# Finder Toolbar to open the current directory in Terminal, iTerm, Hyper or Alacritty. https://github.com/Ji4n1ng/OpenInTerminal` \
    openineditor-lite \
    openinterminal-lite \
    xquartz \
    qlimagesize mdimagesizemdimporter qlcolorcode qlstephen qlmarkdown quicklook-json webpquicklook suspicious-package quicklookase qlvideo \
    2>&1 \
    | grep -Ev '(Warning)|(re[-]?install)'

}


brew_install_cli() {
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
    black \
    cmatrix \
    coreutils `# Dont forget to add $(brew --prefix coreutils)/libexec/gnubin to $PATH` \
    czmq \
    diff-so-fancy \
    dive      `# A tool for exploring each layer in a docker image` \
    dust      `# A more intuitive version of du in rust` \
    fd \
    ffmpeg \
    figlet    `# Banner-like program prints strings as ASCII art` \
    findutils `# GNU find, locate, updatedb, and xargs, g-prefixed` \
    flake8 \
    fzf \
    gcc \
    gdal \
    git \
    glances    `# cross-platform, text-based command-line tool for monitoring systems` \
    gawk \
    gnu-getopt \
    gnu-indent \
    gnu-sed \
    gnu-tar \
    gnupg \
    gnutls \
    gotop      `# graphical activity monitor inspired by gtop and vtop` \
    grep \
    grip \
    highlight \
    htop-osx \
    httpie \
    jenv \
    john-jumbo `# password crack` \
    jq \
    libpng \
    libsvg \
    libxml2 \
    libzip \
    lolcat \
    mas        `# Mac App Store command line interface` \
    moreutils  `# Some other useful utilities like sponge` \
    most \
    ncdu       `# NCurses Disk Usage` \
    neofetch \
    npm \
    openssl \
    p7zip \
    pdfcrack   `# pdf password crack` \
    pip-completion \
    pipenv \
    pipx \
    plowshare  `# 免空神器` \
    proj \
    pyenv \
    pyenv-virtualenv \
    qpdf \
    ranger     `# a terminal browser for Vim` \
    rename \
    ripgrep \
    sc-im \    `# Terminal Spreadsheet Editor (csv)` \
    shellcheck \
    skopeo     `# Work with remote images registries - retrieving information, images, signing content` \
    ssh-copy-id \
    terminal-notifier \
    tig        `# visual tool for Git` \
    tldr \
    tmux \
    tree \
    vim \
    wget \
    wrk        `# Modern HTTP benchmarking tool` \
    ydiff \
    youtube-dl \
    2>&1 \
    | grep -Ev '(installed)|(re[-]?install)'

  # Neovim - Nightly version
  brew install --HEAD neovim

  # Install other useful binaries.
  brew install eddieantonio/eddieantonio/imgcat 2>/dev/null
  brew install jesseduffield/lazydocker/lazydocker 2>/dev/null
  brew install jesseduffield/lazygit/lazygit 2>/dev/null
  brew install saulpw/vd/visidata 2>/dev/null

  # Spreadsheet Calculator Improvised
  # brew install nickolasburr/pfa/sc-im 2>/dev/null

  # Remove outdated versions from the cellar.
  brew cleanup
}


install_go_completion() {
  echo "$(tput setaf 2)###### Install go-complete ######$(tput sgr 0)"
  command -v go >/dev/null \
    && go insatll github.com/posener/complete/gocomplete@latest
}

install_alacritty_theme_switch () {
  # ats < https://www.npmjs.com/package/alacritty-theme-switch/v/1.1.11 >
  echo "$(tput setaf 2)###### Install alacritty-theme-switch ######$(tput sgr 0)"
  if command -v npm >/dev/null && command -v alacritty >/dev/null; then
    npm install -g alacritty-theme-switch >/dev/null
  else
    echo "(Skip) Either npm or alacritty hasn't been installed."
  fi
}


post_insatll_config() {
  echo "$(tput setaf 2)###### Post-install Config ######$(tput sgr 0)"
  command -v yabai && yabai --start-service
  command -v skhd && skhd --start-service

  # Fix python.
  [ -f /opt/homebrew/bin/python ] && ln -sf ./python3 /opt/homebrew/bin/python
}


# Execute functions.
validate_os macos
install_xcodecli
install_homebrew

# Insatll brew apps.
command -v brew >/dev/null && brew bundle install --no-upgrade --file="${_SCRIPT_DIR}"/homebrew/Brewfile
# command -v brew >/dev/null && xargs brew install < "${_SCRIPT_DIR}"/homebrew/leaves.txt

install_alacritty_theme_switch
install_go_completion
post_insatll_config

unset \
  install_xcodecli \
  install_homebrew \
  install_alacritty_theme_switch \
  install_go_completion \
  post_insatll_config \
  &>/dev/null

echo "$(tput setaf 2)###### Finished ######$(tput sgr 0)"

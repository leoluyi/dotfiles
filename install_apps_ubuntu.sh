#!/usr/bin/env bash

# Check if has sudo privilege
sudo -v || exit;

if [ "$1" = "--force" ] || [ "$1" = "-f" ]; then
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


function install_apt_apps {
  echo "$(tput setaf 2)###### Install Apps with Apt ######$(tput sgr 0)"

  sudo apt update -qq && sudo apt install -qq -y --no-install-recommends \
    `# fd-find` \
    `# python-neovim` \
    `# python3-neovim` \
    `# tldr # Ubuntu 18 later only` \
    ag \
    apt-transport-https \
    build-essential \
    ca-certificates \
    curl \
    default-jdk \
    fzf \
    gdebi-core \
    gnupg-agent \
    highlight \
    libbz2-dev \
    libffi-dev \
    liblzma-dev \
    libncurses5-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    libxml2-dev \
    libxmlsec1-dev \
    linuxbrew-wrapper \
    llvm \
    make \
    most \
    ncdu    `# Interactive and very fast du` \
    neofetch \
    neovim \
    nmon    `# Performance monitor` \
    p7zip-full \
    ranger \
    silversearcher-ag \
    software-properties-common \
    source-highlight \
    tk-dev \
    tree \
    unzip \
    wget \
    xclip \
    xz-utils \
    zlib1g-dev \
    zip \
    2>/dev/null
}


function install_tldr {
  # https://gitlab.com/pepa65/tldr-bash-client
  # https://github.com/raylee/tldr

  local loc=/usr/local/bin/tldr  # elevated privileges needed for some locations
  sudo wget -qO $loc https://4e4.win/tldr
  sudo chmod +x $loc
}

function install_neovim {
  echo "$(tput setaf 2)###### Install Neovim ######$(tput sgr 0)"
  local new_ubuntu="$(echo "$(lsb_release -rs) 18.04" | awk '{print ($1 >= $2)}')"

  if ! command -v nvim &>/dev/null || [ "$1" = "-f" ]; then
    # Nvim repository
    sudo apt install -y software-properties-common
    sudo add-apt-repository -y ppa:neovim-ppa/stable

    if [ "${new_ubuntu}" = 1 ];then
      sudo apt -qq update && sudo apt install -y neovim python3-pip
    else
      sudo apt -qq update && sudo apt install -y neovim python3-pip
      # sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
      # sudo update-alternatives --config vi
      # sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
      # sudo update-alternatives --config vim
      # sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
      # sudo update-alternatives --config editor
    fi
  fi

  python3 -m pip install --quiet --no-cache-dir --user -U neovim pynvim jedi flake8 autopep8
}


function install_git {
  echo "$(tput setaf 2)###### Install Git ######$(tput sgr 0)"
  local VERSION_REQUIRED='2.25.0'

  local current_version="$(git --version | cut -d' ' -f3-)"
  local need_upgrade="$(echo "${current_version} ${VERSION_REQUIRED}" | awk '{print ($1 < $2)}')"
  # SC2072 - https://stackoverflow.com/a/46827362/3744499

  if [ "${need_upgrade}" = 1 ]; then
    sudo add-apt-repository -y ppa:git-core/ppa
    sudo apt update -qq && sudo apt install -qq -y git
  else
    echo "No need to upgrade git (current version: ${current_version})"
  fi
}


function install_chrome {
  echo "$(tput setaf 2)###### Install Chrome ######$(tput sgr 0)"

  if ! dpkg -l | awk '{print $2}' | grep -q google-chrome-stable; then
    curl -fsSL -o /tmp/google-chrome-stable_current_amd64.deb \
      https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg -i /tmp/google-chrome-stable_current_amd64.deb
  fi
}


function install_docker {
  echo "$(tput setaf 2)###### Install Docker ######$(tput sgr 0)"

  # ====== Docker ======
  if ! command -v docker &>/dev/null || [ "$1" = "-f" ]; then
    # https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-docker-engine---community
    sudo apt install -qq -y \
      apt-transport-https \
      ca-certificates \
      curl \
      gnupg-agent \
      software-properties-common

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

    sudo add-apt-repository -y \
       "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
       $(lsb_release -cs) \
       stable"

    sudo apt update -qq && sudo apt install -qq -y docker-ce docker-ce-cli containerd.io
  fi

  # ====== Docker-compose ======
  if ! command -v docker-compose &>/dev/null || [ "$1" = "-f" ]; then
    sudo curl -fsSL "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" \
      -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
  fi

  # ====== Completion ======
  docker_compose_completion=/etc/bash_completion.d/docker-compose
  if [ ! -f "${docker_compose_completion}" ]; then
    sudo curl -fsSL https://raw.githubusercontent.com/docker/compose/1.24.1/contrib/completion/bash/docker-compose \
      -o ${docker_compose_completion}
  fi
}


function install_dropbox {
  echo "$(tput setaf 2)###### Install Dropbox ######$(tput sgr 0)"

  if ! command -v dropbox &>/dev/null; then
    sudo apt install -qq -y gdebi python-gpg
    # sudo apt install python-gpgme   # for Ubuntu16
    wget -qO /tmp/dropbox_2019.02.14_amd64.deb https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2019.02.14_amd64.deb
    sudo gdebi -n /tmp/dropbox_2019.02.14_amd64.deb

    # https://askubuntu.com/a/148177/594426
    # sudo echo fs.inotify.max_user_watches=100000 | sudo tee -a /etc/sysctl.conf; sudo sysctl -p

    # Remove icon from Unity menu
    sudo mv /usr/share/applications/dropbox.desktop /usr/share/applications/dropbox.desktop.bak &>/dev/null
  fi
}


function install_r {
  echo "$(tput setaf 2)###### Install R ######$(tput sgr 0)"

  if [ "$1" = "-f" ]; then
    # Remove Ubuntu packages for R.
    sudo apt purge -y r-base* r-recommended r-cran-*
    sudo apt autoremove -y

    # Remove old site packages.
    sudo rm -rf /usr/local/lib/R/site-library/*
  fi

  if ! dpkg -l | awk '{print $2}' | grep -q '^r-base' ; then
    # Install new version of R (3.6) for Ubuntu 18.04.
    sudo add-apt-repository -y "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -sc)-cran35/"
    sudo add-apt-repository -y ppa:marutter/c2d4u3.5
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 51716619E084DAB9
    sudo apt update -qq
    sudo apt install -qq -y \
      build-essential libcurl4-gnutls-dev libxml2-dev libssl-dev curl libssh2-1-dev libxml2-dev libxslt-dev
    sudo apt install -qq -y \
      r-base \
      r-base-core \
      r-recommended \
      r-cran-rjava \
      r-cran-devtools
  fi
}


function install_rstudio {
  echo "$(tput setaf 2)###### Install RStudio ######$(tput sgr 0)"

  local VERSION_REQUIRED="1.2.1335"
  if ! command -v rstudio &>/dev/null; then
    curl -fsSL -o /tmp/rstudio-${VERSION_REQUIRED}-amd64.deb \
      https://download1.rstudio.org/desktop/bionic/amd64/rstudio-${VERSION_REQUIRED}-amd64.deb
    sudo apt install -qq -y gdebi-core && sudo gdebi -n /tmp/rstudio-${VERSION_REQUIRED}-amd64.deb
  fi
}


function install_pyenv {
  echo "$(tput setaf 2)###### Install Pyenv ######$(tput sgr 0)"

  if [ -z "$PYENV_ROOT" ]; then
    PYENV_ROOT="${HOME}/.pyenv"
  fi

  colorize() {
    if [ -t 1 ]; then printf "\e[%sm%s\e[m" "$1" "$2"
    else echo -n "$2"
    fi
  }

  # Checks for `.pyenv` file, and suggests to remove it for installing
  if [ -d "${PYENV_ROOT}" ]; then
    { echo
      colorize 1 "INFO"
      echo ": Pyenv is already installed. Can not proceed with installation. Kindly remove the '${PYENV_ROOT}' directory first."
      echo
    } >&2
    return
  fi
  curl -fsSL https://pyenv.run | bash
}


function install_diff_so_fancy {
  echo "$(tput setaf 2)###### Install diff-so-fancy ######$(tput sgr 0)"

  diff_so_fancy=/usr/local/bin/diff-so-fancy
  if [ ! -x "${diff_so_fancy}" ]; then
    sudo curl -fsSL https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy \
      -o $diff_so_fancy &&
    sudo chmod +x $diff_so_fancy
  fi
}


function install_dbeaver {
  echo "$(tput setaf 2)###### Install DBeaver ######$(tput sgr 0)"

  if [ ! "$(dpkg -l dbeaver-ce 2>/dev/null)" ]; then
    wget -O - https://dbeaver.io/debs/dbeaver.gpg.key | sudo apt-key add -
    if [ ! -f /etc/apt/sources.list.d/dbeaver.list ]; then
      echo "deb https://dbeaver.io/debs/dbeaver-ce /" | sudo tee /etc/apt/sources.list.d/dbeaver.list
    fi

    sudo apt update -qq && sudo apt install -qq -y dbeaver-ce
  fi
}


function upgrade_tmux {
  echo "$(tput setaf 2)###### Upgrade tmux ######$(tput sgr 0)"

  # https://bogdanvlviv.com/posts/tmux/how-to-install-the-latest-tmux-on-ubuntu-16_04.html
  local VERSION_REQUIRED="2.9"

  local current_version="$(tmux -V | cut -d' ' -f2-)"
  local need_upgrade="$(echo "${current_version} ${VERSION_REQUIRED}" | awk '{print ($1 < $2)}')"  # SC2072

  if [ "${need_upgrade}" = 1 ]; then
    echo "tmux need to be upgraded to v2.9 (current tmux version: ${current_version})"
    sudo apt install -qq -y \
      curl \
      automake \
      build-essential \
      pkg-config \
      libevent-dev \
      libncurses5-dev

    # Download, compile and install tmux
    rm -rf /tmp/tmux
    mkdir -p /tmp/tmux
    curl -fsSLo "/tmp/tmux-${VERSION_REQUIRED}.tar.gz" \
      "https://github.com/tmux/tmux/releases/download/${VERSION_REQUIRED}/tmux-${VERSION_REQUIRED}.tar.gz"
    tar -xf "/tmp/tmux-${VERSION_REQUIRED}.tar.gz" -C /tmp
    cd "/tmp/tmux-${VERSION_REQUIRED}" || return
    ./configure && make
    sudo make install
    cd - || return
    rm -rf /tmp/tmux  # Cleanup
  else
    echo "No need to upgrade tmux (current version: ${current_version})"
  fi
}


function install_fd {
  echo "$(tput setaf 2)###### Install fd ######$(tput sgr 0)"

  local VERSION_REQUIRED="7.4.0"
  local os_version_id="$(. /etc/os-release; printf "%s\n" "$VERSION_ID")"

  function version_gte {
    [ "$1" = "$(echo -e "$1\n$2" | sort -Vr | head -n1)" ]
  }

  if ! command -v fd &>/dev/null; then
    if version_gte "$os_version_id" "19.04"; then
      sudo apt install fd-find
    else
      curl -fsSLo "/tmp/fd_${VERSION_REQUIRED}_amd64.deb" \
        "https://github.com/sharkdp/fd/releases/download/v${VERSION_REQUIRED}/fd_${VERSION_REQUIRED}_amd64.deb" \
        && sudo dpkg -i "/tmp/fd_${VERSION_REQUIRED}_amd64.deb"
    fi
  fi
}


function install_vscode {
  if ! [ -x /usr/bin/code ] && ! [ -x /usr/local/bin/code ]; then
    wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
    sudo apt update && sudo apt -y install code
  fi
}


function install_sublimetext {
  if ! command -v subl &>/dev/null; then
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
    sudo apt update && sudo apt install -y sublime-text
  fi
}


function install_fonts {
  old_dir=$(pwd)

  # Powerline.
  font_dir=~/.local/share/fonts
  mkdir -p "$font_dir"
  curl -fsSL -o ~/.local/share/fonts/Meslo-LG-M-DZ-Regular-for-Powerline.ttf https://github.com/powerline/fonts/raw/master/Meslo%20Dotted/Meslo%20LG%20M%20DZ%20Regular%20for%20Powerline.ttf
  fc-cache -f "$font_dir"

  # nerd-font.
  cd /tmp || return
  git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git \
    && cd nerd-fonts \
    && ./install.sh SourceCodePro

  cd "$old_dir"
}


# Step 0 - Detect OS Version
validate_os ubuntu

# Step 1 - Execute the installation
install_apt_apps
install_chrome
install_dbeaver
install_diff_so_fancy
install_docker $FORCE
# install_dropbox
install_fd
install_git
install_neovim $FORCE
install_pyenv
install_r $FORCE
install_rstudio
install_sublimetext
install_tldr
install_vscode
upgrade_tmux

unset \
  install_apt_apps \
  install_chrome \
  install_dbeaver \
  install_diff_so_fancy \
  install_docker \
  # install_dropbox \
  install_fd \
  install_git \
  install_neovim \
  install_pyenv \
  install_r \
  install_rstudio \
  install_sublimetext \
  install_tldr \
  install_vscode \
  upgrade_tmux \
  validate_os ubuntu \
  &>/dev/null

echo "$(tput setaf 2)###### Finished ######$(tput sgr 0)"

#!/usr/bin/env bash

# Check if has sudo privilege
sudo -v || exit;

if [ "$1" = "--force" ] || [ "$1" = "-f" ]; then
  FORCE="-f"
fi

version=$(lsb_release -sd)

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

  sudo apt update && sudo apt install -y --no-install-recommends \
    apt-transport-https \
    build-essential \
    ca-certificates \
    curl \
    default-jdk \
    fzf \
    gdebi-core \
    gnupg-agent \
    libbz2-dev \
    libffi-dev \
    liblzma-dev \
    libncurses5-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    libxml2-dev \
    libxmlsec1-dev \
    llvm \
    make \
    more \
    ncdu    `# Interactive and very fast du` \
    neofetch \
    neovim \
    `# python-neovim` \
    `# python3-neovim` \
    nmon    `# Performance monitor` \
    p7zip-full \
    silversearcher-ag \
    software-properties-common \
    tk-dev \
    tldr \
    tree \
    unzip \
    wget \
    xclip \
    xz-utils \
    zlib1g-dev \
    2>dev/null
}


function install_neovim {
  local old_ubuntu="$(echo "$(lsb_release -rs) 18.04" | awk '{print ($1 < $2)}')"

  if [ "${old_ubuntu}" = 1 ];then
    # Nvim repository
    sudo apt install -y software-properties-common
    sudo add-apt-repository -y ppa:neovim-ppa/stable

    sudo apt update && sudo apt install -y neovim

    sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
    sudo update-alternatives --config vi
    sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
    sudo update-alternatives --config vim
    sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
    sudo update-alternatives --config editor
  else
    sudo apt update && sudo apt install -y neovim python-neovim python3-neovim
  fi

  sudo python3 -m pip install pynvim
}


function install_git {
  echo "$(tput setaf 2)###### Install Git ######$(tput sgr 0)"
  sudo add-apt-repository -y ppa:git-core/ppa
  sudo apt update && sudo apt install -y git
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

  # ====== Docker ======
  # https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-docker-engine---community
  sudo apt install -y \
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
  sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io

  # ====== Docker-compose ======
  if ! command -v docker-compose &>/dev/null ; then
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
    sudo apt install -y gdebi python-gpg
    # sudo apt install python-gpgme   # for Ubuntu16
    wget -qO /tmp/dropbox_2019.02.14_amd64.deb https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2019.02.14_amd64.deb
    sudo gdebi -n /tmp/dropbox_2019.02.14_amd64.deb
    # https://askubuntu.com/a/148177/594426
    # sudo echo fs.inotify.max_user_watches=100000 | sudo tee -a /etc/sysctl.conf; sudo sysctl -p
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

  if ! dpkg -l | awk '{print $2}' | grep -q r-base ; then
    # Install new version of R (3.6) for Ubuntu 18.04.
    sudo add-apt-repository -y "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -sc)-cran35/"
    sudo add-apt-repository -y ppa:marutter/c2d4u3.5
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 51716619E084DAB9
    sudo apt update
    sudo apt -y install build-essential libcurl4-gnutls-dev libxml2-dev libssl-dev curl libssh2-1-dev libxml2-dev libxslt-dev
    sudo apt -y install \
    r-base \
    r-base-core \
    r-recommended \
    r-cran-rjava \
    r-cran-devtools
  fi
}


function install_rstudio {
  echo "$(tput setaf 2)###### Install RStudio ######$(tput sgr 0)"

  if ! command -v rstudio &>/dev/null; then
    curl -fsSL -o /tmp/rstudio-1.2.1335-amd64.deb \
      https://download1.rstudio.org/desktop/bionic/amd64/rstudio-1.2.1335-amd64.deb
    sudo apt install gdebi-core &&  sudo gdebi -n /tmp/rstudio-1.2.1335-amd64.deb
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


function upgrade_tmux {
  echo "$(tput setaf 2)###### Upgrade tmux ######$(tput sgr 0)"

  # https://bogdanvlviv.com/posts/tmux/how-to-install-the-latest-tmux-on-ubuntu-16_04.html
  local MIN_TMUX_VERSION_REQUIRED="2.9"
  local current_tmux_version="$(tmux -V | cut -d' ' -f2-)"
  local need_upgrade="$(echo "${current_tmux_version} ${MIN_TMUX_VERSION_REQUIRED}" | awk '{print ($1 < $2)}')"  # SC2072

  if [ "${need_upgrade}" = 1 ]; then
    sudo apt install -y \
      curl \
      automake \
      build-essential \
      pkg-config \
      libevent-dev \
      libncurses5-dev

    # Download, compile and install tmux
    rm -rf /tmp/tmux
    mkdir -p /tmp/tmux
    curl -fsSLo "/tmp/tmux-${MIN_TMUX_VERSION_REQUIRED}.tar.gz" \
      "https://github.com/tmux/tmux/releases/download/${MIN_TMUX_VERSION_REQUIRED}/tmux-${MIN_TMUX_VERSION_REQUIRED}.tar.gz"
    tar -xf "/tmp/tmux-${MIN_TMUX_VERSION_REQUIRED}.tar.gz" -C /tmp
    cd "/tmp/tmux-${MIN_TMUX_VERSION_REQUIRED}" || return
    ./configure && make
    sudo make install
    cd - || return
    rm -rf /tmp/tmux  # Cleanup
  else
    echo "No need to upgrade (current tmux version: ${current_tmux_version})"
  fi
}


validate_os ubuntu
install_apt_apps
install_chrome
install_docker
install_dropbox
install_git
install_r $FORCE
install_rstudio
install_pyenv
install_diff_so_fancy
upgrade_tmux

unset \
  install_apt_apps \
  install_chrome \
  install_docker \
  install_dropbox \
  install_git \
  install_r \
  install_rstudio \
  install_pyenv \
  install_diff_so_fancy \
  upgrade_tmux \
  &>/dev/null

echo "$(tput setaf 2)###### Finished ######$(tput sgr 0)"

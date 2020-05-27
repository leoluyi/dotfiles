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

  apt update -qq && apt install -qq -y --no-install-recommends \
    `# python-neovim` \
    `# python3-neovim` \
    apt-transport-https \
    build-essential \
    ca-certificates \
    curl \
    default-jdk \
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
    nmon    `# Performance monitor` \
    openssl \
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
    zip \
    zlib1g-dev \
    2>/dev/null
}

function install_tldr {
  # https://gitlab.com/pepa65/tldr-bash-client
  # https://github.com/raylee/tldr

  local loc=/usr/local/bin/tldr  # elevated privileges needed for some locations
  wget -qO $loc https://4e4.win/tldr
  chmod +x $loc
}

function install_neovim {
  local new_ubuntu="$(echo "$(lsb_release -rs) 18.04" | awk '{print ($1 >= $2)}')"

  if ! command -v nvim &>/dev/null || [ "$1" = "-f" ]; then
    # Nvim repository
    apt install -qq -y software-properties-common
    add-apt-repository -y ppa:neovim-ppa/unstable

    if [ "${new_ubuntu}" = 1 ];then
      apt -qq update && apt install -qq -y neovim python3-pip
    else
      apt -qq update && apt install -qq -y neovim python3-pip
      # update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
      # update-alternatives --config vi
      # update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
      # update-alternatives --config vim
      # update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
      # update-alternatives --config editor
    fi
  fi

  # Install neovim python client for ncm2
  # https://github.com/ncm2/ncm2
  python3 -m pip install --quiet --no-cache-dir --user -U neovim pynvim jedi flake8 autopep8
}


function install_git {
  local VERSION_REQUIRED='2.25.0'

  local current_version="$(git --version | cut -d' ' -f3-)"
  local need_upgrade="$(echo "${current_version} ${VERSION_REQUIRED}" | awk '{print ($1 < $2)}')"
  # SC2072 - https://stackoverflow.com/a/46827362/3744499

  if [ "${need_upgrade}" = 1 ]; then
    add-apt-repository -y ppa:git-core/ppa
    apt update -qq && apt install -qq -y git
  else
    echo "No need to upgrade git (current version: ${current_version})"
  fi
}


function install_chrome {

  if ! dpkg -l | awk '{print $2}' | grep -q google-chrome-stable; then
    curl -fsSL -o /tmp/google-chrome-stable_current_amd64.deb \
      https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    apt install -qq -y gdebi-core && gdebi -n /tmp/google-chrome-stable_current_amd64.deb
  fi
}


function install_docker {

  # ====== Docker ======
  if ! command -v docker &>/dev/null || [ "$1" = "-f" ]; then
    # https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-docker-engine---community
    apt install -qq -y \
      apt-transport-https \
      ca-certificates \
      curl \
      gnupg-agent \
      software-properties-common

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

    add-apt-repository -y \
       "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
       $(lsb_release -cs) \
       stable"

    apt update -qq && apt install -qq -y docker-ce docker-ce-cli containerd.io
  fi

  # ====== Docker-compose ======
  if ! command -v docker-compose &>/dev/null || [ "$1" = "-f" ]; then
    curl -fsSL "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" \
      -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
  fi

  # ====== Completion ======
  docker_compose_completion=/etc/bash_completion.d/docker-compose
  if [ ! -f "${docker_compose_completion}" ]; then
    curl -fsSL https://raw.githubusercontent.com/docker/compose/1.24.1/contrib/completion/bash/docker-compose \
      -o ${docker_compose_completion}
  fi
}

function install_dropbox {
  echo "$(tput setaf 2)###### Install Dropbox ######$(tput sgr 0)"

  if ! command -v dropbox &>/dev/null; then
    apt install -qq -y gdebi python-gpg
    # apt install python-gpgme   # for Ubuntu16
    wget -qO /tmp/dropbox_2019.02.14_amd64.deb https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2019.02.14_amd64.deb
    gdebi -n /tmp/dropbox_2019.02.14_amd64.deb

    # https://askubuntu.com/a/148177/594426
    # echo fs.inotify.max_user_watches=100000 | tee -a /etc/sysctl.conf; sysctl -p

    # Remove icon from Unity menu
    mv /usr/share/applications/dropbox.desktop /usr/share/applications/dropbox.desktop.bak &>/dev/null
  fi
}

function install_r {

  if [ "$1" = "-f" ]; then
    # Remove Ubuntu packages for R.
    apt purge -y r-base* r-recommended r-cran-*
    apt autoremove -y

    # Remove old site packages.
    rm -rf /usr/local/lib/R/site-library/*
  fi

  if ! dpkg -l | awk '{print $2}' | grep -q '^r-base' ; then
    # Install new version of R (3.6) for Ubuntu 18.04.
    add-apt-repository -y "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -sc)-cran35/"
    add-apt-repository -y ppa:marutter/c2d4u3.5
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 51716619E084DAB9
    apt update -qq
    apt install -qq -y \
      build-essential libcurl4-gnutls-dev libxml2-dev libssl-dev curl libssh2-1-dev libxml2-dev libxslt-dev
    apt install -qq -y \
      r-base \
      r-base-core \
      r-recommended \
      r-cran-rjava \
      r-cran-devtools

    su - -c "R -e \"install.packages('renv', repos = 'http://cran.rstudio.com/')\""
  fi
}


function install_rstudio {

  local VERSION_REQUIRED="1.2.1335"
  local UBUNTU_CODENAME

  UBUNTU_CODENAME="$(grep -Po '(?<=CODENAME\=).+' </etc/lsb-release)"
  if ! command -v rstudio &>/dev/null; then
    curl -fsSL -o /tmp/rstudio-${VERSION_REQUIRED}-amd64.deb \
      "https://download1.rstudio.org/desktop/${UBUNTU_CODENAME}/amd64/rstudio-${VERSION_REQUIRED}-amd64.deb"
    apt install -qq -y gdebi-core && gdebi -n /tmp/rstudio-${VERSION_REQUIRED}-amd64.deb
  fi
}


function install_pyenv {
  echo "$(tput setaf 2)###### Install Python ######$(tput sgr 0)"

  apt install -qq -y --no-install-recommends make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

  rm -rf /pyenv
  mkdir -p /pyenv
  chmod 755 /pyenv >/dev/null 2>&1

  colorize() {
    if [ -t 1 ]; then printf "\e[%sm%s\e[m" "$1" "$2"
    else echo -n "$2"
    fi
  }

  curl -fsSL https://pyenv.run | PYENV_ROOT="/pyenv/.pyenv" bash
}


function install_diff_so_fancy {

  diff_so_fancy=/usr/local/bin/diff-so-fancy
  if [ ! -x "${diff_so_fancy}" ]; then
    curl -fsSL https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy \
      -o $diff_so_fancy &&
    chmod +x $diff_so_fancy
  fi
}


function install_dbeaver {

  if [ ! "$(dpkg -l dbeaver-ce 2>/dev/null)" ]; then
    wget -O - https://dbeaver.io/debs/dbeaver.gpg.key | apt-key add -
    if [ ! -f /etc/apt/sources.list.d/dbeaver.list ]; then
      echo "deb https://dbeaver.io/debs/dbeaver-ce /" | tee /etc/apt/sources.list.d/dbeaver.list
    fi

    apt update -qq && apt install -qq -y dbeaver-ce
  fi
}


function upgrade_tmux {

  # https://bogdanvlviv.com/posts/tmux/how-to-install-the-latest-tmux-on-ubuntu-16_04.html
  local VERSION_REQUIRED="3.1"

  local current_version="$(tmux -V | cut -d' ' -f2-)"
  local need_upgrade="$(echo "${current_version} ${VERSION_REQUIRED}" | awk '{print ($1 < $2)}')"  # SC2072

  if ! command -v tmux &>/dev/null || [ "${need_upgrade}" = 1 ]; then
    echo "tmux need to be upgraded to v2.9 (current tmux version: ${current_version})"
    apt install -qq -y \
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
    make install
    cd - || return
    rm -rf /tmp/tmux  # Cleanup
  else
    echo "No need to upgrade tmux (current version: ${current_version})"
  fi
}


function install_fd {

  local VERSION_REQUIRED="7.4.0"
  local os_version_id="$(. /etc/os-release; printf "%s\n" "$VERSION_ID")"

  function version_gte {
    [ "$1" = "$(echo -e "$1\n$2" | sort -Vr | head -n1)" ]
  }

  if ! command -v fd &>/dev/null; then
    if version_gte "$os_version_id" "19.04"; then
      apt install -qq -y fd-find
    else
      curl -fsSLo "/tmp/fd_${VERSION_REQUIRED}_amd64.deb" \
        "https://github.com/sharkdp/fd/releases/download/v${VERSION_REQUIRED}/fd_${VERSION_REQUIRED}_amd64.deb" \
        && dpkg -i "/tmp/fd_${VERSION_REQUIRED}_amd64.deb"
    fi
  fi
}


function install_vscode {
  if ! [ -x /usr/bin/code ] && ! [ -x /usr/local/bin/code ]; then
    wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | apt-key add -
    add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
    apt update -qq && apt -y install code

    sed -i '#https://packages.microsoft.com/repos/vscode#d' /etc/apt/sources.list 2>/dev/null
  fi
}


function install_sublimetext {
  if ! command -v subl &>/dev/null; then
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | apt-key add -
    echo "deb https://download.sublimetext.com/ apt/stable/" | tee /etc/apt/sources.list.d/sublime-text.list
    apt update -qq && apt install -qq -y sublime-text
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

function install_ripgrep {
  # [[ $UID == 0 ]] || { echo "run as sudo to install"; exit 1; }
  if ! command -v rg &>/dev/null; then
    apt install -qq -y jq curl
    REPO="https://github.com/BurntSushi/ripgrep/releases/download/"
    RG_LATEST=$(curl -sSL "https://api.github.com/repos/BurntSushi/ripgrep/releases/latest" | jq --raw-output .tag_name)
    RELEASE="${RG_LATEST}/ripgrep-${RG_LATEST}-x86_64-unknown-linux-musl.tar.gz"

    TMPDIR=$(mktemp -d)

    curl -fsSL ${REPO}${RELEASE} | tar zxf - --strip-component=1 -C $TMPDIR
    mv ${TMPDIR}/rg /usr/local/bin/
    mkdir -p /usr/local/share/man/man1/
    mv ${TMPDIR}/doc/rg.1 /usr/local/share/man/man1/
    mkdir -p /usr/share/bash-completion/completions/
    mv ${TMPDIR}/complete/rg.bash /usr/share/bash-completion/completions/rg
    mandb

    # Cleanup
    rm -rf ${TMPDIR}
  fi
}


function main {
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
  install_ripgrep
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
    `# install_dropbox` \
    install_fd \
    install_git \
    install_neovim \
    install_pyenv \
    install_r \
    install_ripgrep \
    install_rstudio \
    install_sublimetext \
    install_tldr \
    install_vscode \
    upgrade_tmux \
    validate_os ubuntu \
    &>/dev/null
}

sudo bash main
echo "$(tput setaf 2)###### Finished ######$(tput sgr 0)"

#!/usr/bin/env bash

# Check if has sudo privilege
if ! sudo -v; then
  echo Aborted! Must have sudo privilege.;
  exit;
fi

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


install_apt_apps() {
  echo "$(tput setaf 2)###### Installing Apps with Apt ######$(tput sgr 0)"

  sudo apt update -qq && sudo apt install -qq -y --no-install-recommends \
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
    nodejs \
    openssl \
    p7zip-full \
    ranger \
    silversearcher-ag \
    software-properties-common \
    source-highlight \
    stow \
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

install_starship () {
  echo "$(tput setaf 2)###### Installing Starship - A cross shell prompt ######$(tput sgr 0)"

  if ! command -v starship >/dev/null; then
    curl -sS https://starship.rs/install.sh | sh
  else
    echo "(Skip) Starship has been already installed."
  fi
}

install_tldr() {
  # https://gitlab.com/pepa65/tldr-bash-client
  # https://github.com/raylee/tldr
  echo "$(tput setaf 2)###### Installing tldr ######$(tput sgr 0)"

  local loc=/usr/local/bin/tldr  # elevated privileges needed for some locations
  sudo wget -qO $loc https://4e4.win/tldr
  sudo chmod +x $loc
}

install_neovim() {
  echo "$(tput setaf 2)###### Installing Neovim ######$(tput sgr 0)"

  local new_ubuntu="$(echo "$(lsb_release -rs) 18.04" | awk '{print ($1 >= $2)}')"

  if command -v nvim >/dev/null && [ "$1" != "-f" ]; then echo "(Skip) neovim has been already installed." && return 0; fi

  # Add Nvim repository.
  sudo add-apt-repository -y ppa:neovim-ppa/unstable

  if [ "${new_ubuntu}" = 1 ];then
    sudo apt update -qq && sudo apt install -qq -y neovim python3-pip
  else
    sudo apt update -qq && sudo apt install -qq -y neovim python3-pip
    # update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
    # update-alternatives --config vi
    # update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
    # update-alternatives --config vim
    # update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
    # update-alternatives --config editor
  fi
}


install_git() {
  echo "$(tput setaf 2)###### Installing Git ######$(tput sgr 0)"

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


install_chrome() {
  echo "$(tput setaf 2)###### Installing Chrome ######$(tput sgr 0)"

  if ! dpkg -l | awk '{print $2}' | grep -q google-chrome-stable; then
    sudo curl -fsSL -o /tmp/google-chrome-stable_current_amd64.deb \
      https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt install -qq -y gdebi-core && gdebi -n /tmp/google-chrome-stable_current_amd64.deb
  fi
}


install_docker() {
  # https://docs.docker.com/engine/install/ubuntu/
  echo "$(tput setaf 2)###### Install Docker ######$(tput sgr 0)"

  # ====== Docker Engine ======
  if ! command -v docker >/dev/null || [ "$1" = "-f" ]; then

    # Uninstall old versions.
    # sudo apt -qy remove docker docker-engine docker.io containerd runc

    sudo apt install -qq -y \
      apt-transport-https \
      ca-certificates \
      curl \
      gnupg-agent \
      software-properties-common

    sudo bash -c 'curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -'

    sudo add-apt-repository -y \
       "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu \
       $(lsb_release -cs) stable"

    sudo apt update -qq && sudo apt install -qq -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
  fi

  # ====== Docker Compose ======
  if ! command -v docker-compose >/dev/null || [ "$1" = "-f" ]; then
    sudo mkdir -p /usr/local/lib/docker/cli-plugins
    sudo rm -f /usr/local/lib/docker/cli-plugins/docker-compose
    sudo curl -SL "https://github.com/docker/compose/releases/download/v2.5.0/docker-compose-linux-$(uname -m)" \
      -o /usr/local/lib/docker/cli-plugins/docker-compose
    sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

    sudo ln -sf /usr/local/lib/docker/cli-plugins/docker-compose /usr/local/bin/docker-compose
  fi

  # ====== Completion ======
  # docker_compose_completion=/etc/bash_completion.d/docker-compose
  # if [ ! -f "${docker_compose_completion}" ]; then
  #   curl -fsSL https://raw.githubusercontent.com/docker/compose/1.24.1/contrib/completion/bash/docker-compose \
  #     -o ${docker_compose_completion}
  # fi
}

install_dropbox() {
  echo "$(tput setaf 2)###### Install Dropbox ######$(tput sgr 0)"

  if ! command -v dropbox >/dev/null; then
    sudo apt install -qq -y gdebi python-gpg
    # sudo apt install python-gpgme   # for Ubuntu16
    sudo wget -qO /tmp/dropbox_2019.02.14_amd64.deb https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2019.02.14_amd64.deb
    sudo gdebi -n /tmp/dropbox_2019.02.14_amd64.deb

    # https://askubuntu.com/a/148177/594426
    # echo fs.inotify.max_user_watches=100000 | tee -a /etc/sysctl.conf; sysctl -p

    # Remove icon from Unity menu
    sudo mv /usr/share/applications/dropbox.desktop /usr/share/applications/dropbox.desktop.bak >/dev/null
  fi
}

install_r() {
  echo "$(tput setaf 2)###### Install R ######$(tput sgr 0)"
  if [ "$1" = "-f" ]; then
    # Remove Ubuntu packages for R.
    sudo apt purge -y r-base* r-recommended r-cran-*
    sudo apt autoremove -y

    # Remove old site packages.
    sudo rm -rf /usr/local/lib/R/site-library/*
  fi

  if ! dpkg -l | awk '{print $2}' | grep -q '^r-base' ; then
    # dd the rrutter4.0 PPA for R itself (same as CRAN).
    #sudo add-apt-repository --enable-source --yes "ppa:marutter/rrutter4.0"
    local release_codename=$(lsb_release -cd | grep Codename | cut -f2)
    sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(release_codename)-cran40/"
    # Add the c4d4u.teams repo for over 4k CRAN packages.
    sudo add-apt-repository --enable-source --yes "ppa:marutter/c2d4u4.0+"
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

    su - -c "R -e \"install.packages('renv', repos = 'http://cran.rstudio.com/')\""
  fi
}


install_rstudio() {
  echo "$(tput setaf 2)###### Install RStudio ######$(tput sgr 0)"

  local VERSION_REQUIRED="1.2.1335"
  local UBUNTU_CODENAME

  UBUNTU_CODENAME="$(grep -Po '(?<=CODENAME\=).+' </etc/lsb-release)"
  if ! command -v rstudio >/dev/null; then
    sudo curl -fsSL -o /tmp/rstudio-${VERSION_REQUIRED}-amd64.deb \
      "https://download1.rstudio.org/desktop/${UBUNTU_CODENAME}/amd64/rstudio-${VERSION_REQUIRED}-amd64.deb"
    sudo apt install -qq -y gdebi-core && gdebi -n /tmp/rstudio-${VERSION_REQUIRED}-amd64.deb
  fi
}


install_pyenv() {
  echo "$(tput setaf 2)###### Install pyenv ######$(tput sgr 0)"

  local pyenv_path
  pyenv_path=/pyenv/.pyenv

  command -v $pyenv_path/bin/pyenv >/dev/null && echo "=> (Skip) pyenv has been already installed ($pyenv_path/bin/pyenv)." && return 0

  sudo apt install -qq -y --no-install-recommends make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

  #sudo rm -rf /pyenv
  #sudo mkdir -p /pyenv
  #sudo bash -c 'curl -fsSL https://pyenv.run | PYENV_ROOT='$pyenv_path' bash'
  #sudo chmod -R 777 $pyenv_path >/dev/null 2>&1

  curl -fsSL https://pyenv.run | bash
}


install_diff_so_fancy() {
  echo "$(tput setaf 2)###### Installing diff-so-fancy ######$(tput sgr 0)"

  local diff_so_fancy="/usr/local/bin/diff-so-fancy"
  if [ ! -x "${diff_so_fancy}" ]; then
    sudo curl -fsSL https://github.com/so-fancy/diff-so-fancy/releases/download/v1.4.4/diff-so-fancy \
      -o $diff_so_fancy &&
    sudo chmod +x $diff_so_fancy
  fi
}


install_dbeaver() {
  echo "$(tput setaf 2)###### Installing dbeaver ######$(tput sgr 0)"

  if [ ! "$(dpkg -l dbeaver-ce 2>/dev/null)" ]; then
    sudo wget -O - https://dbeaver.io/debs/dbeaver.gpg.key | apt-key add -
    if [ ! -f /etc/apt/sources.list.d/dbeaver.list ]; then
      echo "deb https://dbeaver.io/debs/dbeaver-ce /" | tee /etc/apt/sources.list.d/dbeaver.list
    fi

    sudo apt update -qq && sudo apt install -qq -y dbeaver-ce
  fi
}


upgrade_tmux() {
  echo "$(tput setaf 2)###### Installing tmux ######$(tput sgr 0)"

  # https://bogdanvlviv.com/posts/tmux/how-to-install-the-latest-tmux-on-ubuntu-16_04.html
  local VERSION_REQUIRED="3.1"

  local current_version="$(tmux -V | cut -d' ' -f2-)"
  local need_upgrade="$(echo "${current_version} ${VERSION_REQUIRED}" | awk '{print ($1 < $2)}')"  # SC2072

  if ! command -v tmux >/dev/null || [ "${need_upgrade}" = 1 ]; then
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


install_tmux_awesome() {
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
    ln -sf ~/.tmux/.tmux.conf ~/.tmux.conf \
      && cp ~/.tmux/.tmux.conf.local ~/.tmux.conf.local

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


install_fd() {
  echo "$(tput setaf 2)###### Installing fd ######$(tput sgr 0)"

  local VERSION_REQUIRED="7.4.0"
  local os_version_id="$(. /etc/os-release; printf "%s\n" "$VERSION_ID")"

  function version_gte {
    [ "$1" = "$(echo -e "$1\n$2" | sort -Vr | head -n1)" ]
  }

  if ! command -v fd >/dev/null; then
    if version_gte "$os_version_id" "19.04"; then
      sudo apt install -qq -y fd-find
    else
      curl -fsSLo "/tmp/fd_${VERSION_REQUIRED}_amd64.deb" \
        "https://github.com/sharkdp/fd/releases/download/v${VERSION_REQUIRED}/fd_${VERSION_REQUIRED}_amd64.deb" \
        && sudo dpkg -i "/tmp/fd_${VERSION_REQUIRED}_amd64.deb"
    fi
  fi
}


install_vscode() {
  echo "$(tput setaf 2)###### Installing vscode ######$(tput sgr 0)"

  if ! [ -x /usr/bin/code ] && ! [ -x /usr/local/bin/code ]; then
    wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
    sudo apt update -qq && apt -y install code

    sudo sed -i '#https://packages.microsoft.com/repos/vscode#d' /etc/apt/sources.list 2>/dev/null
  fi
}


install_sublimetext() {
  echo "$(tput setaf 2)###### Installing sublime-text ######$(tput sgr 0)"

  if ! command -v subl >/dev/null; then
    sudo bash -c 'wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | apt-key add -'
    [ ! -f /etc/apt/sources.list.d/sublime-text.list ] \
      && sudo bash -c 'echo "deb https://download.sublimetext.com/apt/stable/" | tee /etc/apt/sources.list.d/sublime-text.list'
    sudo apt update -qq && sudo apt install -qq -y sublime-text
  fi
}


install_fonts() {
  echo "$(tput setaf 2)###### Installing powerline fonts ######$(tput sgr 0)"

  # Powerline.
  font_dir=~/.local/share/fonts
  mkdir -p "$font_dir"
  curl -fsSL -o ~/.local/share/fonts/Meslo-LG-M-DZ-Regular-for-Powerline.ttf https://github.com/powerline/fonts/raw/master/Meslo%20Dotted/Meslo%20LG%20M%20DZ%20Regular%20for%20Powerline.ttf
  fc-cache -f "$font_dir"

  # nerd-font.
  pushd /tmp || return
  git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git \
    && cd nerd-fonts \
    && ./install.sh SourceCodePro

  popd || return
}

install_ripgrep() {
  echo "$(tput setaf 2)###### Installing ripgrep ######$(tput sgr 0)"

  # [[ $UID == 0 ]] || { echo "run as sudo to install"; exit 1; }
  command -v rg >/dev/null && echo "(Skip) ripgrep has been already installed." && return 0

  sudo apt install -qq -y jq curl
  REPO="https://github.com/BurntSushi/ripgrep/releases/download/"
  RG_LATEST=$(curl -sSL "https://api.github.com/repos/BurntSushi/ripgrep/releases/latest" | jq --raw-output .tag_name)
  RELEASE="${RG_LATEST}/ripgrep-${RG_LATEST}-x86_64-unknown-linux-musl.tar.gz"

  TMPDIR="$(mktemp -d)"

  sudo bash -c "curl -fsSL ${REPO}${RELEASE} | tar zxf - --strip-component=1 -C $TMPDIR"
  sudo mv "${TMPDIR}/rg" /usr/local/bin/
  sudo mkdir -p /usr/local/share/man/man1/ && sudo mv "${TMPDIR}/doc/rg.1" /usr/local/share/man/man1/
  sudo mkdir -p /usr/share/bash-completion/completions/ && sudo mv "${TMPDIR}/complete/rg.bash" /usr/share/bash-completion/completions/rg
  sudo mandb

  # Cleanup
  sudo rm -rf "${TMPDIR}"
}

install_linuxbrew() {
  # https://brew.sh/
  # https://docs.brew.sh/Homebrew-on-Linux
  echo "$(tput setaf 2)###### Installing linuxbrew ######$(tput sgr 0)"

  [ -d "$HOME"/.linuxbrew ]  && eval "$($HOME/.linuxbrew/bin/brew shellenv)"
  [ -d /home/linuxbrew/.linuxbrew ]  && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  if ! command -v brew >/dev/null; then
    command -v curl >/dev/null || return 1
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  # Install apps.
  #command -v brew >/dev/null && \
  #  brew install \
  #  fzf
}

install_fzf_local() {
  git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME"/.fzf \
    && "$HOME"/.fzf/instal
}

install_nvm () {
  echo "$(tput setaf 2)###### Installing nvm ######$(tput sgr 0)"

  local INSTALL_DIR="${XDG_DATA_HOME-$HOME/.local/share}/nvm"

  [ -d "$INSTALL_DIR/.git" ] \
    && echo "=> nvm is already installed in $INSTALL_DIR, trying to update using git" \
    && return 0

  export NVM_DIR="${XDG_DATA_HOME-$HOME/.local/share}/nvm"
  if command -v curl >/dev/null; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
  elif command -v wget >/dev/null; then
    wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
  fi
}

main() {
  # Step 0 - Detect OS Version
  validate_os ubuntu

  # Step 1 - Execute the installation
  # install_dropbox
  install_apt_apps
  install_starship
  install_diff_so_fancy
  install_fd
  install_fzf_local
  install_git
  install_linuxbrew
  install_neovim $FORCE
  install_pyenv
  install_ripgrep
  install_tldr
  install_nvm
  upgrade_tmux
  install_tmux_awesome

  # install_chrome
  # install_docker $FORCE
  # install_dbeaver
  # install_fonts
  # install_rstudio
  # install_sublimetext
  # install_vscode
  # install_r $FORCE
}

main
echo "$(tput setaf 2)###### Finished ######$(tput sgr 0)"

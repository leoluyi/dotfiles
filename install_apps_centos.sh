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

get_version_id() {
  if [ "$(get_os)" = "centos" ] || [ "$(get_os)" = "redhat" ]; then
    version_id="$(. /etc/os-release; printf "%s\n" "$VERSION_ID")"
  fi
  printf "%s" "$version_id"
}

validate_os() {
  local os="$(get_os)"
  local want_os="$1"

  if [ "$os" != "$want_os" ]; then
    printf "Sorry, this script is intended only for %s. (Your os is %s)\n" "$want_os" "$os"
    exit 1
  fi
}


function make_yum_repo {
  echo "$(tput setaf 2)###### Download RPMs and make yum repo ######$(tput sgr 0)"

  local VERSION_ID="$(get_version_id)"

  yum install -y yum-plugin-downloadonly yum-utils createrepo
  mkdir -p /var/tmp/repo
  mkdir -p /var/tmp/repo-installroot

  rm -rf /var/cache/yum/*
  yum clean all -y

  if [ -w "/var/tmp/repo" ] && [ -w "/var/tmp/repo-installroot" ]; then
    yum groupinstall -y --downloadonly --installroot=/var/tmp/repo-installroot --releasever=$VERSION_ID --downloaddir=/var/tmp/repo \
      'Development Tools'

    yum install -y --downloadonly --installroot=/var/tmp/repo-installroot --releasever=$VERSION_ID --downloaddir=/var/tmp/repo \
      autoconf \
      automake \
      cmake \
      ctags \
      gcc \
      gcc-c++ \
      git \
      ninja-build \
      kernel-devel \
      libtool \
      lua lua-devel \
      luajit luajit-devel \
      make \
      ncurses-devel \
      ninja-build \
      patch \
      perl perl-devel \
      perl-ExtUtils-CBuilder \
      perl-ExtUtils-Embed \
      perl-ExtUtils-ParseXS \
      perl-ExtUtils-XSpp \
      pkgconfig \
      python python-devel \
      ruby ruby-devel \
      tcl-devel \
      unzip \
      2>/dev/null

    createrepo --database /var/tmp/repo
  fi
}


function install_python3 {
  echo "$(tput setaf 2)###### Install Python 3.7 ######$(tput sgr 0)"

  PYTHON_VERSION=3.7.8
  old_dir="$(pwd)"

  yum install -y make gcc gcc-c++ openssl-devel bzip2-devel zlib-devel
  curl -fsSLo /tmp/Python-${PYTHON_VERSION}.tgz https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz \
    && tar xxzf Python-${PYTHON_VERSION}.tgz -C /tmp \
    && cd /tmp/Python-${PYTHON_VERSION} \
    && ./configure --enable-optimizations \
    && make clean && make && make install

  [ -x /usr/local/bin/python3 ] \
    && /usr/local/bin/python3 -m pip install --system --
    neovim pynvim jedi flake8 autopep8

  cd "${old_dir}"
}


function install_vim {
  echo "$(tput setaf 2)###### Install Vim ######$(tput sgr 0)"

  old_dir="$(pwd)"

  yum install -y -q \
    ctags \
    git \
    lua lua-devel \
    luajit luajit-devel \
    ncurses-devel \
    perl perl-devel \
    perl-ExtUtils-CBuilder \
    perl-ExtUtils-Embed \
    perl-ExtUtils-ParseXS \
    perl-ExtUtils-XSpp \
    python python-devel \
    ruby ruby-devel \
    tcl-devel \
    2>/dev/null

  git clone https://github.com/vim/vim.git /tmp/vim \
    && cd /tmp/vim \
    && ./configure --with-features=huge \
      --enable-multibyte \
      --enable-rubyinterp \
      --enable-pythoninterp \
      --enable-perlinterp \
      --enable-luainterp \
    && make clean && make && make install

  cd "${old_dir}"
}

function install_neovim {
  echo "$(tput setaf 2)###### Install Neovim ######$(tput sgr 0)"
  # https://github.com/neovim/neovim/wiki/Building-Neovim#centos--rhel--fedora
  old_dir="$(pwd)"

  sudo yum -y install git ninja-build libtool autoconf automake cmake gcc gcc-c++ make pkgconfig unzip patch

  git clone https://github.com/neovim/neovim /tmp/neovim \
    && cd /tmp/neovim \
    && make CMAKE_BUILD_TYPE=Release \
    && sudo make install

  cd "${old_dir}"
}


function install_tmux() {
  echo "$(tput setaf 2)###### Install tmux ######$(tput sgr 0)"

  TMUX_VERSION=2.9
  LIBEVENT_VERSION=2.0.22
  old_dir="$(pwd)"

  yum install -y gcc kernel-devel make ncurses-devel

  # DOWNLOAD SOURCES FOR LIBEVENT AND MAKE AND INSTALL
  curl -fsSLo "/tmp/libevent-${LIBEVENT_VERSION}-stable.tar.gz" "https://github.com/libevent/libevent/releases/download/release-${LIBEVENT_VERSION}-stable/libevent-${LIBEVENT_VERSION}-stable.tar.gz"
  tar -xf libevent-${LIBEVENT_VERSION}-stable.tar.gz -C /tmp

  if [ -d "/tmp/libevent-${LIBEVENT_VERSION}-stable" ]; then
    cd "/tmp/libevent-${LIBEVENT_VERSION}-stable" || return
    ./configure --prefix=/usr/local
    make && make install
  fi

  # DOWNLOAD SOURCES FOR TMUX AND MAKE AND INSTALL
  curl -fsSLo "/tmp/tmux-${TMUX_VERSION}.tar.gz" \
    "https://github.com/tmux/tmux/releases/download/${TMUX_VERSION}/tmux-${TMUX_VERSION}.tar.gz"
  tar -xf "/tmp/tmux-${TMUX_VERSION}.tar.gz" -C /tmp

  if [ -d "/tmp/tmux-${TMUX_VERSION}" ]; then
    cd "/tmp/tmux-${TMUX_VERSION}" || return
    LDFLAGS="-L/usr/local/lib -Wl,-rpath=/usr/local/lib" ./configure --prefix=/usr/local
    make && make install
  fi

  cd "${old_dir}"
}


function main {
  # Step 0 - Detect OS Version
  validate_os centos

  # Step 1 - Execute the installation
  install_apt_apps
  install_diff_so_fancy
  install_docker $FORCE
  install_fd
  install_git
  install_linuxbrew
  install_neovim $FORCE
  install_pyenv
  upgrade_tmux

  unset \
    install_apt_apps \
    install_chrome \
    install_dbeaver \
    install_diff_so_fancy \
    install_docker \
    install_fd \
    install_git \
    install_linuxbrew \
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

main
echo "$(tput setaf 2)###### Finished ######$(tput sgr 0)"

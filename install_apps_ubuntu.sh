#!/usr/bin/env bash

# Check if has sudo privilege
sudo -v || exit;

if [ "$1" == "--force" ] || [ "$1" == "-f" ]; then
  FORCE="-f"
fi


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


function install_git {
  echo "$(tput setaf 2)###### Install Git ######$(tput sgr 0)"
  sudo add-apt-repository -y ppa:git-core/ppa
  sudo apt update && sudo apt install -y git
}


function install_chrome {
  echo "$(tput setaf 2)###### Install Chrome ######$(tput sgr 0)"

  if [ ! "$(dpkg -l | awk '{print $2}' | grep google-chrome-stable)" ]; then
    curl -fsSL -o ~/Downloads/google-chrome-stable_current_amd64.deb \
      https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg -i ~/Downloads/google-chrome-stable_current_amd64.deb
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
  if [ ! $(command -v docker-compose 2>/dev/null) ]; then
    sudo curl -fsSL "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" \
      -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
  fi

  # ====== Completion ======
  if [ ! -f /etc/bash_completion.d/docker-compose ]; then
    sudo curl -fsSL https://raw.githubusercontent.com/docker/compose/1.24.1/contrib/completion/bash/docker-compose \
      -o /etc/bash_completion.d/docker-compose
  fi
}


function install_dropbox {
  echo "$(tput setaf 2)###### Install Dropbox ######$(tput sgr 0)"

  if [ ! $(command -v dropbox 2>/dev/null) ]; then
    sudo apt install -y gdebi python-gpg
    # sudo apt install python-gpgme   # for Ubuntu16
    wget -qO ~/Downloads/dropbox_2019.02.14_amd64.deb https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2019.02.14_amd64.deb
    sudo gdebi -n ~/Downloads/dropbox_2019.02.14_amd64.deb
    # https://askubuntu.com/a/148177/594426
    # sudo echo fs.inotify.max_user_watches=100000 | sudo tee -a /etc/sysctl.conf; sudo sysctl -p
  fi
}


function install_r {
  echo "$(tput setaf 2)###### Install R ######$(tput sgr 0)"

  if [ "$1" == "-f" ]; then
    # Remove Ubuntu packages for R.
    sudo apt purge -y r-base* r-recommended r-cran-*
    sudo apt autoremove -y

    # Remove old site packages.
    sudo rm -rf /usr/local/lib/R/site-library/*
  fi

  if [ ! "$(dpkg -l | awk '{print $2}' | grep r-base)" ]; then
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

  if [ ! $(command -v rstudio 2>/dev/null) ]; then
    curl -fsSL -o ~/Downloads/rstudio-1.2.1335-amd64.deb \
      https://download1.rstudio.org/desktop/bionic/amd64/rstudio-1.2.1335-amd64.deb
    sudo apt install gdebi-core &&  sudo gdebi -n ~/Downloads/rstudio-1.2.1335-amd64.deb
  fi
}


function install_pyenv {
  echo "$(tput setaf 2)###### Install Pyenv ######$(tput sgr 0)"
  curl -fsSL https://pyenv.run | bash
}


function install_diff_so_fancy {
  echo "$(tput setaf 2)###### Install diff-so-fancy ######$(tput sgr 0)"

  diff_so_fancy=/usr/local/bin/diff-so-fancy
  if [ ! -x "${diff_so_fancy}" ]
    sudo curl -fsSL https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy \
      -o $diff_so_fancy &&
    sudo chmod +x $diff_so_fancy
  fi
}


install_apt_apps
install_chrome
install_docker
install_dropbox
install_git
install_r $FORCE
install_rstudio
install_pyenv
install_diff_so_fancy

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
  2>/dev/null

echo "$(tput setaf 2)###### Finished ######$(tput sgr 0)"

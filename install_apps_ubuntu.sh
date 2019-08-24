#!/usr/bin/env bash

# Check if has sudo privilege
sudo -v || exit;


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
    silversearcher-ag \
    software-properties-common \
    tk-dev \
    tree \
    wget \
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
  curl -fsSL -o ~/Downloads/google-chrome-stable_current_amd64.deb \
    https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  sudo dpkg -i ~/Downloads/google-chrome-stable_current_amd64.deb
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
  sudo curl -fsSL "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose

  # ====== Completion ======
  sudo curl -fsSL https://raw.githubusercontent.com/docker/compose/1.24.1/contrib/completion/bash/docker-compose \
    -o /etc/bash_completion.d/docker-compose
}


function install_dropbox {
  sudo apt install -y gdebi python-gpg
  # sudo apt install python-gpgme   # for Ubuntu16
  wget -qO ~/Downloads/dropbox_2019.02.14_amd64.deb https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2019.02.14_amd64.deb
  sudo gdebi -n ~/Downloads/dropbox_2019.02.14_amd64.deb
  # https://askubuntu.com/a/148177/594426
  # sudo echo fs.inotify.max_user_watches=100000 | sudo tee -a /etc/sysctl.conf; sudo sysctl -p
}


function install_r {
  echo "$(tput setaf 2)###### Install R ######$(tput sgr 0)"
  # Remove Ubuntu packages for R.
  sudo apt purge -y r-base* r-recommended r-cran-*
  sudo apt autoremove -y

  # Remove old site packages.
  sudo rm -rf /usr/local/lib/R/site-library/*

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
}


function install_rstudio {
  curl -fsSL -o ~/Downloads/rstudio-1.2.1335-amd64.deb \
    https://download1.rstudio.org/desktop/bionic/amd64/rstudio-1.2.1335-amd64.deb
  sudo apt install gdebi-core &&  sudo gdebi -n ~/Downloads/rstudio-1.2.1335-amd64.deb
}


install_apt_apps
install_chrome
install_docker
install_dropbox
install_git
install_r
install_rstudio

unset \
  install_apt_apps \
  install_chrome \
  install_docker \
  install_dropbox \
  install_git \
  install_r \
  install_rstudio

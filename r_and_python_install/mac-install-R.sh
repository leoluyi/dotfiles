#!/usr/bin/env bash

# See http://pacha.hk/2017-07-12_r_and_python_via_homebrew.html

# XCode CLT
xcode-select --install

# Update Homebrew and add formulae
brew update

# Check for broken dependencies and/or outdated packages
brew doctor
brew cleanup

# Install R
if ! command -v nvim &>/dev/null || [ "$1" = "-f" ]; then
  brew install openblas
  brew install r
  defaults write org.R-project.R force.LANG en_US.UTF-8
  # echo 'Sys.setlocale(category="LC_ALL", locale = "en_US.UTF-8")' >> ~/.bash_profile

  # data.table
  R --vanilla << EOF
install.packages('data.table', repos='https://cloud.r-project.org')
q()
EOF

  # rJava
  brew install --cask java
  # ln -f -s "$(/usr/libexec/java_home)/jre/lib/server/libjvm.dylib" /usr/local/lib
  sudo R CMD javareconf
  Rscript -e 'install.packages("rJava", repos="https://cloud.r-project.org")';

  # devtools
  brew install openssl openssl@1.1 libssh2
  Rscript -e 'install.packages("devtools", repos="https://cloud.r-project.org")';

  # tidyverse tools
  Rscript -e 'install.packages("tidyverse", repos="https://cloud.r-project.org")';
fi

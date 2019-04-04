#!/usr/bin/env bash

# See http://pacha.hk/2017-07-12_r_and_python_via_homebrew.html

# XCode CLT
xcode-select --install

# Update Homebrew and add formulae
brew update

# Check for broken dependencies and/or outdated packages
brew doctor
brew cleanup

pip install pelican==3.6.3 
pip install markdown rpy2

# R
brew install openblas
brew install r --with-openblas
defaults write org.R-project.R force.LANG en_US.UTF-8
# echo 'Sys.setlocale(category="LC_ALL", locale = "en_US.UTF-8")' >> ~/.bash_profile

# data.table
R --vanilla << EOF
install.packages('data.table', repos='https://cloud.r-project.org')
q()
EOF

# knitr
R --vanilla << EOF
install.packages('knitr', repos='https://cloud.r-project.org')
q()
EOF

# rmarkdown
R --vanilla << EOF
install.packages('rmarkdown', repos='http://cran.us.r-project.org')
q()
EOF

# rJava
brew cask install java
# ln -f -s "$(/usr/libexec/java_home)/jre/lib/server/libjvm.dylib" /usr/local/lib
sudo R CMD javareconf
Rscript -e 'install.packages("rJava", repos="https://cloud.r-project.org")';

# devtools
brew install openssl openssl@1.1 libssh2
Rscript -e 'install.packages("devtools", repos="https://cloud.r-project.org")';

# tidyverse tools
Rscript -e 'install.packages("tidyverse", repos="https://cloud.r-project.org")';

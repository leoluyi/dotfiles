#!/usr/bin/env bash

install_r() {
  # See http://pacha.hk/2017-07-12_r_and_python_via_homebrew.html
  # Install R
  if ! command -v r &>/dev/null || [ "$1" = "-f" ]; then
    # Update Homebrew and add formulae
    brew update
    brew install --cask r
    defaults write org.R-project.R force.LANG en_US.UTF-8

    if grep -qv 'Sys.setlocale(category="LC_ALL", locale = "en_US.UTF-8")' "$HOME/.Rprofile"; then
      echo 'Sys.setlocale(category="LC_ALL", locale = "en_US.UTF-8")' >> "$HOME/.Rprofile"
    fi

    if grep -qv '/Library/Frameworks/R.framework/Resources' "$HOME/.bash_profile"; then
      echo -e '# R Framework.\n[ -d "/Library/Frameworks/R.framework/Resources" ] && export PATH="/Library/Frameworks/R.framework/Resources:$PATH"' >>"$HOME/.bash_profile"
    fi

    # Install additionally OpenMP enabled compiler
    brew update && brew install llvm libomp
    local LIBOMPBASE=$(brew --prefix libomp)
    ln -sb "${LIBOMPBASE}/lib/libomp.a" /usr/local/lib/libomp.a
    ln -sb "${LIBOMPBASE}/lib/libomp.dylib" /usr/local/lib/libomp.dylib
    bash -c "cat >~/.R/Makevars" <<EOF
XCBASE:=$(shell xcrun --show-sdk-path)
LLVMBASE:=$(shell brew --prefix llvm)
GCCBASE:=$(shell brew --prefix gcc)
GETTEXT:=$(shell brew --prefix gettext)

CC=$(LLVMBASE)/bin/clang -fopenmp
CXX=$(LLVMBASE)/bin/clang++ -fopenmp
CXX11=$(LLVMBASE)/bin/clang++
CXX14=$(LLVMBASE)/bin/clang++
CXX17=$(LLVMBASE)/bin/clang++
CXX1X=$(LLVMBASE)/bin/clang++

CPPFLAGS=-isystem"$(GETTEXT)/include" -isystem "$(LLVMBASE)/include" -isysroot "$(XCBASE)"
LDFLAGS=-L"$(LLVMBASE)/lib" -L"$(GETTEXT)/lib" --sysroot="$(XCBASE)"
# -O3 should be faster than -O2 (default) level optimisation ..
CFLAGS=-g -O3 -Wall -pedantic -std=gnu99 -mtune=native -pipe
CXXFLAGS=-g -O3 -Wall -pedantic -std=c++11 -mtune=native -pipe

FC=$(GCCBASE)/bin/gfortran
F77=$(GCCBASE)/bin/gfortran
FLIBS=-L$(GCCBASE)/lib/gcc/9/ -lm
EOF

  # Install R packages --------------------------------------------------------
  # data.table
  R --vanilla <<EOF
install.packages('data.table', repos='https://cloud.r-project.org', type='source')
q()
EOF

    # rJava
    brew install --cask adoptopenjdk/openjdk/adoptopenjdk8
    # ln -f -s "$(/usr/libexec/java_home)/jre/lib/server/libjvm.dylib" /usr/local/lib
    R CMD javareconf
    Rscript -e 'install.packages("rJava", repos="https://cloud.r-project.org")';

    # devtools
    brew install openssl openssl@1.1 libssh2
    Rscript -e 'install.packages("devtools", repos="https://cloud.r-project.org")';
  fi
}

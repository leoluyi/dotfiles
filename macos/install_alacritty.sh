#!/usr/bin/env bash
# https://medium.com/@pezcoder/how-i-migrated-from-iterm-to-alacritty-c50a04705f95

set -e

# Utility functions

## For ease of iterative experimentation
doo () {
    $@
    # echo $@
}

command_exists () {
  type "$1" &> /dev/null ;
}

installed () {
  echo -e " ✓ $1 already installed."
}

# START HERE.
main () {
    install_alacritty
}

# https://github.com/alacritty/alacritty#macos
# Alacritty helpful links:
# Setup italics: https://alexpearce.me/2014/05/italics-in-iterm2-vim-tmux/
# Ligature for operator mono: https://github.com/kiliman/operator-mono-lig
install_alacritty() {
  if ! (command_exists alacritty); then
    doo brew cask install alacritty

    # Clone.
    old_dir="$(pwd)"
    doo cd /tmp
    doo git clone https://github.com/alacritty/alacritty.git
    doo cd alacritty

    # Setup man page.
    # https://github.com/alacritty/alacritty/blob/master/INSTALL.md#manual-page
    sudo mkdir -p /usr/local/share/man/man1
    gzip -c extra/alacritty.man | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null

    # Shell completions.
    # https://github.com/alacritty/alacritty/blob/master/INSTALL.md#shell-completions

    # Terminfo definitions.
    # https://github.com/alacritty/alacritty/blob/master/INSTALL.md#terminfo
    # I'm thinking this is to make the awesome true colors & italic fonts work
    # We also change default terminal to alacritty in ~/.tmux.conf to use this
    doo sudo tic -xe alacritty,alacritty-direct extra/alacritty.info

    # # Config
    # doo mkdir -p "$HOME/.config/alacritty"
    # curl -fsSLo "$HOME/.config/alacritty/alacritty.yml" https://github.com/alacritty/alacritty/raw/master/alacritty.yml

    # Cleanup.
    doo cd ..
    doo rm -rf alacritty
    cd "${old_dir}"

    # Enable smoothing on mac
    # doo defaults write -g CGFontRenderingFontSmoothingDisabled -bool NO
    # doo defaults -currentHost write -globalDomain AppleFontSmoothing -int 2
  else
    installed 'alacritty'
  fi
}

# Fire missiles
main

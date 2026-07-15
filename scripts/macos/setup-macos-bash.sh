#!/usr/bin/env bash

# Update bash to version 5.x on OSX.
# < https://apple.stackexchange.com/questions/193411/update-bash-to-version-4-0-on-osx/292760#292760 >

set -e

# Add brew PATH.
[ -d /opt/homebrew/bin ] && export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}"

echo "==> Install bash with Homebrew."
brew install bash 2>/dev/null
echo

BREW_PREFIX=$(brew --prefix)
new_bash="$BREW_PREFIX"/bin/bash

# Check all bash versions on the system:

echo "==> Show all bash versions:"
which -a bash
echo

# Add to a list of "trusted" shells.
sudo bash -c 'echo /opt/homebrew/bin/bash >> /etc/shells'
#grep -q "$new_bash" /etc/shells || \
#  sudo cat <<\EOF >/etc/shells
#"$new_bash"
#EOF

# Set Default Shell.
echo "==> Set default shell."
if [ "$SHELL" != "$new_bash" ]; then
  chsh -s "$new_bash"
  echo "Default shell is set to $new_bash"
else
  echo "Default shell is already set to $new_bash"
fi
echo

# Install Homebrew

http://brew.sh/

## Install homebrew

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Backup and Restore brew packages

```sh
# Leaving a machine
brew leaves > leaves.txt

# Fresh installation
xargs brew install < leaves.txt

# Install from bundle
brew bundle install --file="homebrew/Brewfile"
```

# Homebrew Package List

### List Installed Packages

```
$ brew list
```

### Install

```
$ brew install \
bash \
bash-completion \
bfg \
coreutils \
czmq \
ffmpeg \
gcc \
gdal \
git \
gnupg \
grep \
grip \
highlight \
htop-osx \
libpng \
libsvg \
libxml2 \
libzip \
openssl \
proj \
pyenv \
pyenv-virtualenv
tldr \
tmux \
tree \
vim \
wget \
youtube-dl \
```

### Update

```
$ brew update && brew upgrade
```

### Refernces

- https://github.com/joeyespo/grip
- http://yenlung-blog.logdown.com/posts/773053-keynote-code-highlighting

---------------------------------------------

# brew cask

### Install homebrew-cask

http://blog.visioncan.com/2014/introducing-cask/

```
$ brew tap caskroom/cask
```

or

```
$ brew install caskroom/cask/brew-cask
```

Search

```
$ brew cask search <PGMNAME>
```

List installed cask

```
$ brew cask list
```

Update

```
$ brew cask update
```

Uninstall

```
$ brew cask uninstall <PGMNAME>
```

### Cask list

```
$ brew cask install \
iterm2 \
sourcetree \
java \
transmission \
xquartz \
qlcolorcode qlstephen qlmarkdown quicklook-json quicklook-csv qlimagesize qlvideo
```

### References

- https://github.com/sindresorhus/quick-look-plugins
- https://github.com/Marginal/QLVideo
- http://bionicprofessor.com/2016/05/15/installing-r-in-os-x-with-homebrew-and-cask/

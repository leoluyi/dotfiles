# Homebrew Package List

### List Installed Packages

```
$ brew list
```

### Install

```
$ brew install \
asciinema \ # record terminal sessions
atomicparsley \ # setting metadata into MPEG-4
bash \
bash-completion \
bash-git-prompt \
bfg \
cmatrix \
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
john-jumbo \ # password crack
libpng \
libsvg \
libxml2 \
libzip \
npm \
openssl \
pdfcrack \  # pdf password crack
pip-completion \
pipenv \
plowshare \ # 免空神器
proj \
pyenv \
pyenv-virtualenv \
rename \
shellcheck \
terminal-notifier \
thefuck \
tldr \
tmux \
tree \
vim \
wget \
youtube-dl \

$ brew tap eddieantonio/eddieantonio && brew install imgcat
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
deckset \
iina \
iterm2 \
java \
jupyter-notebook-viewer \
keycastr \
sourcetree \
transmission \
xquartz \
qlcolorcode qlstephen qlmarkdown quicklook-json qlimagesize webpquicklook suspicious-package quicklookase qlvideo
```

### References

- https://github.com/sindresorhus/quick-look-plugins
- https://github.com/Marginal/QLVideo
- http://bionicprofessor.com/2016/05/15/installing-r-in-os-x-with-homebrew-and-cask/
